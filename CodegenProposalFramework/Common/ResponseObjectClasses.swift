//
//  ResponseObjectClasses.swift
//  CodegenProposalFramework
//
//  Created by Anthony Miller on 2/18/21.
//

import Foundation

/// An abstract base class for any data object that is part of the response
/// data for a `GraphQLOperation`.
///
/// This class uses `@dynamicMemberLookup` to provide accessors to all of the fields and
/// type cases on the provided `Fields` and `TypeCases` objects.
///
/// - Generic Parameters:
///   - `Fields`: An object that stores the fields fetched and stored directly on this object.
///   - `TypeCases`: [optional] An object that stores the `TypeCase`s that the object may be
///                  and their fields. Defaults to `Void`.
@dynamicMemberLookup
class ResponseObjectBase<Fields, TypeCases>: ResponseObject {
  /// An abstract base class that a subclasses `TypeCases` should inherit from.
  class TypeCasesBase<T> {
    final let parent: Unwrapped<T> = .init()
  }

  final let data: FieldData<Fields, TypeCases>

  /// The designated initializer.
  /// - Parameter data: The raw data for the fields of the type and any of its `TypeCases`
  init(data: FieldData<Fields, TypeCases>) {
    self.data = data
    if let typeCases = self.data.typeCaseFields as? TypeCasesBase<Self> {
      typeCases.parent.value = (self as! Self)
    }
  }

  final subscript<T>(dynamicMember keyPath: KeyPath<Fields, T>) -> T {
    return data.fields[keyPath: keyPath]
  }

  final subscript<T>(dynamicMember keyPath: KeyPath<TypeCases, T>) -> T {
    return data.typeCaseFields[keyPath: keyPath]
  }
}

extension ResponseObjectBase where TypeCases == Void {
  /// Initializes a `ResponseObject` that has no `TypeCases`.
  /// - Parameter fields: The GraphQL fields fetched and stored directly on this object.
  convenience init(fields: Fields) {
    self.init(data: .init(fields: fields))
  }
}

/// An abstract base class for a type case response data object.
///
/// A type case is a more specific type, that a `ResponseObject` may also be, such as an
/// interface or a type in a union. For more information see `TypeCase`
class TypeCaseBase<Fields, TypeCases, Parent: ResponseObject>:
  ResponseObjectBase<Fields, TypeCases>, TypeCase {
  typealias Parent = Parent

  final let parent: Parent

  required init(parent: Parent, data: ResponseData) {
    self.parent = parent
    super.init(data: data)
  }

  final subscript<T>(dynamicMember keyPath: KeyPath<Parent.Fields, T>) -> T {
    parent.data.fields[keyPath: keyPath]
  }
}

// These extensions can be generated based on the max number of levels of nested type cases
// in the user's project. // TODO: need to do the same for ToFragments I think. Need to test
extension TypeCaseBase where Parent: TypeCase {
  final subscript<T>(dynamicMember keyPath: KeyPath<Parent.Parent.Fields, T>) -> T {
    parent.parent.data.fields[keyPath: keyPath]
  }
}

extension TypeCaseBase where Parent: TypeCase, Parent.Parent: TypeCase {
  final subscript<T>(dynamicMember keyPath: KeyPath<Parent.Parent.Parent.Fields, T>) -> T {
    parent.parent.parent.data.fields[keyPath: keyPath]
  }
}

/// A typealias for a `TypeCase` that is included as a fragment.
///
/// Each fragment defined has a generic class generated that inherits from
/// `FragmentTypeCase`. Other response data objects can subclass that generated class to
/// include the reusable fragment.
/// Like other `TypeCase`s, the fields from the parent object are also accessible on the
/// child type case.
typealias FragmentTypeCaseBase<FragmentType: Fragment, Parent: ResponseObject> = TypeCaseBase<FragmentType.Fields, FragmentType.TypeCases, Parent> & HasFragments
