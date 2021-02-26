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
final class PetDetails: ResponseObjectBase<PetDetails.Fields>, Fragment {
  final class Fields: FieldData {
    @Field("humanName") final var  humanName: String
    @Field("favoriteToy") final var  favoriteToy: String
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
  final class Fragments: BaseClass.Fragments {
    @ToFragment var petDetails: PetDetails
  }
}
