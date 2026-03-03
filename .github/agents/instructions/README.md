# Migration Instructions

This directory contains technology-specific migration references that the agents use during analysis and execution.

## How It Works

The **Migration Planner** agent auto-detects the tech stack by scanning config files, then references the appropriate instruction file for framework-specific guidance.

## Supported Stacks

| File | Technology | Detects Via |
|------|-----------|-------------|
| `flutter.md` | Flutter / Dart | `pubspec.yaml` |
| `node.md` | Node.js / React / Angular / Vue / Next.js | `package.json` |
| `python.md` | Python / Django / FastAPI / Flask | `requirements.txt`, `pyproject.toml` |
| `java.md` | Java / Spring Boot / Android | `pom.xml`, `build.gradle` |
| `dotnet.md` | .NET / C# | `*.csproj`, `*.sln` |
| `go.md` | Go | `go.mod` |
| `rust.md` | Rust | `Cargo.toml` |

## Adding a New Stack

1. Create a new `[stack].md` file in this directory
2. Follow the template structure:
   - Version manager detection
   - Dependency management commands
   - Common deprecated APIs for recent versions
   - Platform-specific configurations
   - Testing and build commands
3. The agents will automatically pick it up based on config file detection
