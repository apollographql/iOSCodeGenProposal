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

@dynamicMemberLookup
class ToFragments<Parent, Fields> {
  let parent: Parent
  let fields: Fields

  internal init(parent: Parent, fields: Fields) {
    self.parent = parent
    self.fields = fields
  }
}

extension ToFragments where Parent: HasFragments {
  subscript<T>(dynamicMember keyPath: KeyPath<Parent.Fragments, T>) -> T {
    return parent.fragments[keyPath: keyPath]
  }
}

// MARK: Fragments

final class PetDetails: Fragment {
  final class Fields {
    let humanName: String
    let favoriteToy: String

    init(humanName: String, favoriteToy: String) {
      self.humanName = humanName
      self.favoriteToy = favoriteToy
    }
  }

  let fields: Fields

  init(fields: Fields) {
    self.fields = fields
  }

  subscript<T>(dynamicMember keyPath: KeyPath<Fields, T>) -> T {
    return fields[keyPath: keyPath]
  }
}

final class AsPetDetails<Parent: ResponseData>: FragmentTypeCase {
  typealias FragmentType = PetDetails

  let fields: Fields
  let parent: Parent
  private(set) lazy var fragments = Fragments(parent: parent, fields: fields)

  init(parent: Parent, fields: Fields) {
    self.parent = parent
    self.fields = fields
  }

  final class Fragments: ToFragments<Parent, Fields> {
    private(set) lazy var petDetails = PetDetails(fields: self.fields)
  }

  subscript<T>(dynamicMember keyPath: KeyPath<Fields, T>) -> T {
    return fields[keyPath: keyPath]
  }

  subscript<T>(dynamicMember keyPath: KeyPath<Parent.Fields, T>) -> T {
    return parent.fields[keyPath: keyPath]
  }
}

final class WarmBloodedDetails: Fragment {
  final class Fields {
    let bodyTemperature: Int
    let height: Height

    init(bodyTemperature: Int, height: Height) {
      self.bodyTemperature = bodyTemperature
      self.height = height
    }
  }

  let fields: Fields

  init(fields: Fields) {
    self.fields = fields
  }

  final class Height: ResponseData {
    final class Fields {
      let meters: Int
      let yards: Int

      init(meters: Int, yards: Int) {
        self.meters = meters
        self.yards = yards
      }
    }

    let fields: Fields

    init(fields: Fields) {
      self.fields = fields
    }

    subscript<T>(dynamicMember keyPath: KeyPath<Fields, T>) -> T {
      return fields[keyPath: keyPath]
    }
  }

  subscript<T>(dynamicMember keyPath: KeyPath<Fields, T>) -> T {
    return fields[keyPath: keyPath]
  }
}

class AsWarmBloodedDetails<Parent: ResponseData>: FragmentTypeCase {
  typealias FragmentType = WarmBloodedDetails

  let fields: Fields
  let parent: Parent
  private(set) lazy var fragments = Fragments(parent: parent, fields: fields)

  required init(parent: Parent, fields: Fields) {
    self.parent = parent
    self.fields = fields
  }

  final class Fragments: ToFragments<Parent, Fields> {
    private(set) lazy var warmBloodedDetails = WarmBloodedDetails(fields: self.fields)
  }

  subscript<T>(dynamicMember keyPath: KeyPath<Fields, T>) -> T {
    return fields[keyPath: keyPath]
  }

  subscript<T>(dynamicMember keyPath: KeyPath<Parent.Fields, T>) -> T {
    return parent.fields[keyPath: keyPath]
  }
}

final class HeightInMeters: Fragment {
  final class Fields {
    let height: Height

    init(height: Height) {
      self.height = height
    }
  }

  let fields: Fields

  init(fields: Fields) {
    self.fields = fields
  }

  init(height: Height) {
    self.fields = Fields(height: height)
  }

  final class Height: ResponseData {
    final class Fields {
      let meters: Int

      init(meters: Int) {
        self.meters = meters
      }
    }

    let fields: Fields

    init(fields: Fields) {
      self.fields = fields
    }

    init(meters: Int) {
      self.fields = Fields(meters: meters)
    }

    subscript<T>(dynamicMember keyPath: KeyPath<Fields, T>) -> T {
      return fields[keyPath: keyPath]
    }
  }

  subscript<T>(dynamicMember keyPath: KeyPath<Fields, T>) -> T {
    return fields[keyPath: keyPath]
  }
}

final class AsHeightInMeters<Parent: ResponseData>: FragmentTypeCase {
  typealias FragmentType = HeightInMeters

  let fields: Fields
  let parent: Parent
  private(set) lazy var fragments = Fragments(parent: parent, fields: fields)

  init(parent: Parent, fields: Fields) {
    self.parent = parent
    self.fields = fields
  }

  @dynamicMemberLookup
  final class Fragments: ToFragments<Parent, Fields> {
    private(set) lazy var heightInMeters = HeightInMeters(fields: self.fields)
  }

  subscript<T>(dynamicMember keyPath: KeyPath<Fields, T>) -> T {
    return fields[keyPath: keyPath]
  }

  subscript<T>(dynamicMember keyPath: KeyPath<Parent.Fields, T>) -> T {
    return parent.fields[keyPath: keyPath]
  }
}

// MARK: - Query Response Data Structs

public final class Animal: ResponseData, HasFragments {
  final class Fields {
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

  let fields: Fields

  @AsType var asPet: AsPet?

  @AsType var asWarmBlooded: AsWarmBlooded?

  private(set) var fragments: Fragments

  final class Fragments: ToFragments<Void, Fields> {
    private(set) lazy var heightInMeters = HeightInMeters(height: .init(meters: fields.height.meters))
  }

  init(__typename: String, species: String, height: Height) {
    self.fields = Fields(__typename: __typename, species: species, height: height)
    self.fragments = Fragments(parent: (), fields: fields)
    self._asPet = .nil
    self._asWarmBlooded = .nil
  }

  subscript<T>(dynamicMember keyPath: KeyPath<Fields, T>) -> T {
    return fields[keyPath: keyPath]
  }

  /// `Animal.Height`
  final class Height: ResponseData {
    final class Fields {
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

    let fields: Fields

    init(fields: Fields) {
      self.fields = fields
    }

    subscript<T>(dynamicMember keyPath: KeyPath<Fields, T>) -> T {
      return fields[keyPath: keyPath]
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

    required init(parent: Animal, fields: AsWarmBloodedDetails<Animal>.Fields) {
      self.height = .init(first: parent.height, second: fields.height)
      super.init(parent: parent, fields: fields)
    }
  }

  /// `Animal.Predators`
//  final class Predators {
//    final class Fields {
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
    final class Fields {
      let humanName: String
      let favoriteToy: String

      init(humanName: String, favoriteToy: String) {
        self.humanName = humanName
        self.favoriteToy = favoriteToy
      }
    }

    let fields: Fields
    let parent: Animal
    private(set) lazy var fragments = Fragments(parent: parent, fields: fields)

    final class Fragments: ToFragments<Animal, Fields> {
      private(set) lazy var petDetails = PetDetails(fields: .init(humanName: fields.humanName, favoriteToy: fields.favoriteToy))
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
      let fields = Fields(humanName: humanName, favoriteToy: favoriteToy)
      self.init(parent: parent, fields: fields)
    }

    init(parent: Animal, fields: Fields) {
      self.parent = parent
      self.fields = fields
      self._asWarmBlooded = .nil
    }

    subscript<T>(dynamicMember keyPath: KeyPath<Fields, T>) -> T {
      return fields[keyPath: keyPath]
    }

    subscript<T>(dynamicMember keyPath: KeyPath<Parent.Fields, T>) -> T {
      parent.fields[keyPath: keyPath]
    }

    final class AsWarmBlooded: AsWarmBloodedDetails<Animal.AsPet> {
      final class Height: FieldJoiner<Animal.Height, WarmBloodedDetails.Height> {
        var meters: Int { first.meters }
      }

      let height: Height

      required init(parent: Animal.AsPet, fields: AsWarmBloodedDetails<Animal.AsPet>.Fields) {
        self.height = .init(first: parent.height, second: fields.height)
        super.init(parent: parent, fields: fields)
      }
    }
  }
}

// MARK: - Extensions for creating mock objects
// I am NOT at all happy with this part yet.
//
extension Animal {

  func makeAsPet(humanName: String, favoriteToy: String) -> AsPet {
    let asPetFields = AsPet.Fields(humanName: humanName,
                                 favoriteToy: favoriteToy)
    self._asPet = AsType(parent: self, fields: asPetFields)
    return self.asPet!
  }

  func makeAsWarmBlooded(
    bodyTemperature: Int,
    height: WarmBloodedDetails.Height
  ) -> AsWarmBloodedDetails<Animal> {
    let asWarmBloodedFields = AsWarmBloodedDetails<Animal>.Fields(
      bodyTemperature: bodyTemperature,
      height: height
    )
    self._asWarmBlooded = AsType(parent: self, fields: asWarmBloodedFields)
    return self.asWarmBlooded!
  }

}

extension Animal.AsPet {

  func makeAsWarmBlooded(
    bodyTemperature: Int,
    height: WarmBloodedDetails.Height
  ) -> AsWarmBloodedDetails<Animal.AsPet> {
    let asWarmBloodedFields = AsWarmBloodedDetails<Animal.AsPet>.Fields(
      bodyTemperature: bodyTemperature,
      height: height
    )
    self._asWarmBlooded = AsType(parent: self, fields: asWarmBloodedFields)
    return self.asWarmBlooded!
  }

}