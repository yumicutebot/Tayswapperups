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
            VStack {
                // Class Filter
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
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
                .padding(.vertical, 8)
                
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
                            
                            Text("No backups found for \(selectedClass.rawValue) characters.")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                        }
                        
                        Button("Create Your First Profile") {
                            dismiss()
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    List {
                        ForEach(backups) { backup in
                            BackupRowView(
                                backup: backup,
                                onRestore: {
                                    restoreBackup(backup)
                                },
                                onDelete: {
                                    backupToDelete = backup
                                    showingDeleteConfirmation = true
                                }
                            )
                        }
                    }
                    .listStyle(PlainListStyle())
                }
                
                Spacer()
                
                // Footer Actions
                HStack {
                    Button("Open Backup Folder") {
                        openBackupFolder()
                    }
                    .buttonStyle(.bordered)
                    
                    Spacer()
                    
                    Text("\(backups.count) backup\(backups.count == 1 ? "" : "s")")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding()
            }
            .navigationTitle("Backup Manager")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
        .onAppear {
            loadBackups()
        }
        .alert("Delete Backup", isPresented: $showingDeleteConfirmation) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                if let backup = backupToDelete {
                    deleteBackup(backup)
                }
            }
        } message: {
            if let backup = backupToDelete {
                Text("Are you sure you want to delete the backup for \(backup.characterName)? This action cannot be undone.")
            }
        }
    }
    
    private func loadBackups() {
        backups = profileManager.backupManager.getBackupsForClass(selectedClass.rawValue)
    }
    
    private func restoreBackup(_ backup: BackupInfo) {
        let success = profileManager.backupManager.restoreBackup(from: backup.fullPath)
        if success {
            // Show success message or update UI
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
                
                Text(wowClass.rawValue)
                    .font(.caption)
                    .fontWeight(isSelected ? .semibold : .regular)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(isSelected ? wowClass.color.opacity(0.2) : Color(.controlBackgroundColor))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(isSelected ? wowClass.color : Color.clear, lineWidth: 1.5)
            )
            .foregroundColor(isSelected ? wowClass.color : .primary)
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
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(backup.characterName)
                    .font(.headline)
                
                Text(backup.formattedDate)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            HStack(spacing: 8) {
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
        .padding(.vertical, 4)
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
