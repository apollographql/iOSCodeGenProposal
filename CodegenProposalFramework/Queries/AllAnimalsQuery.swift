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

// TODO: Fragment with nested type condition
// TODO: Figure out access control on everything

// MARK: - Query Response Data Structs

final class Animal: RootResponseObjectBase<Animal.Fields, Animal.TypeConditions>, HasFragments {
  class Fields: FieldData {
    @Field("__typename") final var __typename: String
    @Field("species") final var species: String
    @Field("height") final var height: Height
    @Field("predators") final var predators: [Predators]
  }

  final class TypeConditions: TypeConditionsBase<Animal> {
    @AsType var asPet: AsPet?
    @AsType var asWarmBlooded: AsWarmBlooded?
  }

  class Fragments: FieldData {
    @ToFragment var heightInMeters: HeightInMeters
  }

  // TODO: spread type condition fields into initializers?
//  convenience init(
//    __typename: String,
//    species: String,
//    height: Height,
//    predators: [Predators],
//    asPet: AsPet.ResponseData? = nil,
//    asWarmBlooded: AsWarmBlooded.ResponseData? = nil
//  ) {
//    let data = ResponseData(
//      fields: Fields(
//        __typename: __typename,
//        species: species,
//        height: height,
//        predators: predators
//      ),
//      typeConditionFields: TypeConditions(
//        asPet: asPet,
//        asWarmBlooded: asWarmBlooded
//      ))
//
//    self.init(data: data)
//  }

  /// `Animal.Height`
  final class Height: RootResponseObjectBase<Height.Fields, Void> {
    final class Fields: FieldData {
      @Field("__typename") final var __typename: String
      @Field("feet") final var feet: Int
      @Field("inches") final var inches: Int
      @Field("meters") final var meters: Int // - NOTE:
      // This field is merged in from `HeightInMeters` fragment.
      // Because the fragment type identically matches the type it is queried on, we do
      // not need an optional `TypeCondition` and can merge the field up.
      // TODO: We might be able to create something like `FieldJoiner` to make this cleaner?
    }
  }

  /// `Animal.AsPet`
  final class AsPet: TypeConditionBase<AsPet.Fields, AsPet.TypeConditions, Animal>, HasFragments {
    final class Fields: Animal.Fields {
      @Field("humanName") final var humanName: String
      @Field("favoriteToy") final var favoriteToy: String
    }

    final class TypeConditions: TypeConditionsBase<AsPet> {
      @AsType var asWarmBlooded: AsWarmBlooded?

      init(asWarmBlooded: AsWarmBlooded.ResponseData? = nil) {
        super.init()
        self._asWarmBlooded = AsType(parent: parent, data: asWarmBlooded)
      }
    }

    final class Fragments: ToFragments<Animal, ResponseData> {
      private(set) lazy var petDetails = PetDetails(
        data: .init(fields: .init(
          humanName: data.fields.humanName,
          favoriteToy: data.fields.favoriteToy
        )))
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
        // level of nested type condtions?
        parent.parent.data.fields[keyPath: keyPath]
      }
    }
  }

  // - NOTE:
  // Because the type condition for `WarmBlooded` only includes the fragment, we can just inherit the fragment type condition.
  //
  // For a type condition that fetches a fragment in addition to other fields, we would use a custom `TypeCondition`
  // with the fragment type condition nested inside. See `Predators.AsWarmBlooded` for an example of this.
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
  final class Predators: ResponseObjectBase<Predators.Fields, Predators.TypeConditions> {
    final class Fields {
      let __typename: String
      let species: String

      init(__typename: String, species: String) {
        self.__typename = __typename
        self.species = species
      }
    }

    final class TypeConditions: TypeConditionsBase<Predators> {
      @AsType var asWarmBlooded: AsWarmBlooded?

      init(asWarmBlooded: AsWarmBlooded.ResponseData? = nil) {
        super.init()
        self._asWarmBlooded = AsType(parent: parent, data: asWarmBlooded)
      }
    }

    /// `AllAnimals.Predators.AsWarmBlooded`
    final class AsWarmBlooded: TypeConditionBase<AsWarmBlooded.Fields, Void, Predators>, HasFragments {
      final class Fields {
        let bodyTemperature: Int
        let height: WarmBloodedDetails.Height // - NOTE:
        // These 2 fields are merged in from `WarmBloodedDetails` fragment.
        // Because the fragment type identically matches the type it is queried on, we do
        // not need an optional `TypeCondition` and can merge the fields up.
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

      final class Fragments: ToFragments<Animal.Predators, ResponseData> {
        private(set) lazy var warmBloodedDetails = WarmBloodedDetails(
          data: .init(fields: .init(
            bodyTemperature: data.fields.bodyTemperature,
            height: data.fields.height
          )))
      }
    }
  }
}
