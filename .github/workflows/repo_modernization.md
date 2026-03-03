---
name: Repository Modernization

on:
  workflow_dispatch:
  schedule: daily

permissions:
  id-token: write
  contents: read
  issues: read
  pull-requests: read
  models: read

safe-outputs:
  create-pull-request:
    title-prefix: "[ai modernization]: "
    labels: ["migration", "automated"]
    draft: true
    reviewers: copilot

engine:
  id: copilot

network:
  allowed: [defaults, dart, node, python, java]

imports:
  - ../agents/migration-orchestrator.agent.md
---

# Repository Modernization Workflow

You are a code modernization agent that performs a full **Plan → Execute → Validate** migration pipeline on this repository. You work with **any technology stack** — detect it automatically and apply the right tools and patterns.

Run each phase below in sequence. Do not skip any phase. If validation fails, loop back to the Execution phase to fix issues (max 3 retry cycles).

---

## Phase 1: Planning — Deep Codebase Analysis

Perform exhaustive analysis of the repository before making any changes. You are a planner in this phase — **do not modify code yet**.

### 1.1 Tech Stack Detection

Scan the repository root for config files and identify the stack:

| Config File | Technology |
|---|---|
| `pubspec.yaml` | Flutter / Dart |
| `package.json` | Node.js / React / Angular / Vue / Next.js |
| `pom.xml` | Java / Spring Boot / Maven |
| `build.gradle` or `build.gradle.kts` | Java / Kotlin / Android / Gradle |
| `Cargo.toml` | Rust |
| `go.mod` | Go |
| `requirements.txt` / `pyproject.toml` / `Pipfile` | Python |
| `Gemfile` | Ruby / Rails |
| `*.csproj` / `*.sln` | .NET / C# |
| `Package.swift` | Swift / iOS |
| `composer.json` | PHP / Laravel |

After detection:
1. Read the main config file to determine current versions
2. Identify the package manager in use
3. Determine the framework version
4. Check for version manager files (`.nvmrc`, `.tool-versions`, `.fvmrc`, `.python-version`, etc.)

Output a **Tech Stack Summary**:
```
TECH STACK DETECTED:
- Language: [language] [version]
- Framework: [framework] [version]
- Package Manager: [manager]
- Version Manager: [manager or "none"]
- Build System: [system]
- Platform Targets: [web, mobile, desktop, server, etc.]
```

### 1.2 Dependency Audit

Run the appropriate commands to audit dependencies:

| Stack | Check Outdated | Audit Vulnerabilities |
|---|---|---|
| Flutter/Dart | `flutter pub outdated` |  |
| Node.js | `npm outdated` or `yarn outdated` | `npm audit` or `yarn audit` |
| Python | `pip list --outdated` | `pip-audit` or `safety check` |
| Java/Gradle | `gradle dependencyUpdates` | `gradle dependencyCheckAnalyze` |
| Java/Maven | `mvn versions:display-dependency-updates` | `mvn dependency-check:check` |
| Go | `go list -m -u all` | `govulncheck ./...` |
| Rust | `cargo outdated` | `cargo audit` |
| .NET | `dotnet list package --outdated` | `dotnet list package --vulnerable` |

Classify each dependency:
- ✅ **Current** — latest version
- 🟡 **Minor update** — patch or minor version behind
- 🟠 **Major update** — major version behind
- 🔴 **Deprecated** — package abandoned
- ⛔ **Vulnerable** — known CVE

### 1.3 Code Analysis

1. **Run static analysis** with the stack-appropriate analyzer (`flutter analyze`, `npx eslint .`, `ruff check .`, `go vet ./...`, etc.)
2. **Detect deprecated API usage** — search for `@deprecated`, `@Deprecated`, deprecation warnings
3. **Assess architecture** — identify patterns, structure, test layout

### 1.4 Breaking Change Research

For each major dependency update:
1. Check the package's CHANGELOG or release notes
2. Identify breaking changes that affect the codebase
3. Determine if automated fixes exist (`dart fix`, codemods, etc.)
4. Estimate effort for manual migration

### 1.5 Generate Migration Plan

Produce a structured plan:

```markdown
# MIGRATION PLAN

## Metadata
- Generated: [timestamp]
- Tech Stack: [stack]
- Current Version: [version]
- Target Version: [version]
- Estimated Effort: [Low/Medium/High]
- Risk Level: [Low/Medium/High]

## Pre-Migration Checklist
- [ ] Git working directory is clean
- [ ] All tests pass on current version
- [ ] Branch created for migration

## Migration Steps

### Step N: [Title]
- Priority: [Critical/High/Medium/Low]
- Type: [SDK Upgrade/Dependency Update/Code Refactor/Config Change]
- Risk: [High/Medium/Low]
- Description: [what and why]
- Commands: [exact commands]
- Manual Changes: [files and changes]
- Verification: [commands to verify]
- Rollback: [commands to undo]
```

Order steps by dependency (prerequisites first). Every step must include verification commands.

---

## Phase 2: Execution — Implement Migration

Now implement the plan. You are the executor — make all code changes directly.

### 2.0 Environment Setup

1. **Verify clean git state:**
   ```bash
   git status
   ```
   Stash uncommitted changes if needed.

2. **Create migration branch:**
   ```bash
   git checkout -b migration/upgrade-$(date +%Y%m%d)
   ```

3. **Detect version managers** (fvm, nvm, pyenv, rbenv, sdkman, asdf) and use them if present.

4. **Run baseline tests** — record results before any changes:
   - Flutter: `flutter test`
   - Node: `npm test` / `yarn test`
   - Python: `pytest`
   - Java: `gradle test` / `mvn test`
   - Go: `go test ./...`
   - Rust: `cargo test`

### 2.1 SDK / Runtime Upgrade

Upgrade the core SDK:
- Flutter: `flutter upgrade` or `fvm install [version] && fvm use [version]`
- Node: update `.nvmrc`, `nvm install [version]`
- Python: `pyenv install [version] && pyenv local [version]`
- Java: update `java.toolchain` in gradle or `maven.compiler.source/target`
- Go: update `go` directive in `go.mod`
- Rust: `rustup update stable`

Verify: `[runtime] --version`

### 2.2 Dependency Updates

For each dependency in the plan:
1. Update the version in the manifest
2. Install: `flutter pub get` / `npm install` / `pip install -r requirements.txt` / etc.
3. Verify build compiles
4. Commit:
   ```bash
   git add . && git commit -m "chore: update [package] from [old] to [new]"
   ```

### 2.3 Code Refactoring

For each deprecated API or breaking change:
1. **Try automated fixes first:**
   - Flutter/Dart: `dart fix --apply`
   - Node/TS: `npx eslint --fix .` or framework codemods
   - Python: `ruff check --fix .`
   - Go: `gofmt -w .`
   - Rust: `cargo fix`
2. **Apply manual changes** as specified in the plan
3. **Run analysis** after each change
4. **Commit incrementally:**
   ```bash
   git add . && git commit -m "refactor: migrate [old-api] to [new-api]"
   ```

### 2.4 Platform-Specific Updates

Apply platform configs as needed:
- **Flutter:** Android `build.gradle`, iOS `Podfile`, Xcode settings
- **Node:** Webpack/Vite config, Docker, CI pipeline
- **Python:** Docker, pyproject.toml tooling sections
- **Java:** Gradle wrapper, Maven parent, Docker base image

Commit: `git add . && git commit -m "chore: update platform configurations"`

### 2.5 Final Build & Test

1. Run full test suite
2. Run static analysis
3. Build the application
4. Final commit: `git add . && git commit -m "chore: migration complete - all tests passing"`

### Execution Report

After execution, produce:
```
MIGRATION EXECUTION REPORT
- Branch: [name]
- Steps Completed: [N/M]
- Tests: [Pass/Fail]
- Analysis: [Clean/N warnings]
- Status: [Complete/Partial/Blocked]
```

---

## Phase 3: Validation — Verify Changes

Now validate everything the executor did. Be thorough — do not approve if there are failures.

### 3.1 Environment Check

1. Confirm we're on a migration branch: `git branch --show-current`
2. Review commit history: `git log --oneline main..HEAD`
3. List changed files: `git diff --name-only main..HEAD`
4. Verify no unrelated changes

### 3.2 Build Verification

Run the build command for the detected stack:
- Flutter: `flutter build apk --debug`
- Node: `npm run build`
- Python: `python -m py_compile [files]`
- Java/Gradle: `gradle build`
- Go: `go build ./...`
- Rust: `cargo build`

**Verdict:** PASS or FAIL

### 3.3 Static Analysis

Run the analyzer. Check for:
- Zero errors (MUST pass)
- Deprecation warnings eliminated (MUST pass)
- No new warnings introduced (SHOULD pass)

**Verdict:** PASS or FAIL

### 3.4 Test Suite

1. Run full test suite
2. Compare with baseline — no previously passing tests should now fail
3. Check coverage if available

**Verdict:** PASS or FAIL

### 3.5 Code Review

Review changed files for:
- **Completeness:** All deprecated APIs migrated, no partial migrations
- **Correctness:** New API usage follows best practices, imports updated
- **Consistency:** Same patterns used throughout (not mixed old/new)
- **Configs:** Dependency manifest correct, lock file regenerated, platform configs updated
- **No regressions:** No functionality removed accidentally

**Verdict:** PASS or FAIL

### 3.6 Security Check

1. Run dependency vulnerability scan (`npm audit`, `dart pub audit`, `pip-audit`, etc.)
2. Verify no secrets in committed code
3. No new security issues introduced

**Verdict:** PASS or FAIL

### Validation Decision

```
IF any critical issue → REJECTED — hand issues back to execution phase
IF warnings > 3 → APPROVED WITH WARNINGS — list them for review
IF all checks pass → APPROVED — migration complete
```

### Validation Report

```markdown
# MIGRATION VALIDATION REPORT

## Overall Verdict: [APPROVED / REJECTED / APPROVED WITH WARNINGS]

| Phase | Check | Verdict | Details |
|-------|-------|---------|---------|
| Build | Compilation | ✅/❌ | ... |
| Analysis | Zero errors | ✅/❌ | ... |
| Tests | All passing | ✅/❌ | ... |
| Review | Completeness | ✅/❌ | ... |
| Review | Correctness | ✅/❌ | ... |
| Security | No vulnerabilities | ✅/❌ | ... |

## Issues Found (if REJECTED)
| # | Issue | File | Suggested Fix |
|---|-------|------|--------------|
```

---

## Retry Loop

If validation returns **REJECTED**:
1. Extract the issues list from the validation report
2. Return to **Phase 2** and fix only the reported issues
3. Re-run **Phase 3** validation
4. **Maximum 3 retry cycles** — if still failing after 3 attempts, stop and report all unresolved issues

---

## Final Output

After successful validation, produce the pull request with:
- **Title:** Clear description of what was migrated
- **Body:** Include the Migration Plan summary, Execution Report, and Validation Report
- **Branch:** The migration branch with all commits

---

## Tech-Specific Reference

Use the following reference guides based on the detected tech stack. These contain exact command syntax, common breaking changes, and migration patterns.

{{#import shared/instructions/flutter.md}}

{{#import shared/instructions/node.md}}

{{#import shared/instructions/python.md}}

{{#import shared/instructions/java.md}}