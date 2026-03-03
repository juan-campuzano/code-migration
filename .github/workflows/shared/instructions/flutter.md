# Flutter / Dart Migration Instructions

## Detection
- **Config file:** `pubspec.yaml`
- **Version manager:** `fvm` (`.fvmrc` or `.fvm/fvm_config.json`)

## Commands Reference

| Action | Command |
|--------|---------|
| Check version | `flutter --version` |
| Upgrade SDK | `flutter upgrade` |
| Check outdated | `flutter pub outdated` |
| Install deps | `flutter pub get` |
| Upgrade major | `flutter pub upgrade --major-versions` |
| Analyze | `flutter analyze` |
| Auto-fix | `dart fix --apply` |
| Run tests | `flutter test` |
| Test coverage | `flutter test --coverage` |
| Audit security | `dart pub audit` |
| Build Android | `flutter build apk --debug` |
| Build iOS | `flutter build ios --no-codesign` |
| Clean | `flutter clean` |

## With FVM

If `fvm` is detected, prefix commands:
```bash
fvm install [version]
fvm use [version]
fvm flutter pub get
fvm flutter test
fvm flutter analyze
fvm dart fix --apply
```

## Common Breaking Changes (Flutter 3.x)

### MaterialState → WidgetState (Flutter 3.22+)
```dart
// Before
MaterialState.pressed
MaterialStateProperty.all(...)

// After
WidgetState.pressed
WidgetStateProperty.all(...)
```

### TextTheme Renames (Flutter 3.0+)
```dart
// Before → After
headline1 → displayLarge
headline2 → displayMedium
headline3 → displaySmall
headline4 → headlineMedium
headline5 → headlineSmall
headline6 → titleLarge
subtitle1 → titleMedium
subtitle2 → titleSmall
bodyText1 → bodyLarge
bodyText2 → bodyMedium
caption → bodySmall
overline → labelSmall
```

### ButtonStyle (Flutter 3.0+)
```dart
// Before
ElevatedButton.styleFrom(primary: ..., onPrimary: ...)

// After
ElevatedButton.styleFrom(backgroundColor: ..., foregroundColor: ...)
```

### WillPopScope → PopScope (Flutter 3.12+)
```dart
// Before
WillPopScope(onWillPop: () async => false, child: child)

// After
PopScope(canPop: false, child: child)
```

### ButtonBar → OverflowBar (Flutter 3.12+)
```dart
// Before
ButtonBar(children: [...])

// After
OverflowBar(children: [...])
```

### AppBar Brightness (Flutter 2.0+)
```dart
// Before
AppBar(brightness: Brightness.dark)

// After
AppBar(systemOverlayStyle: SystemUiOverlayStyle.light)
```

## Android Configuration

### build.gradle Updates
- AGP 8.5+ requires JDK 17
- NDK 27+ recommended for 16KB page support
- Target SDK 35
- compileSdkVersion 35
- Add `namespace` in android block

### settings.gradle
```groovy
plugins {
    id "dev.flutter.flutter-plugin-loader" version "1.0.0"
    id "com.android.application" version '8.6.0' apply false
    id "org.jetbrains.kotlin.android" version "1.9.22" apply false
}
```

### 16KB Memory Pages Checklist
- Update Gradle Plugin to 8.5.1+
- Update Gradle Wrapper to 8.7+
- Update NDK to 28.0.12433566
- Rebuild with `flutter clean && flutter build appbundle`
- Verify: `adb shell getconf PAGE_SIZE`

## iOS Configuration

- Deployment Target ≥ 13.0
- Update Podfile platform version
- Run `cd ios && pod install --repo-update`

## Material 3

Flutter 3.16+ defaults to Material 3. To keep Material 2:
```dart
ThemeData(useMaterial3: false)
```

## Analysis Rules (`analysis_options.yaml`)

Recommended rules to add:
```yaml
linter:
  rules:
    - always_declare_return_types
    - prefer_const_constructors
    - avoid_print
    - use_key_in_widget_constructors
    - prefer_final_fields
    - prefer_const_literals_to_create_immutables
```

## Null Safety

If migrating from pre-null-safety code:
```bash
dart migrate
```
