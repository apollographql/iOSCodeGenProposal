//
//  FieldData.swift
//  CodegenProposalFramework
//
//  Created by Anthony Miller on 2/17/21.
//

import Foundation

/// An object that stores the raw data objects for the `Fields` of a `ResponseObject`
/// and any of its `TypeConditions`.
final class FieldData<Fields, TypeConditionFields> { // TODO: One generic param for ResponseObject type? Try this again after making base classes!
  /// An object that stores the GraphQL fields fetched and stored directly on this object.
  let fields: Fields

  /// An object that stores the `TypeCondition`s that the object may be and their fields.
  let typeConditionFields: TypeConditionFields

  init(fields: Fields, typeConditionFields: TypeConditionFields) {
    self.fields = fields
    self.typeConditionFields = typeConditionFields
  }
}

extension FieldData where TypeConditionFields == Void {
  convenience init(fields: Fields) {
    self.init(fields: fields, typeConditionFields: ())
  }
}

