//
//  FieldData.swift
//  CodegenProposalFramework
//
//  Created by Anthony Miller on 2/17/21.
//

import Foundation

// TODO: Docs
final class FieldData<Fields, TypeCaseFields> { // TODO: One generic param for ResponseObject type? Try this again after making base classes!
  let fields: Fields
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

