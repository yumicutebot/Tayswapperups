import SwiftUI

struct BackupManagerView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var profileManager: ProfileManager
    @State private var selectedClass: WoWClass = .warrior
    @State private var backups: [BackupInfo] = []
    @State private var showingDeleteConfirmation = false
    @State private var backupToDelete: BackupInfo?
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Class Filter Bar
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        ForEach(WoWClass.allCases, id: \.self) { wowClass in
                            ClassFilterButton(
                                wowClass: wowClass,
                                isSelected: selectedClass == wowClass
                            ) {
                                selectedClass = wowClass
                                loadBackups()
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical, 10)
                .background(Color(.controlBackgroundColor))
                
                Divider()
                
                // Backups List
                if backups.isEmpty {
                    VStack(spacing: 20) {
                        Image(systemName: "archivebox")
                            .font(.system(size: 60))
                            .foregroundColor(.secondary)
                        
                        VStack(spacing: 8) {
                            Text("No Backups Found")
                                .font(.title2)
                                .fontWeight(.semibold)
                            
                            Text("No backups exist for \(selectedClass.rawValue) characters")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        
                        Text("Create a profile and use 'Create Backup' to save your WTF folder configurations here.")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 40)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    List {
                        ForEach(backups) { backup in
                            BackupRowView(backup: backup) {
                                restoreBackup(backup)
                            } onDelete: {
                                backupToDelete = backup
                                showingDeleteConfirmation = true
                            }
                        }
                    }
                    .listStyle(PlainListStyle())
                }
            }
            .navigationTitle("Backup Manager")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .primaryAction) {
                    Menu {
                        Button("Refresh Backups") {
                            loadBackups()
                        }
                        
                        Divider()
                        
                        Button("Open Backup Folder") {
                            openBackupFolder()
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle")
                    }
                }
            }
            .onAppear {
                loadBackups()
            }
            .alert("Delete Backup", isPresented: $showingDeleteConfirmation) {
                Button("Delete", role: .destructive) {
                    if let backup = backupToDelete {
                        deleteBackup(backup)
                    }
                }
                Button("Cancel", role: .cancel) { }
            } message: {
                if let backup = backupToDelete {
                    Text("Are you sure you want to delete the backup for \(backup.characterName)? This action cannot be undone.")
                }
            }
        }
    }
    
    private func loadBackups() {
        backups = profileManager.backupManager.getBackupsForClass(selectedClass.rawValue)
    }
    
    private func restoreBackup(_ backup: BackupInfo) {
        let success = profileManager.backupManager.restoreBackup(from: backup.fullPath)
        if success {
            // Show success message or notification
            print("✅ Successfully restored backup for \(backup.characterName)")
        }
    }
    
    private func deleteBackup(_ backup: BackupInfo) {
        let success = profileManager.backupManager.deleteBackup(backup)
        if success {
            loadBackups() // Refresh the list
        }
    }
    
    private func openBackupFolder() {
        let url = URL(fileURLWithPath: profileManager.backupManager.backupPath.appending("/\(selectedClass.rawValue)"))
        NSWorkspace.shared.open(url)
    }
}

struct ClassFilterButton: View {
    let wowClass: WoWClass
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 8) {
                wowClass.officialIcon
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 20, height: 20)
                    .clipShape(Circle())
                
                Text(wowClass.rawValue)
                    .font(.subheadline)
                    .fontWeight(isSelected ? .semibold : .regular)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(isSelected ? wowClass.color.opacity(0.2) : Color.clear)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(isSelected ? wowClass.color : Color.clear, lineWidth: 1.5)
            )
        }
        .buttonStyle(PlainButtonStyle())
        .animation(.easeInOut(duration: 0.2), value: isSelected)
    }
}

struct BackupRowView: View {
    let backup: BackupInfo
    let onRestore: () -> Void
    let onDelete: () -> Void
    
    var body: some View {
        HStack(spacing: 15) {
            // Character Class Icon
            if let wowClass = WoWClass.allCases.first(where: { $0.rawValue == backup.className }) {
                wowClass.officialIcon
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 40, height: 40)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(wowClass.color, lineWidth: 2))
            }
            
            // Backup Info
            VStack(alignment: .leading, spacing: 4) {
                Text(backup.characterName)
                    .font(.headline)
                
                Text(backup.formattedDate)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Text(backup.className)
                    .font(.caption)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 2)
                    .background(
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color.blue.opacity(0.1))
                    )
                    .foregroundColor(.blue)
            }
            
            Spacer()
            
            // Actions
            VStack(spacing: 8) {
                Button("Restore") {
                    onRestore()
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.small)
                
                Button("Delete") {
                    onDelete()
                }
                .buttonStyle(.bordered)
                .controlSize(.small)
                .foregroundColor(.red)
            }
        }
        .padding(.vertical, 8)
        .contentShape(Rectangle())
        .contextMenu {
            Button("Restore Backup") {
                onRestore()
            }
            
            Button("Show in Finder") {
                NSWorkspace.shared.selectFile(backup.fullPath, inFileViewerRootedAtPath: "")
            }
            
            Divider()
            
            Button("Delete Backup", role: .destructive) {
                onDelete()
            }
        }
    }
}

#Preview {
    BackupManagerView()
        .environmentObject(ProfileManager())
}