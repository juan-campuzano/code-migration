#!/bin/bash

# Script para analizar y reportar código deprecado en Flutter

echo "======================================"
echo "Flutter Deprecated Code Analyzer"
echo "======================================"
echo ""

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Navegar al directorio de la app
cd "$(dirname "$0")/../app" || exit

echo -e "${BLUE}📍 Working directory: $(pwd)${NC}"
echo ""

# Verificar que Flutter está instalado
if ! command -v flutter &> /dev/null; then
    echo -e "${RED}❌ Flutter no está instalado${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Flutter version:${NC}"
flutter --version | head -1
echo ""

# Función para contar ocurrencias
count_pattern() {
    local pattern=$1
    local description=$2
    local count=$(grep -r "$pattern" lib/ 2>/dev/null | wc -l | tr -d ' ')
    
    if [ "$count" -gt 0 ]; then
        echo -e "${YELLOW}⚠️  $description: $count occurrences${NC}"
    else
        echo -e "${GREEN}✅ $description: None found${NC}"
    fi
}

# Análisis de código deprecado
echo -e "${BLUE}🔍 Scanning for deprecated patterns...${NC}"
echo ""

echo "## TextTheme Deprecated Properties:"
count_pattern "headline[1-6]" "headline1-6"
count_pattern "bodyText[1-2]" "bodyText1-2"
count_pattern "subtitle[1-2]" "subtitle1-2"
count_pattern "\.caption" "caption"
count_pattern "button:" "button style"
echo ""

echo "## Button Style Deprecated Properties:"
count_pattern "primary: Colors\." "primary color"
count_pattern "onPrimary: Colors\." "onPrimary color"
echo ""

echo "## Widget Deprecations:"
count_pattern "WillPopScope" "WillPopScope"
count_pattern "ButtonBar" "ButtonBar"
echo ""

echo "## AppBar Deprecations:"
count_pattern "brightness: Brightness\." "brightness"
echo ""

echo "## Other Deprecations:"
count_pattern "activeColor:" "activeColor"
count_pattern "checkColor:" "checkColor"
count_pattern "textColor:" "textColor (SnackBarAction)"
count_pattern "\.withOpacity" "withOpacity"
echo ""

# Contar total de problemas
total=$(grep -r "headline[1-6]\|bodyText[1-2]\|subtitle[1-2]\|WillPopScope\|ButtonBar\|brightness: Brightness\.\|primary: Colors\.\|onPrimary: Colors\." lib/ 2>/dev/null | wc -l | tr -d ' ')

echo -e "${BLUE}📊 Total deprecated patterns found: ${total}${NC}"
echo ""

# Ejecutar flutter analyze
echo -e "${BLUE}🔬 Running flutter analyze...${NC}"
echo ""
flutter analyze --no-fatal-infos 2>&1 | head -50
echo ""

# Sugerencias
echo -e "${BLUE}💡 Next Steps:${NC}"
echo ""
echo "1. Run 'dart fix --dry-run' to see what can be auto-fixed"
echo "2. Run 'dart fix --apply' to apply automatic fixes"
echo "3. Manually update remaining deprecated code"
echo "4. Run 'flutter test' to ensure everything still works"
echo "5. Update pubspec.yaml to latest Flutter version"
echo ""

echo -e "${GREEN}✅ Analysis complete!${NC}"
