"""
Configuration constants for the repository migration server.
"""

# LLM Model Configuration
DEFAULT_MODEL = "gpt-4"

# Timeout Configuration (in seconds)
AGENT_MIGRATION_TIMEOUT = 300  # 5 minutes - timeout for Copilot agent operations
CLIENT_MIGRATION_TIMEOUT = 600  # 10 minutes - HTTP timeout for client requests
ANALYSIS_TIMEOUT = 60  # 1 minute

# Content Formatting
MAX_CHANGE_DESCRIPTION_LENGTH = 200  # characters
