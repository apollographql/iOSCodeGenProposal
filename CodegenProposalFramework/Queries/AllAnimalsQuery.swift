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

final class Animal: ResponseObjectBase<Animal.Fields>, HasFragments {
  class Fields: FieldData {
    @Field("species") final var species: String
    @Field("height") var height: Height
    @Field("predators") final var predators: [Predators]
  }

  class Fragments: FieldData {
    @ToFragment var heightInMeters: HeightInMeters
  }

  @AsType var asWarmBlooded: AsWarmBlooded?
  @AsType var asPet: AsPet?

  /// `Animal.Height`
  class Height: ResponseObjectBase<Height.Fields> {
    class Fields: FieldData {
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
  final class AsWarmBlooded: TypeCondition<AsWarmBlooded.Fields>, HasFragments {
    class Fields: Animal.Fields {
      @Field("bodyTemperature") final var bodyTemperature: Int
      @Field("height") private final var _height: Height
      override var height: Height { _height }
    }

    class Fragments: Animal.Fragments {
      @ToFragment var warmBloodedDetails: WarmBloodedDetails
    }

    final class Height: Animal.Height {
      final class Fields: Animal.Height.Fields {
        @Field("yards") final var yards: Int
      }
    }
  }

  /// `Animal.AsPet`
  final class AsPet: TypeCondition<AsPet.Fields>, HasFragments {
    class Fields: Animal.Fields {
      @Field("humanName") final var humanName: String
      @Field("favoriteToy") final var favoriteToy: String

      @Field("height") private final var _height: Height
      override var height: Height { _height }
    }

    class Fragments: Animal.Fragments {
      @ToFragment var petDetails: PetDetails
    }

    @AsType var asWarmBlooded: AsWarmBlooded?

    class Height: Animal.Height {
      @Field("centimeters") final var centimeters: Int
    }

    /// `Animal.AsPet.AsWarmBlooded`
    final class AsWarmBlooded: TypeCondition<AsWarmBlooded.Fields>, HasFragments {
      class Fields: AsPet.Fields {
        @Field("height") private final var _height: Height
        override var height: Height { _height }
      }

      class Fragments: Animal.AsPet.Fragments {
        @ToFragment var warmBloodedDetails: WarmBloodedDetails
      }

      final class Height: Animal.AsPet.Height {
        @Field("yards") final var yards: Int
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

      class Fragments: FragmentJoiner<Predators> {
        @ToFragment var warmBloodedDetails: WarmBloodedDetails
      }
    }
  }
}
