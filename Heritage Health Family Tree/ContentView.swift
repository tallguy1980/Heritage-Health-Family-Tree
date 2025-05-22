//
//  ContentView.swift
//  Heritage Health Family Tree
//
//  Created by DUJUAN PUGH on 5/6/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationStack {
                HomeView()
            }
            .tabItem {
                Label("", systemImage: "house.fill")
            }
            .tag(0)
            
            NavigationStack {
                FamilyTreeView()
            }
            .tabItem {
                Label("", systemImage: "tree")
            }
            .tag(1)
            
            NavigationStack {
                HealthDataSharingView()
            }
            .tabItem {
                Label("", systemImage: "person.3")
            }
            .tag(2)
            
            NavigationStack {
                TreeNodeView()
            }
            .tabItem {
                Label("", systemImage: "rectangle.3.offgrid")
            }
            .tag(3)
            
            NavigationStack {
                HealthWebView(url: URL(string: "https://www.who.int/")!)
            }
            .tabItem {
                Label("", systemImage: "globe")
            }
            .tag(4)
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: FamilyMember.self)
}
