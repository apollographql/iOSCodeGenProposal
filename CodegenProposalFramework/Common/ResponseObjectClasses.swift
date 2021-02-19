//
//  ResponseObjectClasses.swift
//  CodegenProposalFramework
//
//  Created by Anthony Miller on 2/18/21.
//

import Foundation


@dynamicMemberLookup
class ResponseObjectBase<Fields, TypeCases>: ResponseObject {
  class TypeCasesBase<T> {
    final let parent: Unwrapped<T> = .init()
  }

  final let data: FieldData<Fields, TypeCases>

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
  convenience init(fields: Fields) {
    self.init(data: .init(fields: fields))
  }
}

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
