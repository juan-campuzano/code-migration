# Guía Rápida de Migración

## Comandos Útiles

### Análisis

```bash
# Ver todos los problemas
cd app && flutter analyze

# Ver solo deprecaciones
cd app && flutter analyze 2>&1 | grep deprecated

# Contar deprecaciones
cd app && flutter analyze 2>&1 | grep deprecated | wc -l

# Script personalizado
./scripts/analyze_deprecated.sh
```

### Migración Automática

```bash
# Ver qué se puede arreglar (no hace cambios)
cd app && dart fix --dry-run

# Aplicar correcciones automáticas
cd app && dart fix --apply

# Script interactivo
./scripts/apply_migration.sh
```

### Testing

```bash
# Ejecutar tests
cd app && flutter test

# Verificar que compila
cd app && flutter build apk --debug

# Ejecutar en dispositivo/emulador
cd app && flutter run
```

### Git

```bash
# Crear rama para migración
git checkout -b migration/flutter-upgrade

# Ver cambios
git diff

# Commit
git add .
git commit -m "chore: migrate deprecated Flutter APIs"

# Push
git push origin migration/flutter-upgrade
```

## Patrones de Reemplazo Manual

### TextTheme

```dart
// Antes
Theme.of(context).textTheme.headline1
Theme.of(context).textTheme.bodyText1

// Después
Theme.of(context).textTheme.displayLarge
Theme.of(context).textTheme.bodyLarge
```

### Buttons

```dart
// Antes
ElevatedButton.styleFrom(
  primary: Colors.blue,
  onPrimary: Colors.white,
)

// Después
ElevatedButton.styleFrom(
  backgroundColor: Colors.blue,
  foregroundColor: Colors.white,
)
```

### WillPopScope

```dart
// Antes
WillPopScope(
  onWillPop: () async {
    // lógica
    return true;
  },
  child: widget,
)

// Después
PopScope(
  canPop: true,
  onPopInvokedWithResult: (didPop, result) {
    // lógica si es necesario
  },
  child: widget,
)
```

### AppBar

```dart
// Antes
AppBar(
  brightness: Brightness.dark,
)

// Después
import 'package:flutter/services.dart';

AppBar(
  systemOverlayStyle: SystemUiOverlayStyle.light,
)
```

### ButtonBar

```dart
// Antes
ButtonBar(
  children: [button1, button2],
)

// Después
OverflowBar(
  children: [button1, button2],
)
```

## Orden de Migración Recomendado

1. ✅ **Ejecutar dart fix --apply**
   - Migra automáticamente muchos patrones comunes

2. ✅ **Actualizar TextTheme**
   - Buscar/reemplazar en todo el proyecto
   - `headline1` → `displayLarge`
   - `bodyText1` → `bodyLarge`

3. ✅ **Actualizar ButtonStyle**
   - `primary:` → `backgroundColor:`
   - `onPrimary:` → `foregroundColor:`

4. ✅ **Reemplazar WillPopScope**
   - `WillPopScope` → `PopScope`

5. ✅ **Actualizar AppBar**
   - `brightness:` → `systemOverlayStyle:`

6. ✅ **Reemplazar ButtonBar**
   - `ButtonBar` → `OverflowBar`

7. ✅ **Testing**
   - Ejecutar tests
   - Verificar visualmente la UI
   - Probar funcionalidad

## Problemas Comunes

### Error: "The getter 'headline1' isn't defined"

**Causa:** TextTheme fue refactorizado en Flutter 3.0

**Solución:**
```dart
// Antes
style: Theme.of(context).textTheme.headline1

// Después
style: Theme.of(context).textTheme.displayLarge
```

### Error: "The named parameter 'primary' isn't defined"

**Causa:** ButtonStyle.primary fue renombrado

**Solución:**
```dart
// Antes
ElevatedButton.styleFrom(primary: Colors.blue)

// Después
ElevatedButton.styleFrom(backgroundColor: Colors.blue)
```

### Warning: "WillPopScope is deprecated"

**Causa:** WillPopScope fue deprecado en Flutter 3.12

**Solución:**
```dart
// Antes
WillPopScope(
  onWillPop: () async => false,
  child: child,
)

// Después
PopScope(
  canPop: false,
  child: child,
)
```

## Checklist de Migración

- [ ] Backup del código (git branch)
- [ ] Ejecutar `dart fix --dry-run`
- [ ] Revisar cambios propuestos
- [ ] Ejecutar `dart fix --apply`
- [ ] Actualizar TextTheme manualmente
- [ ] Actualizar ButtonStyle manualmente
- [ ] Reemplazar WillPopScope
- [ ] Actualizar AppBar.brightness
- [ ] Reemplazar ButtonBar
- [ ] Ejecutar `flutter analyze`
- [ ] Ejecutar `flutter test`
- [ ] Probar app en dispositivo
- [ ] Commit y push

## Scripts Incluidos

### analyze_deprecated.sh

Analiza el código y genera un reporte de todas las deprecaciones encontradas.

### apply_migration.sh

Aplica migraciones automáticas con confirmación del usuario y crea backup automático.

## Recursos Adicionales

- [Flutter 3.0 Breaking Changes](https://docs.flutter.dev/release/breaking-changes/3-0-deprecations)
- [Flutter 3.12 Breaking Changes](https://docs.flutter.dev/release/breaking-changes/3-12-deprecations)
- [Dart Fix Tool](https://dart.dev/tools/dart-fix)
