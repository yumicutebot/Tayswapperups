import SwiftUI

@main
struct TaysSwapperApp: App {
    @StateObject private var updateService = UpdateService()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .frame(minWidth: 1200, minHeight: 800)
                .environmentObject(updateService)
        }
        .windowStyle(.hiddenTitleBar)
        .windowToolbarStyle(.unified)
        .commands {
            CommandGroup(replacing: .newItem) {
                Button("New Profile") {
                    // Handle new profile action
                }
                .keyboardShortcut("n", modifiers: .command)
            }
            
            CommandGroup(after: .help) {
                Button("Check for Updates") {
                    updateService.checkForUpdates()
                }
                .keyboardShortcut("u", modifiers: [.command, .shift])
            }
        }
    }
}
