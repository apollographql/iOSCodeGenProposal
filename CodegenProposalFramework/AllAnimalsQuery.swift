import Foundation
// query AllAnimals {
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
//     meters // TODO: Use HeightInMeters fragment?
//     yards
//   }
// }
//
// fragment HeightInMeters on Animal {
//   height {
//     meters
//   }
// }

// MARK: Protocols

@dynamicMemberLookup
protocol ResponseData: AnyObject {
  associatedtype Props

  var props: Props { get }

  subscript<T>(dynamicMember keyPath: KeyPath<Props, T>) -> T { get }
}

protocol TypeCase: ResponseData {
  associatedtype Parent: ResponseData

  init(parent: Parent, props: Props)

  var parent: Parent { get }

  subscript<T>(dynamicMember keyPath: KeyPath<Parent.Props, T>) -> T { get }
}

protocol FragmentTypeCase: TypeCase, HasFragments where Fragments: ToFragments<Parent, Props> {
  associatedtype FragmentType: Fragment
  associatedtype Props = FragmentType.Props
}

protocol HasFragments {
  associatedtype Fragments

  var fragments: Fragments { get }
}

protocol Fragment: ResponseData {
  init(props: Props)
}

@dynamicMemberLookup
class ToFragments<Parent, Props> {
  let parent: Parent
  let props: Props

  internal init(parent: Parent, props: Props) {
    self.parent = parent
    self.props = props
  }
}

extension ToFragments where Parent: HasFragments {
  subscript<T>(dynamicMember keyPath: KeyPath<Parent.Fragments, T>) -> T {
    return parent.fragments[keyPath: keyPath]
  }
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

  subscript<T>(dynamicMember keyPath: KeyPath<Props, T>) -> T {
    return props[keyPath: keyPath]
  }
}

final class AsPetDetails<Parent: ResponseData>: FragmentTypeCase {
  typealias FragmentType = PetDetails

  let props: Props
  let parent: Parent
  private(set) lazy var fragments = Fragments(parent: parent, props: props)

  init(parent: Parent, props: Props) {
    self.parent = parent
    self.props = props
  }

  final class Fragments: ToFragments<Parent, Props> {
    private(set) lazy var petDetails = PetDetails(props: self.props)
  }

  subscript<T>(dynamicMember keyPath: KeyPath<Props, T>) -> T {
    return props[keyPath: keyPath]
  }

  subscript<T>(dynamicMember keyPath: KeyPath<Parent.Props, T>) -> T {
    return parent.props[keyPath: keyPath]
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

  final class Height: ResponseData {
    final class Props {
      let meters: Int
      let yards: Int

      init(meters: Int, yards: Int) {
        self.meters = meters
        self.yards = yards
      }
    }

    let props: Props

    init(props: Props) {
      self.props = props
    }

    subscript<T>(dynamicMember keyPath: KeyPath<Props, T>) -> T {
      return props[keyPath: keyPath]
    }
  }

  subscript<T>(dynamicMember keyPath: KeyPath<Props, T>) -> T {
    return props[keyPath: keyPath]
  }
}

class AsWarmBloodedDetails<Parent: ResponseData>: FragmentTypeCase {
  typealias FragmentType = WarmBloodedDetails

  let props: Props
  let parent: Parent
  private(set) lazy var fragments = Fragments(parent: parent, props: props)

  required init(parent: Parent, props: Props) {
    self.parent = parent
    self.props = props
  }

  final class Fragments: ToFragments<Parent, Props> {
    private(set) lazy var warmBloodedDetails = WarmBloodedDetails(props: self.props)
  }

  subscript<T>(dynamicMember keyPath: KeyPath<Props, T>) -> T {
    return props[keyPath: keyPath]
  }

  subscript<T>(dynamicMember keyPath: KeyPath<Parent.Props, T>) -> T {
    return parent.props[keyPath: keyPath]
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

  init(height: Height) {
    self.props = Props(height: height)
  }

  final class Height: ResponseData {
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

    init(meters: Int) {
      self.props = Props(meters: meters)
    }

    subscript<T>(dynamicMember keyPath: KeyPath<Props, T>) -> T {
      return props[keyPath: keyPath]
    }
  }

  subscript<T>(dynamicMember keyPath: KeyPath<Props, T>) -> T {
    return props[keyPath: keyPath]
  }
}

final class AsHeightInMeters<Parent: ResponseData>: FragmentTypeCase {
  typealias FragmentType = HeightInMeters

  let props: Props
  let parent: Parent
  private(set) lazy var fragments = Fragments(parent: parent, props: props)

  init(parent: Parent, props: Props) {
    self.parent = parent
    self.props = props
  }

  @dynamicMemberLookup
  final class Fragments: ToFragments<Parent, Props> {
    private(set) lazy var heightInMeters = HeightInMeters(props: self.props)
  }

  subscript<T>(dynamicMember keyPath: KeyPath<Props, T>) -> T {
    return props[keyPath: keyPath]
  }

  subscript<T>(dynamicMember keyPath: KeyPath<Parent.Props, T>) -> T {
    return parent.props[keyPath: keyPath]
  }
}

// MARK: - Query Response Data Structs

public final class Animal: ResponseData, HasFragments {
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

  @AsType var asWarmBlooded: AsWarmBlooded?

  private(set) var fragments: Fragments

  final class Fragments: ToFragments<Void, Props> {
    private(set) lazy var heightInMeters = HeightInMeters(height: .init(meters: props.height.meters))
  }

  init(__typename: String, species: String, height: Height) {
    self.props = Props(__typename: __typename, species: species, height: height)
    self.fragments = Fragments(parent: (), props: props)
    self._asPet = .nil
    self._asWarmBlooded = .nil
  }

  subscript<T>(dynamicMember keyPath: KeyPath<Props, T>) -> T {
    return props[keyPath: keyPath]
  }

  /// `Animal.Height`
  final class Height: ResponseData {
    final class Props {
      let __typename: String
      let feet: Int
      let inches: Int
      // This field is merged in from `HeightInMeters` fragment.
      // Because the fragment type identically matches the type it is queried on, we do
      // not need an optional `TypeCase` and can merge the field up.
      let meters: Int

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

    subscript<T>(dynamicMember keyPath: KeyPath<Props, T>) -> T {
      return props[keyPath: keyPath]
    }
  }

  // Because the type case for `WarmBlooded` only includes the fragment, we can just inherit the fragment type case.
  // For a type case that fetches a fragment in addition to other fields, we would use a custom `TypeCase`
  // with the fragment type case nested inside. See `Predators.AsWarmBlooded` for an example of this.
  /// `Animal.AsWarmBlooded`
  final class AsWarmBlooded: AsWarmBloodedDetails<Animal> {
    final class Height: FieldJoiner<Animal.Height, WarmBloodedDetails.Height> {
      var meters: Int { first.meters }
    }

    let height: Height

    required init(parent: Animal, props: AsWarmBloodedDetails<Animal>.Props) {
      self.height = .init(first: parent.height, second: props.height)
      super.init(parent: parent, props: props)
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
  final class AsPet: TypeCase, HasFragments {
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
    private(set) lazy var fragments = Fragments(parent: parent, props: props)

    final class Fragments: ToFragments<Animal, Props> {
      private(set) lazy var petDetails = PetDetails(props: .init(humanName: props.humanName, favoriteToy: props.favoriteToy))
    }

    // Because the type case for `WarmBlooded` only includes the fragment, we can just use the fragment type case.
    // For a type case that fetches a fragment in addition to other fields, we would use a custom `TypeCase`
    // with the fragment type case nested inside. See `Predators.AsWarmBlooded` for an example of this.
    @AsType var asWarmBlooded: AsWarmBlooded?

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

    subscript<T>(dynamicMember keyPath: KeyPath<Props, T>) -> T {
      return props[keyPath: keyPath]
    }

    subscript<T>(dynamicMember keyPath: KeyPath<Parent.Props, T>) -> T {
      parent.props[keyPath: keyPath]
    }

    final class AsWarmBlooded: AsWarmBloodedDetails<Animal.AsPet> {
      final class Height: FieldJoiner<Animal.Height, WarmBloodedDetails.Height> {
        var meters: Int { first.meters }
      }

      let height: Height

      required init(parent: Animal.AsPet, props: AsWarmBloodedDetails<Animal.AsPet>.Props) {
        self.height = .init(first: parent.height, second: props.height)
        super.init(parent: parent, props: props)
      }
    }
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
