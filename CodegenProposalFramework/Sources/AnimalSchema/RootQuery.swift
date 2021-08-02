import Foundation
import CodegenProposalFramework

@available(macOS 10.15.0, *)
public final class RootQuery {
  let transaction: ReadTransaction
  init(_ t: ReadTransaction) {
    self.transaction = t
  }

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
