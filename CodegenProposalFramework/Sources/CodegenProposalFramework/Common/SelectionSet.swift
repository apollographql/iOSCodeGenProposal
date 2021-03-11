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

enum SelectionSetType {
  case ConcreteType(Schema.ConcreteType)
  case Interface(Schema.Interface)
}

protocol SelectionSet: DataContainer, Equatable {

  /// The GraphQL type for the `SelectionSet`.
  ///
  /// This may be a concrete type (`ConcreteType`) or an abstract type (`Interface`).
  static var __type: SelectionSetType { get }
}

extension SelectionSet {

  var __concreteType: Schema.ConcreteType { Schema.ConcreteType(rawValue: __typename) ?? ._unknown }

  var __typename: String { data["__typename"] }

  func asType<T: SelectionSet>() -> T? {
    guard let __concreteType = __concreteType, __concreteType != ._unknown else { return nil } // TODO: Unit Test
    switch T.__type {
    case .ConcreteType(let type):
      guard __concreteType == type else { return nil } // TODO: Unit Test
    case .Interface(let interface):
      guard __concreteType.implements(interface) else { return nil } // TODO: Unit Test
    }

    return T.init(data: data)
  }
}

extension DataContainer {
  func toFragment<T: SelectionSet>() -> T {
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
