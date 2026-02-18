# Repository Outdated Score Server

A Python FastAPI server that analyzes repositories for deprecated code patterns and provides a score indicating how outdated the codebase is.

## Features

- 🔍 Analyzes code repositories for deprecated patterns
- 📊 Provides an outdated score (0-100)
- 🎯 Detects Flutter/Dart deprecations automatically
- 🚀 RESTful API with automatic documentation
- 💡 Provides actionable recommendations

## Installation

1. Install Python 3.8 or higher

2. Install dependencies:
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
├── app.py              # Main FastAPI application
├── requirements.txt    # Python dependencies
├── test_client.py      # Test client script
└── README.md          # This file
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

### Flutter command not found
If the server cannot find the `flutter` command:
1. Make sure Flutter is installed
2. Add Flutter to your PATH
3. Restart the server

### Permission denied
If you get permission errors:
```bash
chmod +x app.py
```

## License

This project is part of the code-migration repository and follows the same license.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.
