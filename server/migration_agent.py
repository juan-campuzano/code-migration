#!/usr/bin/env python3
"""
Migration Agent using GitHub Copilot SDK
Handles automated code migration using Copilot's agentic workflows.
"""

import asyncio
import logging
from typing import Optional, List, Dict
from pathlib import Path

try:
    from copilot import CopilotClient
    COPILOT_AVAILABLE = True
except ImportError:
    COPILOT_AVAILABLE = False

from config import (
    DEFAULT_MODEL,
    AGENT_MIGRATION_TIMEOUT,
    MAX_CHANGE_DESCRIPTION_LENGTH
)

logger = logging.getLogger(__name__)


class MigrationAgent:
    """Agent that handles code migration using GitHub Copilot SDK."""
    
    def __init__(self):
        """Initialize the migration agent."""
        self.client: Optional[CopilotClient] = None
        self.is_initialized = False
        
    async def initialize(self) -> bool:
        """
        Initialize the Copilot client.
        
        Returns:
            bool: True if successfully initialized, False otherwise
        """
        if not COPILOT_AVAILABLE:
            logger.warning("GitHub Copilot SDK is not installed")
            return False
        
        try:
            self.client = CopilotClient()
            await self.client.start()
            self.is_initialized = True
            logger.info("Migration agent initialized successfully")
            return True
        except Exception as e:
            logger.error(f"Failed to initialize migration agent: {e}")
            self.is_initialized = False
            return False
    
    async def shutdown(self):
        """Shutdown the Copilot client."""
        if self.client and self.is_initialized:
            try:
                await self.client.stop()
                self.is_initialized = False
                logger.info("Migration agent shut down")
            except Exception as e:
                logger.error(f"Error during shutdown: {e}")
    
    async def migrate_repository(
        self, 
        repo_path: str, 
        deprecations: List[Dict],
        model: str = DEFAULT_MODEL,
        timeout: int = AGENT_MIGRATION_TIMEOUT
    ) -> Dict:
        """
        Migrate a repository by fixing deprecated code patterns.
        
        Args:
            repo_path: Path to the repository to migrate
            deprecations: List of deprecation patterns found
            model: LLM model to use (default from config.DEFAULT_MODEL)
            timeout: Timeout in seconds (default from config.AGENT_MIGRATION_TIMEOUT)
            
        Returns:
            Dict with migration results including changes made and status
        """
        if not self.is_initialized:
            return {
                "success": False,
                "error": "Migration agent not initialized. Copilot CLI may not be available.",
                "changes": [],
                "message": "Please install Copilot CLI: https://docs.github.com/en/copilot/copilot-cli"
            }
        
        try:
            # Create a session for migration
            session = await self.client.create_session({"model": model})
            
            # Build migration prompt based on deprecations
            prompt = self._build_migration_prompt(repo_path, deprecations)
            
            # Track events and collect response
            migration_log = []
            response_content = None
            done = asyncio.Event()
            
            def on_event(event):
                nonlocal response_content
                
                try:
                    event_type = event.type.value if hasattr(event.type, 'value') else str(event.type)
                except AttributeError:
                    event_type = "unknown"
                    logger.warning(f"Event has unexpected structure: {event}")
                
                if event_type == "assistant.reasoning":
                    migration_log.append({
                        "type": "reasoning",
                        "content": event.data.content
                    })
                    logger.info(f"Agent reasoning: {event.data.content}")
                    
                elif event_type == "tool.execution_start":
                    migration_log.append({
                        "type": "tool",
                        "tool_name": event.data.tool_name
                    })
                    logger.info(f"Executing tool: {event.data.tool_name}")
                    
                elif event_type == "assistant.message":
                    response_content = event.data.content
                    migration_log.append({
                        "type": "message",
                        "content": event.data.content
                    })
                    
                elif event_type == "session.idle":
                    done.set()
            
            session.on(on_event)
            
            # Send migration request
            await session.send({"prompt": prompt})
            
            # Wait for completion (with timeout)
            try:
                await asyncio.wait_for(done.wait(), timeout=timeout)
            except asyncio.TimeoutError:
                logger.error(f"Migration timed out after {timeout} seconds")
                await session.destroy()
                return {
                    "success": False,
                    "error": f"Migration timed out after {timeout} seconds",
                    "changes": [],
                    "migration_log": migration_log
                }
            
            # Clean up session
            await session.destroy()
            
            return {
                "success": True,
                "message": response_content or "Migration completed",
                "changes": self._extract_changes_from_log(migration_log),
                "migration_log": migration_log,
                "repo_path": repo_path
            }
            
        except Exception as e:
            logger.error(f"Migration failed: {e}")
            return {
                "success": False,
                "error": str(e),
                "changes": [],
                "migration_log": []
            }
    
    def _build_migration_prompt(self, repo_path: str, deprecations: List[Dict]) -> str:
        """Build a prompt for the migration agent."""
        
        deprecation_summary = "\n".join([
            f"- {dep['description']}: {dep['count']} occurrences"
            for dep in deprecations
        ])
        
        prompt = f"""You are a code migration expert. I need you to fix deprecated code in a repository.

Repository Path: {repo_path}

Deprecated Patterns Found:
{deprecation_summary}

Please:
1. Navigate to the repository path
2. Find all files with deprecated code
3. Fix each deprecation by replacing it with the modern equivalent
4. Ensure all changes maintain the same functionality
5. Verify the changes don't break the code

For Flutter/Dart deprecations, use these mappings:
- headline1-6 → displayLarge, displayMedium, displaySmall, headlineLarge, headlineMedium, headlineSmall
- bodyText1-2 → bodyLarge, bodyMedium
- subtitle1-2 → titleLarge, titleMedium
- caption → bodySmall
- ButtonStyle.primary → backgroundColor
- ButtonStyle.onPrimary → foregroundColor
- WillPopScope → PopScope
- ButtonBar → OverflowBar
- AppBar.brightness → systemOverlayStyle

After making changes, provide a summary of what was fixed."""
        
        return prompt
    
    def _extract_changes_from_log(self, migration_log: List[Dict]) -> List[str]:
        """Extract file changes from the migration log."""
        changes = []
        
        for entry in migration_log:
            if entry.get("type") == "tool" and "edit" in entry.get("tool_name", "").lower():
                changes.append(f"Modified file via {entry['tool_name']}")
            elif entry.get("type") == "message":
                # Try to extract file mentions from message
                content = entry.get("content", "")
                if "modified" in content.lower() or "updated" in content.lower():
                    changes.append(content[:MAX_CHANGE_DESCRIPTION_LENGTH])
        
        return changes if changes else ["Changes applied (see migration log for details)"]


# Singleton instance
_migration_agent: Optional[MigrationAgent] = None


async def get_migration_agent() -> MigrationAgent:
    """Get or create the singleton migration agent instance."""
    global _migration_agent
    
    if _migration_agent is None:
        _migration_agent = MigrationAgent()
        await _migration_agent.initialize()
    
    return _migration_agent


async def shutdown_migration_agent():
    """Shutdown the migration agent if it exists."""
    global _migration_agent
    
    if _migration_agent is not None:
        await _migration_agent.shutdown()
        _migration_agent = None
