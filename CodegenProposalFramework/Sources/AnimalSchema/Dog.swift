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
