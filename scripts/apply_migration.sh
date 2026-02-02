#!/bin/bash

# Script para aplicar migraciones automáticas a código Flutter deprecado

echo "======================================"
echo "Flutter Auto Migration Script"
echo "======================================"
echo ""

# Colores
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Navegar al directorio de la app
cd "$(dirname "$0")/../app" || exit

echo -e "${BLUE}📍 Working directory: $(pwd)${NC}"
echo ""

# Backup del código actual
backup_dir="../backup_$(date +%Y%m%d_%H%M%S)"
echo -e "${YELLOW}📦 Creating backup in: $backup_dir${NC}"
cp -r . "$backup_dir"
echo ""

# Actualizar dependencias
echo -e "${BLUE}📥 Getting latest dependencies...${NC}"
flutter pub get
echo ""

# Ejecutar dart fix en modo dry-run primero
echo -e "${BLUE}🔍 Checking what can be auto-fixed (dry-run)...${NC}"
dart fix --dry-run
echo ""

# Preguntar al usuario si quiere continuar
echo -e "${YELLOW}Do you want to apply these fixes? (y/n)${NC}"
read -r response

if [[ "$response" =~ ^[Yy]$ ]]; then
    echo ""
    echo -e "${BLUE}🔧 Applying automatic fixes...${NC}"
    dart fix --apply
    echo ""
    
    echo -e "${BLUE}🔬 Running analysis after fixes...${NC}"
    flutter analyze --no-fatal-infos
    echo ""
    
    echo -e "${GREEN}✅ Migration complete!${NC}"
    echo ""
    echo -e "${BLUE}Next steps:${NC}"
    echo "1. Review the changes with 'git diff'"
    echo "2. Run 'flutter test' to verify tests pass"
    echo "3. Build and test the app: 'flutter run'"
    echo "4. Manually fix any remaining issues"
    echo "5. Commit the changes"
    echo ""
    echo -e "${YELLOW}💾 Backup saved in: $backup_dir${NC}"
else
    echo ""
    echo -e "${YELLOW}Migration cancelled. No changes made.${NC}"
    rm -rf "$backup_dir"
fi
