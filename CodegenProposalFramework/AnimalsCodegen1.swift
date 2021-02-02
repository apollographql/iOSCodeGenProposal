import Foundation
// query {
//   allAnimals {
//     height {
//       feet
//       inches
//     }
//     species
//     ... on Pet {
//       ...PetDetails
//       ...WarmBloodedDetails
//     }
//     ...WarmBloodedDetails
//     predators {
//       species
//       ... on WarmBlooded {
//         ...WarmBloodedDetails
//         hasFur
//       }
//     }
//   }
// }
//
// fragment PetDetails on Pet {
//  humanName
//  favoriteToy
// }
//
// fragment WarmBloodedDetails on WarmBlooded {
//   bodyTemperature
//   height {
//     meters
//   }
// }

// MARK: Fragments

public struct PetDetails {
  let humanName: String
  let favoriteToy: String
}

final class AsWarmBloodedDetails<Parent: ResponseData>: FragmentTypeCase {
  let props: Props
  let parent: Parent

  init(parent: Parent, props: Props) {
    self.parent = parent
    self.props = props
  }

  func toFragment() -> WarmBloodedDetails {
    WarmBloodedDetails(props: .init(bodyTemperature: self.props.bodyTemperature))
  }
}

final class WarmBloodedDetails: Fragment {
  final class Props {
    let bodyTemperature: Int

    init(bodyTemperature: Int) {
      self.bodyTemperature = bodyTemperature
    }
  }

  let props: Props

  init(props: Props) {
    self.props = props
  }

  final class Height {
    final class Props {
      let meters: Int

      init(meters: Int) {
        self.meters = meters
      }
    }
  }
}

// MARK: Protocols

protocol ResponseData: AnyObject {
  associatedtype Props

  var props: Props { get }
}

protocol TypeCase: ResponseData {
  associatedtype Parent: ResponseData

  init(parent: Parent, props: Props)
}

protocol FragmentTypeCase: TypeCase {
  associatedtype FragmentType: Fragment
  associatedtype Props = FragmentType.Props

  func toFragment() -> FragmentType
}

protocol Fragment: ResponseData {

}

// MARK: Query Response Data Structs

public final class AllAnimals: ResponseData {
  final class Props {
    let __typename: String
    let species: String
    let height: Height
    //  let predators: [Predators] = [] // TODO

    init(__typename: String, species: String, height: AllAnimals.Height) {
      self.__typename = __typename
      self.species = species
      self.height = height
    }
  }

  let props: Props

  @AsType var asPet: AsPet?

  /// - Note: Because the type case for `WarmBlooded` only includes the fragment, we can just use the fragment type case.
  /// For a type case that fetches a fragment in addition to other fields, we would use a custom `TypeCase`
  /// with the fragment type case nested inside. See `Predators.AsWarmBlooded` for an example of this.
  @AsType var asWarmBlooded: AsWarmBloodedDetails<AllAnimals.AsPet>?

  init(__typename: String, species: String, height: Height) {
    self.props = Props(__typename: __typename, species: species, height: height)
    self._asPet = .nil
    self._asWarmBlooded = .nil
  }

  /// `AllAnimals.Height`
  final class Height: ResponseData {
    final class Props {
      let __typename: String
      let feet: Int
      let inches: Int

      init(__typename: String, feet: Int, inches: Int) {
        self.__typename = __typename
        self.feet = feet
        self.inches = inches
      }
    }

    let props: Props

    init(props: Props) {
      self.props = props
    }
  }

  /// `AllAnimals.Predators`
//  struct Predators {
//    var __typename: String // Animal
//    var species: String
//
//    var asWarmBlooded: AsWarmBlooded?
//
//    /// `AllAnimals.Predators.AsWarmBlooded`
//    @dynamicMemberLookup
//    struct AsWarmBlooded: WarmBloodedDetails, HasParent {
//      var bodyTemperature: Int
//
//      internal let parent: Reference<AllAnimals.Predators>
//
//      subscript<T>(dynamicMember keyPath: KeyPath<Self.Parent, T>) -> T {
//        parent.value[keyPath: keyPath]
//      }
//    }
//  }
  
  /// `AllAnimals.AsPet`
//  @dynamicMemberLookup
  final class AsPet: TypeCase {
    final class Props {
      let humanName: String
      let favoriteToy: String

      init(humanName: String, favoriteToy: String) {
        self.humanName = humanName
        self.favoriteToy = favoriteToy
      }
    }

    let props: Props
    let parent: AllAnimals

    /// - Note: Because the type case for `WarmBlooded` only includes the fragment, we can just use the fragment type case.
    /// For a type case that fetches a fragment in addition to other fields, we would use a custom `TypeCase`
    /// with the fragment type case nested inside. See `Predators.AsWarmBlooded` for an example of this.
    @AsType var asWarmBlooded: AsWarmBloodedDetails<AllAnimals.AsPet>?

    convenience init(
      humanName: String = "",
      favoriteToy: String,
      parent: AllAnimals
    ) {
      let props = Props(humanName: humanName, favoriteToy: favoriteToy)
      self.init(parent: parent, props: props)
    }

    init(parent: AllAnimals, props: Props) {
      self.parent = parent
      self.props = props
      self._asWarmBlooded = .nil
    }

//    subscript<T>(dynamicMember keyPath: KeyPath<AllAnimals.AsPet.Parent, T>) -> T {
//      parent.value[keyPath: keyPath]
//    }
  }

  /// `AllAnimals.AsWarmBlooded`
////    @dynamicMemberLookup
//  final class AsWarmBlooded: TypeCase {
//    final class Props {
//      let bodyTemperature: Int
//
//      internal init(bodyTemperature: Int) {
//        self.bodyTemperature = bodyTemperature
//      }
//    }
//
//    let props: Props
//    let parent: AllAnimals
//
//    init(parent: AllAnimals, props: Props) {
//      self.parent = parent
//      self.props = props
//    }
//
////      subscript<T>(dynamicMember keyPath: KeyPath<Self.Parent, T>) -> T {
////        parent.value[keyPath: keyPath]
////      }
//  }

}

// MARK: - Extensions for creating mock objects
// I am NOT at all happy with this part yet.
//
//extension AllAnimals {
//
//  func makeAsPet(humanName: String, favoriteToy: String) -> AsPet {
//    let asPetProps = AsPet.Props(humanName: humanName,
//                                 favoriteToy: favoriteToy)
//    self._asPet = AsType(parent: self, props: asPetProps)
//    return self.asPet!
//  }
//
//  func makeAsWarmBlooded(bodyTemperature: Int) -> AsWarmBlooded {
//    let asWarmBloodedProps = AsWarmBlooded.Props(bodyTemperature: bodyTemperature)
//    self._asWarmBlooded = AsType(parent: self, props: asWarmBloodedProps)
//    return self.asWarmBlooded!
//  }
//
//}
//
//extension AllAnimals.AsPet {
//
//  func makeAsWarmBlooded(bodyTemperature: Int) -> AsWarmBlooded {
//    let asWarmBloodedProps = AsWarmBlooded.Props(bodyTemperature: bodyTemperature)
//    self._asWarmBlooded = AsType(parent: self, props: asWarmBloodedProps)
//    return self.asWarmBlooded!
//  }
//
//}
