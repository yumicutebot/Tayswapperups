import SwiftUI
import Foundation

class BackupManager: ObservableObject {
    @Published var wowPath: String = "/Applications/World of Warcraft/_retail_/"
    @Published var backupPath: String = "/Applications/World of Warcraft/_retail_/Tay Swapper Backups"
    
    private let fileManager = FileManager.default
    
    init() {
        loadSettings()
        createBackupStructure()
    }
    
    private func loadSettings() {
        wowPath = UserDefaults.standard.string(forKey: "wowPath") ?? "/Applications/World of Warcraft/_retail_/"
        updateBackupPath()
    }
    
    func saveSettings() {
        UserDefaults.standard.set(wowPath, forKey: "wowPath")
        updateBackupPath()
        createBackupStructure()
    }
    
    private func updateBackupPath() {
        backupPath = wowPath.appending("/Tay Swapper Backups")
    }
    
    private func createBackupStructure() {
        let classNames = [
            "Death Knight", "Demon Hunter", "Druid", "Evoker", "Hunter",
            "Mage", "Monk", "Paladin", "Priest", "Rogue", "Shaman", "Warlock", "Warrior"
        ]
        
        for className in classNames {
            let classPath = backupPath.appending("/\(className)")
            try? fileManager.createDirectory(atPath: classPath, withIntermediateDirectories: true, attributes: nil)
        }
    }
    
    func createBackup(for profile: Profile, characterName: String) -> Bool {
        let wtfSourcePath = wowPath.appending("/WTF")
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd-HH-mm-ss"
        let dateString = dateFormatter.string(from: Date())
        
        let backupName = "\(characterName)-\(dateString)"
        let classBackupPath = backupPath.appending("/\(profile.characterClass.rawValue)/\(backupName)")
        
        do {
            // Check if WTF folder exists
            guard fileManager.fileExists(atPath: wtfSourcePath) else {
                print("WTF folder not found at: \(wtfSourcePath)")
                return false
            }
            
            // Create backup directory
            try fileManager.createDirectory(atPath: classBackupPath, withIntermediateDirectories: true, attributes: nil)
            
            // Copy WTF folder contents
            let wtfContents = try fileManager.contentsOfDirectory(atPath: wtfSourcePath)
            for item in wtfContents {
                let sourcePath = wtfSourcePath.appending("/\(item)")
                let destinationPath = classBackupPath.appending("/\(item)")
                try fileManager.copyItem(atPath: sourcePath, toPath: destinationPath)
            }
            
            print("✅ Backup created: \(backupName)")
            return true
            
        } catch {
            print("❌ Backup failed: \(error.localizedDescription)")
            return false
        }
    }
    
    func restoreBackup(from backupPath: String) -> Bool {
        let wtfDestinationPath = wowPath.appending("/WTF")
        
        do {
            // Remove existing WTF folder
            if fileManager.fileExists(atPath: wtfDestinationPath) {
                try fileManager.removeItem(atPath: wtfDestinationPath)
            }
            
            // Create new WTF directory
            try fileManager.createDirectory(atPath: wtfDestinationPath, withIntermediateDirectories: true, attributes: nil)
            
            // Copy backup contents to WTF folder
            let backupContents = try fileManager.contentsOfDirectory(atPath: backupPath)
            for item in backupContents {
                let sourcePath = backupPath.appending("/\(item)")
                let destinationPath = wtfDestinationPath.appending("/\(item)")
                try fileManager.copyItem(atPath: sourcePath, toPath: destinationPath)
            }
            
            print("✅ Backup restored from: \(backupPath)")
            return true
            
        } catch {
            print("❌ Restore failed: \(error.localizedDescription)")
            return false
        }
    }
    
    func getBackupsForClass(_ className: String) -> [BackupInfo] {
        let classPath = backupPath.appending("/\(className)")
        
        do {
            let backupFolders = try fileManager.contentsOfDirectory(atPath: classPath)
            return backupFolders.compactMap { folder in
                let fullPath = classPath.appending("/\(folder)")
                let attributes = try? fileManager.attributesOfItem(atPath: fullPath)
                let creationDate = attributes?[.creationDate] as? Date ?? Date()
                
                // Parse character name and date from folder name
                let components = folder.components(separatedBy: "-")
                let characterName = components.first ?? "Unknown"
                
                return BackupInfo(
                    characterName: characterName,
                    className: className,
                    creationDate: creationDate,
                    folderName: folder,
                    fullPath: fullPath
                )
            }.sorted { $0.creationDate > $1.creationDate }
        } catch {
            print("❌ Failed to read backups for \(className): \(error.localizedDescription)")
            return []
        }
    }
    
    func deleteBackup(_ backup: BackupInfo) -> Bool {
        do {
            try fileManager.removeItem(atPath: backup.fullPath)
            print("✅ Deleted backup: \(backup.folderName)")
            return true
        } catch {
            print("❌ Failed to delete backup: \(error.localizedDescription)")
            return false
        }
    }
    
    func getBackupSize(_ backup: BackupInfo) -> String {
        guard let attributes = try? fileManager.attributesOfItem(atPath: backup.fullPath),
              let size = attributes[.size] as? Int64 else {
            return "Unknown"
        }
        
        let formatter = ByteCountFormatter()
        formatter.allowedUnits = [.useMB, .useGB]
        formatter.countStyle = .file
        return formatter.string(fromByteCount: size)
    }
}

struct BackupInfo: Identifiable {
    let id = UUID()
    let characterName: String
    let className: String
    let creationDate: Date
    let folderName: String
    let fullPath: String
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: creationDate)
    }
}
