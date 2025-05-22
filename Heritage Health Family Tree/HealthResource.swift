//
//  HealthResource.swift
//  Heritage Health Family Tree
//
//  Created by DUJUAN PUGH on 5/19/25.
//


import SwiftUI
import SafariServices

struct HealthResource: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let url: String
    let category: HealthCategory
    let icon: String
    let isBookmarked: Bool = false
    let lastVisited: Date?
}

enum HealthCategory: String, CaseIterable {
    case heart = "Heart Health"
    case diabetes = "Diabetes"
    case cancer = "Cancer"
    case asthma = "Asthma"
    case mental = "Mental Health"
    case nutrition = "Nutrition"
    case exercise = "Exercise"
    case general = "General Health"
    
    var color: Color {
        switch self {
        case .heart: return .red
        case .diabetes: return .orange
        case .cancer: return .purple
        case .asthma: return .green
        case .mental: return .blue
        case .nutrition: return .mint
        case .exercise: return .indigo
        case .general: return .gray
        }
    }
    
    var icon: String {
        switch self {
        case .heart: return "heart.fill"
        case .diabetes: return "drop.fill"
        case .cancer: return "cross.case.fill"
        case .asthma: return "lungs.fill"
        case .mental: return "brain.head.profile"
        case .nutrition: return "leaf.fill"
        case .exercise: return "figure.walk"
        case .general: return "cross.fill"
        }
    }
}

struct HealthResourcesView: View {
    @State private var selectedCategory: HealthCategory = .general
    @State private var searchText = ""
    @State private var showingBookmarks = false
    @State private var bookmarkedResources: Set<UUID> = []
    @State private var recentlyVisited: [HealthResource] = []
    @State private var showingFilters = false
    @State private var selectedFilters: Set<HealthCategory> = Set(HealthCategory.allCases)
    
    let resources: [HealthResource] = [
        // Heart Health Resources
        HealthResource(
            title: "American Heart Association",
            description: "Learn about heart disease prevention, treatment, and research.",
            url: "https://www.heart.org",
            category: .heart,
            icon: "heart.fill",
            lastVisited: nil
        ),
        HealthResource(
            title: "Heart Foundation",
            description: "Resources for heart health and cardiovascular disease prevention.",
            url: "https://www.heartfoundation.org.au",
            category: .heart,
            icon: "heart.fill",
            lastVisited: nil
        ),
        
        // Diabetes Resources
        HealthResource(
            title: "American Diabetes Association",
            description: "Resources for diabetes management and prevention.",
            url: "https://www.diabetes.org",
            category: .diabetes,
            icon: "drop.fill",
            lastVisited: nil
        ),
        HealthResource(
            title: "Diabetes UK",
            description: "Comprehensive diabetes information and support.",
            url: "https://www.diabetes.org.uk",
            category: .diabetes,
            icon: "drop.fill",
            lastVisited: nil
        ),
        
        // Cancer Resources
        HealthResource(
            title: "American Cancer Society",
            description: "Information about cancer prevention, treatment, and support.",
            url: "https://www.cancer.org",
            category: .cancer,
            icon: "cross.case.fill",
            lastVisited: nil
        ),
        HealthResource(
            title: "Cancer Research UK",
            description: "Latest cancer research and treatment information.",
            url: "https://www.cancerresearchuk.org",
            category: .cancer,
            icon: "cross.case.fill",
            lastVisited: nil
        ),
        
        // Asthma Resources
        HealthResource(
            title: "Asthma and Allergy Foundation",
            description: "Resources for asthma management and treatment.",
            url: "https://www.aafa.org",
            category: .asthma,
            icon: "lungs.fill",
            lastVisited: nil
        ),
        HealthResource(
            title: "Global Initiative for Asthma",
            description: "International asthma guidelines and resources.",
            url: "https://ginasthma.org",
            category: .asthma,
            icon: "lungs.fill",
            lastVisited: nil
        ),
        
        // Mental Health Resources
        HealthResource(
            title: "National Institute of Mental Health",
            description: "Research and information about mental health conditions.",
            url: "https://www.nimh.nih.gov",
            category: .mental,
            icon: "brain.head.profile",
            lastVisited: nil
        ),
        HealthResource(
            title: "Mental Health First Aid",
            description: "Training and resources for mental health support.",
            url: "https://www.mentalhealthfirstaid.org",
            category: .mental,
            icon: "brain.head.profile",
            lastVisited: nil
        ),
        
        // Nutrition Resources
        HealthResource(
            title: "Academy of Nutrition and Dietetics",
            description: "Expert nutrition information and resources.",
            url: "https://www.eatright.org",
            category: .nutrition,
            icon: "leaf.fill",
            lastVisited: nil
        ),
        HealthResource(
            title: "Nutrition.gov",
            description: "Government nutrition information and guidelines.",
            url: "https://www.nutrition.gov",
            category: .nutrition,
            icon: "leaf.fill",
            lastVisited: nil
        ),
        
        // Exercise Resources
        HealthResource(
            title: "American College of Sports Medicine",
            description: "Exercise guidelines and fitness information.",
            url: "https://www.acsm.org",
            category: .exercise,
            icon: "figure.walk",
            lastVisited: nil
        ),
        HealthResource(
            title: "CDC Physical Activity Guidelines",
            description: "Official physical activity recommendations.",
            url: "https://www.cdc.gov/physicalactivity",
            category: .exercise,
            icon: "figure.walk",
            lastVisited: nil
        ),
        
        // General Health Resources
        HealthResource(
            title: "CDC Health Information",
            description: "Comprehensive health information from the Centers for Disease Control.",
            url: "https://www.cdc.gov",
            category: .general,
            icon: "cross.fill",
            lastVisited: nil
        ),
        HealthResource(
            title: "Mayo Clinic Health Library",
            description: "Expert health information and resources.",
            url: "https://www.mayoclinic.org",
            category: .general,
            icon: "book.fill",
            lastVisited: nil
        ),
        HealthResource(
            title: "World Health Organization",
            description: "Global health information and guidelines.",
            url: "https://www.who.int",
            category: .general,
            icon: "globe",
            lastVisited: nil
        )
    ]
    
    var filteredResources: [HealthResource] {
        resources.filter { resource in
            let matchesCategory = selectedFilters.contains(resource.category)
            let matchesSearch = searchText.isEmpty || 
                resource.title.localizedCaseInsensitiveContains(searchText) ||
                resource.description.localizedCaseInsensitiveContains(searchText)
            return matchesCategory && matchesSearch
        }
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Context Header
                VStack(spacing: 4) {
                    Image(systemName: "cross.case.fill")
                        .font(.system(size: 40))
                        .foregroundColor(.blue)
                        .padding(.top, 16)
                    Text("")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    Text("Find trusted information, tools, and support for your family's health and wellness.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
                .padding(.bottom, 12)
                
                // Search and Filter Bar
                VStack(spacing: 12) {
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.secondary)
                        TextField("Search resources...", text: $searchText)
                    }
                    .padding(8)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                    
                    HStack {
                        Button(action: { showingFilters.toggle() }) {
                            Label("Filters", systemImage: "line.3.horizontal.decrease.circle")
                        }
                        .sheet(isPresented: $showingFilters) {
                            FilterView(selectedFilters: $selectedFilters)
                        }
                        
                        Spacer()
                        
                        Button(action: { showingBookmarks.toggle() }) {
                            Label("Bookmarks", systemImage: "bookmark.fill")
                        }
                    }
                    .padding(.horizontal)
                }
                .padding()
                
                // Category Picker
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(HealthCategory.allCases, id: \.self) { category in
                            CategoryButton(
                                title: category.rawValue,
                                color: category.color,
                                isSelected: selectedCategory == category
                            ) {
                                withAnimation {
                                    selectedCategory = category
                                    selectedFilters = [category]
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.bottom)
                
                // Recently Visited
                if !recentlyVisited.isEmpty {
                    VStack(alignment: .leading) {
                        Text("Recently Visited")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 12) {
                                ForEach(recentlyVisited) { resource in
                                    RecentResourceCard(resource: resource)
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    .padding(.vertical)
                }
                
                // Resources List
                List {
                    ForEach(filteredResources) { resource in
                        ResourceCard(
                            resource: resource,
                            isBookmarked: bookmarkedResources.contains(resource.id),
                            onBookmark: { toggleBookmark(resource) }
                        )
                    }
                }
                .listStyle(PlainListStyle())
            }
            .navigationTitle("Health Resources")
            .sheet(isPresented: $showingBookmarks) {
                BookmarksView(
                    resources: resources.filter { bookmarkedResources.contains($0.id) }
                )
            }
        }
    }
    
    private func toggleBookmark(_ resource: HealthResource) {
        if bookmarkedResources.contains(resource.id) {
            bookmarkedResources.remove(resource.id)
        } else {
            bookmarkedResources.insert(resource.id)
        }
    }
}

struct FilterView: View {
    @Binding var selectedFilters: Set<HealthCategory>
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            List(HealthCategory.allCases, id: \.self) { category in
                Button(action: {
                    if selectedFilters.contains(category) {
                        selectedFilters.remove(category)
                    } else {
                        selectedFilters.insert(category)
                    }
                }) {
                    HStack {
                        Image(systemName: category.icon)
                            .foregroundColor(category.color)
                        Text(category.rawValue)
                        Spacer()
                        if selectedFilters.contains(category) {
                            Image(systemName: "checkmark")
                                .foregroundColor(.blue)
                        }
                    }
                }
            }
            .navigationTitle("Filter Categories")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct CategoryButton: View {
    let title: String
    let color: Color
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(isSelected ? color.opacity(0.2) : Color.gray.opacity(0.1))
                .foregroundColor(isSelected ? color : .primary)
                .cornerRadius(20)
        }
    }
}

struct ResourceCard: View {
    let resource: HealthResource
    let isBookmarked: Bool
    let onBookmark: () -> Void
    @State private var showingWebView = false
    
    var body: some View {
        Button(action: { showingWebView = true }) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Image(systemName: resource.icon)
                        .font(.title2)
                        .foregroundColor(resource.category.color)
                        .frame(width: 30)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(resource.title)
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        Text(resource.description)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .lineLimit(2)
                    }
                    
                    Spacer()
                    
                    Button(action: onBookmark) {
                        Image(systemName: isBookmarked ? "bookmark.fill" : "bookmark")
                            .foregroundColor(isBookmarked ? .blue : .gray)
                    }
                }
                
                HStack {
                    Text(resource.category.rawValue)
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(resource.category.color.opacity(0.1))
                        .foregroundColor(resource.category.color)
                        .cornerRadius(8)
                    
                    Spacer()
                    
                    Image(systemName: "arrow.right")
                        .foregroundColor(.blue)
                }
            }
            .padding()
            .background(Color(uiColor: .systemBackground))
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
        }
        .buttonStyle(PlainButtonStyle())
        .sheet(isPresented: $showingWebView) {
            if let url = URL(string: resource.url) {
                HealthWebView(url: url)
            }
        }
    }
}

struct RecentResourceCard: View {
    let resource: HealthResource
    @State private var showingWebView = false
    
    var body: some View {
        Button(action: { showingWebView = true }) {
            VStack(alignment: .leading, spacing: 8) {
                Image(systemName: resource.icon)
                    .font(.title2)
                    .foregroundColor(resource.category.color)
                
                Text(resource.title)
                    .font(.subheadline)
                    .foregroundColor(.primary)
                    .lineLimit(2)
            }
            .frame(width: 120)
            .padding()
            .background(Color(uiColor: .systemBackground))
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
        }
        .buttonStyle(PlainButtonStyle())
        .sheet(isPresented: $showingWebView) {
            if let url = URL(string: resource.url) {
                HealthWebView(url: url)
            }
        }
    }
}

struct BookmarksView: View {
    let resources: [HealthResource]
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            List(resources) { resource in
                ResourceCard(
                    resource: resource,
                    isBookmarked: true,
                    onBookmark: {}
                )
            }
            .navigationTitle("Bookmarks")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
} 
