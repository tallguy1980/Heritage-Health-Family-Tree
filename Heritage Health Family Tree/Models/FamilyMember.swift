import Foundation
import SwiftData
import SwiftUI

@Model
final class FamilyMember {
    var name: String
    var healthStatus: HealthStatus
    var generation: Int
    var level: Int
    
    // Added properties for AddMemberView compatibility
    var age: Int
    var birthDate: Date
    var deceased: Bool
    var lastCheckup: Date
    var notes: String
    var healthConditions: [String]
    
    @Relationship(deleteRule: .cascade)
    var parent: FamilyMember?
    
    @Relationship(deleteRule: .cascade)
    var children: [FamilyMember]?
    
    init(name: String, age: Int = 0, birthDate: Date = Date(), deceased: Bool = false, lastCheckup: Date = Date(), notes: String = "", healthConditions: [String] = [], parent: FamilyMember? = nil, healthStatus: HealthStatus = .healthy, generation: Int = 0, level: Int = 0) {
        self.name = name
        self.age = age
        self.birthDate = birthDate
        self.deceased = deceased
        self.lastCheckup = lastCheckup
        self.notes = notes
        self.healthConditions = healthConditions
        self.parent = parent
        self.healthStatus = healthStatus
        self.generation = generation
        self.level = level
        self.children = []
    }
    
    var healthColor: Color {
        healthStatus.color
    }
    
    var healthIcon: String {
        switch healthStatus {
        case .healthy:
            return "heart.fill"
        case .atRisk:
            return "exclamationmark.triangle.fill"
        case .needsAttention:
            return "exclamationmark.circle.fill"
        case .critical:
            return "cross.fill"
        }
    }
}

enum HealthStatus: String, Codable {
    case healthy
    case atRisk
    case needsAttention
    case critical
    
    var color: Color {
        switch self {
        case .healthy:
            return .green
        case .atRisk:
            return .yellow
        case .needsAttention:
            return .orange
        case .critical:
            return .red
        }
    }
} 
