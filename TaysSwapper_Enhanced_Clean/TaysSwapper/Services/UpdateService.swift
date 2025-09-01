import SwiftUI
import Foundation

class UpdateService: ObservableObject {
    @Published var isCheckingForUpdates = false
    @Published var updateAvailable = false
    @Published var latestVersion: String = ""
    @Published var currentVersion: String = "2.0.0"
    @Published var showingUpdateAlert = false
    @Published var updateMessage: String = ""
    
    private let updateCheckURL = "https://api.github.com/repos/taysswapper/releases/latest"
    private let timer = Timer.publish(every: 86400, on: .main, in: .common).autoconnect() // Check daily
    
    init() {
        // Get current version from bundle
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            currentVersion = version
        }
    }
    
    func scheduleAutomaticChecks() {
        // Check for updates on app launch if more than 24 hours since last check
        let lastCheck = UserDefaults.standard.object(forKey: "lastUpdateCheck") as? Date ?? Date.distantPast
        if Date().timeIntervalSince(lastCheck) > 86400 {
            checkForUpdates(isAutomatic: true)
        }
    }
    
    func checkForUpdates(isAutomatic: Bool = false) {
        guard !isCheckingForUpdates else { return }
        
        isCheckingForUpdates = true
        updateAvailable = false
        
        guard let url = URL(string: updateCheckURL) else {
            handleUpdateCheckError("Invalid update URL", isAutomatic: isAutomatic)
            return
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            DispatchQueue.main.async {
                self?.isCheckingForUpdates = false
                
                if let error = error {
                    self?.handleUpdateCheckError("Network error: \\(error.localizedDescription)", isAutomatic: isAutomatic)
                    return
                }
                
                guard let data = data else {
                    self?.handleUpdateCheckError("No data received", isAutomatic: isAutomatic)
                    return
                }
                
                do {
                    if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                       let tagName = json["tag_name"] as? String {
                        self?.processUpdateResponse(tagName: tagName, isAutomatic: isAutomatic)
                    } else {
                        self?.handleUpdateCheckError("Invalid response format", isAutomatic: isAutomatic)
                    }
                } catch {
                    self?.handleUpdateCheckError("Failed to parse response", isAutomatic: isAutomatic)
                }
            }
        }.resume()
        
        // Record the check time
        UserDefaults.standard.set(Date(), forKey: "lastUpdateCheck")
    }
    
    private func processUpdateResponse(tagName: String, isAutomatic: Bool) {
        latestVersion = tagName.replacingOccurrences(of: "v", with: "")
        
        if isVersionNewer(latestVersion, than: currentVersion) {
            updateAvailable = true
            updateMessage = "Tay's Swapper \\(latestVersion) is available! You have \\(currentVersion)."
            if !isAutomatic {
                showingUpdateAlert = true
            }
        } else {
            if !isAutomatic {
                updateMessage = "You're running the latest version (\\(currentVersion))."
                showingUpdateAlert = true
            }
        }
    }
    
    private func handleUpdateCheckError(_ message: String, isAutomatic: Bool) {
        if !isAutomatic {
            updateMessage = "Update check failed: \\(message)"
            showingUpdateAlert = true
        }
    }
    
    private func isVersionNewer(_ newVersion: String, than currentVersion: String) -> Bool {
        let newComponents = newVersion.split(separator: ".").compactMap { Int($0) }
        let currentComponents = currentVersion.split(separator: ".").compactMap { Int($0) }
        
        for i in 0..<max(newComponents.count, currentComponents.count) {
            let newVersionPart = i < newComponents.count ? newComponents[i] : 0
            let currentVersionPart = i < currentComponents.count ? currentComponents[i] : 0
            
            if newVersionPart > currentVersionPart {
                return true
            } else if newVersionPart < currentVersionPart {
                return false
            }
        }
        
        return false
    }
    
    func downloadAndInstallUpdate() {
        guard let url = URL(string: "https://github.com/taysswapper/releases/latest") else { return }
        NSWorkspace.shared.open(url)
    }
}

// Update Alert View
struct UpdateAlertView: View {
    @ObservedObject var updateService: UpdateService
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: updateService.updateAvailable ? "arrow.down.circle.fill" : "checkmark.circle.fill")
                .font(.system(size: 50))
                .foregroundColor(updateService.updateAvailable ? .blue : .green)
            
            Text(updateService.updateAvailable ? "Update Available" : "Up to Date")
                .font(.title2)
                .fontWeight(.bold)
            
            Text(updateService.updateMessage)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            HStack {
                if updateService.updateAvailable {
                    Button("Download Update") {
                        updateService.downloadAndInstallUpdate()
                        updateService.showingUpdateAlert = false
                    }
                    .buttonStyle(.borderedProminent)
                    
                    Button("Later") {
                        updateService.showingUpdateAlert = false
                    }
                    .buttonStyle(.bordered)
                } else {
                    Button("OK") {
                        updateService.showingUpdateAlert = false
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
        }
        .padding(30)
        .frame(width: 400)
    }
}