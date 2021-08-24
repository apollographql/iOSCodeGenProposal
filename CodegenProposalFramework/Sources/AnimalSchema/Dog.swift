import CodegenProposalFramework

public final class Dog: CacheEntity {
  //, Animal, Pet, WarmBlooded, HousePet
  @CacheField("species") var species: String?
  @CacheField("height") var height: Height?
  @CacheList var predators: [HousePet]
  @CacheField("skinCovering") var skinCovering: GraphQLEnum<SkinCovering>?
  @CacheField("humanName") var humanName: String?
  @CacheField("favoriteToy") var favoriteToy: String?
  @CacheField("owner") var owner: Human?
  @CacheField("bodyTemperature") var bodyTemperature: Int?
  @CacheField("laysEggs") var laysEggs: Bool?
  @CacheField("isJellicle") var isJellicle: Bool?
  @CacheField("bestFriend") var bestFriend: HousePet?

  override public class var __metadata: Metadata { _metadata }
  private static let _metadata: Metadata = Metadata(
    interfaces: [Animal.self, Pet.self, WarmBlooded.self, HousePet.self]
  )

  override public func propertyType(forField field: String) -> Cacheable.Type? {
    switch field {
    case "species": return String.self
    case "bestFriend": return HousePet.self
    default: return nil
    }
  }

//  public override class var fields: [String: Cacheable.Type] { [
//    "species": String.self,
//    //    "height": Height.self, "skinCovering": GraphQLEnum<SkinCovering>.self,
//    //    "humanName": String.self, "favoriteToy": String.self, "owner": Human.self,
//    //    "bodyTemperature": Int.self, "laysEggs": Bool.self, "isJellicle": Bool.self,
//    "bestFriend": HousePet.self
//  ]
//  }
}

//struct CacheEntityMetadata {
//  static var fields: [String: Cacheable.Type] { get }
//}

extension Dog {

  static let __type: TypesUsed.ObjectType = .Dog

//  let a = Dog.fields["species"]!.self.valueType
}

//extension Animal where Self == Dog {
//  var predators: [Animal] {
//    get { self.$predators.wrappedValue as! [Animal] }
////    set { self.$predators.mutate(newValue) }
//  }
//}

//extension WarmBlooded where Self == Dog {
//  var predators: [Animal] {
//    get { self.$predators.wrappedValue }
//    set { self.$predators.mutate(newValue) }
//  }
//}

//extension Dog {
//  var bestFriendRef: Pet? {
//    get { return self.bestFriend }
//    set {  }
//  }
//}
