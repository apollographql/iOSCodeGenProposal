import CodegenProposalFramework

protocol Pet: CacheEntity {
  var humanName: String? { get }
  var favoriteToy: String? { get }
  var owner: Human? { get }
}
