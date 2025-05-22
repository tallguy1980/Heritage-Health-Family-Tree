import SwiftUI
import SwiftData

struct SettingsView: View {
    @AppStorage("notificationsEnabled") private var notificationsEnabled = true
    @AppStorage("darkModeEnabled") private var darkModeEnabled = false
    @AppStorage("healthDataSharing") private var healthDataSharing = false
    @AppStorage("selectedLanguage") private var selectedLanguage = "English"
    @State private var showingHealthDataSheet = false
    @State private var showingPrivacyPolicy = false
    @State private var showingTermsOfService = false
    @Environment(\.dismiss) private var dismiss
    
    let languages = ["English", "Spanish", "French", "Chinese", "Arabic"]
    
    var body: some View {
        NavigationStack {
            List {
                // Notifications Section
                Section(header: Text("Notifications")) {
                    Toggle("Enable Notifications", isOn: $notificationsEnabled)
                    if notificationsEnabled {
                        NavigationLink("Notification Preferences") {
                            NotificationPreferencesView()
                        }
                    }
                }
                
                // Appearance Section
                Section(header: Text("Appearance")) {
                    Toggle("Dark Mode", isOn: $darkModeEnabled)
                    Picker("Language", selection: $selectedLanguage) {
                        ForEach(languages, id: \.self) { language in
                            Text(language)
                        }
                    }
                }
                
                // Health Data Section
                Section(header: Text("Health Data")) {
                    Toggle("Share Health Data", isOn: $healthDataSharing)
                    if healthDataSharing {
                        Button("Manage Health Data") {
                            showingHealthDataSheet = true
                        }
                    }
                }
                
                // About Section
                Section(header: Text("About")) {
                    Button("Privacy Policy") {
                        showingPrivacyPolicy = true
                    }
                    Button("Terms of Service") {
                        showingTermsOfService = true
                    }
                    HStack {
                        Text("Version")
                        Spacer()
                        Text("1.0.0")
                            .foregroundColor(.secondary)
                    }
                }
                
                // Support Section
                Section(header: Text("Support")) {
                    Button("Contact Support") {
                        if let url = URL(string: "mailto:support@heritagehealth.com") {
                            UIApplication.shared.open(url)
                        }
                    }
                    Button("Send Feedback") {
                        if let url = URL(string: "mailto:feedback@heritagehealth.com") {
                            UIApplication.shared.open(url)
                        }
                    }
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $showingHealthDataSheet) {
                HealthDataSharingView()
            }
            .sheet(isPresented: $showingPrivacyPolicy) {
                if let url = URL(string: "https://www.heritagehealth.com/privacy") {
                    HealthWebView(url: url)
                }
            }
            .sheet(isPresented: $showingTermsOfService) {
                if let url = URL(string: "https://www.heritagehealth.com/terms") {
                    HealthWebView(url: url)
                }
            }
        }
    }
}

struct NotificationPreferencesView: View {
    @AppStorage("reminderNotifications") private var reminderNotifications = true
    @AppStorage("healthUpdateNotifications") private var healthUpdateNotifications = true
    @AppStorage("familyUpdateNotifications") private var familyUpdateNotifications = true
    
    var body: some View {
        List {
            Section(header: Text("Notification Types")) {
                Toggle("Health Reminders", isOn: $reminderNotifications)
                Toggle("Health Updates", isOn: $healthUpdateNotifications)
                Toggle("Family Updates", isOn: $familyUpdateNotifications)
            }
            
            Section(header: Text("Notification Schedule")) {
                NavigationLink("Reminder Times") {
                    ReminderTimesView()
                }
                NavigationLink("Quiet Hours") {
                    QuietHoursView()
                }
            }
        }
        .navigationTitle("Notification Preferences")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ReminderTimesView: View {
    @AppStorage("morningReminderTime") private var morningReminderTime = Date()
    @AppStorage("eveningReminderTime") private var eveningReminderTime = Date()
    
    var body: some View {
        List {
            Section(header: Text("Daily Reminders")) {
                DatePicker("Morning Reminder", selection: $morningReminderTime, displayedComponents: .hourAndMinute)
                DatePicker("Evening Reminder", selection: $eveningReminderTime, displayedComponents: .hourAndMinute)
            }
        }
        .navigationTitle("Reminder Times")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct QuietHoursView: View {
    @AppStorage("quietHoursStart") private var quietHoursStart = Date()
    @AppStorage("quietHoursEnd") private var quietHoursEnd = Date()
    @AppStorage("quietHoursEnabled") private var quietHoursEnabled = false
    
    var body: some View {
        List {
            Section {
                Toggle("Enable Quiet Hours", isOn: $quietHoursEnabled)
            }
            
            if quietHoursEnabled {
                Section(header: Text("Quiet Hours Schedule")) {
                    DatePicker("Start Time", selection: $quietHoursStart, displayedComponents: .hourAndMinute)
                    DatePicker("End Time", selection: $quietHoursEnd, displayedComponents: .hourAndMinute)
                }
            }
        }
        .navigationTitle("Quiet Hours")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    SettingsView()
} 