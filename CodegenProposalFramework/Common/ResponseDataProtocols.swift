//
//  ResponseDataProtocols.swift
//  CodegenProposalFramework
//
//  Created by Anthony Miller on 2/16/21.
//

import Foundation

/// A protocol representing any data object that is part of the response
/// data for a `GraphQLOperation`.
@dynamicMemberLookup
protocol ResponseData: AnyObject {

  /// The type that represents the GraphQL fields fetched and stored directly on this object.
  associatedtype Fields

  /// The GraphQL fields fetched and stored directly on this object.
  var fields: Fields { get }

  /// A subsrcipt used by `@dynamicMemberLookup` to access the `Fields` on the data object directly.
  subscript<T>(dynamicMember keyPath: KeyPath<Fields, T>) -> T { get }
}

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
  /// The type of the parent response data object that the type case is a more specific type of.
  associatedtype Parent: ResponseData

  /// Designated initializer for a `TypeCase`.
  /// A `TypeCase` can always be initialized with an instance of its parent data
  /// and the fields for the `TypeCase`.
  /// - Parameters:
  ///   - parent: The parent data object that the `TypeCase` is a more specific type for.
  ///   - fields: The fields for the specific `TypeCase`
  init(parent: Parent, fields: Fields)

  var parent: Parent { get }

  subscript<T>(dynamicMember keyPath: KeyPath<Parent.Fields, T>) -> T { get }
}

protocol FragmentTypeCase: TypeCase, HasFragments where Fragments: ToFragments<Parent, Fields> {
  associatedtype FragmentType: Fragment
  associatedtype Fields = FragmentType.Fields
}

protocol HasFragments {
  associatedtype Fragments

  var fragments: Fragments { get }
}

protocol Fragment: ResponseData {
  init(fields: Fields)
}
