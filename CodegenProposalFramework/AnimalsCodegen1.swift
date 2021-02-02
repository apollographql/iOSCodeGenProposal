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

public struct PetDetails {
  let humanName: String
  let favoriteToy: String
}

//public extension HasParent where Parent: PetDetails {
//  var humanName: String { parent.humanName }
//  var favoriteToy: String { parent.favoriteToy }
//}

public struct WarmBloodedDetails {
  let bodyTemperature: Int
}

//public extension HasParent where Parent: WarmBloodedDetails {
//  var bodyTemperature: Int { parent.bodyTemperature }
//}

protocol ResponseData: AnyObject {
  associatedtype Props

  var props: Props { get }
}

protocol TypeCase: ResponseData {
  associatedtype Parent: ResponseData

  init(parent: Parent, props: Props)
}

// MARK: Query Response Data Structs

public final class AllAnimals: ResponseData {
  final class Props {
    let __typename: String
    let species: String
    let height: Height
    //  let predators: [Predators] = [] // TODO

    init(__typename: String, species: String, height: AllAnimals.Height) {
      self.__typename = __typename
      self.species = species
      self.height = height
    }
  }

  let props: Props

  @AsInterface var asPet: AsPet?
  @AsInterface var asWarmBlooded: AsWarmBlooded?

  init(__typename: String, species: String, height: Height) {
    self.props = Props(__typename: __typename, species: species, height: height)
    self._asPet = .nil
    self._asWarmBlooded = .nil
  }

  /// `AllAnimals.Height`
  final class Height: ResponseData {
    final class Props {
      let __typename: String
      let feet: Int
      let inches: Int

      init(__typename: String, feet: Int, inches: Int) {
        self.__typename = __typename
        self.feet = feet
        self.inches = inches
      }
    }

    let props: Props

    init(props: Props) {
      self.props = props
    }
  }

  /// `AllAnimals.Predators`
//  struct Predators {
//    var __typename: String // Animal
//    var species: String
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
  
  /// `AllAnimals.AsPet`
//  @dynamicMemberLookup
  final class AsPet: TypeCase {
    final class Props {
      let humanName: String
      let favoriteToy: String

      init(humanName: String, favoriteToy: String) {
        self.humanName = humanName
        self.favoriteToy = favoriteToy
      }
    }

    let props: Props
    let parent: AllAnimals

    @AsInterface var asWarmBlooded: AsWarmBlooded?

    convenience init(
      humanName: String = "",
      favoriteToy: String,
      parent: AllAnimals
    ) {
      let props = Props(humanName: humanName, favoriteToy: favoriteToy)
      self.init(parent: parent, props: props)
    }

    init(parent: AllAnimals, props: Props) {
      self.parent = parent
      self.props = props
      self._asWarmBlooded = .nil
    }

//    subscript<T>(dynamicMember keyPath: KeyPath<AllAnimals.AsPet.Parent, T>) -> T {
//      parent.value[keyPath: keyPath]
//    }

    /// `AllAnimals.AsPet.AsWarmBlooded`
//    @dynamicMemberLookup
    final class AsWarmBlooded: TypeCase {
      final class Props {
        let bodyTemperature: Int

        internal init(bodyTemperature: Int) {
          self.bodyTemperature = bodyTemperature
        }
      }

      let props: Props
      let parent: AllAnimals.AsPet

      init(parent: AllAnimals.AsPet, props: Props) {
        self.parent = parent
        self.props = props
      }

//      subscript<T>(dynamicMember keyPath: KeyPath<Self.Parent, T>) -> T {
//        parent.value[keyPath: keyPath]
//      }
    }
  }

  /// `AllAnimals.AsWarmBlooded`
//    @dynamicMemberLookup
  final class AsWarmBlooded: TypeCase {
    final class Props {
      let bodyTemperature: Int

      internal init(bodyTemperature: Int) {
        self.bodyTemperature = bodyTemperature
      }
    }

    let props: Props
    let parent: AllAnimals

    init(parent: AllAnimals, props: Props) {
      self.parent = parent
      self.props = props
    }

//      subscript<T>(dynamicMember keyPath: KeyPath<Self.Parent, T>) -> T {
//        parent.value[keyPath: keyPath]
//      }
  }

}

// MARK: - Extensions for creating mock objects
// I am NOT at all happy with this part yet.

extension AllAnimals {

  func makeAsPet(humanName: String, favoriteToy: String) -> AsPet {
    let asPetProps = AsPet.Props(humanName: humanName,
                                 favoriteToy: favoriteToy)
    self._asPet = AsInterface(parent: self, props: asPetProps)
    return self.asPet!
  }

  func makeAsWarmBlooded(bodyTemperature: Int) -> AsWarmBlooded {
    let asWarmBloodedProps = AsWarmBlooded.Props(bodyTemperature: bodyTemperature)
    self._asWarmBlooded = AsInterface(parent: self, props: asWarmBloodedProps)
    return self.asWarmBlooded!
  }

}

extension AllAnimals.AsPet {

  func makeAsWarmBlooded(bodyTemperature: Int) -> AsWarmBlooded {
    let asWarmBloodedProps = AsWarmBlooded.Props(bodyTemperature: bodyTemperature)
    self._asWarmBlooded = AsInterface(parent: self, props: asWarmBloodedProps)
    return self.asWarmBlooded!
  }

}
