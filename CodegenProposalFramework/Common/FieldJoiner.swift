//
//  FieldJoiner.swift
//  CodegenProposalFramework
//
//  Created by Anthony Miller on 2/16/21.
//

import Foundation

/// Combines the fields of two `ResponseObject` objects onto one object.
///
/// This is used when different fields on a type are being fetched by `ResponseObject` objects
/// and their child `TypeCase`s. A `FieldJoiner` allows you to merge the fields
/// from each `TypeCase` and their parent.
///
/// `FieldJoiner` can be subclassed to provide computed properties to resolve any naming conflicts
/// for fields that exist on both of the joined objects. `FieldJoiner`s can also be nested to merge
/// more than two objects.
@dynamicMemberLookup
class FieldJoiner<T: ResponseObject, U: ResponseObject> {
  let first: T.Fields
  let second: U.Fields

  init(first: T, second: U) {
    self.first = first.data.fields
    self.second = second.data.fields
  }

  subscript<Value>(dynamicMember keyPath: KeyPath<T.Fields, Value>) -> Value {
    first[keyPath: keyPath]
  }

  subscript<Value>(dynamicMember keyPath: KeyPath<U.Fields, Value>) -> Value {
    second[keyPath: keyPath]
  }
}
