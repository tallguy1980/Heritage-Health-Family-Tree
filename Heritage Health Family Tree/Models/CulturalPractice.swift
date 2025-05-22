import Foundation
import SwiftData
import SwiftUI

@Model
final class CulturalPractice {
    @Attribute(.unique) var id: UUID
    var name: String
    var practiceDescription: String
    var region: String
    var category: String
    var healthBenefits: String
    var healthConsiderations: String
    
    init(
        id: UUID = UUID(),
        name: String,
        practiceDescription: String,
        region: String,
        category: String,
        healthBenefits: String,
        healthConsiderations: String
    ) {
        self.id = id
        self.name = name
        self.practiceDescription = practiceDescription
        self.region = region
        self.category = category
        self.healthBenefits = healthBenefits
        self.healthConsiderations = healthConsiderations
    }
    
    static let samplePractices: [CulturalPractice] = [
        CulturalPractice(
            name: "Ayurveda",
            practiceDescription: "Traditional Indian system of medicine focusing on balance between body, mind, and spirit.",
            region: "South Asia",
            category: "Traditional Medicine",
            healthBenefits: "Holistic wellness, stress reduction, natural healing",
            healthConsiderations: "Consult healthcare provider before starting new treatments"
        ),
        CulturalPractice(
            name: "Traditional Chinese Medicine",
            practiceDescription: "Ancient healing system using acupuncture, herbs, and other practices.",
            region: "East Asia",
            category: "Traditional Medicine",
            healthBenefits: "Pain management, stress relief, improved energy flow",
            healthConsiderations: "Ensure practitioner is licensed and qualified"
        ),
        CulturalPractice(
            name: "Mediterranean Diet",
            practiceDescription: "Traditional eating pattern from Mediterranean region emphasizing whole foods.",
            region: "Mediterranean",
            category: "Nutrition",
            healthBenefits: "Heart health, longevity, reduced inflammation",
            healthConsiderations: "Adapt to local food availability and personal needs"
        ),
        CulturalPractice(
            name: "Hammam",
            practiceDescription: "Traditional Middle Eastern steam bath and cleansing ritual.",
            region: "Middle East",
            category: "Wellness",
            healthBenefits: "Skin health, relaxation, social connection",
            healthConsiderations: "Stay hydrated, avoid if pregnant or with certain conditions"
        ),
        CulturalPractice(
            name: "Forest Bathing",
            practiceDescription: "Japanese practice of immersing oneself in nature for health benefits.",
            region: "Japan",
            category: "Wellness",
            healthBenefits: "Stress reduction, improved mood, better sleep",
            healthConsiderations: "Be mindful of allergies and weather conditions"
        ),
        CulturalPractice(
            name: "Traditional Herbal Medicine",
            practiceDescription: "Use of plants and herbs for medicinal purposes across various cultures.",
            region: "Global",
            category: "Traditional Medicine",
            healthBenefits: "Natural healing, immune support, symptom relief",
            healthConsiderations: "Research interactions with medications"
        ),
        CulturalPractice(
            name: "Mindfulness Meditation",
            practiceDescription: "Buddhist practice of present-moment awareness adapted for modern use.",
            region: "Global",
            category: "Mental Health",
            healthBenefits: "Stress reduction, improved focus, emotional regulation",
            healthConsiderations: "Start with short sessions, seek guidance if needed"
        ),
        CulturalPractice(
            name: "Traditional Dance",
            practiceDescription: "Cultural dance forms that combine physical activity with cultural expression.",
            region: "Global",
            category: "Physical Activity",
            healthBenefits: "Cardiovascular health, coordination, cultural connection",
            healthConsiderations: "Start slowly, respect cultural significance"
        )
    ]
} 
