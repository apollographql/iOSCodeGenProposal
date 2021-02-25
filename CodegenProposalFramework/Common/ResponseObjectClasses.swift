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
/// type conditions on the provided `Fields` and `TypeConditions` objects.
///
/// - Generic Parameters:
///   - `Fields`: An object that stores the fields fetched and stored directly on this object.
///   - `TypeConditions`: [optional] An object that stores the `TypeCondition`s that the object may be
///                  and their fields. Defaults to `Void`.
@dynamicMemberLookup
class ResponseObjectBase<Fields, TypeConditions>: ResponseObject {
  /// An abstract base class that a subclasses `TypeConditions` should inherit from.
  class TypeConditionsBase<T> {
    final let parent: Unwrapped<T> = .init()
  }

  final let data: FieldData<Fields, TypeConditions>

  /// The designated initializer.
  /// - Parameter data: The raw data for the fields of the type and any of its `TypeConditions`
  init(data: FieldData<Fields, TypeConditions>) {
    self.data = data
    if let typeConditions = self.data.typeConditionFields as? TypeConditionsBase<Self> {
      typeConditions.parent.value = (self as! Self)
    }
  }

  final subscript<T>(dynamicMember keyPath: KeyPath<Fields, T>) -> T {
    return data.fields[keyPath: keyPath]
  }

  final subscript<T>(dynamicMember keyPath: KeyPath<TypeConditions, T>) -> T {
    return data.typeConditionFields[keyPath: keyPath]
  }
}

extension ResponseObjectBase where TypeConditions == Void {
  /// Initializes a `ResponseObject` that has no `TypeConditions`.
  /// - Parameter fields: The GraphQL fields fetched and stored directly on this object.
  convenience init(fields: Fields) {
    self.init(data: .init(fields: fields))
  }
}

/// An abstract base class for a type condition response data object.
///
/// A type condition is a more specific type, that a `ResponseObject` may also be, such as an
/// interface or a type in a union. For more information see `TypeCondition`
class TypeConditionBase<Fields, TypeConditions, Parent: ResponseObject>:
  ResponseObjectBase<Fields, TypeConditions>, TypeCondition {
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

// These extensions can be generated based on the max number of levels of nested type conditions
// in the user's project. // TODO: need to do the same for ToFragments I think. Need to test
extension TypeConditionBase where Parent: TypeCondition {
  final subscript<T>(dynamicMember keyPath: KeyPath<Parent.Parent.Fields, T>) -> T {
    parent.parent.data.fields[keyPath: keyPath]
  }
}

extension TypeConditionBase where Parent: TypeCondition, Parent.Parent: TypeCondition {
  final subscript<T>(dynamicMember keyPath: KeyPath<Parent.Parent.Parent.Fields, T>) -> T {
    parent.parent.parent.data.fields[keyPath: keyPath]
  }
}

/// A typealias for a `TypeCondition` that is included as a fragment.
///
/// Each fragment defined has a generic class generated that inherits from
/// `FragmentTypeConditionBase`. Other response data objects can subclass that generated class to
/// include the reusable fragment.
/// Like other `TypeCondition`s, the fields from the parent object are also accessible on the
/// child type condition.
typealias FragmentTypeConditionBase<FragmentType: Fragment, Parent: ResponseObject> = TypeConditionBase<FragmentType.Fields, FragmentType.TypeConditions, Parent> & HasFragments
