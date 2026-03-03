# Java / Kotlin / Spring Boot / Android Migration Instructions

## Detection
- **Config files:** `pom.xml` (Maven), `build.gradle` / `build.gradle.kts` (Gradle)
- **Version manager:** `sdkman` (`.sdkmanrc`), `asdf` (`.tool-versions`)

## Project Type Detection

| Indicator | Type |
|-----------|------|
| `org.springframework.boot` in deps | Spring Boot |
| `com.android.application` plugin | Android |
| `org.jetbrains.kotlin` in deps | Kotlin project |
| `jakarta.*` imports | Jakarta EE |
| `javax.*` imports | Java EE (needs migration to jakarta) |

## Commands Reference

### Gradle
| Action | Command |
|--------|---------|
| Build | `gradle build` or `./gradlew build` |
| Test | `gradle test` or `./gradlew test` |
| Check outdated | `gradle dependencyUpdates` (with plugin) |
| Audit | `gradle dependencyCheckAnalyze` (OWASP plugin) |
| Clean | `gradle clean` |
| Dependencies tree | `gradle dependencies` |

### Maven
| Action | Command |
|--------|---------|
| Build | `mvn compile` |
| Test | `mvn test` |
| Package | `mvn package` |
| Check outdated | `mvn versions:display-dependency-updates` |
| Update parent | `mvn versions:update-parent` |
| Audit | `mvn dependency-check:check` |
| Dependency tree | `mvn dependency:tree` |

## Common Breaking Changes

### Java 17 → 21
- Pattern matching for switch (finalized)
- Record patterns (finalized)
- Virtual threads (finalized)
- Sequenced collections
- String templates (preview)
- Scoped values (preview)
- Structured concurrency (preview)

### Spring Boot 2.x → 3.x
- Java 17+ required
- `javax.*` → `jakarta.*` namespace
- Spring Security 6.x changes
- Actuator endpoint changes
- `spring.config.import` for config files
- Property binding changes
- Auto-configuration file changes (`META-INF/spring/org.springframework.boot.autoconfigure.AutoConfiguration.imports`)

```java
// Before (javax)
import javax.persistence.Entity;
import javax.servlet.http.HttpServletRequest;

// After (jakarta)
import jakarta.persistence.Entity;
import jakarta.servlet.http.HttpServletRequest;
```

### Spring Boot 3.x Migration Checklist
- [ ] Upgrade Java to 17+
- [ ] Replace `javax.*` with `jakarta.*`
- [ ] Update Spring Security config (lambda DSL)
- [ ] Migrate auto-configuration files
- [ ] Update observability (Micrometer)
- [ ] Review property changes

### Kotlin 1.x → 2.x
- K2 compiler by default
- Smart cast improvements
- `when` with guards
- `data object` declarations
- Compiler plugins API changes

### Android (AGP Updates)
- AGP 8.5+ requires JDK 17
- Gradle 8.7+
- Target SDK 35
- NDK 27+ for 16KB page support
- Namespace required in `build.gradle`

### Gradle Version Compatibility

| Gradle | Min Java | AGP Compatible |
|--------|----------|----------------|
| 8.7 | 17 | 8.5+ |
| 8.5 | 17 | 8.3+ |
| 8.0 | 17 | 8.0+ |
| 7.6 | 11 | 7.4 |

## Codemods and Migration Tools

| Migration | Tool |
|-----------|------|
| javax → jakarta | `openrewrite` recipes |
| Spring Boot upgrade | `spring-boot-migrator` or OpenRewrite |
| Java version upgrade | IntelliJ inspections + OpenRewrite |
| Gradle upgrade | `gradle wrapper --gradle-version [ver]` |

### OpenRewrite (Recommended for Java Migrations)
```groovy
// build.gradle
plugins {
    id("org.openrewrite.rewrite") version "latest"
}

rewrite {
    activeRecipe("org.openrewrite.java.spring.boot3.UpgradeSpringBoot_3_0")
}

dependencies {
    rewrite("org.openrewrite.recipe:rewrite-spring:latest")
}
```

Run:
```bash
gradle rewriteRun
```

## Testing

| Tool | Command |
|------|---------|
| JUnit 5 | `gradle test` or `mvn test` |
| Mockito | Included in test scope |
| Spring Test | `@SpringBootTest` |
| Coverage (JaCoCo) | `gradle jacocoTestReport` |
| Android tests | `gradle connectedAndroidTest` |

## Build Configuration Templates

### Gradle (Kotlin DSL)
```kotlin
plugins {
    java
    id("org.springframework.boot") version "3.3.0"
    id("io.spring.dependency-management") version "1.1.5"
}

java {
    toolchain {
        languageVersion = JavaLanguageVersion.of(21)
    }
}
```

### Maven
```xml
<parent>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-parent</artifactId>
    <version>3.3.0</version>
</parent>

<properties>
    <java.version>21</java.version>
</properties>
```
