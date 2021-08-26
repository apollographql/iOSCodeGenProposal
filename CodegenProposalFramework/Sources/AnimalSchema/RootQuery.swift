import Foundation
import CodegenProposalFramework

public final class RootQuery: CacheEntity {
  public static let __typename: String = "ROOT_QUERY" // tODO: or "QUERY? or what?

  var allAnimals: [Animal] = []
  var allPets: [Pet] = []
//  var classroomPets: [ClassroomPet]
}

//store.readWriteTransaction() { transaction in
//  let bird: Bird = AnimalSchema.object(withKey: "Bird:1234", in: transaction)
//
//  bird.$species
//  bird.humanName = "Tweety"
//
//  let rootQuery: RootQuery = AnimalSchema.rootQuery(in: transaction)
//  let user = rootQuery.me.friends[0]
//  let post = rootQuery.latestPosts(user: user.id)
//
//
//}
