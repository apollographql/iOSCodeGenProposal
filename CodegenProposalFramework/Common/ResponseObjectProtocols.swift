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
protocol ResponseObject: AnyObject { // TODO: Make base class?

  /// A type representing the GraphQL fields fetched and stored directly on this object.
  associatedtype Fields

  /// A type representing the fields for all `TypeCase`s that the object may be.
  associatedtype TypeCases = Void

  /// A typealias for the `FieldData` of the object. This stores the `Fields` and `TypeCaseFields`.
  typealias ResponseData = FieldData<Fields, TypeCases> // TODO: Remove this?

  /// The GraphQL fields fetched and stored directly on this object.
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
  ///   - data: The data for the fields on the `TypeCase`, including fields for any child `TypeCase`s.
  init(parent: Parent, data: ResponseData) // TODO: fix docs

  /// The parent `ResponseObject` that the type case is a more specific type of.
  /// The fields from the parent object are also accessible on the child type case.
  var parent: Parent { get }

  /// A subscript used by `@dynamicMemberLookup` to access the parent `ResponseObject`'s `Field`s directly.
  subscript<T>(dynamicMember keyPath: KeyPath<Parent.Fields, T>) -> T { get }
}

extension TypeCase where TypeCases == Void {
  /// Designated initializer for a `TypeCase`.
  /// - Parameters:
  ///   - parent: The parent data object that the `TypeCase` is a more specific type for.
  ///   - fields: The fields for the specific `TypeCase`.
  init(parent: Parent, fields: Fields) {
    self.init(parent: parent, data: .init(fields: fields))
  }
}

// MARK: - FragmentTypeCase

/// A protocol representing a `TypeCase` that is included as a fragment.
///
/// Each fragment defined has a generic class generated that conforms to `FragmentTypeCase`.
/// Other response data objects can subclass that generated class to include the reusable fragment.
/// Like other `TypeCase`s, the fields from the parent object are also accessible on the
/// child type case.
protocol FragmentTypeCase: TypeCase, HasFragments {

  /// The type of the fragment that the `FragmentTypeCase` represents
  associatedtype FragmentType: Fragment

  /// A type representing the GraphQL fields for the fragment. These will be stored
  /// on the fragment directly. // TODO: Docs

  associatedtype Fields = FragmentType.Fields
  associatedtype TypeCases = FragmentType.Fields
}

extension FragmentTypeCase {
  typealias Fields = FragmentType.Fields
  typealias TypeCases = FragmentType.TypeCases
}

// MARK: - Fragment

/// A protocol representing a fragment that a `ResponseObject` object may be converted to.
///
/// Any `ResponseObject` object that conforms to `HasFragments` can be converted to
/// any `Fragment`s included on that object using its `fragments` property.
protocol Fragment: ResponseObject { }

// MARK: - HasFragment

/// A protocol that a `ResponseObject` object that contains fragments should conform to.
protocol HasFragments: ResponseObject {

  /// If applicable, the type of the parent response data object. Defaults to `Void`.
  /// This will be the `Parent` of any `TypeCase` that also conforms to `HasFragments`.
  associatedtype Parent = Void

  /// A type representing all of the fragments contained on the response data object.
  ///
  /// This type should always be a generic `ToFragments` object.
  associatedtype Fragments = ToFragments<Parent, ResponseData>

  /// A `ToFragments` object that contains accessors for all of the fragments
  /// the object can be converted to.
  var fragments: Fragments { get }
}
