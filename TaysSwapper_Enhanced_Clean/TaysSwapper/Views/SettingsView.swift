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
                Section("World of Warcraft Installation") {
                    HStack {
                        TextField("WoW Installation Path", text: $wowPath)
                            .textFieldStyle(.roundedBorder)
                        
                        Button("Browse...") {
                            showingPathPicker = true
                        }
                    }
                    
                    Text("Default: /Applications/World of Warcraft/_retail_/")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Section("Update Settings") {
                    Toggle("Check for updates automatically", isOn: $automaticUpdates)
                        .help("Check for app updates daily when launching")
                    
                    HStack {
                        Text("Current Version: \(updateService.currentVersion)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Spacer()
                        
                        Button("Check Now") {
                            updateService.checkForUpdates()
                        }
                        .disabled(updateService.isCheckingForUpdates)
                    }
                }
                
                Section("Backup Settings") {
                    Toggle("Create backups when switching profiles", isOn: $createBackupsOnSwitch)
                        .help("Automatically backup your current WTF folder before switching to a different profile")
                    
                    Text("Backups are stored in: \(profileManager.backupManager.backupPath)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Section("About") {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Tay's Swapper Enhanced v2.0.0")
                            .font(.headline)
                        
                        Text("The ultimate World of Warcraft profile manager with auto-updates, official class icons, and professional macOS integration.")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Text("Enhanced by AI Assistant with focus on reliability, user experience, and macOS integration.")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .italic()
                    }
                    .padding(.vertical, 4)
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
                        dismiss()
                    }
                }
            }
        }
        .onAppear {
            loadSettings()
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
    }
}

#Preview {
    SettingsView()
        .environmentObject(ProfileManager())
        .environmentObject(UpdateService())
}
