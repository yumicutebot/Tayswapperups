#!/bin/bash
# Tay's Swapper Enhanced v2.0.0 - Clean Installation Script

echo "🎮 Installing Tay's Swapper Enhanced v2.0.0..."
echo "Features: Auto-updates, Official WoW Class Icons, Advanced Backup System"
echo ""

# Check for Xcode
if ! command -v xcodebuild &> /dev/null; then
    echo "⚠️  Xcode not found."
    echo "Please install Xcode from the App Store, then:"
    echo "1. Run: xcode-select --install"
    echo "2. Run: sudo xcodebuild -license accept"
    echo "3. Run this installer again"
    exit 1
fi

echo "🔨 Building Enhanced Tay's Swapper..."

# Clean any previous builds
rm -rf build

# Build with Xcode
xcodebuild -project TaysSwapper.xcodeproj \
           -scheme TaysSwapper \
           -configuration Release \
           -derivedDataPath build \
           clean build

if [ $? -eq 0 ]; then
    echo "✅ Build successful!"
    
    # Find the built app
    APP_PATH=$(find build -name "Tay's Swapper.app" -type d | head -1)
    
    if [ -n "$APP_PATH" ] && [ -d "$APP_PATH" ]; then
        echo "📦 Installing to Applications..."
        
        # Remove existing installation
        rm -rf "/Applications/Tay's Swapper.app"
        
        # Install new app
        cp -R "$APP_PATH" "/Applications/"
        
        echo "✅ Installation complete!"
        echo ""
        echo "🎉 Tay's Swapper Enhanced v2.0.0 installed successfully!"
        echo ""
        echo "✨ New Features:"
        echo "• Auto-update system with daily checks"
        echo "• Official WoW class icons (13 classes)"
        echo "• Class-organized backup system"
        echo "• Backup location: /Applications/World of Warcraft/_retail_/Tay Swapper Backups"
        echo "• Professional SwiftUI sidebar interface"
        echo ""
        echo "🚀 Launch the app:"
        open "/Applications/Tay's Swapper.app"
        
    else
        echo "❌ Built app not found"
        echo "Looking for app bundle..."
        find build -name "*.app" -type d
    fi
else
    echo "❌ Build failed"
    echo "Try opening TaysSwapper.xcodeproj in Xcode and building manually"
fi
