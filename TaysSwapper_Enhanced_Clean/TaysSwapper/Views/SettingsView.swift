import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var profileManager: ProfileManager
    @EnvironmentObject var updateService: UpdateService
    
    @State private var wowPath: String = ""
    @State private var automaticUpdates = true
    @State private var createBackupsOnSwitch = true
    @State private var showingPathPicker = false
    
    var body: some View {
        NavigationView {
            Form {
                Section("World of Warcraft") {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("WoW Installation Path")
                            .font(.headline)
                        
                        HStack {
                            TextField("Path to World of Warcraft", text: $wowPath)
                                .textFieldStyle(.roundedBorder)
                            
                            Button("Browse") {
                                showingPathPicker = true
                            }
                            .buttonStyle(.bordered)
                        }
                        
                        Text("This should point to your World of Warcraft installation folder containing the WTF directory.")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                Section("Backup Settings") {
                    Toggle("Create backups when switching profiles", isOn: $createBackupsOnSwitch)
                        .help("Automatically backup your current WTF folder before switching to a different profile")
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Backup Location")
                            .font(.headline)
                        
                        Text(profileManager.backupManager.backupPath)
                            .font(.system(.caption, design: .monospaced))
                            .foregroundColor(.secondary)
                            .padding(8)
                            .background(Color(.controlBackgroundColor))
                            .cornerRadius(6)
                        
                        Text("Backups are organized by class and stored as 'CharacterName-DateOfBackup' folders.")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                Section("Updates") {
                    Toggle("Check for updates automatically", isOn: $automaticUpdates)
                        .help("Check for new versions when the app starts")
                    
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Current Version")
                                .font(.headline)
                            Text("v\(updateService.currentVersion)")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        Button("Check Now") {
                            updateService.checkForUpdates()
                        }
                        .buttonStyle(.bordered)
                        .disabled(updateService.isCheckingForUpdates)
                    }
                    
                    if updateService.updateAvailable {
                        HStack {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .foregroundColor(.orange)
                            VStack(alignment: .leading) {
                                Text("Update Available")
                                    .font(.headline)
                                Text("Version \(updateService.latestVersion) is ready to download")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                            Button("Download") {
                                updateService.downloadAndInstallUpdate()
                            }
                            .buttonStyle(.borderedProminent)
                        }
                        .padding(12)
                        .background(Color.orange.opacity(0.1))
                        .cornerRadius(8)
                    }
                }
                
                Section("About") {
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Image(systemName: "gamecontroller.fill")
                                .font(.title)
                                .foregroundColor(.blue)
                            VStack(alignment: .leading) {
                                Text("Tay's Swapper")
                                    .font(.headline)
                                Text("WoW Profile Manager")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                        }
                        
                        Text("Manage unlimited World of Warcraft addon profiles with automatic backups, official class icons, and seamless profile switching.")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .navigationTitle("Settings")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveSettings()
                    }
                }
            }
            .onAppear {
                loadSettings()
            }
        }
        .fileImporter(
            isPresented: $showingPathPicker,
            allowedContentTypes: [.folder],
            allowsMultipleSelection: false
        ) { result in
            switch result {
            case .success(let urls):
                if let url = urls.first {
                    wowPath = url.path
                }
            case .failure(let error):
                print("Error selecting folder: \(error)")
            }
        }
    }
    
    private func loadSettings() {
        wowPath = profileManager.wowPath
        automaticUpdates = UserDefaults.standard.bool(forKey: "automaticUpdates")
        createBackupsOnSwitch = UserDefaults.standard.bool(forKey: "createBackupsOnSwitch")
    }
    
    private func saveSettings() {
        profileManager.wowPath = wowPath
        profileManager.saveSettings()
        
        UserDefaults.standard.set(automaticUpdates, forKey: "automaticUpdates")
        UserDefaults.standard.set(createBackupsOnSwitch, forKey: "createBackupsOnSwitch")
        
        dismiss()
    }
}

#Preview {
    SettingsView()
        .environmentObject(ProfileManager())
        .environmentObject(UpdateService())
}