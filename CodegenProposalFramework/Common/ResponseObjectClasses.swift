//
//  ResponseObjectClasses.swift
//  CodegenProposalFramework
//
//  Created by Anthony Miller on 2/18/21.
//

import Foundation

class BaseResponseObject<Fields, TypeCaseFields>: ResponseObject {

//  typealias ResponseData = FieldData<Fields, TypeCaseFields>

  final let data: ResponseData

  init(data: ResponseData) {
    self.data = data
  }

  final subscript<T>(dynamicMember keyPath: KeyPath<Fields, T>) -> T {
    return data.fields[keyPath: keyPath]
  }
}

//class BaseResponseObjectWithFragments<Fields, TypeCaseFields, Fragments>:
//  BaseResponseObject<Fields, TypeCaseFields>, HasFragments {
//
//  private(set) lazy var fragments = Fragments(parent: (), data: data)
//}

class BaseTypeCase<Parent: ResponseObject, Fields, TypeCaseFields>:
  BaseResponseObject<Fields, TypeCaseFields>, TypeCase {

  final let parent: Parent

  required init(parent: Parent, data: ResponseData) {
    self.parent = parent
    super.init(data: data)
  }

  final subscript<T>(dynamicMember keyPath: KeyPath<Parent.Fields, T>) -> T {
    parent.data.fields[keyPath: keyPath]
  }
}
