import Foundation
import ApolloCodegenLib
import AnimalsAPI

let generator = try! ApolloCodegenFrontend.init()

let animalSchemaURL = Bundle.module.url(forResource: "AnimalSchema", withExtension: "graphqls")!
let animalSchema = try! generator.loadSchema(from: animalSchemaURL)
let animalOperations = try! generator.mergeDocuments(
  AnimalsAPI.Resources.GraphQLOperations.map {
    try! generator.parseDocument(from: $0)
  }
)

let AST = try! generator.compile(schema: animalSchema, document: animalOperations)

print(AST)
