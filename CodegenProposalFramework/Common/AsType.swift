//
//  LazyWeakProperty.swift
//  CodegenProposalFramework
//
//  Created by Anthony Miller on 2/1/21.
//

import Foundation

/// A property wrapper for a `TypeCondition` on a `ResponseObject`.
@propertyWrapper struct AsType<Value: TypeCondition> {

  static subscript<T: FieldData>(
    _enclosingInstance instance: T,
    wrapped wrappedKeyPath: KeyPath<T, Value?>,
    storage storageKeyPath: KeyPath<T, Self>
  ) -> Value? {
    get {
      guard Value.possibleTypes.contains(instance.__typename) else { return nil }
      return Value(data: instance.data)
    }
  }

  @available(*, unavailable, message: "This property wrapper can only be applied to classes")
  var wrappedValue: Value? {
      get { fatalError() }
  }
}
