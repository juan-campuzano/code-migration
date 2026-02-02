# Flutter Deprecated Code Demo

Esta aplicación de Flutter contiene intencionalmente código deprecado de la versión **3.10.6** para probar automatizaciones de migración en GitHub.

## 🎯 Propósito

El propósito de este repositorio es:
- Probar herramientas de migración automática de código Flutter
- Validar GitHub Actions para actualización automática de versiones
- Identificar patrones de código deprecado comunes
- Servir como base de pruebas para scripts de migración

## ⚠️ APIs y Patrones Deprecados Incluidos

### 1. **TextTheme (Deprecado en Flutter 3.0+)**
- ❌ `headline1`, `headline2`, `headline3`, `headline4`, `headline5`, `headline6`
- ❌ `bodyText1`, `bodyText2`
- ❌ `subtitle1`, `subtitle2`
- ❌ `caption`
- ❌ `button`
- ✅ Reemplazar con: `displayLarge`, `displayMedium`, `displaySmall`, `headlineLarge`, etc.

### 2. **ButtonStyle (Deprecado en Flutter 3.0+)**
- ❌ `primary` → ✅ `backgroundColor`
- ❌ `onPrimary` → ✅ `foregroundColor`
- ❌ `onSurface` en botones

### 3. **AppBar (Deprecado en Flutter 3.1+)**
- ❌ `brightness` → ✅ `systemOverlayStyle`

### 4. **WillPopScope (Deprecado en Flutter 3.12+)**
- ❌ `WillPopScope` → ✅ `PopScope`

### 5. **Colors y Opacidad**
- ❌ `withOpacity()` en algunos contextos
- ❌ `Opacity` widget (preferir alternativas más eficientes)
- ❌ `Color.fromRGBO` en ciertos usos

### 6. **SnackBarAction**
- ❌ `textColor` → ✅ usar `foregroundColor` en el estilo

### 7. **ButtonBar (Deprecado)**
- ❌ `ButtonBar` → ✅ usar `Row` o `OverflowBar`

### 8. **CheckboxListTile, RadioListTile, SwitchListTile**
- ❌ `activeColor` → ✅ usar `fillColor` con `MaterialStateProperty`
- ❌ `checkColor` en algunos contextos

### 9. **Slider**
- ❌ `activeColor` → ✅ usar `activeTrackColor`
- ❌ `inactiveColor` → ✅ usar `inactiveTrackColor`

### 10. **TabBar**
- ❌ `labelColor`, `unselectedLabelColor` → ✅ usar theme

### 11. **InputDecoration**
- Patrones antiguos de decoración de inputs

### 12. **MaterialStateProperty**
- Uso de patrones antiguos que no usan `MaterialStateProperty`

### 13. **Chip**
- ❌ `deleteIconColor` usado de forma directa

### 14. **FloatingActionButton**
- ❌ `backgroundColor` en algunos contextos antiguos

## 📁 Estructura del Código Deprecado

```
lib/
├── main.dart                    # Aplicación principal con múltiples ejemplos
├── deprecated_widgets.dart      # Widgets y componentes deprecados
├── deprecated_forms.dart        # Formularios con estilos deprecados
└── deprecated_list.dart         # Listas y vistas de detalle
```

## 🚀 Cómo Ejecutar

```bash
# Instalar dependencias
flutter pub get

# Ejecutar la aplicación
flutter run

# Analizar código deprecado
flutter analyze
```

## 📝 Warnings Esperados

Al ejecutar `flutter analyze`, deberías ver múltiples warnings sobre:
- Uso de propiedades deprecadas en `TextTheme`
- Uso de propiedades deprecadas en `ButtonStyle`
- Uso de `WillPopScope` deprecado
- Uso de `brightness` en `AppBar`
- Otros patrones deprecados

## 🔄 Migración Automática

Para probar la migración automática:

```bash
# Ejecutar dart fix (herramienta oficial de Flutter)
dart fix --apply

# O para ver qué se cambiaría sin aplicar
dart fix --dry-run
```

## 🛠️ Herramientas de CI/CD

Este repositorio está diseñado para integrarse con:
- GitHub Actions para análisis automático
- Scripts de migración personalizados
- Herramientas de detección de código deprecado
- Bots de actualización automática

## ⚙️ Versión de Flutter Objetivo

- **Versión actual**: 3.10.6 (con código deprecado)
- **Versión objetivo**: 3.24+ (código modernizado)

## 📊 Métricas de Migración

Después de ejecutar herramientas de migración, se pueden medir:
- Número de deprecaciones encontradas
- Número de correcciones automáticas
- Número de correcciones manuales requeridas
- Tiempo de migración
- Cobertura de migración (%)

## 🤝 Contribuir

Este es un proyecto de prueba. Para agregar más ejemplos de código deprecado:

1. Identifica APIs deprecadas en Flutter
2. Crea ejemplos claros y documentados
3. Asegúrate de que el código compile pero genere warnings
4. Documenta la deprecación y su reemplazo

## 📚 Referencias

- [Flutter Breaking Changes](https://docs.flutter.dev/release/breaking-changes)
- [Flutter Migration Guide](https://docs.flutter.dev/release/breaking-changes)
- [Dart Fix](https://dart.dev/tools/dart-fix)

## ⚖️ Licencia

Este es un proyecto de demostración para pruebas de migración.

---

**Nota**: Este código contiene intencionalmente patrones deprecados. No debe usarse como referencia para nuevos proyectos de Flutter.
