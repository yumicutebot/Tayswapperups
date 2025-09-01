import SwiftUI

struct AddProfileView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var profileManager: ProfileManager
    
    @State private var profileName = ""
    @State private var characterName = ""
    @State private var characterClass: WoWClass = .warrior
    @State private var description = ""
    @State private var createBackup = true
    
    var body: some View {
        NavigationView {
            Form {
                Section("Profile Information") {
                    TextField("Profile Name", text: $profileName)
                        .textFieldStyle(.roundedBorder)
                    
                    TextField("Character Name", text: $characterName)
                        .textFieldStyle(.roundedBorder)
                    
                    TextField("Description (Optional)", text: $description, axis: .vertical)
                        .textFieldStyle(.roundedBorder)
                        .lineLimit(3)
                }
                
                Section("Character Class") {
                    ClassSelectionGrid(selectedClass: $characterClass)
                }
                
                Section("Backup Options") {
                    Toggle("Create backup of current WTF folder", isOn: $createBackup)
                        .help("This will save your current addon configuration before switching to the new profile")
                }
            }
            .navigationTitle("New Profile")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Create") {
                        createProfile()
                    }
                    .disabled(profileName.isEmpty || characterName.isEmpty)
                }
            }
        }
    }
    
    private func createProfile() {
        let newProfile = Profile(
            name: profileName,
            characterClass: characterClass,
            characterName: characterName,
            description: description
        )
        
        profileManager.addProfile(newProfile)
        
        if createBackup && profileManager.currentProfile != nil {
            let _ = profileManager.createBackupForProfile(newProfile)
        }
        
        dismiss()
    }
}

struct ClassSelectionGrid: View {
    @Binding var selectedClass: WoWClass
    
    let columns = [
        GridItem(.adaptive(minimum: 120))
    ]
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: 15) {
            ForEach(WoWClass.allCases, id: \.self) { wowClass in
                ClassSelectionCard(
                    wowClass: wowClass,
                    isSelected: selectedClass == wowClass
                ) {
                    selectedClass = wowClass
                }
            }
        }
        .padding(.vertical, 10)
    }
}

struct ClassSelectionCard: View {
    let wowClass: WoWClass
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        VStack(spacing: 8) {
            wowClass.officialIcon
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 40, height: 40)
                .clipShape(Circle())
                .overlay(
                    Circle()
                        .stroke(wowClass.color, lineWidth: isSelected ? 3 : 1)
                )
                .shadow(radius: isSelected ? 4 : 0)
            
            Text(wowClass.rawValue)
                .font(.caption)
                .fontWeight(isSelected ? .bold : .regular)
                .foregroundColor(isSelected ? wowClass.color : .primary)
                .multilineTextAlignment(.center)
                .lineLimit(2)
        }
        .frame(width: 100, height: 80)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(isSelected ? wowClass.color.opacity(0.1) : Color(.controlBackgroundColor))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(isSelected ? wowClass.color : Color.clear, lineWidth: 2)
        )
        .contentShape(Rectangle())
        .onTapGesture(perform: onTap)
        .animation(.easeInOut(duration: 0.2), value: isSelected)
    }
}

#Preview {
    AddProfileView()
        .environmentObject(ProfileManager())
}