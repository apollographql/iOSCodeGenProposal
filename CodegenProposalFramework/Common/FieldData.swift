//
//  FieldData.swift
//  CodegenProposalFramework
//
//  Created by Anthony Miller on 2/17/21.
//

import Foundation

// TODO: Docs
struct FieldData<Fields, TypeCaseFields> { // TODO: One generic param for ResponseObject type? Try this again after making base classes!
  let fields: Fields
  let typeCaseFields: TypeCaseFields
}

extension FieldData where TypeCaseFields == Void {
  init(fields: Fields) {
    self.init(fields: fields, typeCaseFields: ())
  }
}
