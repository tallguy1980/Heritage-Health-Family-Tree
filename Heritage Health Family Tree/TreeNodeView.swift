import SwiftUI
import SwiftData

@MainActor
struct TreeNodeView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var members: [FamilyMember]
    @State private var scale: CGFloat = 0.7
    @State private var offset: CGSize = .zero
    @State private var lastOffset: CGSize = .zero
    
    var body: some View {
        ScrollView([.horizontal, .vertical]) {
            VStack {
                headerView
                zoomControls
                treeVisualization
            }
            .frame(minWidth: 800, minHeight: 600)
        }
    }
    
    private var headerView: some View {
        Text("Family Tree Visualization")
            .font(.title)
            .padding()
    }
    
    private var zoomControls: some View {
        HStack(spacing: 16) {
            Button(action: { withAnimation { scale = max(0.3, scale - 0.1) } }) {
                Image(systemName: "minus.magnifyingglass")
                    .font(.title2)
            }
            Text(String(format: "%.0f%%", scale * 100))
                .font(.caption)
                .frame(width: 40)
            Button(action: { withAnimation { scale = min(2.0, scale + 0.1) } }) {
                Image(systemName: "plus.magnifyingglass")
                    .font(.title2)
            }
        }
        .padding(.bottom, 8)
    }
    
    private var treeVisualization: some View {
        ZStack {
            memberNodes
            connectionLines
        }
        .scaleEffect(scale)
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
    
    private var memberNodes: some View {
        let nodes = members.map { member -> (member: FamilyMember, position: CGPoint) in
            let x = CGFloat(member.generation * 200) + offset.width
            let y = CGFloat(member.level * 100) + offset.height
            return (member: member, position: CGPoint(x: x, y: y))
        }
        
        return ZStack {
            ForEach(nodes, id: \.member.name) { node in
                TreeNode(member: node.member)
                    .position(node.position)
            }
        }
    }
    
    private var connectionLines: some View {
        let connections = members.compactMap { member -> (start: CGPoint, end: CGPoint)? in
            guard let parent = member.parent else { return nil }
            let startX = CGFloat(member.generation * 200) + offset.width
            let startY = CGFloat(member.level * 100) + offset.height
            let endX = CGFloat(parent.generation * 200) + offset.width
            let endY = CGFloat(parent.level * 100) + offset.height
            return (start: CGPoint(x: startX, y: startY),
                   end: CGPoint(x: endX, y: endY))
        }
        
        return ZStack {
            ForEach(connections.indices, id: \.self) { index in
                let connection = connections[index]
                Path { path in
                    path.move(to: connection.start)
                    path.addLine(to: connection.end)
                }
                .stroke(Color.gray.opacity(0.5), lineWidth: 1)
            }
        }
    }
}

struct TreeNode: View {
    let member: FamilyMember
    @State private var isExpanded = true
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            ZStack(alignment: .topTrailing) {
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .fill(LinearGradient(
                        gradient: Gradient(colors: [Color(.systemTeal).opacity(0.18), Color(.systemBlue).opacity(0.12)]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ))
                    .overlay(
                        RoundedRectangle(cornerRadius: 18)
                            .stroke(Color.blue.opacity(0.25), lineWidth: 1)
                    )
                    .shadow(color: Color(.black).opacity(0.08), radius: 6, x: 0, y: 2)
                
                VStack(spacing: 10) {
                    Image(systemName: "person.crop.circle")
                        .resizable()
                        .frame(width: 28, height: 28)
                        .foregroundColor(.blue)
                        .padding(.top, 8)
                    
                    Text(member.name)
                        .font(.headline.bold())
                        .foregroundColor(.primary)
                        .lineLimit(1)
                        .minimumScaleFactor(0.7)
                    
                    HStack(spacing: 8) {
                        Label("Gen \(member.generation)", systemImage: "arrow.up.arrow.down")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                        Label("Lvl \(member.level)", systemImage: "chart.bar")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                    
                    HStack(spacing: 6) {
                        Image(systemName: "heart.fill")
                            .foregroundColor(member.healthColor)
                            .font(.caption)
                        Text(member.healthStatus.rawValue.capitalized)
                            .font(.caption2.bold())
                            .foregroundColor(member.healthColor)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(member.healthColor.opacity(0.15))
                            .cornerRadius(6)
                    }
                    .padding(.bottom, 8)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
            }
            .frame(width: 120, height: 90)
            .padding(.bottom, 4)
            
            // Children
            if let children = member.children, !children.isEmpty {
                VStack(alignment: .center, spacing: 8) {
                    ForEach(children) { child in
                        TreeNode(member: child)
                            .padding(.top, 8)
                    }
                }
            }
        }
    }
}

struct TreeNodeView_Previews: PreviewProvider {
    static var previews: some View {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try! ModelContainer(for: FamilyMember.self, configurations: config)
        
        // Create sample data
        let parent = FamilyMember(
            name: "Parent",
            age: 50,
            birthDate: Date(),
            deceased: false,
            lastCheckup: Date(),
            notes: "",
            healthConditions: [],
            parent: nil,
            healthStatus: .healthy,
            generation: 0,
            level: 0
        )
        
        let child1 = FamilyMember(
            name: "Child 1",
            age: 25,
            birthDate: Date(),
            deceased: false,
            lastCheckup: Date(),
            notes: "",
            healthConditions: [],
            parent: parent,
            healthStatus: .atRisk,
            generation: 1,
            level: 1
        )
        
        let child2 = FamilyMember(
            name: "Child 2",
            age: 22,
            birthDate: Date(),
            deceased: false,
            lastCheckup: Date(),
            notes: "",
            healthConditions: [],
            parent: parent,
            healthStatus: .needsAttention,
            generation: 1,
            level: 1
        )
        
        parent.children = [child1, child2]
        
        return TreeNodeView()
            .modelContainer(container)
            .padding()
    }
} 
