//
//  LazyWeakProperty.swift
//  CodegenProposalFramework
//
//  Created by Anthony Miller on 2/1/21.
//

import Foundation

final class SubType<T: TypeCase> {
  private weak var _value: T?

  private unowned let parent: T.Parent
  fileprivate let props: T.Props

  init(parent: T.Parent, props: T.Props) {
    self.parent = parent
    self.props = props
  }

  var value: T {
    get {
      if let value = _value {
        return value
      }

      let value = T.init(parent: parent, props: props)
      self._value = value
      return value
    }
  }

}

@propertyWrapper struct AsType<T: TypeCase> {
  let subType: SubType<T>?

  static var `nil`: Self {
    Self.init()
  }

  init(subType: SubType<T>? = nil) {
    self.subType = subType
  }

  init(parent: T.Parent, props: T.Props) {
    self.subType = SubType(parent: parent, props: props)
  }

  var wrappedValue: T? {
    guard let subType = subType else { return nil }
    return subType.value
  }
}

@propertyWrapper struct FragmentSpread<T: FragmentTypeCase> {
  let subType: SubType<T>!

  init(parent: T.Parent, props: T.Props) {
    self.subType = SubType(parent: parent, props: props)
  }

  @available(*, message: "Do not use")
  init(wrappedValue: T!) {
    // TODO: If we pass `Parent.Props` around instead of `Parent` we wont have the issue with
    // initializing with `self`?
    self.subType = nil
  }

  var wrappedValue: T! {
    return subType.value
  }

  var projectedValue: T.Props {
    return subType.props
  }
}

@dynamicMemberLookup
class FieldJoiner<T, U> {
  let first: T
  let second: U

  init(first: T, second: U) {
    self.first = first
    self.second = second
  }

  subscript<Value>(dynamicMember keyPath: KeyPath<T, Value>) -> Value {
    return first[keyPath: keyPath]
  }

  subscript<Value>(dynamicMember keyPath: KeyPath<U, Value>) -> Value {
    return second[keyPath: keyPath]
  }
}
