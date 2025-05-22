//
//  Heritage.swift
//  Heritage Health Family Tree
//
//  Created by DUJUAN PUGH on 5/19/25.
//


import SwiftUI
import SwiftData

struct EditMemberView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    @Bindable var member: FamilyMember
    @Query private var members: [FamilyMember]
    
    @State private var name: String
    @State private var healthStatus: HealthStatus
    @State private var generation: Int
    @State private var level: Int
    @State private var selectedParent: FamilyMember?
    @State private var showDeleteAlert = false
    
    init(member: FamilyMember) {
        self.member = member
        _name = State(initialValue: member.name)
        _healthStatus = State(initialValue: member.healthStatus)
        _generation = State(initialValue: member.generation)
        _level = State(initialValue: member.level)
        _selectedParent = State(initialValue: member.parent)
    }
    
    var body: some View {
        Form {
            Section(header: Text("Basic Information")) {
                TextField("Name", text: $name)
                
                Picker("Health Status", selection: $healthStatus) {
                    ForEach([HealthStatus.healthy, .atRisk, .needsAttention, .critical], id: \.self) { status in
                        Text(status.rawValue.capitalized)
                            .tag(status)
                    }
                }
            }
            
            Section(header: Text("Family Position")) {
                Stepper("Generation: \(generation)", value: $generation, in: 0...10)
                Stepper("Level: \(level)", value: $level, in: 0...10)
            }
            
            Section(header: Text("Family Relations")) {
                Picker("Parent", selection: $selectedParent) {
                    Text("None").tag(nil as FamilyMember?)
                    ForEach(members.filter { $0.name != member.name }, id: \.name) { potentialParent in
                        Text(potentialParent.name).tag(potentialParent as FamilyMember?)
                    }
                }
            }
        }
        .navigationTitle("Edit Member")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Save") {
                    saveChanges()
                }
            }
        }
        Section {
            Button(role: .destructive) {
                showDeleteAlert = true
            } label: {
                Label("Delete Member", systemImage: "trash")
            }
        }
        .alert("Delete Member?", isPresented: $showDeleteAlert) {
            Button("Delete", role: .destructive) {
                deleteMember()
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("Are you sure you want to delete this family member? This action cannot be undone.")
        }
    }
    
    private func saveChanges() {
        member.name = name
        member.healthStatus = healthStatus
        member.generation = generation
        member.level = level
        member.parent = selectedParent
        
        if let parent = selectedParent {
            if parent.children == nil {
                parent.children = []
            }
            if !parent.children!.contains(where: { $0.name == member.name }) {
                parent.children!.append(member)
            }
        }
        
        dismiss()
    }
    
    private func deleteMember() {
        context.delete(member)
        dismiss()
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: FamilyMember.self, configurations: config)
    
    let member = FamilyMember(name: "Test Member", healthStatus: .healthy, generation: 1, level: 1)
    
    return NavigationStack {
        EditMemberView(member: member)
    }
    .modelContainer(container)
} 
