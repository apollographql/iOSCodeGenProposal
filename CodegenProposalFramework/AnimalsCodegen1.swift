import Foundation
// query {
//   allAnimals {
//     height {
//       feet
//       inches
//     }
//     ...HeightInMeters
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
//   } // TODO: use HeightInMeters fragment?
// }
//
// fragment HeightInMeters on Animal {
//   height {
//     meters
//   }
// }

// MARK: Protocols

protocol ResponseData: AnyObject {
  associatedtype Props

  var props: Props { get }
}

protocol TypeCase: ResponseData {
  associatedtype Parent: ResponseData

  init(parent: Parent, props: Props)

  var parent: Parent { get }
}

protocol FragmentTypeCase: TypeCase {
  associatedtype FragmentType: Fragment
  associatedtype Props = FragmentType.Props

  func toFragment() -> FragmentType
}

protocol Fragment: ResponseData {

}

// MARK: Fragments

final class PetDetails: Fragment {
  final class Props {
    let humanName: String
    let favoriteToy: String

    init(humanName: String, favoriteToy: String) {
      self.humanName = humanName
      self.favoriteToy = favoriteToy
    }
  }

  let props: Props

  init(props: Props) {
    self.props = props
  }
}

final class AsPetDetails<Parent: ResponseData>: FragmentTypeCase {
  let props: Props
  let parent: Parent

  init(parent: Parent, props: Props) {
    self.parent = parent
    self.props = props
  }

  func toFragment() -> PetDetails {
    PetDetails(props: self.props)
  }
}

final class WarmBloodedDetails: Fragment {
  final class Props {
    let bodyTemperature: Int
    let height: Height

    init(bodyTemperature: Int, height: Height) {
      self.bodyTemperature = bodyTemperature
      self.height = height
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

final class AsWarmBloodedDetails<Parent: ResponseData>: FragmentTypeCase {
  let props: Props
  let parent: Parent

  init(parent: Parent, props: Props) {
    self.parent = parent
    self.props = props
  }

  func toFragment() -> WarmBloodedDetails {
    WarmBloodedDetails(props: self.props)
  }
}

final class HeightInMeters: Fragment {
  final class Props {
    let height: Height

    init(height: Height) {
      self.height = height
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

    let props: Props

    init(props: Props) {
      self.props = props
    }
  }
}

final class AsHeightInMeters<Parent: ResponseData>: FragmentTypeCase {
  let props: Props
  let parent: Parent

  init(parent: Parent, props: Props) {
    self.parent = parent
    self.props = props
  }

  func toFragment() -> HeightInMeters {
    HeightInMeters(props: self.props)
  }
}

// MARK: Query Response Data Structs

public final class Animal: ResponseData {
  final class Props {
    let __typename: String
    let species: String
    let height: Height
//    let predators: [Predators] = [] // TODO

    init(__typename: String, species: String, height: Animal.Height) {
      self.__typename = __typename
      self.species = species
      self.height = height
    }
  }

  let props: Props

  @AsType var asPet: AsPet?

  // Because the type case for `WarmBlooded` only includes the fragment, we can just use the fragment type case.
  // For a type case that fetches a fragment in addition to other fields, we would use a custom `TypeCase`
  // with the fragment type case nested inside. See `Predators.AsWarmBlooded` for an example of this.
  @AsType var asWarmBlooded: AsWarmBloodedDetails<Animal>?

  @FragmentSpread var asHeightInMeters: AsHeightInMeters<Animal>!

  init(__typename: String, species: String, height: Height) {
    self.props = Props(__typename: __typename, species: species, height: height)
    self._asPet = .nil
    self._asWarmBlooded = .nil
    self._asHeightInMeters = .init(parent: self,
                                   props: .init(
                                    height: .init(
                                      props: .init(
                                        meters: height.props.meters
                                      ))))
  }

//  subscript<T>(dynamicMember keyPath: KeyPath<Animal.Props, T>) -> T {
//    return props[keyPath: keyPath]
//  }

//  subscript<T>(dynamicMember keyPath: KeyPath<AsHeightInMeters<AllAnimals>.Props, T>) -> T {
//    return $asHeightInMeters[keyPath: keyPath]
//  }

  /// `Animal.Height`
  final class Height: ResponseData {
    final class Props {
      let __typename: String
      let feet: Int
      let inches: Int
      // This field is merged in from `HeightInMeters` fragment.
      // Because the fragment type identically matches the type it is queried on, we do
      // not need an optional `TypeCase` and can merge the field up.
      let meters: Int // TODO: might remove this if we merge the matched fragment fields upwards?

      init(__typename: String, feet: Int, inches: Int, meters: Int) {
        self.__typename = __typename
        self.feet = feet
        self.inches = inches
        self.meters = meters
      }
    }

    let props: Props

    init(props: Props) {
      self.props = props
    }
  }

  /// `Animal.Predators`
//  final class Predators {
//    final class Props {
//      var __typename: String // Animal
//      var species: String
//    }
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
  
  /// `Animal.AsPet`
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
    let parent: Animal

    // Because the type case for `WarmBlooded` only includes the fragment, we can just use the fragment type case.
    // For a type case that fetches a fragment in addition to other fields, we would use a custom `TypeCase`
    // with the fragment type case nested inside. See `Predators.AsWarmBlooded` for an example of this.
    @AsType var asWarmBlooded: AsWarmBloodedDetails<Animal.AsPet>?

    convenience init(
      humanName: String = "",
      favoriteToy: String,
      parent: Animal
    ) {
      let props = Props(humanName: humanName, favoriteToy: favoriteToy)
      self.init(parent: parent, props: props)
    }

    init(parent: Animal, props: Props) {
      self.parent = parent
      self.props = props
      self._asWarmBlooded = .nil
    }

//    subscript<T>(dynamicMember keyPath: KeyPath<AllAnimals.AsPet.Parent, T>) -> T {
//      parent.value[keyPath: keyPath]
//    }
  }
}

// MARK: - Extensions for creating mock objects
// I am NOT at all happy with this part yet.
//
extension Animal {

  func makeAsPet(humanName: String, favoriteToy: String) -> AsPet {
    let asPetProps = AsPet.Props(humanName: humanName,
                                 favoriteToy: favoriteToy)
    self._asPet = AsType(parent: self, props: asPetProps)
    return self.asPet!
  }

  func makeAsWarmBlooded(
    bodyTemperature: Int,
    height: WarmBloodedDetails.Height
  ) -> AsWarmBloodedDetails<Animal> {
    let asWarmBloodedProps = AsWarmBloodedDetails<Animal>.Props(
      bodyTemperature: bodyTemperature,
      height: height
    )
    self._asWarmBlooded = AsType(parent: self, props: asWarmBloodedProps)
    return self.asWarmBlooded!
  }

}

extension Animal.AsPet {

  func makeAsWarmBlooded(
    bodyTemperature: Int,
    height: WarmBloodedDetails.Height
  ) -> AsWarmBloodedDetails<Animal.AsPet> {
    let asWarmBloodedProps = AsWarmBloodedDetails<Animal.AsPet>.Props(
      bodyTemperature: bodyTemperature,
      height: height
    )
    self._asWarmBlooded = AsType(parent: self, props: asWarmBloodedProps)
    return self.asWarmBlooded!
  }

}
