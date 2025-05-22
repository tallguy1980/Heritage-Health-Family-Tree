import SwiftUI
import SwiftData
import Charts

struct FamilyConditionsView: View {
    @Environment(\.dismiss) private var dismiss
    @Query private var members: [FamilyMember]
    
    private var ageGroups: [(range: String, count: Int)] {
        let groups = [
            (0...12, "0-12"),
            (13...19, "13-19"),
            (20...39, "20-39"),
            (40...59, "40-59"),
            (60...79, "60-79"),
            (80...Int.max, "80+")
        ]
        
        return groups.map { range, label in
            let count = members.filter { range.contains($0.age) }.count
            return (range: label, count: count)
        }
    }
    
    private var commonConditions: [(condition: String, count: Int)] {
        var conditionCounts: [String: Int] = [:]
        
        for member in members {
            for condition in member.healthConditions {
                conditionCounts[condition, default: 0] += 1
            }
        }
        
        return conditionCounts.map { (condition: $0.key, count: $0.value) }
            .sorted { $0.count > $1.count }
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Age Distribution Chart
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Age Distribution")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        Chart(ageGroups, id: \.range) { group in
                            BarMark(
                                x: .value("Age Group", group.range),
                                y: .value("Count", group.count)
                            )
                            .foregroundStyle(Color.blue.gradient)
                        }
                        .frame(height: 200)
                        .padding()
                    }
                    .background(Color(.systemBackground))
                    .cornerRadius(12)
                    .shadow(radius: 2)
                    .padding(.horizontal)
                    
                    // Common Health Conditions
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Common Health Conditions")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        Chart(commonConditions.prefix(5), id: \.condition) { condition in
                            BarMark(
                                x: .value("Count", condition.count), y: .value("Condition", condition.condition)
                            )
                            .foregroundStyle(Color.green.gradient)
                        }
                        .frame(height: 200)
                        .padding()
                    }
                    .background(Color(.systemBackground))
                    .cornerRadius(12)
                    .shadow(radius: 2)
                    .padding(.horizontal)
                    
                    // Key Insights
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Key Insights")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            InsightRow(
                                icon: "person.2.fill",
                                title: "Family Size",
                                value: "\(members.count) members"
                            )
                            
                            InsightRow(
                                icon: "heart.fill",
                                title: "Most Common Condition",
                                value: commonConditions.first?.condition ?? "None"
                            )
                            
                            InsightRow(
                                icon: "calendar",
                                title: "Average Age",
                                value: String(format: "%.1f years", Double(members.map { $0.age }.reduce(0, +)) / Double(max(1, members.count)))
                            )
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical)
            }
            .navigationTitle("Family Health Overview")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct InsightRow: View {
    let icon: String
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.blue)
                .frame(width: 30)
            
            VStack(alignment: .leading) {
                Text(title)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Text(value)
                    .font(.headline)
            }
            
            Spacer()
        }
    }
}

#Preview {
    FamilyConditionsView()
        .modelContainer(for: FamilyMember.self)
} 
