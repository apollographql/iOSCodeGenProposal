//
//  FieldData.swift
//  CodegenProposalFramework
//
//  Created by Anthony Miller on 2/17/21.
//

import Foundation

/// An object that stores the raw data objects for the `Fields` of a `ResponseObject`
/// and any of its `TypeCases`.
final class FieldData<Fields, TypeCaseFields> { // TODO: One generic param for ResponseObject type? Try this again after making base classes!
  /// An object that stores the GraphQL fields fetched and stored directly on this object.
  let fields: Fields

  /// An object that stores the `TypeCase`s that the object may be and their fields.
  let typeCaseFields: TypeCaseFields

  init(fields: Fields, typeCaseFields: TypeCaseFields) {
    self.fields = fields
    self.typeCaseFields = typeCaseFields
  }
}

extension FieldData where TypeCaseFields == Void {
  convenience init(fields: Fields) {
    self.init(fields: fields, typeCaseFields: ())
  }
}

