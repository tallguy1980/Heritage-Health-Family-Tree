import Foundation
import SwiftUI

enum FamilyRelationship: String, CaseIterable {
    case parent = "Parent"
    case child = "Child"
    case sibling = "Sibling"
    case spouse = "Spouse"
    case grandparent = "Grandparent"
    case grandchild = "Grandchild"
    case aunt = "Aunt"
    case uncle = "Uncle"
    case cousin = "Cousin"
    
    var icon: String {
        switch self {
        case .parent:
            return "person.2.fill"
        case .child:
            return "person.fill"
        case .sibling:
            return "person.2"
        case .spouse:
            return "heart.fill"
        case .grandparent:
            return "person.3.fill"
        case .grandchild:
            return "person.fill"
        case .aunt:
            return "person.fill"
        case .uncle:
            return "person.fill"
        case .cousin:
            return "person.2.fill"
        }
    }
} 