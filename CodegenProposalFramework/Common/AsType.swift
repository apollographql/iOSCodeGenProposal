//
//  LazyWeakProperty.swift
//  CodegenProposalFramework
//
//  Created by Anthony Miller on 2/1/21.
//

import Foundation

/// A property wrapper for a `TypeCase` on a `ResponseData` object.
///
/// `AsType` uses a lazy and weak wrapper that can create a `TypeCase` data object
/// given the fields for the `TypeCase` and the parent `ResponseData` object.
///
/// To ensure a retain cycle is not created, this uses an an unowned reference to
/// the `parent` and lazily creates the child `TypeCase` object, which is retained weakly.
/// If the child is de-referenced, it will deallocate, losing it's retain on the parent.
/// If the property is accessed on the parent again, the `TypeCase` will be re-created.
@propertyWrapper struct AsType<T: TypeCase> {
  private let typeCase: LazyWeakTypeCase<T>?

  static var `nil`: Self { Self.init() }

  init(parent: T.Parent, dataPath: KeyPath<T.Parent, T.FieldData?>) {
    guard let data = parent[keyPath: dataPath] else {
      self.init()
      return
    }

    self.init(parent: parent, data: data)
  }

  init(parent: T.Parent, data: T.FieldData?) {
    guard let data = data else {
      self.typeCase = nil
      return
    }

    self.typeCase = LazyWeakTypeCase(parent: parent, data: data)
  }

  init() {
    self.typeCase = nil
  }

  var wrappedValue: T? {
    guard let typeCase = typeCase else { return nil }
    return typeCase.value
  }
}

//extension AsType where T.TypeCaseFields == Void {
//  init(parent: T.Parent, typeCaseFields: KeyPath<T.Parent, T.Fields?>) {
//    self.init(parent: parent, fields: parent[keyPath: typeCaseFields], typeCaseFields: ())
//  }
//
//  init(parent: T.Parent, fields: T.Fields?) {
//    self.init(parent: parent, fields: fields, typeCaseFields: ())
//  }
//}

private final class LazyWeakTypeCase<T: TypeCase> {
  private weak var _value: T?

  private unowned let parent: T.Parent
  fileprivate let data: T.FieldData

  init(parent: T.Parent, data: T.FieldData) {
    self.parent = parent
    self.data = data
  }

  var value: T {
    get {
      if let value = _value {
        return value
      }

      let value = T.init(parent: parent, data: data)
      self._value = value
      return value
    }
  }
}


