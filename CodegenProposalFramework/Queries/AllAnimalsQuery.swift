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

// TODO: Fragment with nested type case
// TODO: Figure out access control on everything

// MARK: - Query Response Data Structs

public final class Animal: ResponseData, HasFragments {
  final class Fields {
    let __typename: String
    let species: String
    let height: Height
    let predators: [Predators]

    init(__typename: String, species: String, height: Animal.Height, predators: [Predators]) {
      self.__typename = __typename
      self.species = species
      self.height = height
      self.predators = predators
    }
  }

  final class TypeCaseFields {
    let asPet: (AsPet.Fields, AsPet.TypeCaseFields)?
    let asWarmBlooded: AsWarmBlooded.Fields?

    init(
      asPet: (AsPet.Fields, AsPet.TypeCaseFields)? = nil,
      asWarmBlooded: AsWarmBlooded.Fields? = nil
    ) {
      self.asPet = asPet
      self.asWarmBlooded = asWarmBlooded
    }
  }

  let fields: Fields
  private let typeCaseFields: TypeCaseFields

  @AsType var asPet: AsPet?

  @AsType var asWarmBlooded: AsWarmBlooded?

  private(set) lazy var fragments = Fragments(parent: (), fields: fields)

  final class Fragments: ToFragments<Void, Fields> {
    private(set) lazy var heightInMeters = HeightInMeters(height: .init(meters: fields.height.meters))
  }

  // TODO: spread type case fields into initializers
  init(
    __typename: String,
    species: String,
    height: Height,
    predators: [Predators],
    typeCaseFields: TypeCaseFields = .init(
      asPet: nil, asWarmBlooded: nil
    )
  ) {
    self.fields = Fields(
      __typename: __typename,
      species: species,
      height: height,
      predators: predators
    )
    self.typeCaseFields = typeCaseFields

    self._asPet = .init(
      parent: self,
      fields: typeCaseFields.asPet?.0,
      typeCaseFields: typeCaseFields.asPet?.1
    )

    self._asWarmBlooded = .init(
      parent: self,
      fields: typeCaseFields.asWarmBlooded
    )
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
      let meters: Int // - NOTE:
                      // This field is merged in from `HeightInMeters` fragment.
                      // Because the fragment type identically matches the type it is queried on, we do
                      // not need an optional `TypeCase` and can merge the field up.
                      // TODO: We might be able to create something like `FieldJoiner` to make this cleaner?

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

  // - NOTE:
  // Because the type case for `WarmBlooded` only includes the fragment, we can just inherit the fragment type case.
  //
  // For a type case that fetches a fragment in addition to other fields, we would use a custom `TypeCase`
  // with the fragment type case nested inside. See `Predators.AsWarmBlooded` for an example of this.
  /// `Animal.AsWarmBlooded`
  final class AsWarmBlooded: AsWarmBloodedDetails<Animal> {
    final class Height: FieldJoiner<Animal.Height, WarmBloodedDetails.Height> {
      var meters: Int { first.meters }
    }

    let height: Height

    required init(
      parent: Animal,
      fields: Fields,
      typeCaseFields: Void = ()
    ) {
      self.height = .init(first: parent.height, second: fields.height)
      super.init(parent: parent, fields: fields)
    }
  }

  /// `Animal.Predators`
  final class Predators: ResponseData {
    final class Fields {
      let __typename: String
      let species: String

      init(__typename: String, species: String) {
        self.__typename = __typename
        self.species = species
      }
    }

    let fields: Fields
    private let typeCaseFields: TypeCaseFields

    final class TypeCaseFields {
      let asWarmBlooded: AsWarmBlooded.Fields?

      init(asWarmBlooded: AsWarmBlooded.Fields? = nil) {
        self.asWarmBlooded = asWarmBlooded
      }
    }

    @AsType var asWarmBlooded: AsWarmBlooded?

    init(
      __typename: String,
      species: String,
      typeCaseFields: TypeCaseFields = .init(asWarmBlooded: nil)
    ) {
      self.fields = Fields(
        __typename: __typename,
        species: species
      )
      self.typeCaseFields = typeCaseFields

      self._asWarmBlooded = .init(parent: self, fields: typeCaseFields.asWarmBlooded)
    }

    subscript<T>(dynamicMember keyPath: KeyPath<Fields, T>) -> T {
      fields[keyPath: keyPath]
    }

    /// `AllAnimals.Predators.AsWarmBlooded`
    final class AsWarmBlooded: TypeCase, HasFragments {
      final class Fields {
        let bodyTemperature: Int
        let height: WarmBloodedDetails.Height // - NOTE:
                                              // These 2 fields are merged in from `WarmBloodedDetails` fragment.
                                              // Because the fragment type identically matches the type it is queried on, we do
                                              // not need an optional `TypeCase` and can merge the fields up.
                                              // TODO: We might be able to create something like `FieldJoiner` to make this cleaner?
        let hasFur: Bool

        init(
          bodyTemperature: Int,
          height: WarmBloodedDetails.Height,
          hasFur: Bool
        ) {
          self.bodyTemperature = bodyTemperature
          self.height = height
          self.hasFur = hasFur
        }
      }

      let fields: Fields
      let parent: Animal.Predators

      private(set) lazy var fragments = Fragments(parent: parent, fields: fields)

      init(parent: Animal.Predators, fields: Fields, typeCaseFields: Void = ()) {
        self.parent = parent
        self.fields = fields
      }

      final class Fragments: ToFragments<Animal.Predators, Fields> {
        private(set) lazy var warmBloodedDetails = WarmBloodedDetails(
          fields: .init(
            bodyTemperature: fields.bodyTemperature,
            height: fields.height
          ))
      }

      subscript<T>(dynamicMember keyPath: KeyPath<Fields, T>) -> T {
        fields[keyPath: keyPath]
      }

      subscript<T>(dynamicMember keyPath: KeyPath<Parent.Fields, T>) -> T {
        parent.fields[keyPath: keyPath]
      }
    }
  }
  
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

    final class TypeCaseFields {
      let asWarmBlooded: AsWarmBlooded.Fields?

      init(asWarmBlooded: AsWarmBlooded.Fields? = nil) {
        self.asWarmBlooded = asWarmBlooded
      }
    }

    let fields: Fields
    let parent: Animal
    private let typeCaseFields: TypeCaseFields

    @AsType var asWarmBlooded: AsWarmBlooded?

    private(set) lazy var fragments = Fragments(parent: parent, fields: fields)

    final class Fragments: ToFragments<Animal, Fields> {
      private(set) lazy var petDetails = PetDetails(
        fields: .init(
          humanName: fields.humanName,
          favoriteToy: fields.favoriteToy
        ))
    }

    convenience init(
      humanName: String = "",
      favoriteToy: String,
      parent: Animal
    ) {
      let fields = Fields(humanName: humanName, favoriteToy: favoriteToy)
      self.init(parent: parent, fields: fields)
    }

    init(
      parent: Animal,
      fields: Fields,
      typeCaseFields: TypeCaseFields = .init(asWarmBlooded: nil)
    ) {
      self.parent = parent
      self.fields = fields
      self.typeCaseFields = typeCaseFields

      self._asWarmBlooded = .init(parent: self, fields: typeCaseFields.asWarmBlooded)
    }

    subscript<T>(dynamicMember keyPath: KeyPath<Fields, T>) -> T {
      return fields[keyPath: keyPath]
    }

    subscript<T>(dynamicMember keyPath: KeyPath<Animal.Fields, T>) -> T {
      parent.fields[keyPath: keyPath]
    }

    final class AsWarmBlooded: AsWarmBloodedDetails<Animal.AsPet> {
      final class Height: FieldJoiner<Animal.Height, WarmBloodedDetails.Height> {
        var meters: Int { first.meters }
      }

      let height: Height

      required init(
        parent: Animal.AsPet,
        fields: Fields,
        typeCaseFields: Void = ()
      ) {
        self.height = .init(first: parent.height, second: fields.height)
        super.init(parent: parent, fields: fields)
      }

      subscript<T>(dynamicMember keyPath: KeyPath<Animal.Fields, T>) -> T {
        parent.parent.fields[keyPath: keyPath]
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
    self._asPet = AsType(
      parent: self,
      fields: asPetFields,
      typeCaseFields: .init(asWarmBlooded: nil)
    )
    return self.asPet!
  }

  func makeAsWarmBlooded(
    bodyTemperature: Int,
    height: WarmBloodedDetails.Height
  ) -> Animal.AsWarmBlooded {
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
  ) -> Animal.AsPet.AsWarmBlooded {
    let asWarmBloodedFields = AsWarmBloodedDetails<Animal.AsPet>.Fields(
      bodyTemperature: bodyTemperature,
      height: height
    )
    self._asWarmBlooded = AsType(parent: self, fields: asWarmBloodedFields)
    return self.asWarmBlooded!
  }

}
