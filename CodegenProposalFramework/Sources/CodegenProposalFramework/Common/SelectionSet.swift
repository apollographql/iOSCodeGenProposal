//
//  FieldData.swift
//  CodegenProposalFramework
//
//  Created by Anthony Miller on 2/17/21.
//

import Foundation

protocol DataContainer {
  var data: ResponseData { get }

  init(data: ResponseData)
}

extension DataContainer {
  func toFragment<T: SelectionSet>() -> T {
    return T.init(data: data)
  }
}

enum SelectionSetType {
  case ObjectType(Schema.ObjectType)
  case Interface(Schema.Interface)
}

protocol SelectionSet: DataContainer, Equatable {

  /// The GraphQL type for the `SelectionSet`.
  ///
  /// This may be a concrete type (`ConcreteType`) or an abstract type (`Interface`).
  static var __parentType: SelectionSetType { get }
}

extension SelectionSet {

  var __objectType: Schema.ObjectType? { Schema.ObjectType(rawValue: __typename) }

  var __typename: String { data["__typename"] }

  func asType<T: SelectionSet>() -> T? {
    guard let __objectType = __objectType, __objectType != ._unknown else { return nil } // TODO: Unit Test
    switch T.__parentType {
    case .ObjectType(let type):
      guard __objectType == type else { return nil }
    case .Interface(let interface):
      guard __objectType.implements(interface) else { return nil }
    }

    return T.init(data: data)
  }
}

func ==<T: SelectionSet>(lhs: T, rhs: T) -> Bool {
  return true // TODO: Unit test & implement this
}

struct ResponseData {

  let data: [String: Any]

  subscript<T: ScalarType>(_ key: String) -> T {
    data[key] as! T
  }

  subscript<T: SelectionSet>(_ key: String) -> T {
    let entityData = data[key] as! [String: Any]
    return T.init(data: ResponseData(data: entityData))
  }

  subscript<T: SelectionSet>(_ key: String) -> [T] {
    let entityData = data[key] as! [[String: Any]]
    return entityData.map { T.init(data: ResponseData(data: $0)) }
  }
}

protocol ScalarType {}
extension String: ScalarType {}
extension Int: ScalarType {}
extension Bool: ScalarType {}
