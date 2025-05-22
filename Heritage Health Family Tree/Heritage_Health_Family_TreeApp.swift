import SwiftUI
import SwiftData

@main
struct Heritage_Health_Family_TreeApp: App {
    let modelContainer: ModelContainer
    
    init() {
        do {
            let schema = Schema([
                FamilyMember.self,
                CulturalPractice.self
            ])
            
            let modelConfiguration = ModelConfiguration(
                schema: schema,
                isStoredInMemoryOnly: true,// this was false if shit breaks it change back to FALSE 
                allowsSave: true
            )
            
            modelContainer = try ModelContainer(
                for: schema,
                configurations: [modelConfiguration]
            )
        } catch {
           fatalError("Could not initialize ModelContainer: \(error.localizedDescription)")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(modelContainer)
    }
}

