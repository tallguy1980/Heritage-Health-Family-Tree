import SwiftUI
import SwiftData

struct MemberDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @Bindable var member: FamilyMember
    @State private var showingEditSheet = false
    
    var body: some View {
        List {
            Section(header: Text("Basic Information")) {
                LabeledContent("Name", value: member.name)
                LabeledContent("Age", value: "\(member.age)")
                LabeledContent("Birth Date", value: member.birthDate.formatted(date: .long, time: .omitted))
                if member.deceased {
                    LabeledContent("Status", value: "Deceased")
                }
            }
            
            Section(header: Text("Health Information")) {
                LabeledContent("Health Status", value: member.healthStatus.rawValue.capitalized)
                LabeledContent("Last Checkup", value: member.lastCheckup.formatted(date: .long, time: .omitted))
                
                if !member.healthConditions.isEmpty {
                    VStack(alignment: .leading) {
                        Text("Health Conditions")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        ForEach(member.healthConditions, id: \.self) { condition in
                            Text("• \(condition)")
                                .padding(.leading)
                        }
                    }
                }
            }
            
            if let parent = member.parent {
                Section(header: Text("Family Relationship")) {
                    LabeledContent("Parent", value: parent.name)
                }
            }
            
            if let children = member.children, !children.isEmpty {
                Section(header: Text("Children")) {
                    ForEach(children) { child in
                        Text(child.name)
                    }
                }
            }
            
            if !member.notes.isEmpty {
                Section(header: Text("Notes")) {
                    Text(member.notes)
                }
            }
        }
        .navigationTitle("Member Details")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button("Edit") {
                    showingEditSheet = true
                }
            }
        }
        .sheet(isPresented: $showingEditSheet) {
            NavigationStack {
                EditMemberView(member: member)
            }
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: FamilyMember.self, configurations: config)
    
    let member = FamilyMember(
        name: "John Doe",
        age: 45,
        birthDate: Date(),
        deceased: false,
        lastCheckup: Date(),
        notes: "Regular checkups",
        healthConditions: ["Hypertension", "Diabetes"],
        parent: nil,
        healthStatus: .atRisk,
        generation: 0,
        level: 0
    )
    
    return NavigationStack {
        MemberDetailView(member: member)
    }
    .modelContainer(container)
} 