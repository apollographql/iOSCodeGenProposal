//
//  ToFragments.swift
//  CodegenProposalFramework
//
//  Created by Anthony Miller on 2/16/21.
//

import Foundation

@propertyWrapper
struct ToFragment<Value: Fragment> {

  static subscript<T: FieldData>(
    _enclosingInstance instance: T,
    wrapped wrappedKeyPath: KeyPath<T, Value>,
    storage storageKeyPath: KeyPath<T, Self>
  ) -> Value {
    get {
      return Value(data: instance.data)
    }
  }

  @available(*, unavailable, message: "This property wrapper can only be applied to classes")
  var wrappedValue: Value {
      get { fatalError() }
  }
}
