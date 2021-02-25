//
//  LazyWeakProperty.swift
//  CodegenProposalFramework
//
//  Created by Anthony Miller on 2/1/21.
//

import Foundation

final class Unwrapped<T> { // TODO: find better name? Or use UnsafePointer or something like that?
  var value: T!

  init() {}

  init(value: T?) {
    self.value = value
  }
}

/// A property wrapper for a `TypeCondition` on a `ResponseObject`.
///
/// `AsType` uses a lazy and weak wrapper that can create a `TypeCondition` data object
/// given the fields for the `TypeCondition` and the parent `ResponseObject`.
///
/// To ensure a retain cycle is not created, this uses an an unowned reference to
/// the `parent` and lazily creates the child `TypeCondition` object, which is retained weakly.
/// If the child is dereferenced, it will deallocate, losing it's retain on the parent.
/// If the property is accessed on the parent again, the `TypeCondition` will be recreated.
///
/// - SeeAlso: `LazyWeakTypeCondition`
@propertyWrapper struct AsType<T: TypeCondition> {
  private let typeCondition: LazyWeakTypeCondition<T>?

  /// A convenience property for creating an instance with a `nil` value.
  static var `nil`: Self { Self.init() }

  init(parent: Unwrapped<T.Parent>, data: T.ResponseData?) {
    guard let data = data else {
      self.typeCondition = nil
      return
    }

    self.typeCondition = LazyWeakTypeCondition(parent: parent, data: data)
  }

  init() {
    self.typeCondition = nil
  }

  var wrappedValue: T? {
    guard let typeCondition = typeCondition else { return nil }
    return typeCondition.value
  }
}

private final class LazyWeakTypeCondition<T: TypeCondition> {
  private weak var _value: T?

  private unowned let parent: Unwrapped<T.Parent>
  fileprivate let data: T.ResponseData

  init(parent: Unwrapped<T.Parent>, data: T.ResponseData) {
    self.parent = parent
    self.data = data
  }

  var value: T {
    get {
      if let value = _value {
        return value
      }

      let value = T.init(parent: parent.value, data: data)
      self._value = value
      return value
    }
  }
}
