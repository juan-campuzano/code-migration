# Repository Outdated Score Server

A Python FastAPI server that analyzes repositories for deprecated code patterns, provides a score indicating how outdated the codebase is, and can automatically migrate code using GitHub Copilot AI.

## Features

- 🔍 Analyzes code repositories for deprecated patterns
- 📊 Provides an outdated score (0-100)
- 🎯 Detects Flutter/Dart deprecations automatically
- 🤖 AI-powered code migration using GitHub Copilot SDK
- 🚀 RESTful API with automatic documentation
- 💡 Provides actionable recommendations

## Installation

### Prerequisites

1. Python 3.8 or higher (Python 3.9+ recommended for best compatibility)
2. (Optional) GitHub Copilot CLI for migration features
   - Install from: https://docs.github.com/en/copilot/copilot-cli
   - Authenticate: `copilot auth login`

### Install Dependencies

```bash
cd server
pip install -r requirements.txt
```

## Running the Server

### Method 1: Using Python directly
```bash
cd server
python app.py
```

### Method 2: Using uvicorn
```bash
cd server
uvicorn app:app --host 0.0.0.0 --port 8000
```

The server will start on `http://0.0.0.0:8000`

## API Documentation

Once the server is running, access the interactive API documentation at:
- Swagger UI: http://localhost:8000/docs
- ReDoc: http://localhost:8000/redoc

## API Endpoints

### `GET /`
Root endpoint with API information

### `GET /health`
Health check endpoint

**Response:**
```json
{
  "status": "healthy"
}
```

### `POST /analyze`
Analyze a repository and get an outdated score

**Request Body:**
```json
{
  "path": "/absolute/path/to/repository"
}
```

**Response:**
```json
{
  "repository_path": "/absolute/path/to/repository",
  "total_files_analyzed": 4,
  "deprecated_patterns": [
    {
      "pattern": "headline[1-6]",
      "description": "TextTheme.headline1-6 (use displayLarge, headlineLarge, etc.)",
      "count": 15
    }
  ],
  "total_deprecations": 50,
  "outdated_score": 85.5,
  "severity": "Critical",
  "recommendations": [
    "Run automated migration tools (e.g., 'dart fix --apply' for Flutter)",
    "Review and update deprecated API usage",
    "Consider updating to latest framework version"
  ]
}
```

### `POST /migrate`
Automatically migrate a repository using GitHub Copilot AI

**Requirements:**
- GitHub Copilot CLI must be installed and authenticated
- Active GitHub Copilot subscription or BYOK setup

**Request Body:**
```json
{
  "path": "/absolute/path/to/repository",
  "model": "gpt-4"
}
```

**Response (Success):**
```json
{
  "success": true,
  "message": "Migration completed successfully",
  "repo_path": "/absolute/path/to/repository",
  "changes": [
    "Modified 5 files with deprecated patterns",
    "Updated TextTheme properties in main.dart"
  ],
  "migration_log": [
    {"type": "reasoning", "content": "Analyzing deprecated patterns..."},
    {"type": "tool", "tool_name": "edit_file"},
    {"type": "message", "content": "Successfully updated all files"}
  ]
}
```

**Response (CLI Not Available):**
```json
{
  "success": false,
  "message": "Migration agent not available",
  "error": "Copilot CLI is not available. Please install: https://docs.github.com/en/copilot/copilot-cli",
  "changes": [],
  "migration_log": []
}
```

## Score Interpretation

The outdated score ranges from 0 to 100:

- **0-20 (Low)**: Repository has minimal deprecated code
- **20-50 (Medium)**: Repository has moderate amount of deprecated code
- **50-80 (High)**: Repository has significant deprecated code
- **80-100 (Critical)**: Repository has critical amount of deprecated code

## Example Usage

### Using curl

```bash
# Analyze the current repository
curl -X POST "http://localhost:8000/analyze" \
  -H "Content-Type: application/json" \
  -d '{"path": "/home/runner/work/code-migration/code-migration"}'
```

### Using Python requests

```python
import requests

response = requests.post(
    "http://localhost:8000/analyze",
    json={"path": "/path/to/your/repository"}
)

result = response.json()
print(f"Outdated Score: {result['outdated_score']}")
print(f"Severity: {result['severity']}")
print(f"Total Deprecations: {result['total_deprecations']}")
```

### Migrating a repository (with Copilot CLI)

```python
import requests

# Trigger automated migration
response = requests.post(
    "http://localhost:8000/migrate",
    json={
        "path": "/path/to/your/repository",
        "model": "gpt-4"
    }
)

result = response.json()
if result['success']:
    print(f"Migration completed!")
    print(f"Changes: {result['changes']}")
else:
    print(f"Migration failed: {result.get('error', 'Unknown error')}")
```

### Using the provided test client

```bash
cd server
python test_client.py /path/to/your/repository
```

## Detected Deprecation Patterns

The server currently detects the following Flutter/Dart deprecations:

1. **TextTheme Properties**
   - `headline1-6` → use `displayLarge`, `headlineLarge`, etc.
   - `bodyText1-2` → use `bodyLarge`, `bodyMedium`
   - `subtitle1-2` → use `titleLarge`, `titleMedium`
   - `caption` → use `bodySmall`

2. **Button Styles**
   - `primary` → use `backgroundColor`
   - `onPrimary` → use `foregroundColor`

3. **Widgets**
   - `WillPopScope` → use `PopScope`
   - `ButtonBar` → use `OverflowBar`

4. **AppBar Properties**
   - `brightness` → use `systemOverlayStyle`

5. **Other Properties**
   - `activeColor` (deprecated in Flutter 3.0)
   - `checkColor` (deprecated in Flutter 3.0)

## GitHub Copilot SDK Integration

The server includes integration with the [GitHub Copilot SDK](https://github.com/github/copilot-sdk) for AI-powered code migration.

### How It Works

1. **Analysis Phase**: The server first analyzes the repository to identify deprecated patterns
2. **Migration Phase**: If deprecations are found, the Copilot AI agent:
   - Receives a detailed prompt with all deprecated patterns
   - Navigates to the repository
   - Systematically fixes each deprecation
   - Verifies changes maintain functionality
   - Returns a summary of changes made

### Requirements for Migration

To use the `/migrate` endpoint, you need:

1. **GitHub Copilot CLI** installed and in your PATH
   ```bash
   # Install (see official docs)
   # Then authenticate:
   copilot auth login
   ```

2. **Active Copilot subscription** OR **BYOK (Bring Your Own Key)**
   - Standard: GitHub Copilot subscription
   - BYOK: Configure your own LLM API keys (OpenAI, Anthropic, Azure)

### Migration Agent

The `migration_agent.py` module provides:
- Automatic Copilot CLI lifecycle management
- Custom prompts optimized for code migration
- Event streaming for progress tracking
- Graceful handling when CLI is unavailable

### Customizing Migration Prompts

Edit `migration_agent.py` to customize how the agent performs migrations:

```python
def _build_migration_prompt(self, repo_path: str, deprecations: List[Dict]) -> str:
    # Customize the prompt sent to the Copilot agent
    prompt = f"""Your custom migration instructions...
    
    Repository: {repo_path}
    Deprecations: {deprecations}
    """
    return prompt
```

## Extending the Analyzer

To add more deprecation patterns, edit the `FLUTTER_PATTERNS` list in `app.py`:

```python
FLUTTER_PATTERNS = [
    (r'your-regex-pattern', 'Description of the deprecation'),
    # Add more patterns here
]
```

## Testing the Server

Test with the example Flutter app in this repository:

```bash
# Start the server in one terminal
cd server
python app.py

# In another terminal, test the analysis
curl -X POST "http://localhost:8000/analyze" \
  -H "Content-Type: application/json" \
  -d '{"path": "/home/runner/work/code-migration/code-migration"}'
```

## Development

### Project Structure
```
server/
├── app.py                  # Main FastAPI application
├── migration_agent.py      # Copilot SDK integration for migrations
├── requirements.txt        # Python dependencies
├── test_client.py          # Test client script
├── migrate_client.py       # Migration test client
└── README.md              # This file
```

### Adding New Features

1. Fork the repository
2. Create a feature branch
3. Add your changes to `app.py`
4. Test your changes
5. Submit a pull request

## Troubleshooting

### Port already in use
If port 8000 is already in use, you can specify a different port:
```bash
uvicorn app:app --host 0.0.0.0 --port 8080
```

### Permission denied
If you get permission errors:
```bash
chmod +x app.py
```

## License

This project is part of the code-migration repository and follows the same license.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.
