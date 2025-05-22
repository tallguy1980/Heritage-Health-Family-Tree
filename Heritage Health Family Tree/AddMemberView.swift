//
//  AddMemberView.swift
//  Heritage Health Family Tree
//
//  Created by DUJUAN PUGH on 5/6/25.
//

import SwiftUI
import SwiftData

struct AddMemberView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    @State private var name: String = ""
    @State private var age: String = ""
    @State private var birthDate: Date = Date()
    @State private var deceased: Bool = false
    @State private var lastCheckup: Date = Date()
    @State private var healthConditions: String = ""
    @State private var medications: String = ""
    @State private var allergies: String = ""
    @State private var medicalHistory: String = ""
    // For parent selection
    @Query private var allMembers: [FamilyMember]
    @State private var selectedParent: FamilyMember?

    // Health condition selector feature
    @State private var showingHealthConditionSelector = false
    @State private var selectedHealthConditions: Set<String> = []
    private let commonHealthConditions = [
        "Diabetes", "Hypertension", "Asthma", "Heart Disease", "Cancer",
        "Arthritis", "Allergies", "Obesity", "Depression", "Anxiety"
    ]

    // Medication selector feature
    @State private var showingMedicationSelector = false
    @State private var selectedMedications: Set<String> = []
    private let medicationsByCondition: [String: [String]] = [
        "Diabetes": ["Metformin", "Insulin", "Glipizide"],
        "Hypertension": ["Lisinopril", "Amlodipine", "Hydrochlorothiazide"],
        "Asthma": ["Albuterol", "Fluticasone", "Montelukast"],
        "Heart Disease": ["Aspirin", "Atorvastatin", "Metoprolol"],
        "Cancer": ["Chemotherapy", "Immunotherapy"],
        "Arthritis": ["Ibuprofen", "Naproxen", "Methotrexate"],
        "Allergies": ["Loratadine", "Cetirizine", "Diphenhydramine"],
        "Obesity": ["Orlistat", "Phentermine"],
        "Depression": ["Sertraline", "Fluoxetine", "Citalopram"],
        "Anxiety": ["Alprazolam", "Diazepam", "Buspirone"]
    ]

    // Allergy selector feature
    @State private var showingAllergySelector = false
    @State private var selectedAllergies: Set<String> = []
    private let commonAllergies = [
        "Penicillin", "Peanuts", "Shellfish", "Latex", "Bee Stings",
        "Milk", "Eggs", "Tree Nuts", "Wheat", "Soy", "Fish"
    ]

    // Parent selector feature
    @State private var showingParentSelector = false
    @State private var selectedRelationship: FamilyRelationship = .child

    private var currentYear: Int {
        Calendar.current.component(.year, from: Date())
    }

    private var filteredMedications: [String] {
        let meds = selectedHealthConditions.flatMap { condition in
            medicationsByCondition[condition] ?? []
        }
        return Array(Set(meds)).sorted()
    }

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("BASIC INFORMATION")) {
                    TextField("Name", text: $name)
                    TextField("Age", text: Binding(
                        get: { age },
                        set: { newValue in
                            age = newValue
                            if let ageInt = Int(newValue), ageInt > 0 {
                                if let newBirthDate = Calendar.current.date(from: DateComponents(year: currentYear - ageInt)) {
                                    birthDate = newBirthDate
                                }
                            }
                        }
                    ))
                    .keyboardType(.numberPad)
                    DatePicker("Birth Date", selection: $birthDate, displayedComponents: .date)
                        .onChange(of: birthDate) { _, newDate in
                            let year = Calendar.current.component(.year, from: newDate)
                            let calculatedAge = currentYear - year
                            age = calculatedAge > 0 ? String(calculatedAge) : ""
                        }
                    Toggle("Deceased", isOn: $deceased)
                }

                Section(header: Text("HEALTH INFORMATION")) {
                    Button(action: { showingHealthConditionSelector = true }) {
                        HStack {
                            Text("Health Conditions")
                            Spacer()
                            if selectedHealthConditions.isEmpty {
                                Text("Select")
                                    .foregroundColor(.gray)
                            } else {
                                Text(selectedHealthConditions.sorted().joined(separator: ", "))
                                    .foregroundColor(.primary)
                                    .lineLimit(1)
                            }
                            Image(systemName: "chevron.right")
                                .foregroundColor(.gray)
                        }
                    }
                    .sheet(isPresented: $showingHealthConditionSelector) {
                        HealthConditionSelectorView(
                            allConditions: commonHealthConditions,
                            selectedConditions: $selectedHealthConditions
                        )
                    }
                    Button(action: { showingMedicationSelector = true }) {
                        HStack {
                            Text("Medications")
                            Spacer()
                            if selectedMedications.isEmpty {
                                Text("Select")
                                    .foregroundColor(.gray)
                            } else {
                                Text(selectedMedications.sorted().joined(separator: ", "))
                                    .foregroundColor(.primary)
                                    .lineLimit(1)
                            }
                            Image(systemName: "chevron.right")
                                .foregroundColor(.gray)
                        }
                    }
                    .sheet(isPresented: $showingMedicationSelector) {
                        MedicationSelectorView(
                            medications: filteredMedications,
                            selectedMedications: $selectedMedications
                        )
                    }
                    Button(action: { showingAllergySelector = true }) {
                        HStack {
                            Text("Allergies")
                            Spacer()
                            if selectedAllergies.isEmpty {
                                Text("Select")
                                    .foregroundColor(.gray)
                            } else {
                                Text(selectedAllergies.sorted().joined(separator: ", "))
                                    .foregroundColor(.primary)
                                    .lineLimit(1)
                            }
                            Image(systemName: "chevron.right")
                                .foregroundColor(.gray)
                        }
                    }
                    .sheet(isPresented: $showingAllergySelector) {
                        AllergySelectorView(
                            allergies: commonAllergies,
                            selectedAllergies: $selectedAllergies
                        )
                    }
                    DatePicker("Last Checkup", selection: $lastCheckup, displayedComponents: .date)
                }

                Section(header: Text("FAMILY RELATIONSHIP")) {
                    Picker("Relationship Type", selection: $selectedRelationship) {
                        ForEach(FamilyRelationship.allCases, id: \.self) { relationship in
                            Label(relationship.rawValue, systemImage: relationship.icon)
                                .tag(relationship)
                        }
                    }
                    
                    Button(action: { showingParentSelector = true }) {
                        HStack {
                            Text("Related To")
                            Spacer()
                            if let parent = selectedParent {
                                Text(parent.name)
                                    .foregroundColor(.primary)
                            } else {
                                Text("Select")
                                    .foregroundColor(.gray)
                            }
                            Image(systemName: "chevron.right")
                                .foregroundColor(.gray)
                        }
                    }
                    .sheet(isPresented: $showingParentSelector) {
                        ParentSelectorView(
                            selectedParent: $selectedParent,
                            relationship: selectedRelationship
                        )
                    }
                }

                Section(header: Text("Medical History")) {
                    TextEditor(text: $medicalHistory)
                        .frame(minHeight: 100)
                }
            }
            .navigationTitle("Add Family Member")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveMember()
                    }
                    .disabled(name.isEmpty)
                }
            }
        }
    }

    private func saveMember() {
        let (generation, level) = calculateGenerationAndLevel()
        
        let newMember = FamilyMember(
            name: name,
            age: Int(age) ?? 0,
            birthDate: birthDate,
            deceased: deceased,
            lastCheckup: lastCheckup,
            notes: medicalHistory,
            healthConditions: Array(selectedHealthConditions),
            parent: selectedParent,
            healthStatus: .healthy,
            generation: generation,
            level: level
        )
        
        if let parent = selectedParent {
            if parent.children == nil {
                parent.children = []
            }
            parent.children?.append(newMember)
        }
        
        modelContext.insert(newMember)
        dismiss()
    }
    
    private func calculateGenerationAndLevel() -> (Int, Int) {
        guard let parent = selectedParent else {
            return (0, 0)
        }
        
        switch selectedRelationship {
        case .parent:
            return (parent.generation - 1, parent.level - 1)
        case .child:
            return (parent.generation + 1, parent.level + 1)
        case .sibling:
            return (parent.generation, parent.level)
        case .spouse:
            return (parent.generation, parent.level)
        case .grandparent:
            return (parent.generation - 2, parent.level - 2)
        case .grandchild:
            return (parent.generation + 2, parent.level + 2)
        case .aunt, .uncle:
            return (parent.generation, parent.level - 1)
        case .cousin:
            return (parent.generation + 1, parent.level)
        }
    }
}

struct HealthConditionSelectorView: View {
    let allConditions: [String]
    @Binding var selectedConditions: Set<String>
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            List(allConditions, id: \.self) { condition in
                Button(action: {
                    if selectedConditions.contains(condition) {
                        selectedConditions.remove(condition)
                    } else {
                        selectedConditions.insert(condition)
                    }
                }) {
                    HStack {
                        Text(condition)
                        Spacer()
                        if selectedConditions.contains(condition) {
                            Image(systemName: "checkmark.square.fill")
                                .foregroundColor(.blue)
                        } else {
                            Image(systemName: "square")
                                .foregroundColor(.gray)
                        }
                    }
                }
            }
            .navigationTitle("Select Health Conditions")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}

struct MedicationSelectorView: View {
    let medications: [String]
    @Binding var selectedMedications: Set<String>
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            List(medications, id: \.self) { med in
                Button(action: {
                    if selectedMedications.contains(med) {
                        selectedMedications.remove(med)
                    } else {
                        selectedMedications.insert(med)
                    }
                }) {
                    HStack {
                        Text(med)
                        Spacer()
                        if selectedMedications.contains(med) {
                            Image(systemName: "checkmark.square.fill")
                                .foregroundColor(.blue)
                        } else {
                            Image(systemName: "square")
                                .foregroundColor(.gray)
                        }
                    }
                }
            }
            .navigationTitle("Select Medications")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}

struct AllergySelectorView: View {
    let allergies: [String]
    @Binding var selectedAllergies: Set<String>
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            List(allergies, id: \.self) { allergy in
                Button(action: {
                    if selectedAllergies.contains(allergy) {
                        selectedAllergies.remove(allergy)
                    } else {
                        selectedAllergies.insert(allergy)
                    }
                }) {
                    HStack {
                        Text(allergy)
                        Spacer()
                        if selectedAllergies.contains(allergy) {
                            Image(systemName: "checkmark.square.fill")
                                .foregroundColor(.blue)
                        } else {
                            Image(systemName: "square")
                                .foregroundColor(.gray)
                        }
                    }
                }
            }
            .navigationTitle("Select Allergies")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}

struct ParentSelectorView: View {
    @Environment(\.dismiss) private var dismiss
    @Query private var allMembers: [FamilyMember]
    @Binding var selectedParent: FamilyMember?
    let relationship: FamilyRelationship
    
    private var possibleRelations: [FamilyMember] {
        switch relationship {
        case .child:
            return allMembers.sorted { $0.generation < $1.generation }
        case .parent:
            return allMembers.sorted { $0.generation > $1.generation }
        case .sibling:
            return allMembers.filter { $0.generation == (selectedParent?.generation ?? 0) }
        case .spouse:
            return allMembers.filter { $0.generation == (selectedParent?.generation ?? 0) }
        case .grandparent:
            return allMembers.filter { $0.generation == (selectedParent?.generation ?? 0) - 2 }
        case .grandchild:
            return allMembers.filter { $0.generation == (selectedParent?.generation ?? 0) + 2 }
        case .aunt, .uncle:
            return allMembers.filter { $0.generation == (selectedParent?.generation ?? 0) - 1 }
        case .cousin:
            return allMembers.filter { $0.generation == (selectedParent?.generation ?? 0) + 1 }
        }
    }
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    Button(action: {
                        selectedParent = nil
                        dismiss()
                    }) {
                        HStack {
                            Text("None")
                            Spacer()
                            if selectedParent == nil {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.blue)
                            }
                        }
                    }
                }
                
                Section(header: Text("Select \(relationship.rawValue)")) {
                    ForEach(possibleRelations) { member in
                        Button(action: {
                            selectedParent = member
                            dismiss()
                        }) {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(member.name)
                                    Text("Generation \(member.generation), Level \(member.level)")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                Spacer()
                                if selectedParent?.id == member.id {
                                    Image(systemName: "checkmark")
                                        .foregroundColor(.blue)
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Select \(relationship.rawValue)")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}

#Preview {
    AddMemberView()
        .modelContainer(for: FamilyMember.self)
}



