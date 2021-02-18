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

public final class Animal: RootResponseObject, HasFragments {
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
    let asPet: AsPet.FieldData?
    let asWarmBlooded: AsWarmBlooded.FieldData?

    init(
      asPet: AsPet.FieldData? = nil,
      asWarmBlooded: AsWarmBlooded.FieldData? = nil
    ) {
      self.asPet = asPet
      self.asWarmBlooded = asWarmBlooded
    }
  }

  let data: FieldData

  @AsType var asPet: AsPet?

  @AsType var asWarmBlooded: AsWarmBlooded?

  private(set) lazy var fragments = Fragments(parent: (), data: data)

  final class Fragments: ToFragments<Void, FieldData> {
    private(set) lazy var heightInMeters = HeightInMeters(height: .init(meters: data.fields.height.meters))
  }

  // TODO: spread type case fields into initializers
  convenience init(
    __typename: String,
    species: String,
    height: Height,
    predators: [Predators],
    typeCaseFields: TypeCaseFields = .init(
      asPet: nil, asWarmBlooded: nil
    )
  ) {
    let data = ResponseDataFields(
      fields: Fields(
        __typename: __typename,
        species: species,
        height: height,
        predators: predators
      ),
      typeCaseFields: typeCaseFields
    )

    self.init(data: data)
  }

  init(data: FieldData) {
    self.data = data
    self._asPet = .init(parent: self, dataPath: \Self.data.typeCaseFields.asPet)
    self._asWarmBlooded = .init(parent: self, dataPath: \Self.data.typeCaseFields.asWarmBlooded)
  }

  subscript<T>(dynamicMember keyPath: KeyPath<Fields, T>) -> T {
    return data.fields[keyPath: keyPath]
  }

  /// `Animal.Height`
  final class Height: RootResponseObject {
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

    let data: ResponseDataFields<Fields, Void>

    init(data: FieldData) {
      self.data = data
    }

    subscript<T>(dynamicMember keyPath: KeyPath<Fields, T>) -> T {
      return data.fields[keyPath: keyPath]
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
      data: FieldData
    ) {
      self.height = .init(first: parent.height, second: data.fields.height)
      super.init(parent: parent, data: data)
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

    final class TypeCaseFields {
      let asWarmBlooded: AsWarmBlooded.FieldData?

      init(asWarmBlooded: AsWarmBlooded.FieldData? = nil) {
        self.asWarmBlooded = asWarmBlooded
      }
    }

    let data: FieldData

    @AsType var asWarmBlooded: AsWarmBlooded?

    init(
      __typename: String,
      species: String,
      typeCaseFields: TypeCaseFields = .init(asWarmBlooded: nil)
    ) {
      self.data = .init(
        fields: Fields(
          __typename: __typename,
          species: species
        ),
        typeCaseFields: typeCaseFields
      )

      self._asWarmBlooded = .init(parent: self, dataPath: \Self.data.typeCaseFields.asWarmBlooded)
    }

    subscript<T>(dynamicMember keyPath: KeyPath<Fields, T>) -> T {
      data.fields[keyPath: keyPath]
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

      let data: ResponseDataFields<Fields, Void>
      let parent: Animal.Predators

      private(set) lazy var fragments = Fragments(parent: parent, data: data)

      init(parent: Animal.Predators, data: FieldData) {
        self.parent = parent
        self.data = data
      }

      final class Fragments: ToFragments<Animal.Predators, FieldData> {
        private(set) lazy var warmBloodedDetails = WarmBloodedDetails(
          data: .init(
            fields: .init(
              bodyTemperature: data.fields.bodyTemperature,
              height: data.fields.height
            )))
      }

      subscript<T>(dynamicMember keyPath: KeyPath<Fields, T>) -> T {
        data.fields[keyPath: keyPath]
      }

      subscript<T>(dynamicMember keyPath: KeyPath<Parent.Fields, T>) -> T {
        parent.data.fields[keyPath: keyPath]
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
      let asWarmBlooded: AsWarmBlooded.FieldData?

      init(asWarmBlooded: AsWarmBlooded.FieldData? = nil) {
        self.asWarmBlooded = asWarmBlooded
      }
    }

    let data: FieldData
    let parent: Animal

    @AsType var asWarmBlooded: AsWarmBlooded?

    private(set) lazy var fragments = Fragments(parent: parent, data: data)

    final class Fragments: ToFragments<Animal, FieldData> {
      private(set) lazy var petDetails = PetDetails(
        data: .init(
          fields: .init(
            humanName: data.fields.humanName,
            favoriteToy: data.fields.favoriteToy
          )))
    }

    convenience init(
      humanName: String = "",
      favoriteToy: String,
      parent: Animal
    ) {
      let fields = Fields(humanName: humanName, favoriteToy: favoriteToy)
      self.init(parent: parent, data: .init(fields: fields, typeCaseFields: .init())) // TODO: Type Case Fields
    }

    init(parent: Animal, data: FieldData) {
      self.parent = parent
      self.data = data

      self._asWarmBlooded = .init(parent: self, dataPath: \Self.data.typeCaseFields.asWarmBlooded)
    }

    subscript<T>(dynamicMember keyPath: KeyPath<Fields, T>) -> T {
      return data.fields[keyPath: keyPath]
    }

    subscript<T>(dynamicMember keyPath: KeyPath<Animal.Fields, T>) -> T {
      parent.data.fields[keyPath: keyPath]
    }

    final class AsWarmBlooded: AsWarmBloodedDetails<Animal.AsPet> {
      final class Height: FieldJoiner<Animal.Height, WarmBloodedDetails.Height> {
        var meters: Int { first.meters }
      }

      let height: Height

      required init(parent: Animal.AsPet, data: FieldData) {
        self.height = .init(first: parent.height, second: data.fields.height)
        super.init(parent: parent, data: data)
      }

      subscript<T>(dynamicMember keyPath: KeyPath<Animal.Fields, T>) -> T {
        parent.parent.data.fields[keyPath: keyPath]
      }
    }
  }
}

// MARK: - Extensions for creating mock objects
// I am NOT at all happy with this part yet.

extension Animal {

  func makeAsPet(humanName: String, favoriteToy: String) -> AsPet {
    let asPetFields = AsPet.Fields(humanName: humanName,
                                 favoriteToy: favoriteToy)
    self._asPet = AsType(
      parent: self,
      data: .init(
        fields: asPetFields,
        typeCaseFields: .init(asWarmBlooded: nil)
      ))
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
    self._asWarmBlooded = AsType(
      parent: self,
      data: .init(fields: asWarmBloodedFields)
    )
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
    self._asWarmBlooded = AsType(
      parent: self,
      data: .init(fields: asWarmBloodedFields)
    )
    return self.asWarmBlooded!
  }

}
