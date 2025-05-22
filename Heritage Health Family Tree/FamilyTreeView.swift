//
//  FamilyTreeView.swift
//  Heritage Health Family Tree
//
//  Created by DUJUAN PUGH on 5/6/25.
//

import  SwiftUI
import SwiftData

struct FamilyTreeView: View {
    @Query var members: [FamilyMember]
    @Environment(\.modelContext) var context
    @State private var showingAddMember = false
    @State private var searchText = ""
    @State private var selectedMember: FamilyMember?
    @State private var showingEditSheet = false
    
    var filteredMembers: [FamilyMember] {
        if searchText.isEmpty {
            return members
        }
        return members.filter { member in
            member.name.localizedCaseInsensitiveContains(searchText)
        }
    }

    var body: some View {
        VStack(spacing: 0) {
            // Search and List
            List {
                ForEach(filteredMembers, id: \ .id) { member in
                    MemberRowView(member: member)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            selectedMember = member
                            showingEditSheet = true
                        }
                }
                .onDelete { indexSet in
                    for index in indexSet {
                        let memberToDelete = filteredMembers[index]
                        deleteMember(memberToDelete)
                        if selectedMember?.id == memberToDelete.id {
                            selectedMember = nil
                            showingEditSheet = false
                        }
                    }
                }
            }
            .searchable(text: $searchText, prompt: "Search by name")
            .frame(height: 250)
        }
        .navigationTitle("Family Tree")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    showingAddMember = true
                }) {
                    Image(systemName: "person.badge.plus")
                }
            }
        }
        .sheet(isPresented: $showingAddMember) {
            NavigationStack {
              //  AddMemberView(selectedTab: .constant(0))
            }
        }
        .sheet(isPresented: $showingEditSheet) {
            if let member = selectedMember, members.contains(where: { $0.id == member.id }) {
                NavigationStack {
                    EditMemberView(member: member)
                }
            }
        }
    }

    private func deleteMember(_ member: FamilyMember) {
        // Remove from parent's children
        if let parent = member.parent, let index = parent.children?.firstIndex(where: { $0.id == member.id }) {
            parent.children?.remove(at: index)
        }
        // Remove parent reference from children
        if let children = member.children {
            for child in children {
                child.parent = nil
            }
        }
        // Delete the member from the context
        context.delete(member)
    }
}

struct MemberRowView: View {
    let member: FamilyMember
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(member.name)
                    .font(.headline)
                Spacer()
                Circle()
                    .fill(member.healthColor)
                    .frame(width: 12, height: 12)
            }
            Text("Generation: \(member.generation), Level: \(member.level)")
                .font(.subheadline)
                .foregroundColor(.secondary)
            if let parent = member.parent {
                Text("Child of: \(parent.name)")
                    .font(.caption)
                    .italic()
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
}

//#Preview {
//    let config = ModelConfiguration(isStoredInMemoryOnly: true)
//    let container = try! ModelContainer(for: FamilyMember.self, configurations: config)
//    
//    // Create sample data
//    let parent = FamilyMember(name: "Parent", healthStatus: .healthy, generation: 0, level: 0)
//    let child = FamilyMember(name: "Child", healthStatus: .atRisk, generation: 1, level: 1, parent: parent)
//    parent.children = [child]
//    
//    NavigationStack {
//        MemberDetailView(member: child)
//    }
//    .modelContainer(container)
//}
