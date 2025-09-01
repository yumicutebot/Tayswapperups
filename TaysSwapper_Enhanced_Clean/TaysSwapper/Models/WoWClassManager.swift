import SwiftUI
import Foundation

struct Profile: Identifiable, Codable {
    var id = UUID()
    var name: String
    var characterClass: WoWClass
    var characterName: String
    var description: String
    var isActive: Bool = false
    var createdDate: Date = Date()
    var wtfPath: String = ""
    var lastBackupDate: Date?
}

enum WoWClass: String, CaseIterable, Codable {
    case deathKnight = "Death Knight"
    case demonHunter = "Demon Hunter"
    case druid = "Druid"
    case evoker = "Evoker"
    case hunter = "Hunter"
    case mage = "Mage"
    case monk = "Monk"
    case paladin = "Paladin"
    case priest = "Priest"
    case rogue = "Rogue"
    case shaman = "Shaman"
    case warlock = "Warlock"
    case warrior = "Warrior"
    
    var iconName: String {
        switch self {
        case .deathKnight: return "DeathKnightIcon"
        case .demonHunter: return "DemonHunterIcon"
        case .druid: return "DruidIcon"
        case .evoker: return "EvokerIcon"
        case .hunter: return "HunterIcon"
        case .mage: return "MageIcon"
        case .monk: return "MonkIcon"
        case .paladin: return "PaladinIcon"
        case .priest: return "PriestIcon"
        case .rogue: return "RogueIcon"
        case .shaman: return "ShamanIcon"
        case .warlock: return "WarlockIcon"
        case .warrior: return "WarriorIcon"
        }
    }
    
    var color: Color {
        switch self {
        case .deathKnight: return Color(.systemPurple)
        case .demonHunter: return Color(.systemIndigo)
        case .druid: return Color(.systemGreen)
        case .evoker: return Color(.systemTeal)
        case .hunter: return Color(.systemOrange)
        case .mage: return Color(.systemBlue)
        case .monk: return Color(.systemYellow)
        case .paladin: return Color(.systemPink)
        case .priest: return Color(.systemGray)
        case .rogue: return Color(.systemBrown)
        case .shaman: return Color(.systemCyan)
        case .warlock: return Color(.systemPurple)
        case .warrior: return Color(.systemRed)
        }
    }
    
    var icon: Image {
        // Try to load custom icon first, fallback to SF Symbol
        if let nsImage = NSImage(named: iconName) {
            return Image(nsImage: nsImage)
        } else {
            // Fallback SF Symbol
            let fallbackIcon = switch self {
            case .deathKnight: "skull"
            case .demonHunter: "flame.fill"
            case .druid: "leaf.fill"
            case .evoker: "sparkles"
            case .hunter: "target"
            case .mage: "wand.and.stars"
            case .monk: "figure.martial.arts"
            case .paladin: "shield.fill"
            case .priest: "cross.fill"
            case .rogue: "theatermasks.fill"
            case .shaman: "bolt.fill"
            case .warlock: "flame.circle.fill"
            case .warrior: "sword"
            }
            return Image(systemName: fallbackIcon)
        }
    }
}

class ProfileManager: ObservableObject {
    @Published var profiles: [Profile] = []
    @Published var currentProfile: Profile?
    @Published var wowPath: String = "/Applications/World of Warcraft/_retail_/"
    
    private let userDefaults = UserDefaults.standard
    @Published var backupManager = BackupManager()
    
    init() {
        loadProfiles()
        loadSettings()
    }
    
    func loadProfiles() {
        if let data = userDefaults.data(forKey: "profiles"),
           let decodedProfiles = try? JSONDecoder().decode([Profile].self, from: data) {
            self.profiles = decodedProfiles
            self.currentProfile = decodedProfiles.first(where: { $0.isActive })
        }
    }
    
    func saveProfiles() {
        if let encoded = try? JSONEncoder().encode(profiles) {
            userDefaults.set(encoded, forKey: "profiles")
        }
    }
    
    func loadSettings() {
        wowPath = userDefaults.string(forKey: "wowPath") ?? "/Applications/World of Warcraft/_retail_/"
        backupManager.wowPath = wowPath
    }
    
    func saveSettings() {
        userDefaults.set(wowPath, forKey: "wowPath")
        backupManager.wowPath = wowPath
        backupManager.saveSettings()
    }
    
    func addProfile(_ profile: Profile) {
        profiles.append(profile)
        saveProfiles()
    }
    
    func deleteProfile(_ profile: Profile) {
        profiles.removeAll { $0.id == profile.id }
        if currentProfile?.id == profile.id {
            currentProfile = nil
        }
        saveProfiles()
    }
    
    func activateProfile(_ profile: Profile) {
        // Create backup of current WTF if requested
        if let currentProfile = currentProfile, !currentProfile.characterName.isEmpty {
            let _ = backupManager.createBackup(for: currentProfile, characterName: currentProfile.characterName)
        }
        
        // Deactivate current profile
        if let currentIndex = profiles.firstIndex(where: { $0.isActive }) {
            profiles[currentIndex].isActive = false
        }
        
        // Activate new profile
        if let profileIndex = profiles.firstIndex(where: { $0.id == profile.id }) {
            profiles[profileIndex].isActive = true
            currentProfile = profiles[profileIndex]
            
            // Restore backup if available
            let backups = backupManager.getBackupsForClass(profile.characterClass.rawValue)
            if let latestBackup = backups.first(where: { $0.characterName == profile.characterName }) {
                let _ = backupManager.restoreBackup(from: latestBackup.fullPath)
                profiles[profileIndex].lastBackupDate = Date()
            }
        }
        
        saveProfiles()
    }
    
    func createBackupForProfile(_ profile: Profile) -> Bool {
        let success = backupManager.createBackup(for: profile, characterName: profile.characterName)
        if success, let profileIndex = profiles.firstIndex(where: { $0.id == profile.id }) {
            profiles[profileIndex].lastBackupDate = Date()
            saveProfiles()
        }
        return success
    }
}
