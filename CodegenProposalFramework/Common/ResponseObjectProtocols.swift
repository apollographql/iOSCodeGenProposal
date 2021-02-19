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
  associatedtype Fields

  /// A type representing the `TypeCase`s that the object may be.
  associatedtype TypeCases = Void

  /// A typealias for the `FieldData` of the object. This stores the `Fields` and `TypeCases`.
  typealias ResponseData = FieldData<Fields, TypeCases> // TODO: Remove this?

  /// The raw data objects for the fields of the type and any of its `TypeCases`
  var data: ResponseData { get }

  /// A subscript used by `@dynamicMemberLookup` to access the `Field`s on the data object directly.
  subscript<T>(dynamicMember keyPath: KeyPath<Fields, T>) -> T { get }
}

// MARK: - TypeCase

/// A protocol representing a type case response data object.
/// A type case is a more specific type, that a `ResponseObject` may also be, such as an
/// interface or a type in a union.
///
/// A `TypeCase` can typically be accessed using an `@AsType` wrapped property on the parent object.
/// The child type case is always optional, and will only exist if the type of the object
/// matches the type case.
///
/// The fields from the parent object are also accessible on the child type case.
protocol TypeCase: ResponseObject {

  /// The type of the parent response data object that the type case is a more specific type of.
  associatedtype Parent: ResponseObject

  /// Designated initializer for a `TypeCase`.
  /// - Parameters:
  ///   - parent: The parent data object that the `TypeCase` is a more specific type for.
  ///   - data: The data for the `Fields` on the object,
  ///           including fields for any child `TypeCase`s.
  init(parent: Parent, data: ResponseData)

  /// The parent `ResponseObject` that the `TypeCase` is a more specific type of.
  ///
  /// The fields from the parent object are also accessible on the child type case.
  var parent: Parent { get }

  /// A subscript used by `@dynamicMemberLookup` to access the `Parent`'s `Fields` directly.
  subscript<T>(dynamicMember keyPath: KeyPath<Parent.Fields, T>) -> T { get }
}

extension TypeCase where TypeCases == Void {
  /// Initializes a `TypeCase` that has no child `TypeCases`.
  /// - Parameters:
  ///   - parent: The parent data object that the `TypeCase` is a more specific type for.
  ///   - fields: The GraphQL fields fetched and stored directly on this object.
  init(parent: Parent, fields: Fields) {
    self.init(parent: parent, data: .init(fields: fields))
  }
}

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
  /// This will be the `Parent` of any `TypeCase` that also conforms to `HasFragments`.
  associatedtype Parent = Void

  /// A type representing all of the fragments contained on the `ResponseObject`.
  ///
  /// This type should always be a generic `ToFragments` object.
  associatedtype Fragments = ToFragments<Parent, ResponseData>

  /// A `ToFragments` object that contains accessors for all of the fragments
  /// the object can be converted to.
  var fragments: Fragments { get }
}

extension HasFragments where Parent == Void, Fragments: ToFragments<Parent, ResponseData> {
  var fragments: Fragments { Fragments(parent: (), data: data) }
}

extension HasFragments where Self: TypeCase, Fragments: ToFragments<Parent, ResponseData> {
  var fragments: Fragments { Fragments(parent: parent, data: data) }
}
