//
//  ResponseDataProtocols.swift
//  CodegenProposalFramework
//
//  Created by Anthony Miller on 2/16/21.
//

import Foundation

// MARK: - ResponseObject

/// A protocol representing any data object that is part of the response
/// data for a `GraphQLOperation`.
@dynamicMemberLookup
protocol ResponseObject: AnyObject {

  /// A type representing the GraphQL fields fetched and stored directly on this object.
  associatedtype Fields: FieldData

  /// A typealias for the `FieldData` of the object. This stores the `Fields` and `TypeConditions`.
  typealias ResponseData = [String: Any] // TODO: Remove this?

  /// The raw data objects for the fields of the type and any of its `TypeConditions`
  var data: [String: Any] { get }
  
  var fields: Fields { get } // TODO: remove this?

  /// A subscript used by `@dynamicMemberLookup` to access the `Field`s on the data object directly.
  subscript<T>(dynamicMember keyPath: KeyPath<Fields, T>) -> T { get }

  init(data: [String: Any])
}

// MARK: - TypeCondition

/// A protocol representing a type condition response data object.
/// A type condition is a more specific type, that a `ResponseObject` may also be, such as an
/// interface or a type in a union.
///
/// A `TypeCondition` can typically be accessed using an `@AsType` wrapped property on the parent object.
/// The child type condition is always optional, and will only exist if the type of the object
/// matches the type condition.
///
/// The fields from the parent object are also accessible on the child type condition.
protocol TypeCondition: ResponseObject {

  static var possibleTypes: [String] { get }

  /// Designated initializer for a `TypeCondition`.
  /// - Parameters:
  ///   - parent: The parent data object that the `TypeCondition` is a more specific type for.
  ///   - data: The data for the `Fields` on the object,
  ///           including fields for any child `TypeCondition`s.
  init(data: [String: Any])
}

//extension TypeCondition where TypeConditions == Void {
//  /// Initializes a `TypeCondition` that has no child `TypeConditions`.
//  /// - Parameters:
//  ///   - parent: The parent data object that the `TypeCondition` is a more specific type for.
//  ///   - fields: The GraphQL fields fetched and stored directly on this object.
//  init(parent: Parent, fields: Fields) {
//    self.init(parent: parent, data: .init(fields: fields))
//  }
//}

// MARK: - Fragment

/// A protocol representing a fragment that a `ResponseObject` object may be converted to.
///
/// A `ResponseObject` that conforms to `HasFragments` can be converted to
/// any `Fragment` included in it's `Fragments` object via its `fragments` property.
///
/// - SeeAlso: `HasFragments`, `ToFragments`
protocol Fragment: ResponseObject { }

// MARK: - HasFragments

/// A protocol that a `ResponseObject` that contains fragments should conform to.
protocol HasFragments: ResponseObject {

  /// If applicable, the type of the parent response data object. Defaults to `Void`.
  /// This will be the `Parent` of any `TypeCondition` that also conforms to `HasFragments`.
  associatedtype Parent = Void

  /// A type representing all of the fragments contained on the `ResponseObject`.
  ///
  /// This type should always be a generic `ToFragments` object.
  associatedtype Fragments: FieldData

  /// A `ToFragments` object that contains accessors for all of the fragments
  /// the object can be converted to.
  var fragments: Fragments { get }
}

extension HasFragments {
  var fragments: Fragments { Fragments(data: data) }
}

//extension HasFragments where Parent == Void, Fragments: ToFragments<Parent, ResponseData> {
//  var fragments: Fragments { Fragments(parent: (), data: data) }
//}
//
//extension HasFragments where Self: TypeCondition, Fragments: ToFragments<Parent, ResponseData> {
//  var fragments: Fragments { Fragments(parent: parent, data: data) }
//}
