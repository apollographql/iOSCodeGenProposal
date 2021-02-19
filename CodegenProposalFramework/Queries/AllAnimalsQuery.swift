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

final class Animal: ResponseObjectBase<Animal.Fields, Animal.TypeCases>, HasFragments {
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

  final class TypeCases: TypeCasesBase<Animal> {
    @AsType var asPet: AsPet?
    @AsType var asWarmBlooded: AsWarmBlooded?

    init(
      asPet: AsPet.ResponseData? = nil,
      asWarmBlooded: AsWarmBlooded.ResponseData? = nil
    ) {
      super.init()
      self._asPet = AsType(parent: parent, data: asPet)
      self._asWarmBlooded = AsType(parent: parent, data: asWarmBlooded)
    }
  }

  final class Fragments: ToFragments<Void, ResponseData> {
    private(set) lazy var heightInMeters = HeightInMeters(height: .init(meters: data.fields.height.meters))
  }

  private(set) lazy var fragments = Fragments(parent: (), data: data)

  // TODO: spread type case fields into initializers?
  convenience init(
    __typename: String,
    species: String,
    height: Height,
    predators: [Predators],
    asPet: AsPet.ResponseData? = nil,
    asWarmBlooded: AsWarmBlooded.ResponseData? = nil
  ) {
    let data = ResponseData(
      fields: Fields(
        __typename: __typename,
        species: species,
        height: height,
        predators: predators
      ),
      typeCaseFields: TypeCases(
        asPet: asPet,
        asWarmBlooded: asWarmBlooded
      ))

    self.init(data: data)
  }

  /// `Animal.Height`
  final class Height: ResponseObjectBase<Height.Fields, Void> {
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

    final class TypeCases: TypeCasesBase<AsPet> {
      @AsType var asWarmBlooded: AsWarmBlooded?

      init(asWarmBlooded: AsWarmBlooded.ResponseData? = nil) {
        super.init()
        self._asWarmBlooded = AsType(parent: parent, data: asWarmBlooded)
      }
    }

    let data: FieldData<Fields, TypeCases>
    let parent: Animal


    private(set) lazy var fragments = Fragments(parent: parent, data: data)

    final class Fragments: ToFragments<Animal, ResponseData> {
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

    init(parent: Animal, data: ResponseData) {
      self.parent = parent
      self.data = data

      self.data.typeCaseFields.parent.value = self
    }

    subscript<T>(dynamicMember keyPath: KeyPath<Fields, T>) -> T {
      return data.fields[keyPath: keyPath]
    }

    subscript<T>(dynamicMember keyPath: KeyPath<TypeCases, T>) -> T {
      return data.typeCaseFields[keyPath: keyPath]
    }

    subscript<T>(dynamicMember keyPath: KeyPath<Animal.Fields, T>) -> T {
      parent.data.fields[keyPath: keyPath]
    }

    /// `Animal.AsPet.AsWarmBlooded`
    final class AsWarmBlooded: AsWarmBloodedDetails<Animal.AsPet> {
      final class Height: FieldJoiner<Animal.Height, WarmBloodedDetails.Height> {
        var meters: Int { first.meters }
      }

      let height: Height

      required init(parent: Animal.AsPet, data: ResponseData) {
        self.height = .init(first: parent.height, second: data.fields.height)
        super.init(parent: parent, data: data)
      }

      subscript<T>(dynamicMember keyPath: KeyPath<Animal.Fields, T>) -> T {
        // TODO: Could we use FieldJoiners so we don't have to create additional subscripts for each
        // level of nested type cases?
        parent.parent.data.fields[keyPath: keyPath]
      }
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
      data: FieldData<WarmBloodedDetails.Fields, Void>
    ) {
      self.height = .init(first: parent.height, second: data.fields.height)
      super.init(parent: parent, data: data)
    }
  }

  /// `Animal.Predators`
  final class Predators: ResponseObjectBase<Predators.Fields, Predators.TypeCases> {
    final class Fields {
      let __typename: String
      let species: String

      init(__typename: String, species: String) {
        self.__typename = __typename
        self.species = species
      }
    }

    final class TypeCases: TypeCasesBase<Predators> {
      @AsType var asWarmBlooded: AsWarmBlooded?

      init(asWarmBlooded: AsWarmBlooded.ResponseData? = nil) {
        super.init()
        self._asWarmBlooded = AsType(parent: parent, data: asWarmBlooded)
      }
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

      let data: FieldData<Fields, Void>
      let parent: Animal.Predators

      private(set) lazy var fragments = Fragments(parent: parent, data: data)

      init(parent: Animal.Predators, data: FieldData<Fields, Void>) {
        self.parent = parent
        self.data = data
      }

      final class Fragments: ToFragments<Animal.Predators, ResponseData> {
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
}
