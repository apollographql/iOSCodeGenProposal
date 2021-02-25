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
final class PetDetails: ResponseObjectBase<PetDetails.Fields, Void>, Fragment {
  final class Fields {
    let humanName: String
    let favoriteToy: String

    init(humanName: String, favoriteToy: String) {
      self.humanName = humanName
      self.favoriteToy = favoriteToy
    }
  }

  convenience init(humanName: String, favoriteToy: String) {
    self.init(fields: Fields(humanName: humanName, favoriteToy: favoriteToy))
  }
}

/// A generic type condition for a `PetDetails` fragment.
///
/// ```
/// fragment PetDetails on Pet {
///  humanName
///  favoriteToy
/// }
/// ```
class AsPetDetails<Parent: ResponseObject>: FragmentTypeConditionBase<PetDetails, Parent> {
  final class Fragments: ToFragments<Parent, ResponseData> {
    private(set) lazy var petDetails = PetDetails(data: self.data)
  }
}
