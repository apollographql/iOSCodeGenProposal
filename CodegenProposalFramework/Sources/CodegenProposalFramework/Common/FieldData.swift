//
//  FieldData.swift
//  CodegenProposalFramework
//
//  Created by Anthony Miller on 2/17/21.
//

import Foundation

protocol FieldData: Equatable {

  var data: ResponseData { get }

  init(data: ResponseData)
}

extension FieldData {
  var __typename: String { data["__typename"] }

  func asType<T: FieldData>() -> T? {
//  guard T.possibleTypes.contains(__typename) else { return nil } // TODO: Implement
    return T.init(data: data)
  }

  func toFragment<T: FieldData>() -> T {
    return T.init(data: data)
  }
}

func ==<T: FieldData>(lhs: T, rhs: T) -> Bool {
  return true // TODO: Unit test & implement this
}

struct ResponseData {

  let data: [String: Any]

  subscript<T: ScalarType>(_ key: String) -> T {
    data[key] as! T
  }

  subscript<T: FieldData>(_ key: String) -> T {
    let entityData = data[key] as! [String: Any]
    return T.init(data: ResponseData(data: entityData))
  }

  subscript<T: FieldData>(_ key: String) -> [T] {
    let entityData = data[key] as! [[String: Any]]
    return entityData.map { T.init(data: ResponseData(data: $0)) }
  }
}

protocol ScalarType {}
extension String: ScalarType {}
extension Int: ScalarType {}
extension Bool: ScalarType {}
