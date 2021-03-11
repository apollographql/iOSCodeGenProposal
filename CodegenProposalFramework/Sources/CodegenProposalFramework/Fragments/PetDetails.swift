//
//  PetDetails.swift
//  CodegenProposalFramework
//
//  Created by Anthony Miller on 2/16/21.
//

import Foundation

/// A response data object for a `PetDetails` fragment
///
/// ```
/// fragment PetDetails on Pet {
///  humanName
///  favoriteToy
/// }
/// ```
struct PetDetails: SelectionSet, Fragment {
  let data: ResponseData

  var humanName: String { data["humanName"] }
  var favoriteToy: String { data["favoriteToy"] }
}
