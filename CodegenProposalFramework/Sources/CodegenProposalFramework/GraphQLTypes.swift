import Foundation

struct Schema {
  enum ObjectType: String {
    case Bird, Cat, Coyote, Crocodile, Fish, Height, _unknown

    var interfaces: [Interface] {
      switch self {
      case .Bird, .Cat:
        return [.Animal, .Pet, .WarmBlooded]
      case .Coyote:
        return [.Animal, .WarmBlooded]
      case .Crocodile:
        return [.Animal]
      case .Fish:
        return [.Animal, .Pet]
      default:
        return []
      }
    }

    func implements(_ interface: Interface) -> Bool {
      interfaces.contains(interface)
    }
  }

  enum Interface: String {
    case Animal, Pet, WarmBlooded
  }
}
