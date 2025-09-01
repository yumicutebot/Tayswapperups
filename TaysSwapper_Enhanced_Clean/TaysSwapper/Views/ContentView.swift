import SwiftUI

struct ContentView: View {
    @StateObject private var profileManager = ProfileManager()
    @EnvironmentObject var updateService: UpdateService
    @State private var showingAddProfile = false
    @State private var showingSettings = false
    @State private var selectedBackupClass: WoWClass?
    @State private var showingBackupManager = false
    
    var body: some View {
        NavigationSplitView {
            SidebarView()
        } detail: {
            if let currentProfile = profileManager.currentProfile {
                ProfileDetailView(profile: currentProfile)
            } else {
                WelcomeView()
            }
        }
        .navigationTitle("Tay's Swapper")
        .toolbar {
            ToolbarItemGroup(placement: .primaryAction) {
                Button(action: { showingBackupManager = true }) {
                    Label("Backup Manager", systemImage: "archivebox")
                }
                
                Button(action: { showingAddProfile = true }) {
                    Label("Add Profile", systemImage: "plus")
                }
                
                Button(action: { showingSettings = true }) {
                    Label("Settings", systemImage: "gear")
                }
            }
        }
        .sheet(isPresented: $showingAddProfile) {
            AddProfileView()
                .environmentObject(profileManager)
        }
        .sheet(isPresented: $showingSettings) {
            SettingsView()
                .environmentObject(profileManager)
        }
        .sheet(isPresented: $showingBackupManager) {
            BackupManagerView()
                .environmentObject(profileManager)
        }
        .sheet(isPresented: $updateService.showingUpdateAlert) {
            UpdateAlertView(updateService: updateService)
        }
        .environmentObject(profileManager)
    }
    
    @ViewBuilder
    private func SidebarView() -> some View {
        List {
            Section("Quick Actions") {
                Button(action: { updateService.checkForUpdates() }) {
                    HStack {
                        Image(systemName: updateService.isCheckingForUpdates ? "arrow.triangle.2.circlepath" : "arrow.down.circle")
                            .foregroundColor(.blue)
                        Text("Check for Updates")
                        if updateService.updateAvailable {
                            Spacer()
                            Circle()
                                .fill(.red)
                                .frame(width: 8, height: 8)
                        }
                    }
                }
                .disabled(updateService.isCheckingForUpdates)
                
                Button(action: { showingBackupManager = true }) {
                    HStack {
                        Image(systemName: "archivebox")
                            .foregroundColor(.orange)
                        Text("Manage Backups")
                    }
                }
            }
            
            Section("Profiles") {
                if profileManager.profiles.isEmpty {
                    Text("No profiles yet")
                        .foregroundColor(.secondary)
                        .italic()
                } else {
                    ForEach(profileManager.profiles) { profile in
                        ProfileRowView(profile: profile)
                    }
                    .onDelete(perform: deleteProfiles)
                }
            }
        }
        .listStyle(SidebarListStyle())
    }
    
    private func deleteProfiles(offsets: IndexSet) {
        for offset in offsets {
            profileManager.deleteProfile(profileManager.profiles[offset])
        }
    }
}

struct ProfileRowView: View {
    let profile: Profile
    @EnvironmentObject var profileManager: ProfileManager
    
    var body: some View {
        HStack {
            profile.characterClass.officialIcon
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 24, height: 24)
                .clipShape(Circle())
                .overlay(Circle().stroke(profile.characterClass.color, lineWidth: 2))
            
            VStack(alignment: .leading, spacing: 2) {
                Text(profile.name)
                    .font(.headline)
                    .foregroundColor(profile.isActive ? .primary : .secondary)
                
                Text(profile.characterClass.rawValue)
                    .font(.caption)
                    .foregroundColor(profile.characterClass.color)
            }
            
            Spacer()
            
            if profile.isActive {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.green)
            }
        }
        .padding(.vertical, 4)
        .contentShape(Rectangle())
        .onTapGesture {
            profileManager.activateProfile(profile)
        }
        .contextMenu {
            Button("Activate Profile") {
                profileManager.activateProfile(profile)
            }
            
            Button("Create Backup") {
                let _ = profileManager.createBackupForProfile(profile)
            }
            
            Divider()
            
            Button("Delete Profile", role: .destructive) {
                profileManager.deleteProfile(profile)
            }
        }
    }
}

struct WelcomeView: View {
    var body: some View {
        VStack(spacing: 30) {
            Image(systemName: "gamecontroller.fill")
                .font(.system(size: 80))
                .foregroundColor(.blue)
            
            VStack(spacing: 10) {
                Text("Welcome to Tay's Swapper")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("Manage your World of Warcraft addon profiles with ease")
                    .font(.title3)
                    .foregroundColor(.secondary)
            }
            
            VStack(spacing: 15) {
                FeatureRow(icon: "plus.circle", title: "Create Profiles", description: "Set up unlimited character profiles")
                FeatureRow(icon: "arrow.triangle.swap", title: "Quick Switching", description: "Switch between addon configurations instantly")
                FeatureRow(icon: "archivebox", title: "Auto Backups", description: "Your WTF folders are automatically backed up")
                FeatureRow(icon: "shield.checkered", title: "Safe & Reliable", description: "Never lose your addon configurations again")
            }
            .padding(.horizontal, 40)
            
            Text("Create your first profile to get started")
                .font(.callout)
                .foregroundColor(.secondary)
        }
        .padding(40)
    }
}

struct FeatureRow: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.blue)
                .frame(width: 30)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.headline)
                Text(description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
    }
}

struct ProfileDetailView: View {
    let profile: Profile
    @EnvironmentObject var profileManager: ProfileManager
    @State private var showingBackupCreation = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                // Profile Header
                HStack {
                    profile.characterClass.officialIcon
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 80, height: 80)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(profile.characterClass.color, lineWidth: 4))
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text(profile.name)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        
                        Text(profile.characterClass.rawValue)
                            .font(.title2)
                            .foregroundColor(profile.characterClass.color)
                        
                        Text("Character: \(profile.characterName)")
                            .font(.title3)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    VStack(spacing: 10) {
                        if profile.isActive {
                            Label("Active Profile", systemImage: "checkmark.circle.fill")
                                .foregroundColor(.green)
                                .font(.headline)
                        }
                        
                        Button("Create Backup") {
                            showingBackupCreation = true
                        }
                        .buttonStyle(.borderedProminent)
                    }
                }
                .padding(.horizontal, 40)
                .padding(.top, 30)
                
                // Profile Info Cards
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: 20) {
                    InfoCard(title: "Created", value: profile.createdDate.formatted(date: .abbreviated, time: .omitted))
                    InfoCard(title: "Last Backup", value: profile.lastBackupDate?.formatted(date: .abbreviated, time: .shortened) ?? "Never")
                    InfoCard(title: "Description", value: profile.description.isEmpty ? "No description" : profile.description)
                    InfoCard(title: "Status", value: profile.isActive ? "Active" : "Inactive")
                }
                .padding(.horizontal, 40)
                
                Spacer()
            }
        }
        .alert("Backup Created", isPresented: $showingBackupCreation) {
            Button("OK") { }
        } message: {
            Text("A backup of your WTF folder has been created for \(profile.characterName).")
        }
        .onAppear {
            if showingBackupCreation {
                let _ = profileManager.createBackupForProfile(profile)
            }
        }
    }
}

struct InfoCard: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.caption)
                .textCase(.uppercase)
                .foregroundColor(.secondary)
            
            Text(value)
                .font(.headline)
                .multilineTextAlignment(.leading)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color(.controlBackgroundColor))
        .cornerRadius(8)
    }
}

#Preview {
    ContentView()
        .environmentObject(UpdateService())
}
