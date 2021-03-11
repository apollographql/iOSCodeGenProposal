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
struct Animal: SelectionSet, HasFragments {
  let data: ResponseData

  var species: String { data["species"] }
  var height: Height { data["height"] }
  var predators: [Predators] { data["predators"] }

  var asWarmBlooded: AsWarmBlooded? { asType() }
  var asPet: AsPet? { asType() }

  struct Fragments: SelectionSet {
    let data: ResponseData
    
    var heightInMeters: HeightInMeters { toFragment() }
  }

  /// `Animal.Height`
  struct Height: SelectionSet {
    let data: ResponseData

    var feet: Int { data["feet"] }
    var inches: Int { data["inches"] }
    var meters: Int { data["meters"] } // - NOTE:
    // This field is merged in from `HeightInMeters` fragment.
    // Because the fragment type identically matches the type it is queried on, we do
    // not need an optional `TypeCondition` and can merge the field up.
    // TODO: We might be able to create something like `FieldJoiner` to make this cleaner?
  }

  /// `Animal.Predators`
  struct Predators: SelectionSet {
    let data: ResponseData

    var species: String { data["species"] }

    var asWarmBlooded: AsWarmBlooded? { asType() }

    /// `AllAnimals.Predators.AsWarmBlooded`
    struct AsWarmBlooded: SelectionSet, HasFragments {
      let data: ResponseData

      var bodyTemperature: Int { data["bodyTemperature"] }
      var height: Height { data["height"] }
      var hasFur: Bool { data["hasFur"] }
      // - NOTE:
      // These 2 fields are merged in from `WarmBloodedDetails` fragment.
      // Because the fragment type identically matches the type it is queried on, we do
      // not need an optional `TypeCondition` and can merge the fields up.
      // TODO: We might be able to create something like `FieldJoiner` to make this cleaner?

      struct Fragments: SelectionSet {
        let data: ResponseData
        var warmBloodedDetails: WarmBloodedDetails { toFragment() }
      }

      struct Height: SelectionSet {
        let data: ResponseData

        var meters: Int { data["meters"] }
        var yards: Int { data["yards"] }
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
  struct AsWarmBlooded: SelectionSet, HasFragments {
    let data: ResponseData

    var species: String { data["species"] }
    var height: Height  { data["height"] }
    var predators: [Predators]  { data["predators"] }
    var bodyTemperature: Int { data["bodyTemperature"] }

    struct Fragments: SelectionSet {
      let data: ResponseData

      var heightInMeters: HeightInMeters { toFragment() }
      var warmBloodedDetails: WarmBloodedDetails  { toFragment() }
    }

    struct Height: SelectionSet {
      let data: ResponseData

      var feet: Int { data["feet"] }
      var inches: Int { data["inches"] }
      var meters: Int { data["meters"] }
      var yards: Int { data["yards"] }
    }
  }

  /// `Animal.AsPet`
  struct AsPet: SelectionSet, HasFragments {
    let data: ResponseData

    var species: String { data["species"] }
    var height: Height  { data["height"] }
    var predators: [Predators]  { data["predators"] }
    var humanName: String { data["humanName"] }
    var favoriteToy: String { data["favoriteToy"] }

    var asWarmBlooded: AsWarmBlooded? { asType() }

    struct Fragments: SelectionSet {
      let data: ResponseData

      var heightInMeters: HeightInMeters { toFragment() }
      var petDetails: PetDetails  { toFragment() }
    }

    struct Height: SelectionSet {
      let data: ResponseData

      var feet: Int { data["feet"] }
      var inches: Int { data["inches"] }
      var meters: Int { data["meters"] }
      var centimeters: Int { data["centimeters"] }
    }

    /// `Animal.AsPet.AsWarmBlooded`
    struct AsWarmBlooded: SelectionSet, HasFragments {
      let data: ResponseData

      var species: String { data["species"] }
      var height: Height  { data["height"] }
      var predators: [Predators]  { data["predators"] }
      var humanName: String { data["humanName"] }
      var favoriteToy: String { data["favoriteToy"] }
      var bodyTemperature: Int { data["bodyTemperature"] }

      struct Fragments: SelectionSet {
        let data: ResponseData

        var heightInMeters: HeightInMeters { toFragment() }
        var petDetails: PetDetails  { toFragment() }
        var warmBloodedDetails: WarmBloodedDetails  { toFragment() }
      }

      struct Height: SelectionSet {
        let data: ResponseData

        var feet: Int { data["feet"] }
        var inches: Int { data["inches"] }
        var meters: Int { data["meters"] }
        var centimeters: Int { data["centimeters"] }
        var yards: Int { data["yards"] }
      }
    }
  }
}
