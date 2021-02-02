//
//  LazyWeakProperty.swift
//  CodegenProposalFramework
//
//  Created by Anthony Miller on 2/1/21.
//

import Foundation

@propertyWrapper final class SubType<T: TypeCase> {
  private weak var value: T?

  private unowned let parent: T.Parent
  private let props: T.Props

  init(parent: T.Parent, props: T.Props) {
    self.parent = parent
    self.props = props
  }

  var wrappedValue: T? {
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

@propertyWrapper struct AsInterface<T: TypeCase> {
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
