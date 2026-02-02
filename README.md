# Flutter Deprecated Code Migration Repository

Este repositorio contiene una aplicación Flutter con **código intencionalmente deprecado** de la versión 3.10.6, diseñado para probar y validar herramientas de automatización de migración de código.

## 🎯 Objetivo

El propósito principal de este repositorio es:

1. **Probar automatizaciones de GitHub Actions** para detectar y actualizar código deprecado
2. **Validar herramientas de migración** automática de Flutter/Dart
3. **Servir como proyecto de referencia** para scripts de migración
4. **Documentar patrones de código deprecado** comunes en Flutter

## 📦 Contenido del Repositorio

```
code-migration/
├── app/                          # Aplicación Flutter con código deprecado
│   ├── lib/
│   │   ├── main.dart            # App principal con múltiples ejemplos
│   │   ├── deprecated_widgets.dart
│   │   ├── deprecated_forms.dart
│   │   └── deprecated_list.dart
│   ├── pubspec.yaml             # Dependencias (versión compatible con APIs deprecadas)
│   └── README_DEPRECATED_CODE.md
├── .github/
│   └── workflows/
│       ├── migration-check.yml   # Workflow para detectar deprecaciones
│       └── auto-migration.yml    # Workflow para migración automática
├── scripts/
│   ├── analyze_deprecated.sh     # Script para analizar código deprecado
│   └── apply_migration.sh        # Script para aplicar migraciones
└── README.md                     # Este archivo
```

## 🚀 Inicio Rápido

### Prerrequisitos

- Flutter SDK 3.10.6 o superior
- Dart SDK
- Git

### Instalación

```bash
# Clonar el repositorio
git clone https://github.com/tu-usuario/code-migration.git
cd code-migration/app

# Instalar dependencias
flutter pub get

# Verificar código deprecado
flutter analyze
```

### Ejecutar la Aplicación

```bash
cd app
flutter run
```

## 🔍 Análisis de Código Deprecado

### Opción 1: Script Automatizado

```bash
chmod +x scripts/analyze_deprecated.sh
./scripts/analyze_deprecated.sh
```

### Opción 2: Flutter Analyze

```bash
cd app
flutter analyze --no-fatal-infos
```

### Opción 3: Dart Fix (ver qué se puede arreglar)

```bash
cd app
dart fix --dry-run
```

## 🔧 Aplicar Migraciones Automáticas

### Opción 1: Script Interactivo

```bash
chmod +x scripts/apply_migration.sh
./scripts/apply_migration.sh
```

### Opción 2: Dart Fix Directo

```bash
cd app
# Ver qué se cambiará
dart fix --dry-run

# Aplicar cambios
dart fix --apply
```

## 🤖 GitHub Actions

Este repositorio incluye dos workflows de GitHub Actions:

### 1. Migration Check (`migration-check.yml`)

**Triggers:**
- Push a `main` o `develop`
- Pull requests a `main` o `develop`
- Manual

**Acciones:**
- Analiza el código en busca de patrones deprecados
- Cuenta ocurrencias de cada tipo de deprecación
- Genera reporte de migración

### 2. Auto Migration (`auto-migration.yml`)

**Triggers:**
- Manual
- Programado (semanalmente los lunes)

**Acciones:**
- Ejecuta `dart fix --apply` automáticamente
- Crea un Pull Request con los cambios
- Incluye análisis post-migración

## 📊 APIs Deprecadas Incluidas

### TextTheme (Deprecado en Flutter 3.0+)

❌ **Deprecado:**
- `headline1`, `headline2`, `headline3`, `headline4`, `headline5`, `headline6`
- `bodyText1`, `bodyText2`
- `subtitle1`, `subtitle2`
- `caption`
- `button`

✅ **Usar:**
- `displayLarge`, `displayMedium`, `displaySmall`
- `headlineLarge`, `headlineMedium`, `headlineSmall`
- `bodyLarge`, `bodyMedium`, `bodySmall`
- `labelLarge`, `labelMedium`, `labelSmall`

### ButtonStyle (Deprecado en Flutter 3.0+)

❌ **Deprecado:**
```dart
ElevatedButton.styleFrom(
  primary: Colors.blue,      // Deprecado
  onPrimary: Colors.white,   // Deprecado
)
```

✅ **Usar:**
```dart
ElevatedButton.styleFrom(
  backgroundColor: Colors.blue,
  foregroundColor: Colors.white,
)
```

### WillPopScope (Deprecado en Flutter 3.12+)

❌ **Deprecado:**
```dart
WillPopScope(
  onWillPop: () async => false,
  child: Widget(),
)
```

✅ **Usar:**
```dart
PopScope(
  canPop: false,
  child: Widget(),
)
```

### AppBar.brightness (Deprecado en Flutter 3.1+)

❌ **Deprecado:**
```dart
AppBar(
  brightness: Brightness.dark,
)
```

✅ **Usar:**
```dart
AppBar(
  systemOverlayStyle: SystemUiOverlayStyle.light,
)
```

### ButtonBar (Deprecado en Flutter 3.21+)

❌ **Deprecado:**
```dart
ButtonBar(
  children: [Button1(), Button2()],
)
```

✅ **Usar:**
```dart
OverflowBar(
  children: [Button1(), Button2()],
)
```

## 📈 Estadísticas de Deprecación

Al ejecutar `flutter analyze`, encontrarás aproximadamente:

- **94+ problemas** detectados
- **50+ errores** de propiedades no definidas (TextTheme, ButtonStyle)
- **10+ warnings** de APIs deprecadas (WillPopScope, ButtonBar, etc.)
- **1 import** no utilizado

## 🛠️ Herramientas Recomendadas

1. **Dart Fix** - Herramienta oficial de Dart para migraciones automáticas
   ```bash
   dart fix --apply
   ```

2. **Flutter Analyze** - Análisis estático de código
   ```bash
   flutter analyze
   ```

3. **IDE Plugins** - Detectan deprecaciones en tiempo real
   - Flutter/Dart plugins para VS Code
   - Flutter plugin para IntelliJ/Android Studio

## 📝 Workflow de Migración Recomendado

1. **Análisis Inicial**
   ```bash
   ./scripts/analyze_deprecated.sh
   ```

2. **Backup del Código**
   ```bash
   git checkout -b migration-flutter-3.x
   ```

3. **Aplicar Migraciones Automáticas**
   ```bash
   ./scripts/apply_migration.sh
   ```

4. **Revisar Cambios**
   ```bash
   git diff
   ```

5. **Probar la Aplicación**
   ```bash
   flutter test
   flutter run
   ```

6. **Corregir Manualmente** los problemas restantes

7. **Commit y Push**
   ```bash
   git add .
   git commit -m "chore: migrate deprecated Flutter code"
   git push origin migration-flutter-3.x
   ```

## 🧪 Testing

```bash
cd app

# Ejecutar todos los tests
flutter test

# Ejecutar con cobertura
flutter test --coverage

# Verificar que la app compila
flutter build apk --debug
```

## 🤝 Contribuir

Contribuciones son bienvenidas! Especialmente:

- Nuevos ejemplos de código deprecado
- Mejoras en los scripts de análisis
- Optimizaciones en los GitHub Actions workflows
- Documentación adicional

## 📚 Recursos

- [Flutter Breaking Changes](https://docs.flutter.dev/release/breaking-changes)
- [Flutter Deprecation Guide](https://docs.flutter.dev/release/breaking-changes)
- [Dart Fix Documentation](https://dart.dev/tools/dart-fix)
- [GitHub Actions for Flutter](https://docs.github.com/en/actions)

## ⚖️ Licencia

Este proyecto es de código abierto y está disponible para pruebas y educación.

## ⚠️ Advertencia

**Este código contiene intencionalmente patrones deprecados y no debe usarse como referencia para nuevos proyectos de Flutter.**

El propósito es educativo y para pruebas de herramientas de migración.

---

**Última actualización:** Febrero 2026
**Versión de Flutter testeada:** 3.10.6 → 3.24+
