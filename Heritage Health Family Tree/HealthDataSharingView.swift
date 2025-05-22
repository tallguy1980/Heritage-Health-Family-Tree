import SwiftUI
import HealthKit

struct HealthDataSharingView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var selectedDataTypes: Set<String> = []
    @State private var sharingEnabled = false
    @State private var showingHealthKitPermission = false
    @State private var showingPrivacyNotice = false
    
    let healthDataTypes = [
        "Heart Rate",
        "Blood Pressure",
        "Sleep Analysis",
        "Steps",
        "Weight",
        "Height",
        "BMI",
        "Blood Glucose",
        "Medications",
        "Allergies"
    ]
    
    var body: some View {
        NavigationStack {
            List {
                // Health Data Sharing Toggle
                Section {
                    Toggle("Enable Health Data Sharing", isOn: $sharingEnabled)
                        .onChange(of: sharingEnabled) { _, newValue in
                            if newValue {
                                showingHealthKitPermission = true
                            }
                        }
                }
                
                if sharingEnabled {
                    // Data Types Section
                    Section(header: Text("Share These Health Data Types")) {
                        ForEach(healthDataTypes, id: \.self) { dataType in
                            Toggle(dataType, isOn: Binding(
                                get: { selectedDataTypes.contains(dataType) },
                                set: { isSelected in
                                    if isSelected {
                                        selectedDataTypes.insert(dataType)
                                    } else {
                                        selectedDataTypes.remove(dataType)
                                    }
                                }
                            ))
                        }
                    }
                    
                    // Sharing Options Section
                    Section(header: Text("Sharing Options")) {
                        NavigationLink("Share with Family Members") {
                            FamilySharingView(selectedDataTypes: selectedDataTypes)
                        }
                        
                        NavigationLink("Share with Healthcare Providers") {
                            ProviderSharingView(selectedDataTypes: selectedDataTypes)
                        }
                    }
                    
                    // Privacy Section
                    Section {
                        Button("View Privacy Notice") {
                            showingPrivacyNotice = true
                        }
                    }
                }
                
                // Information Section
                Section(header: Text("About Health Data Sharing")) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Your health data is encrypted and secure")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Text("You can change these settings at any time")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding(.vertical, 8)
                }
            }
            .navigationTitle("Health Data Sharing")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
            .sheet(isPresented: $showingHealthKitPermission) {
                HealthKitPermissionView()
            }
            .sheet(isPresented: $showingPrivacyNotice) {
                if let url = URL(string: "https://www.heritagehealth.com/health-data-privacy") {
                    HealthWebView(url: url)
                }
            }
        }
    }
}

struct FamilySharingView: View {
    let selectedDataTypes: Set<String>
    @State private var selectedFamilyMembers: Set<String> = []
    
    var body: some View {
        List {
            Section(header: Text("Select Family Members")) {
                ForEach(["Parent", "Sibling", "Child", "Spouse"], id: \.self) { member in
                    Toggle(member, isOn: Binding(
                        get: { selectedFamilyMembers.contains(member) },
                        set: { isSelected in
                            if isSelected {
                                selectedFamilyMembers.insert(member)
                            } else {
                                selectedFamilyMembers.remove(member)
                            }
                        }
                    ))
                }
            }
            
            Section(header: Text("Selected Health Data")) {
                ForEach(Array(selectedDataTypes), id: \.self) { dataType in
                    Text(dataType)
                        .foregroundColor(.secondary)
                }
            }
        }
        .navigationTitle("Share with Family")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ProviderSharingView: View {
    let selectedDataTypes: Set<String>
    @State private var selectedProviders: Set<String> = []
    
    var body: some View {
        List {
            Section(header: Text("Select Healthcare Providers")) {
                ForEach(["Primary Care", "Specialist", "Hospital", "Clinic"], id: \.self) { provider in
                    Toggle(provider, isOn: Binding(
                        get: { selectedProviders.contains(provider) },
                        set: { isSelected in
                            if isSelected {
                                selectedProviders.insert(provider)
                            } else {
                                selectedProviders.remove(provider)
                            }
                        }
                    ))
                }
            }
            
            Section(header: Text("Selected Health Data")) {
                ForEach(Array(selectedDataTypes), id: \.self) { dataType in
                    Text(dataType)
                        .foregroundColor(.secondary)
                }
            }
        }
        .navigationTitle("Share with Providers")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct HealthKitPermissionView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var isRequestingPermission = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Image(systemName: "heart.text.square")
                    .font(.system(size: 60))
                    .foregroundColor(.blue)
                
                Text("Health Data Access")
                    .font(.title)
                    .bold()
                
                Text("Heritage Health needs access to your health data to provide personalized insights and track your family's health history.")
                    .multilineTextAlignment(.center)
                    .padding()
                
                Text("Your data is encrypted and secure. You can change these permissions at any time in Settings.")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding()
                
                Button(action: {
                    isRequestingPermission = true
                    // Here you would implement the actual HealthKit permission request
                    // For now, we'll just dismiss the view
                    dismiss()
                }) {
                    Text("Allow Access")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()
                
                Button("Not Now") {
                    dismiss()
                }
                .foregroundColor(.secondary)
            }
            .padding()
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Close") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    HealthDataSharingView()
} 