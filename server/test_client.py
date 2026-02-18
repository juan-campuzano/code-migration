#!/usr/bin/env python3
"""
Test client for the Repository Outdated Score Server
"""

import sys
import json
import requests
from pathlib import Path


def analyze_repository(server_url: str, repo_path: str):
    """Send analysis request to the server."""
    
    # Validate path exists
    if not Path(repo_path).exists():
        print(f"❌ Error: Path does not exist: {repo_path}")
        sys.exit(1)
    
    # Make request
    try:
        response = requests.post(
            f"{server_url}/analyze",
            json={"path": repo_path},
            timeout=120
        )
        response.raise_for_status()
        
        result = response.json()
        
        # Print results
        print("=" * 60)
        print("Repository Outdated Score Analysis")
        print("=" * 60)
        print(f"\n📁 Repository: {result['repository_path']}")
        print(f"📊 Files Analyzed: {result['total_files_analyzed']}")
        print(f"🔍 Total Deprecations: {result['total_deprecations']}")
        print(f"📈 Outdated Score: {result['outdated_score']}/100")
        print(f"⚠️  Severity: {result['severity']}")
        
        if result['deprecated_patterns']:
            print(f"\n🔎 Deprecated Patterns Found:")
            for pattern in result['deprecated_patterns']:
                print(f"  • {pattern['description']}: {pattern['count']} occurrences")
        
        if result['recommendations']:
            print(f"\n💡 Recommendations:")
            for i, rec in enumerate(result['recommendations'], 1):
                print(f"  {i}. {rec}")
        
        print("\n" + "=" * 60)
        
        # Return exit code based on severity
        severity_codes = {
            "Low": 0,
            "Medium": 1,
            "High": 2,
            "Critical": 3
        }
        return severity_codes.get(result['severity'], 0)
        
    except requests.exceptions.ConnectionError:
        print(f"❌ Error: Could not connect to server at {server_url}")
        print("   Make sure the server is running with: python app.py")
        sys.exit(1)
    except requests.exceptions.Timeout:
        print("❌ Error: Request timed out")
        sys.exit(1)
    except requests.exceptions.RequestException as e:
        print(f"❌ Error: {e}")
        if e.response is not None and hasattr(e.response, 'text'):
            print(f"   Server response: {e.response.text}")
        sys.exit(1)


def main():
    """Main function."""
    if len(sys.argv) < 2:
        print("Usage: python test_client.py <repository_path> [server_url]")
        print("\nExample:")
        print("  python test_client.py /path/to/repo")
        print("  python test_client.py /path/to/repo http://localhost:8000")
        sys.exit(1)
    
    repo_path = sys.argv[1]
    server_url = sys.argv[2] if len(sys.argv) > 2 else "http://localhost:8000"
    
    print(f"🚀 Connecting to server at {server_url}")
    print(f"📁 Analyzing repository: {repo_path}\n")
    
    exit_code = analyze_repository(server_url, repo_path)
    sys.exit(exit_code)


if __name__ == "__main__":
    main()
