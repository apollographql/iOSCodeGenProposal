import CodegenProposalFramework

protocol Pet {
  var humanName: String? { get }
  var favoriteToy: String? { get }
  var owner: Human? { get }
}
