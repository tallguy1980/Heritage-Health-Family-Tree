//
//  HomeView.swift
//  Heritage Health Family Tree
//
//  Created by DUJUAN PUGH on 5/19/25.
//

import SwiftUI
import SwiftData

// Import all required views
// If a view is missing, comment out its usage or provide a placeholder

struct HomeView: View {
    @State private var showingAddMember = false
    @State private var showingCulturalPractices = false
    @State private var showingHealthResources = false
    @State private var showingFamilyConditions = false
    @Query private var members: [FamilyMember]
    @Environment(\.modelContext) private var modelContext
    
    private var currentYear: Int {
        Calendar.current.component(.year, from: Date())
    }
    
    var body: some View {
        VStack(spacing: 20) {
            // Welcome Section
            VStack(alignment: .leading, spacing: 8) {
                Text("Welcome to")
                    .font(.title2)
                    .foregroundColor(.secondary)
                Text("Heritage Health")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                Text("Explore your family history and cultural health practices")
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundColor(.blue)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            
            // Quick Actions
            VStack(spacing: 16) {
                Button(action: { showingAddMember = true }) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Add Family Member")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                            .dynamicTypeSize(.medium ... .xxLarge)
                        Text("Add new family members to your tree")
                            .font(.subheadline)
                            .foregroundColor(.black)
                            .dynamicTypeSize(.medium ... .xxLarge)
                    }
                    .frame(width: 320, height: 80)
                    .background(Color(red: 0.95, green: 0.88, blue: 0.76))
                    .cornerRadius(39)
                    .overlay(
                        RoundedRectangle(cornerRadius: 39)
                            .stroke(Color(red: 151/255, green: 151/255, blue: 151/255, opacity: 1.0), lineWidth: 1)
                    )
                }
                .sheet(isPresented: $showingAddMember) {
                    NavigationStack {
                        AddMemberView()
                    }
                }
                
                Button(action: { showingCulturalPractices = true }) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Cultural Practices")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                            .dynamicTypeSize(.medium ... .xxLarge)
                        Text("Explore traditional health practices")
                            .font(.subheadline)
                            .foregroundColor(.black)
                            .dynamicTypeSize(.medium ... .xxLarge)
                    }
                    .frame(width: 320, height: 80)
                    .background(Color(red: 0.95, green: 0.88, blue: 0.76))
                    .cornerRadius(39)
                    .overlay(
                        RoundedRectangle(cornerRadius: 39)
                            .stroke(Color(red: 151/255, green: 151/255, blue: 151/255, opacity: 1.0), lineWidth: 1)
                    )
                }
                .sheet(isPresented: $showingCulturalPractices) {
                    CulturalPracticesView()
                }

                Button(action: { showingHealthResources = true }) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Health Resources")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                            .dynamicTypeSize(.medium ... .xxLarge)
                        Text("View and manage health resources")
                            .font(.subheadline)
                            .foregroundColor(.black)
                            .dynamicTypeSize(.medium ... .xxLarge)
                    }
                    .frame(width: 320, height: 80)
                    .background(Color(red: 0.95, green: 0.88, blue: 0.76))
                    .cornerRadius(39)
                    .overlay(
                        RoundedRectangle(cornerRadius: 39)
                            .stroke(Color(red: 151/255, green: 151/255, blue: 151/255, opacity: 1.0), lineWidth: 1)
                    )
                }
                .sheet(isPresented: $showingHealthResources) {
                    HealthResourcesView()
                }

                Button(action: { showingFamilyConditions = true }) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Track Family Conditions")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                            .dynamicTypeSize(.medium ... .xxLarge)
                        Text("View health conditions and age distribution")
                            .font(.subheadline)
                            .foregroundColor(.black)
                            .dynamicTypeSize(.medium ... .xxLarge)
                    }
                    .frame(width: 320, height: 80)
                    .background(Color(red: 0.95, green: 0.88, blue: 0.76))
                    .cornerRadius(39)
                    .overlay(
                        RoundedRectangle(cornerRadius: 39)
                            .stroke(Color(red: 151/255, green: 151/255, blue: 151/255, opacity: 1.0), lineWidth: 1)
                    )
                }
                .sheet(isPresented: $showingFamilyConditions) {
                    FamilyConditionsView()
                }
            }
            .padding()
            
            // Recent Members
            if !members.isEmpty {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Recent Family Members")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) {
                            ForEach(members.prefix(5)) { member in
                                NavigationLink(destination: MemberDetailView(member: member)) {
                                    VStack {
                                        Image(systemName: member.healthIcon)
                                            .font(.system(size: 30))
                                            .foregroundColor(member.healthColor)
                                        Text(member.name)
                                            .font(.subheadline)
                                            .lineLimit(1)
                                    }
                                    .frame(width: 80, height: 80)
                                    .background(Color(.systemGray6))
                                    .cornerRadius(12)
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                }
            }
            
            Spacer()
        }
        .navigationTitle("")
    }
}

#Preview {
    HomeView()
        .modelContainer(for: FamilyMember.self)
}
