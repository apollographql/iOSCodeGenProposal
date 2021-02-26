//
//  FieldData.swift
//  CodegenProposalFramework
//
//  Created by Anthony Miller on 2/17/21.
//

import Foundation

class FieldData: Equatable {

  final let data: [String: Any]

  @Field("__typename") final var __typename: String

  required init(data: [String: Any]) {
    self.data = data
  }
}

func ==<T: FieldData>(lhs: T, rhs: T) -> Bool {
  return true // TODO: Unit test & implement this
}

@propertyWrapper
struct Field<Value> {

  let key: String // TODO: change to CodingKeys or something more safe than strings?

  init(_ key: String) {
    self.key = key
  }

  static subscript<T: FieldData>(
    _enclosingInstance instance: T,
    wrapped wrappedKeyPath: KeyPath<T, Value>,
    storage storageKeyPath: KeyPath<T, Field>
  ) -> Value {
    get {
      let key = instance[keyPath: storageKeyPath].key

      switch Value.self {
      case let Type as FieldData.Type:
        let data = instance.data[key] as! [String: Any]
        return Type.init(data: data) as! Value
      default:
        return instance.data[key] as! Value
      }
    }
  }

  @available(*, unavailable, message: "This property wrapper can only be applied to classes")
  var wrappedValue: Value { fatalError() }
}
