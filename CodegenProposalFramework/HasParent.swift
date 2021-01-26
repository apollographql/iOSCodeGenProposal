import Foundation

// Generated once for the entire project
//@dynamicMemberLookup
public protocol HasParent {
  associatedtype Parent

  var parent: Reference<Parent> { get }
}

//public extension HasParent {
//  subscript<T>(dynamicMember keyPath: KeyPath<Parent, T>) -> T {
//    parent.value[keyPath: keyPath]
//  }
//}
//
//public extension HasParent where Parent: HasParent {
//  subscript<T>(dynamicMember keyPath: KeyPath<Parent.Parent, T>) -> T {
//    parent.parent.value[keyPath: keyPath]
//  }
//}
//
//public extension HasParent where Parent: HasParent, Parent.Parent: HasParent {
//  subscript<T>(dynamicMember keyPath: KeyPath<Parent.Parent.Parent, T>) -> T {
//    parent.parent.parent.value[keyPath: keyPath]
//  }
//}
