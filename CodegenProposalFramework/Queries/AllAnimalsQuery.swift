import Foundation
// query AllAnimals {
//   allAnimals {
//     height {
//       feet
//       inches
//     }
//     ...HeightInMeters
//     ...WarmBloodedDetails
//     species
//     ... on Pet {
//       ...PetDetails
//       ...WarmBloodedDetails
//     }
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

final class Animal: ResponseObjectBase<Animal.Fields>, HasFragments {
  class Fields: FieldData {
    @Field("species") final var species: String
    @Field("height") final var height: Height
    @Field("predators") final var predators: [Predators]
  }

  class Fragments: FieldData {
    @ToFragment var heightInMeters: HeightInMeters
  }

  @AsType var asWarmBlooded: AsWarmBlooded?
  @AsType var asPet: AsPet?

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
  final class Height: ResponseObjectBase<Height.Fields> {
    final class Fields: FieldData {
      @Field("feet") final var feet: Int
      @Field("inches") final var inches: Int
      @Field("meters") final var meters: Int // - NOTE:
      // This field is merged in from `HeightInMeters` fragment.
      // Because the fragment type identically matches the type it is queried on, we do
      // not need an optional `TypeCondition` and can merge the field up.
      // TODO: We might be able to create something like `FieldJoiner` to make this cleaner?
    }
  }

  // - NOTE:
  // Because the type condition for `WarmBlooded` only includes the fragment, we can just inherit the fragment type condition.
  //
  // For a type condition that fetches a fragment in addition to other fields, we would use a custom `TypeCondition`
  // with the fragment type condition nested inside. See `Predators.AsWarmBlooded` for an example of this.
  /// `Animal.AsWarmBlooded`
  final class AsWarmBlooded: AsWarmBloodedDetails<Animal> {
    class Fields: BaseClass.Fields {
      @Field("height") final var height: Height

      final class Height: FieldJoiner<Animal.Height, WarmBloodedDetails.Height> {
        @Field("meters") final var meters: Int
      }
    }
  }

  /// `Animal.AsPet`
  final class AsPet: TypeCondition<AsPet.Fields>, HasFragments {
    final class Fields: Animal.Fields {
      @Field("humanName") final var humanName: String
      @Field("favoriteToy") final var favoriteToy: String
    }

    @AsType var asWarmBlooded: AsWarmBlooded?

    final class Fragments: Animal.Fragments {
      @ToFragment var petDetails: PetDetails
    }

    /// `Animal.AsPet.AsWarmBlooded`
    final class AsWarmBlooded: AsWarmBloodedDetails<Animal.AsPet> {
      class Fields: BaseClass.Fields {
        @Field("height") final var height: Height

        final class Height: FieldJoiner<Animal.Height, WarmBloodedDetails.Height> {
          @Field("meters") final var meters: Int
        }
      }
    }
  }

  /// `Animal.Predators`
  final class Predators: ResponseObjectBase<Predators.Fields> {
    class Fields: FieldData {
      @Field("species") final var  species: String
    }

    @AsType var asWarmBlooded: AsWarmBlooded?

    /// `AllAnimals.Predators.AsWarmBlooded`
    final class AsWarmBlooded: TypeCondition<AsWarmBlooded.Fields>, HasFragments {
      final class Fields: Predators.Fields {
        @Field("bodyTemperature") final var bodyTemperature: Int
        @Field("height") final var height: Height // - NOTE:
        // These 2 fields are merged in from `WarmBloodedDetails` fragment.
        // Because the fragment type identically matches the type it is queried on, we do
        // not need an optional `TypeCondition` and can merge the fields up.
        // TODO: We might be able to create something like `FieldJoiner` to make this cleaner?
        @Field("hasFur") final var hasFur: Bool
      }

      final class Fragments: FragmentJoiner<Predators> {
        @ToFragment var warmBloodedDetails: WarmBloodedDetails
      }
    }
  }
}
