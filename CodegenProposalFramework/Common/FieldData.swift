//
//  FieldData.swift
//  CodegenProposalFramework
//
//  Created by Anthony Miller on 2/17/21.
//

import Foundation

//protocol FieldData {
//
//  var data: [String: Any] { get }
//
//  init(data: [String: Any])
//
//}

class FieldData {

  final let data: [String: Any]

  @Field("__typename") final var __typename: String

  required init(data: [String: Any]) {
    self.data = data
  }
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
    storage storageKeyPath: KeyPath<T, Self>
  ) -> Value {
    get {
      let key = instance[keyPath: storageKeyPath].key
      return instance.data[key] as! Value
    }
  }

  @available(*, unavailable, message: "This property wrapper can only be applied to classes")
  var wrappedValue: Value {
      get { fatalError() }
//      set { fatalError() }
  }

}

extension Field where Value: ResponseObject {

  static subscript<T: FieldData>(
    _enclosingInstance instance: T,
    wrapped wrappedKeyPath: KeyPath<T, Value>,
    storage storageKeyPath: KeyPath<T, Self>
  ) -> Value {
    get {
      let key = instance[keyPath: storageKeyPath].key
      let data = instance.data[key] as! [String: Any]
      return Value(data: data) // TODO: Unit test this actually gets called
    }
  }

}
///// An object that stores the raw data objects for the `Fields` of a `ResponseObject`
///// and any of its `TypeConditions`.
//final class FieldData<Fields, TypeConditionFields> { // TODO: One generic param for ResponseObject type? Try this again after making base classes!
//  /// An object that stores the GraphQL fields fetched and stored directly on this object.
//  let fields: Fields
//
//  /// An object that stores the `TypeCondition`s that the object may be and their fields.
//  let typeConditionFields: TypeConditionFields
//
//  init(fields: Fields, typeConditionFields: TypeConditionFields) {
//    self.fields = fields
//    self.typeConditionFields = typeConditionFields
//  }
//}
//
//extension FieldData where TypeConditionFields == Void {
//  convenience init(fields: Fields) {
//    self.init(fields: fields, typeConditionFields: ())
//  }
//}
