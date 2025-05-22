//
//  GraphicalTreeView.swift
//  Heritage Health Family Tree
//
//  Created by DUJUAN PUGH on 5/6/25.
//
import SwiftUI
import SwiftData

// Import the module containing FamilyMember

struct GraphicalTreeView: View {
    @Query var members: [FamilyMember]
    @State private var scale: CGFloat = 1.0
    @State private var offset: CGSize = .zero
    @State private var lastOffset: CGSize = .zero
    @State private var selectedMember: FamilyMember?
    @State private var showingDetail = false
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background grid
                GridBackground()
                    .scaleEffect(scale)
                    .offset(offset)
                
                // Family tree nodes
                ForEach(members) { member in
                    FamilyNodeView(member: member)
                        .position(nodePosition(for: member, in: geometry))
                        .scaleEffect(scale)
                        .offset(offset)
                        .onTapGesture {
                            selectedMember = member
                            showingDetail = true
                        }
                }
                
                // Connection lines
                ForEach(members) { member in
                    if let parent = member.parent {
                        ConnectionLine(
                            from: nodePosition(for: parent, in: geometry),
                            to: nodePosition(for: member, in: geometry)
                        )
                        .stroke(Color.gray, lineWidth: 1)
                        .scaleEffect(scale)
                        .offset(offset)
                    }
                }
            }
            .gesture(
                MagnificationGesture()
                    .onChanged { value in
                        scale = value
                    }
            )
            .gesture(
                DragGesture()
                    .onChanged { value in
                        offset = CGSize(
                            width: lastOffset.width + value.translation.width,
                            height: lastOffset.height + value.translation.height
                        )
                    }
                    .onEnded { _ in
                        lastOffset = offset
                    }
            )
        }
        .sheet(isPresented: $showingDetail) {
            if let member = selectedMember {
                MemberDetailView(member: member)
            }
        }
    }
    
    private func nodePosition(for member: FamilyMember, in geometry: GeometryProxy) -> CGPoint {
        let level = getLevel(for: member)
        let siblings = getSiblings(for: member)
        let index = siblings.firstIndex(of: member) ?? 0
        let totalSiblings = siblings.count
        
        let x = geometry.size.width * CGFloat(index + 1) / CGFloat(totalSiblings + 1)
        let y = geometry.size.height * CGFloat(level + 1) / CGFloat(getMaxLevel() + 2)
        
        return CGPoint(x: x, y: y)
    }
    
    private func getLevel(for member: FamilyMember) -> Int {
        var level = 0
        var currentMember = member
        while let parent = currentMember.parent {
            level += 1
            currentMember = parent
        }
        return level
    }
    
    private func getSiblings(for member: FamilyMember) -> [FamilyMember] {
        if let parent = member.parent {
            return members.filter { $0.parent?.id == parent.id }
        } else {
            return members.filter { $0.parent == nil }
        }
    }
    
    private func getMaxLevel() -> Int {
        members.map { getLevel(for: $0) }.max() ?? 0
    }
}

struct FamilyNodeView: View {
    let member: FamilyMember
    
    var body: some View {
        VStack {
            Circle()
                .fill(member.healthColor)
                .frame(width: 40, height: 40)
                .overlay(
                    Text(String(member.name.prefix(1)))
                        .foregroundColor(.white)
                        .font(.headline)
                )
            
            Text(member.name)
                .font(.caption)
                .foregroundColor(.primary)
                .multilineTextAlignment(.center)
                .frame(width: 80)
        }
    }
}

struct ConnectionLine: Shape {
    let from: CGPoint
    let to: CGPoint
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: from)
        path.addLine(to: to)
        return path
    }
}

struct GridBackground: View {
    var body: some View {
        GeometryReader { geometry in
            Path { path in
                let width = geometry.size.width
                let height = geometry.size.height
                let gridSize: CGFloat = 50
                
                for x in stride(from: 0, through: width, by: gridSize) {
                    path.move(to: CGPoint(x: x, y: 0))
                    path.addLine(to: CGPoint(x: x, y: height))
                }
                
                for y in stride(from: 0, through: height, by: gridSize) {
                    path.move(to: CGPoint(x: 0, y: y))
                    path.addLine(to: CGPoint(x: width, y: y))
                }
            }
            .stroke(Color.gray.opacity(0.2), lineWidth: 0.5)
        }
    }
}
