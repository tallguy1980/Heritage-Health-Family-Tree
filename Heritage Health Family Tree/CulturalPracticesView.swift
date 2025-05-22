import SwiftUI
import SwiftData

struct CulturalPracticesView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @Query private var practices: [CulturalPractice]
    @State private var searchText = ""
    @State private var selectedCategory = "All"
    
    private let categories = ["All", "Traditional Medicine", "Nutrition", "Exercise", "Wellness", "Mental Health", "Physical Activity"]
    
    init() {
        // Add sample data if the database is empty
        let fetchDescriptor = FetchDescriptor<CulturalPractice>()
        if let count = try? modelContext.fetch(fetchDescriptor).count, count == 0 {
            for practice in CulturalPractice.samplePractices {
                modelContext.insert(practice)
            }
            try? modelContext.save()
        }
    }
    
    var filteredPractices: [CulturalPractice] {
        practices.filter { practice in
            let matchesSearch = searchText.isEmpty || 
                practice.name.localizedCaseInsensitiveContains(searchText) ||
                practice.practiceDescription.localizedCaseInsensitiveContains(searchText)
            let matchesCategory = selectedCategory == "All" || 
                practice.category == selectedCategory
            return matchesSearch && matchesCategory
        }
    }
    
    var body: some View {
        List {
            Section {
                Picker("Category", selection: $selectedCategory) {
                    ForEach(categories, id: \.self) { category in
                        Text(category).tag(category)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.vertical, 8)
            }
            
            ForEach(filteredPractices) { practice in
                NavigationLink(destination: CulturalPracticeDetailView(practice: practice)) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(practice.name)
                            .font(.headline)
                        
                        Text(practice.practiceDescription)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .lineLimit(2)
                        
                        HStack {
                            Label(practice.region, systemImage: "globe")
                            Spacer()
                            Label(practice.category, systemImage: "tag")
                        }
                        .font(.caption)
                        .foregroundColor(.secondary)
                    }
                    .padding(.vertical, 4)
                }
            }
        }
        .navigationTitle("Cultural Practices")
        .searchable(text: $searchText, prompt: "Search practices")
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Done") { dismiss() }
            }
        }
    }
}

struct CulturalPracticeDetailView: View {
    let practice: CulturalPractice
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        List {
            Section(header: Text("Description")) {
                Text(practice.practiceDescription)
            }
            
            Section(header: Text("Region")) {
                Text(practice.region)
            }
            
            Section(header: Text("Category")) {
                Text(practice.category)
            }
            
            Section(header: Text("Health Benefits")) {
                Text(practice.healthBenefits)
            }
            
            Section(header: Text("Health Considerations")) {
                Text(practice.healthConsiderations)
            }
        }
        .navigationTitle(practice.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        CulturalPracticesView()
    }
    .modelContainer(for: CulturalPractice.self)
} 