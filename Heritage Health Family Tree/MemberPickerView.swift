import SwiftUI
import SwiftData

struct MemberPickerView: View {
    @Environment(\.dismiss) private var dismiss
    @Query private var members: [FamilyMember]
    @Binding var selectedMember: FamilyMember?
    
    var body: some View {
        NavigationStack {
            List(members) { member in
                Button(action: {
                    selectedMember = member
                    dismiss()
                }) {
                    HStack {
                        Text(member.name)
                        Spacer()
                        if selectedMember?.id == member.id {
                            Image(systemName: "checkmark")
                                .foregroundColor(.blue)
                        }
                    }
                }
            }
            .navigationTitle("Select Member")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
            }
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: FamilyMember.self, configurations: config)
    
    // Create sample data
    let parent = FamilyMember(name: "Parent", healthStatus: .healthy, generation: 0, level: 0)
    let child = FamilyMember(name: "Child", parent: parent, healthStatus: .atRisk, generation: 1, level: 1)
    parent.children = [child]
    
    return NavigationStack {
        MemberPickerView(selectedMember: .constant(nil))
            .modelContainer(container)
    }
} 
