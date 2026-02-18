#!/usr/bin/env python3
"""
Test migration client for the Repository Migration Server
Demonstrates how to use the /migrate endpoint.
"""

import sys
import json
import requests
from pathlib import Path

from config import (
    DEFAULT_MODEL,
    ANALYSIS_TIMEOUT,
    DEFAULT_SESSION_TIMEOUT as MIGRATION_TIMEOUT
)


def migrate_repository(server_url: str, repo_path: str, model: str = DEFAULT_MODEL):
    """Send migration request to the server."""
    
    # Validate path exists
    if not Path(repo_path).exists():
        print(f"❌ Error: Path does not exist: {repo_path}")
        sys.exit(1)
    
    print(f"🚀 Connecting to server at {server_url}")
    print(f"📁 Migrating repository: {repo_path}")
    print(f"🤖 Using model: {model}\n")
    
    # First, analyze to see what needs migration
    try:
        print("Step 1: Analyzing repository...")
        analyze_response = requests.post(
            f"{server_url}/analyze",
            json={"path": repo_path},
            timeout=ANALYSIS_TIMEOUT
        )
        analyze_response.raise_for_status()
        analysis = analyze_response.json()
        
        print(f"✅ Analysis complete")
        print(f"   📊 Files analyzed: {analysis['total_files_analyzed']}")
        print(f"   🔍 Deprecations found: {analysis['total_deprecations']}")
        print(f"   📈 Outdated score: {analysis['outdated_score']}/100")
        print(f"   ⚠️  Severity: {analysis['severity']}\n")
        
        if analysis['total_deprecations'] == 0:
            print("✨ No deprecated code found. Repository is up-to-date!")
            return 0
        
        print("Deprecated patterns found:")
        for pattern in analysis['deprecated_patterns'][:5]:  # Show first 5
            print(f"  • {pattern['description']}: {pattern['count']} occurrences")
        if len(analysis['deprecated_patterns']) > 5:
            print(f"  ... and {len(analysis['deprecated_patterns']) - 5} more\n")
        else:
            print()
        
    except requests.exceptions.RequestException as e:
        print(f"❌ Analysis failed: {e}")
        return 1
    
    # Ask for confirmation
    response = input("Proceed with AI-powered migration? (y/n): ")
    if response.lower() != 'y':
        print("Migration cancelled.")
        return 0
    
    # Perform migration
    try:
        print("\nStep 2: Starting migration...")
        print("⏳ This may take several minutes depending on the repository size...")
        print("   The Copilot agent will analyze and fix each deprecation.\n")
        
        migrate_response = requests.post(
            f"{server_url}/migrate",
            json={"path": repo_path, "model": model},
            timeout=MIGRATION_TIMEOUT
        )
        migrate_response.raise_for_status()
        
        result = migrate_response.json()
        
        print("=" * 60)
        print("Migration Results")
        print("=" * 60)
        
        if result['success']:
            print(f"\n✅ {result['message']}")
            print(f"\n📝 Changes made:")
            for change in result['changes']:
                print(f"  • {change}")
            
            if result.get('migration_log'):
                print(f"\n📋 Migration log summary:")
                log_summary = {}
                for entry in result['migration_log']:
                    entry_type = entry.get('type', 'unknown')
                    log_summary[entry_type] = log_summary.get(entry_type, 0) + 1
                
                for log_type, count in log_summary.items():
                    print(f"  • {log_type}: {count} events")
            
            print("\n" + "=" * 60)
            return 0
            
        else:
            print(f"\n❌ Migration failed")
            print(f"   Error: {result.get('error', 'Unknown error')}")
            print(f"   Message: {result.get('message', 'No message')}")
            
            if "Copilot CLI" in result.get('error', ''):
                print("\n💡 To use migration features:")
                print("   1. Install Copilot CLI: https://docs.github.com/en/copilot/copilot-cli")
                print("   2. Authenticate: copilot auth login")
                print("   3. Restart the server")
            
            print("\n" + "=" * 60)
            return 1
            
    except requests.exceptions.Timeout:
        print(f"❌ Migration timed out after {MIGRATION_TIMEOUT} seconds")
        print("   The repository may be too large or complex.")
        return 1
    except requests.exceptions.RequestException as e:
        print(f"❌ Migration request failed: {e}")
        if hasattr(e, 'response') and hasattr(e.response, 'text'):
            print(f"   Server response: {e.response.text}")
        return 1


def main():
    """Main function."""
    if len(sys.argv) < 2:
        print("Usage: python migrate_client.py <repository_path> [model] [server_url]")
        print("\nArguments:")
        print(f"  repository_path  : Path to the repository to migrate (required)")
        print(f"  model           : LLM model to use (default: {DEFAULT_MODEL})")
        print(f"  server_url      : Server URL (default: http://localhost:8000)")
        print("\nExample:")
        print("  python migrate_client.py /path/to/repo")
        print(f"  python migrate_client.py /path/to/repo {DEFAULT_MODEL} http://localhost:8000")
        sys.exit(1)
    
    repo_path = sys.argv[1]
    model = sys.argv[2] if len(sys.argv) > 2 else DEFAULT_MODEL
    server_url = sys.argv[3] if len(sys.argv) > 3 else "http://localhost:8000"
    
    exit_code = migrate_repository(server_url, repo_path, model)
    sys.exit(exit_code)


if __name__ == "__main__":
    main()
