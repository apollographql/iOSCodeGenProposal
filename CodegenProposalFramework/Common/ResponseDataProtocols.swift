//
//  ResponseDataProtocols.swift
//  CodegenProposalFramework
//
//  Created by Anthony Miller on 2/16/21.
//

import Foundation

// MARK: - ResponseData

/// A protocol representing any data object that is part of the response
/// data for a `GraphQLOperation`.
@dynamicMemberLookup
protocol ResponseData: AnyObject {

  /// A type representing the GraphQL fields fetched and stored directly on this object.
  associatedtype Fields

  /// A type representing the fields for all `TypeCase`s that the object may be.
  associatedtype TypeCaseFields = Void

  /// The GraphQL fields fetched and stored directly on this object.
  var fields: Fields { get }

  /// A subscript used by `@dynamicMemberLookup` to access the `Field`s on the data object directly.
  subscript<T>(dynamicMember keyPath: KeyPath<Fields, T>) -> T { get }
}

// MARK: - TypeCase

/// A protocol representing a type case response data object.
/// A type case is a more specific type, that a `ResponseData` object may also be, such as an
/// interface or a type in a union.
///
/// A `TypeCase` can typically be accessed using an `@AsType` wrapped property on the parent object.
/// The child type case is always optional, and will only exist if the type of the object
/// matches the type case.
///
/// The fields from the parent object are also accessible on the child type case.
protocol TypeCase: ResponseData {

  /// The parameters needed to initialize the fields for the `TypeCase`.
  typealias TypeCaseParams = (Fields, TypeCaseFields)

  /// The type of the parent response data object that the type case is a more specific type of.
  associatedtype Parent: ResponseData

  /// Designated initializer for a `TypeCase`.
  /// - Parameters:
  ///   - parent: The parent data object that the `TypeCase` is a more specific type for.
  ///   - fields: The fields for the specific `TypeCase`.
  ///   - typeCaseFields: The fields for any nested `TypeCases` that the object might be.
  init(parent: Parent, fields: Fields, typeCaseFields: TypeCaseFields)

  /// The parent response data object that the type case is a more specific type of.
  /// The fields from the parent object are also accessible on the child type case.
  var parent: Parent { get }

  /// A subscript used by `@dynamicMemberLookup` to access the parent data object's `Field`s directly.
  subscript<T>(dynamicMember keyPath: KeyPath<Parent.Fields, T>) -> T { get }
}

extension TypeCase where TypeCaseFields == Void {
  /// Designated initializer for a `TypeCase`.
  /// - Parameters:
  ///   - parent: The parent data object that the `TypeCase` is a more specific type for.
  ///   - fields: The fields for the specific `TypeCase`.
  init(parent: Parent, fields: Fields) {
    self.init(parent: parent, fields: fields, typeCaseFields: ())
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
  /// on the fragment directly.
  associatedtype Fields = FragmentType.Fields
}

// MARK: - Fragment

/// A protocol representing a fragment that a `ResponseData` object may be converted to.
///
/// Any `ResponseData` object that conforms to `HasFragments` can be converted to
/// any `Fragment`s included on that object using its `fragments` property.
protocol Fragment: ResponseData {

  /// Designated initializer for a `Fragment`
  /// - Parameter fields: The GraphQL fields fetched for the fragment.
  init(fields: Fields) // TODO: add typecase fields?
}

// MARK: - HasFragment

/// A protocol that a `ResponseData` object that contains fragments should conform to.
protocol HasFragments: ResponseData {

  /// If applicable, the type of the parent response data object. Defaults to `Void`.
  /// This will be the `Parent` of any `TypeCase` that also conforms to `HasFragments`.
  associatedtype Parent = Void

  /// A type representing all of the fragments contained on the response data object.
  ///
  /// This type should always be a generic `ToFragments` object.
  associatedtype Fragments = ToFragments<Parent, Fields>

  /// A `ToFragments` object that contains accessors for all of the fragments
  /// the object can be converted to.
  var fragments: Fragments { get }
}
