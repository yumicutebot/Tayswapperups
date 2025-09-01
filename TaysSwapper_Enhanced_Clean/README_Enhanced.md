# Tay's Swapper Enhanced v2.0.0

The ultimate World of Warcraft profile manager with auto-updates, official class icons, and professional macOS integration.

## ✨ New Features in v2.0.0

### 🔄 Auto-Update System
- Automatic update checking on app launch
- Daily background checks for new versions
- One-click download and installation of updates
- Manual update checking via menu or keyboard shortcut (⌘⇧U)

### 🎨 Official WoW Class Icons
- High-quality icons directly from Blizzard/WoW sources
- All 13 classes supported with authentic artwork
- Visual class identification in profile lists and backup manager
- Class-specific color coding throughout the interface

### 📂 Enhanced Backup System
- Organized backup structure by character class
- Backup location: `/Applications/World of Warcraft/_retail_/Tay Swapper Backups`
- Backup naming: `CharacterName-DateOfBackup` format
- Easy restore and management through dedicated Backup Manager
- Automatic backup creation when switching profiles

### 🖥️ Professional macOS Interface
- Native SwiftUI sidebar navigation
- Modern macOS design patterns and animations
- Menu bar integration with global hotkeys
- Proper macOS window management and toolbar

## 🚀 Installation

### Method 1: Automatic Installation (Recommended)
```bash
chmod +x install_enhanced.sh
./install_enhanced.sh
```

### Method 2: Manual Xcode Build
1. Open `TaysSwapper.xcodeproj` in Xcode
2. Select "TaysSwapper" scheme
3. Build and run (⌘R) or Archive for distribution

### Method 3: Download Pre-built Version
Use the download server if available for pre-compiled Universal Binary.

## 📋 System Requirements

- macOS 14.0 (Sonoma) or later
- Apple Silicon (M1/M2/M3) or Intel Mac
- Xcode 15.0+ (for building from source)
- World of Warcraft installed in standard location

## 🎮 How to Use

1. **Set WoW Path**: Go to Settings and set your WoW installation path
2. **Create Profiles**: Click "+" to create profiles for different characters
3. **Select Class**: Choose from 13 official WoW classes with authentic icons
4. **Switch Profiles**: Click on any profile in the sidebar to activate it
5. **Manage Backups**: Use the Backup Manager to restore or delete old configurations

## 🛠️ Troubleshooting

### Build Issues
- Ensure Xcode is installed and updated
- Install Command Line Tools: `xcode-select --install`
- Accept Xcode license: `sudo xcodebuild -license accept`

### Runtime Issues
- Check WoW path in Settings matches your installation
- Ensure you have write permissions to WoW directory
- Verify backup folder creation in: `/Applications/World of Warcraft/_retail_/Tay Swapper Backups`

## 🔧 Technical Details

### Architecture
- Native Swift/SwiftUI application
- JSON-based profile persistence
- File system monitoring for WTF folder changes
- Network-based update checking with GitHub API integration

### Security
- No network access except for update checking
- All file operations are local and reversible
- Backup system prevents data loss
- Sandboxed app bundle for security

## 📄 License

This software is provided as-is for personal use with World of Warcraft. 
Official WoW class icons are property of Blizzard Entertainment.

---

**Enhanced by AI Assistant with focus on reliability, user experience, and macOS integration.**
