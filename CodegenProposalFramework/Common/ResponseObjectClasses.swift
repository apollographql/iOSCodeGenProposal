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


//class BaseResponseObjectWithFragments<Fields, TypeCaseFields, Fragments>:
//  BaseResponseObject<Fields, TypeCaseFields>, HasFragments {
//
//  private(set) lazy var fragments = Fragments(parent: (), data: data)
//}

class TypeCaseBase<Parent: ResponseObject, Fields, TypeCaseFields>:
  ResponseObjectBase<Fields, TypeCaseFields>, TypeCase {

  final let parent: Parent

  required init(parent: Parent, data: ResponseData) {
    self.parent = parent
    super.init(data: data)
  }

  final subscript<T>(dynamicMember keyPath: KeyPath<Parent.Fields, T>) -> T {
    parent.data.fields[keyPath: keyPath]
  }
}
