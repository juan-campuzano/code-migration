#!/usr/bin/env python3
"""
Repository Outdated Score Server
Analyzes repositories for deprecated code patterns and provides a score
indicating how outdated the codebase is.
"""

import re
from pathlib import Path
from typing import List
from fastapi import FastAPI, HTTPException
from pydantic import BaseModel, Field
import uvicorn

app = FastAPI(
    title="Repository Outdated Score API",
    description="Analyze repositories and get a score of how outdated they are",
    version="1.0.0"
)


class RepositoryRequest(BaseModel):
    """Request model for repository analysis."""
    path: str = Field(..., description="Absolute path to the repository to analyze")


class DeprecationPattern(BaseModel):
    """Model for a deprecated code pattern."""
    pattern: str
    description: str
    count: int


class AnalysisResult(BaseModel):
    """Result of repository analysis."""
    repository_path: str
    total_files_analyzed: int
    deprecated_patterns: List[DeprecationPattern]
    total_deprecations: int
    outdated_score: float
    severity: str
    recommendations: List[str]


class RepositoryAnalyzer:
    """Analyzes repositories for deprecated code patterns."""
    
    # Flutter/Dart deprecated patterns
    FLUTTER_PATTERNS = [
        (r'headline[1-6]', 'TextTheme.headline1-6 (use displayLarge, headlineLarge, etc.)'),
        (r'bodyText[1-2]', 'TextTheme.bodyText1-2 (use bodyLarge, bodyMedium)'),
        (r'subtitle[1-2]', 'TextTheme.subtitle1-2 (use titleLarge, titleMedium)'),
        (r'\.caption\b', 'TextTheme.caption (use bodySmall)'),
        (r'\bprimary:\s*Colors\.', 'ButtonStyle.primary (use backgroundColor)'),
        (r'\bonPrimary:\s*Colors\.', 'ButtonStyle.onPrimary (use foregroundColor)'),
        (r'\bWillPopScope\b', 'WillPopScope widget (use PopScope)'),
        (r'\bButtonBar\b', 'ButtonBar widget (use OverflowBar)'),
        (r'brightness:\s*Brightness\.', 'AppBar.brightness (use systemOverlayStyle)'),
        (r'\bactiveColor:', 'activeColor property (deprecated in Flutter 3.0)'),
        (r'\bcheckColor:', 'checkColor property (deprecated in Flutter 3.0)'),
    ]
    
    def __init__(self, repo_path: str):
        """Initialize analyzer with repository path."""
        self.repo_path = Path(repo_path)
        if not self.repo_path.exists():
            raise ValueError(f"Repository path does not exist: {repo_path}")
        if not self.repo_path.is_dir():
            raise ValueError(f"Path is not a directory: {repo_path}")
    
    def _find_code_files(self, extensions: List[str] = None) -> List[Path]:
        """Find code files in the repository."""
        if extensions is None:
            extensions = ['.dart', '.py', '.js', '.ts', '.java', '.kt']
        
        code_files = []
        for ext in extensions:
            code_files.extend(self.repo_path.rglob(f'*{ext}'))
        
        # Filter out common directories to ignore
        ignore_dirs = {'.git', 'node_modules', 'build', 'dist', '.dart_tool', 'android', 'ios', 'linux', 'macos', 'windows', 'web'}
        
        filtered_files = []
        for file_path in code_files:
            if not any(ignored in file_path.parts for ignored in ignore_dirs):
                filtered_files.append(file_path)
        
        return filtered_files
    
    def _count_pattern_in_file(self, file_path: Path, pattern: str) -> int:
        """Count occurrences of a pattern in a file."""
        try:
            with open(file_path, 'r', encoding='utf-8', errors='ignore') as f:
                content = f.read()
                matches = re.findall(pattern, content)
                return len(matches)
        except Exception:
            return 0
    
    def analyze(self) -> AnalysisResult:
        """Perform full analysis of the repository."""
        code_files = self._find_code_files()
        
        if not code_files:
            raise ValueError("No code files found in repository (required for score calculation)")
        
        # Analyze patterns
        deprecated_patterns = []
        total_deprecations = 0
        
        for pattern, description in self.FLUTTER_PATTERNS:
            count = 0
            for file_path in code_files:
                count += self._count_pattern_in_file(file_path, pattern)
            
            if count > 0:
                deprecated_patterns.append(DeprecationPattern(
                    pattern=pattern,
                    description=description,
                    count=count
                ))
                total_deprecations += count
        
        # Calculate outdated score (0-100, where 100 is most outdated)
        # Base score on number of deprecations per file
        deprecations_per_file = float(total_deprecations) / len(code_files)
        # Scale: 0 deprecations = 0 score, 10+ deprecations per file = 100 score
        outdated_score = min(100.0, deprecations_per_file * 10)
        
        # Determine severity
        if outdated_score < 20:
            severity = "Low"
        elif outdated_score < 50:
            severity = "Medium"
        elif outdated_score < 80:
            severity = "High"
        else:
            severity = "Critical"
        
        # Generate recommendations
        recommendations = []
        if total_deprecations > 0:
            recommendations.append("Run automated migration tools (e.g., 'dart fix --apply' for Flutter)")
            recommendations.append("Review and update deprecated API usage")
            
        if outdated_score > 50:
            recommendations.append("Consider updating to latest framework version")
            recommendations.append("Plan a comprehensive migration strategy")
        
        if not recommendations:
            recommendations.append("Code appears to be up-to-date")
        
        return AnalysisResult(
            repository_path=str(self.repo_path),
            total_files_analyzed=len(code_files),
            deprecated_patterns=deprecated_patterns,
            total_deprecations=total_deprecations,
            outdated_score=round(outdated_score, 2),
            severity=severity,
            recommendations=recommendations
        )


@app.get("/")
async def root():
    """Root endpoint with API information."""
    return {
        "name": "Repository Outdated Score API",
        "version": "1.0.0",
        "endpoints": {
            "/analyze": "POST - Analyze a repository",
            "/health": "GET - Health check"
        }
    }


@app.get("/health")
async def health_check():
    """Health check endpoint."""
    return {"status": "healthy"}


@app.post("/analyze", response_model=AnalysisResult)
async def analyze_repository(request: RepositoryRequest):
    """
    Analyze a repository and return an outdated score.
    
    The score ranges from 0 to 100, where:
    - 0-20: Low amount of deprecated code
    - 20-50: Medium amount of deprecated code
    - 50-80: High amount of deprecated code
    - 80-100: Critical amount of deprecated code
    """
    try:
        analyzer = RepositoryAnalyzer(request.path)
        result = analyzer.analyze()
        return result
    except ValueError as e:
        raise HTTPException(status_code=400, detail=str(e))
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Analysis failed: {str(e)}")


def main():
    """Run the server."""
    print("Starting Repository Outdated Score Server...")
    print("Server will be available at http://0.0.0.0:8000")
    print("API documentation at http://0.0.0.0:8000/docs")
    uvicorn.run(app, host="0.0.0.0", port=8000)


if __name__ == "__main__":
    main()
