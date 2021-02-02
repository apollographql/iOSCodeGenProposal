//
//  LazyWeakProperty.swift
//  CodegenProposalFramework
//
//  Created by Anthony Miller on 2/1/21.
//

import Foundation

final class SubType<T: TypeCase> {
  private weak var value: T?

  private unowned let parent: T.Parent
  private let props: T.Props

  init(parent: T.Parent, props: T.Props) {
    self.parent = parent
    self.props = props
  }

  init(wrappedValue: T) {
    self.value = wrappedValue
    self.parent = wrappedValue.parent
    self.props = wrappedValue.props
  }

  var wrappedValue: T {
    get {
      if let value = value {
        return value
      }

      let value = T.init(parent: parent, props: props)
      self.value = value
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
    return subType.wrappedValue
  }
}

@propertyWrapper struct FragmentSpread<T: FragmentTypeCase> {
  let subType: SubType<T>
  let props: T.Props

  init(parent: T.Parent, props: T.Props) {
    self.subType = SubType(parent: parent, props: props)
    self.props = props
  }

  init(wrappedValue: T!) {
    self.subType = SubType(parent: wrappedValue.parent, props: wrappedValue.props)
    self.props = wrappedValue.props
  }

  var wrappedValue: T! {
    return subType.wrappedValue
  }

  var projectedValue: T.Props {
    return props
  }
}
