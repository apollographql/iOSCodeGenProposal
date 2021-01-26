import Foundation
// query {
//   allAnimals {
//     height {
//       feet
//       inches
//     }
//     species
//     ... on Pet {
//       ...PetDetails
//       ...WarmBloodedDetails
//     }
//     ...WarmBloodedDetails
//     predators {
//       species
//       ...WarmBloodedDetails
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
// }

// MARK: Fragments

public protocol PetDetails {
  var humanName: String { get }
  var favoriteToy: String { get }
}

public extension HasParent where Parent: PetDetails {
  var humanName: String { parent.humanName }
  var favoriteToy: String { parent.favoriteToy }
}

public protocol WarmBloodedDetails {
  var bodyTemperature: Int { get }
}

public extension HasParent where Parent: WarmBloodedDetails {
  var bodyTemperature: Int { parent.bodyTemperature }
}

// MARK: Query Response Data Structs

public struct AllAnimals {
  var __typename: String
  var species: String
  var height: Height
  var predators: [Predators] = [] // TODO

  var asPet: AsPet?
  var asWarmBlooded: AsWarmBlooded?

  init(__typename: String, species: String, height: Height) {
    self.__typename = __typename
    self.species = species
    self.height = height
  }

  /// `AllAnimals.Height`
  struct Height {
    let __typename: String = "Height" // TODO: Can we do this?
    var feet: Int
    var inches: Int
  }

  /// `AllAnimals.Predators`
  struct Predators {
    var __typename: String // Animal
    var species: String

    var asWarmBlooded: AsWarmBlooded?

    /// `AllAnimals.Predators.AsWarmBlooded`
    @dynamicMemberLookup
    struct AsWarmBlooded: WarmBloodedDetails, HasParent {
      var bodyTemperature: Int

      internal let parent: Reference<AllAnimals.Predators>

      subscript<T>(dynamicMember keyPath: KeyPath<Self.Parent, T>) -> T {
        parent.value[keyPath: keyPath]
      }
    }
  }
  
  /// `AllAnimals.AsPet`
  @dynamicMemberLookup
  struct AsPet: PetDetails, HasParent { // AllAnimals.AsPet
    var humanName: String
    var favoriteToy: String

    var asWarmBlooded: AsWarmBlooded?

    internal let parent: Reference<AllAnimals>

    subscript<T>(dynamicMember keyPath: KeyPath<Self.Parent, T>) -> T {
      parent.value[keyPath: keyPath]
    }

    /// `AllAnimals.AsPet.AsWarmBlooded`
    @dynamicMemberLookup
    struct AsWarmBlooded: WarmBloodedDetails, PetDetails, HasParent {
      var bodyTemperature: Int

      internal let parent: Reference<AllAnimals.AsPet>

      subscript<T>(dynamicMember keyPath: KeyPath<Self.Parent, T>) -> T {
        parent.value[keyPath: keyPath]
      }
    }
  }

  /// `AllAnimals.AsWarmBlooded`
  @dynamicMemberLookup
  struct AsWarmBlooded: WarmBloodedDetails, HasParent {
    var bodyTemperature: Int

    internal let parent: Reference<AllAnimals>

    subscript<T>(dynamicMember keyPath: KeyPath<Self.Parent, T>) -> T {
      parent.value[keyPath: keyPath]
    }
  }

}

// MARK: - Extensions for creating mock objects
// I am NOT at all happy with this part yet.

extension AllAnimals {

  func makeAsPet(humanName: String, favoriteToy: String) -> AsPet {
    let ref = MutableReference(value: self)
    let asPet = AsPet(humanName: humanName,
                 favoriteToy: favoriteToy,
                 asWarmBlooded: nil,
                 parent: ref)
    ref.asPet = asPet
    return asPet
  }

  func makeAsWarmBlooded(bodyTemperature: Int) -> AsWarmBlooded {
    let ref = MutableReference(value: self)
    let asWarmBlooded = AsWarmBlooded(bodyTemperature: bodyTemperature,
                                      parent: Reference(value: self))
    ref.asWarmBlooded = asWarmBlooded
    return asWarmBlooded
  }

}

extension AllAnimals.AsPet {

  func makeAsWarmBlooded(bodyTemperature: Int) -> AsWarmBlooded {
    let ref = MutableReference(value: self)
    let asWarmBlooded = AsWarmBlooded(bodyTemperature: bodyTemperature,
                                      parent: Reference(value: self))
    ref.asWarmBlooded = asWarmBlooded
    return asWarmBlooded
  }

}
