import Foundation
/// query AllAnimals {
///   allAnimals {
///     height {
///       feet
///       inches
///     }
///     ...HeightInMeters
///     ...WarmBloodedDetails
///     species
///     ... on Pet {
///       ...PetDetails
///       ...WarmBloodedDetails
///       height {
///         centimeters
///       }
///     }
///     predators {
///       species
///       ... on WarmBlooded {
///         ...WarmBloodedDetails
///         hasFur
///       }
///     }
///   }
/// }
///

// TODO: Fragment with nested type condition
// TODO: Figure out access control on everything

// MARK: - Query Response Data Structs

/// `Animal`
final class Animal: FieldData, ResponseObject, HasFragments {
  @Field("species") final var species: String
  @Field("height") var height: Height
  @Field("predators") final var predators: [Predators]

  @AsType var asWarmBlooded: AsWarmBlooded?
  @AsType var asPet: AsPet?

  class Fragments: FieldData {
    @ToFragment var heightInMeters: HeightInMeters
  }

  /// `Animal.Height`
  class Height: FieldData, ResponseObject {
    @Field("feet") final var feet: Int
    @Field("inches") final var inches: Int
    @Field("meters") final var meters: Int // - NOTE:
    // This field is merged in from `HeightInMeters` fragment.
    // Because the fragment type identically matches the type it is queried on, we do
    // not need an optional `TypeCondition` and can merge the field up.
    // TODO: We might be able to create something like `FieldJoiner` to make this cleaner?
  }

  /// `Animal.Predators`
  final class Predators: FieldData, ResponseObject {
    @Field("species") final var  species: String

    @AsType var asWarmBlooded: AsWarmBlooded?

    /// `AllAnimals.Predators.AsWarmBlooded`
    final class AsWarmBlooded: FieldData, ResponseObject, HasFragments {
      @Field("bodyTemperature") final var bodyTemperature: Int
      @Field("height") final var height: Height
      @Field("hasFur") final var hasFur: Bool
      // - NOTE:
      // These 2 fields are merged in from `WarmBloodedDetails` fragment.
      // Because the fragment type identically matches the type it is queried on, we do
      // not need an optional `TypeCondition` and can merge the fields up.
      // TODO: We might be able to create something like `FieldJoiner` to make this cleaner?

      class Fragments: FragmentJoiner<Predators> {
        @ToFragment var warmBloodedDetails: WarmBloodedDetails
      }
    }
  }

  // - NOTE:
  // Because the type condition for `WarmBlooded` only includes the fragment,
  // we can just inherit the fragment type condition.
  //
  // For a type condition that fetches a fragment in addition to other fields,
  // we would use a custom `TypeCondition` with the fragment type condition nested inside.
  // See `Predators.AsWarmBlooded` for an example of this.
  /// `Animal.AsWarmBlooded`
  final class AsWarmBlooded: FieldData, ResponseObject, HasFragments {
    @Field("species") final var species: String
    @Field("height") final var height: Height
    @Field("predators") final var predators: [Predators]
    @Field("bodyTemperature") final var bodyTemperature: Int

    class Fragments: Animal.Fragments {
      @ToFragment var warmBloodedDetails: WarmBloodedDetails
    }

    class Height: FieldData, ResponseObject {
      @Field("feet") final var feet: Int
      @Field("inches") final var inches: Int
      @Field("meters") final var meters: Int
      @Field("yards") final var yards: Int
    }
  }

  /// `Animal.AsPet`
  final class AsPet: FieldData, ResponseObject, HasFragments {
    @Field("species") final var species: String
    @Field("height") var height: Height
    @Field("predators") final var predators: [Predators]
    @Field("humanName") final var humanName: String
    @Field("favoriteToy") final var favoriteToy: String

    @AsType var asWarmBlooded: AsWarmBlooded?

    class Fragments: Animal.Fragments {
      @ToFragment var petDetails: PetDetails
    }

    class Height: FieldData, ResponseObject {
      @Field("feet") final var feet: Int
      @Field("inches") final var inches: Int
      @Field("meters") final var meters: Int
      @Field("centimeters") final var centimeters: Int
    }

    /// `Animal.AsPet.AsWarmBlooded`
    final class AsWarmBlooded: FieldData, ResponseObject, HasFragments {
      @Field("species") final var species: String
      @Field("height") var height: Height
      @Field("predators") final var predators: [Predators]
      @Field("humanName") final var humanName: String
      @Field("favoriteToy") final var favoriteToy: String
      @Field("bodyTemperature") final var bodyTemperature: Int

      class Fragments: Animal.AsPet.Fragments {
        @ToFragment var warmBloodedDetails: WarmBloodedDetails
      }

      final class Height: FieldData, ResponseObject {
        @Field("feet") final var feet: Int
        @Field("inches") final var inches: Int
        @Field("meters") final var meters: Int
        @Field("centimeters") final var centimeters: Int
        @Field("yards") final var yards: Int
      }
    }
  }
}
