#!/bin/bash

# Kanban Board - Xcode Project Setup Helper
# This script helps organize files for easy Xcode import

set -e

echo "🎯 Kanban Board - Project Setup"
echo "================================"
echo ""

# Check if running on macOS
if [[ "$OSTYPE" != "darwin"* ]]; then
    echo "⚠️  This script is designed for macOS"
    echo "    Please follow QUICKSTART.md for manual setup"
    exit 1
fi

# Check if Xcode is installed
if ! command -v xcodebuild &> /dev/null; then
    echo "❌ Xcode is not installed"
    echo "   Download from: https://apps.apple.com/app/xcode/id497799835"
    exit 1
fi

XCODE_VERSION=$(xcodebuild -version | head -n 1 | awk '{print $2}')
echo "✅ Found Xcode version: $XCODE_VERSION"
echo ""

# Check directory structure
if [ ! -d "KanbanBoard" ]; then
    echo "❌ KanbanBoard directory not found"
    echo "   Run this script from the repository root"
    exit 1
fi

echo "📁 Verifying file structure..."

REQUIRED_FILES=(
    "KanbanBoard/KanbanBoardApp.swift"
    "KanbanBoard/Models/Task.swift"
    "KanbanBoard/Models/Project.swift"
    "KanbanBoard/Models/TaskStatus.swift"
    "KanbanBoard/ViewModels/KanbanViewModel.swift"
    "KanbanBoard/Views/ContentView.swift"
    "KanbanBoard/Views/KanbanColumnView.swift"
    "KanbanBoard/Views/TaskCardView.swift"
    "KanbanBoard/Views/ProjectFilterView.swift"
    "KanbanBoard/Services/PersistenceManager.swift"
)

MISSING_FILES=()
for file in "${REQUIRED_FILES[@]}"; do
    if [ ! -f "$file" ]; then
        MISSING_FILES+=("$file")
    fi
done

if [ ${#MISSING_FILES[@]} -ne 0 ]; then
    echo "❌ Missing required files:"
    for file in "${MISSING_FILES[@]}"; do
        echo "   - $file"
    done
    exit 1
fi

echo "✅ All source files present (${#REQUIRED_FILES[@]} files)"
echo ""

# Summary
echo "🎉 Setup complete!"
echo ""
echo "📖 Next Steps:"
echo ""
echo "METHOD 1: Create New Xcode Project (Recommended)"
echo "================================================"
echo "1. Open Xcode"
echo "2. File > New > Project"
echo "3. Choose: macOS > App"
echo "4. Product Name: KanbanBoard"
echo "5. Interface: SwiftUI"
echo "6. Language: Swift"
echo "7. Save OUTSIDE this folder (e.g., Desktop)"
echo "8. Add files from: $(pwd)/KanbanBoard/"
echo "9. Right-click KanbanBoard folder > Add Files to KanbanBoard"
echo "10. Select all items in KanbanBoard/ folder"
echo "11. Check: ✅ Copy items if needed"
echo "12. Click Add"
echo "13. Delete Xcode's template ContentView.swift and KanbanBoardApp.swift"
echo "14. Press ⌘R to run!"
echo ""
echo "METHOD 2: Open in Xcode and Create Project"
echo "=========================================="
echo "1. Run: open -a Xcode ."
echo "2. In Xcode: File > New > Project in Current Folder"
echo "3. Follow steps above to add files"
echo ""
echo "📚 Full instructions: See QUICKSTART.md"
echo ""
echo "🐛 Troubleshooting: See QUICKSTART.md troubleshooting section"
echo ""

# Ask if user wants to open Xcode
read -p "Open this directory in Xcode now? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "🚀 Opening Xcode..."
    open -a Xcode .
    echo ""
    echo "In Xcode:"
    echo "1. File > New > Project"
    echo "2. Choose: macOS > App > Next"
    echo "3. Save IN THIS FOLDER"
    echo "4. Then add KanbanBoard/ files to the project"
fi

echo ""
echo "Happy coding! 🎉"
