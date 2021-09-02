@testable import CodegenProposalFramework
@testable import AnimalSchema

class MockTransaction: CacheTransaction {

  var cache: [String: CacheEntity] = [:]

  init() {
    super.init(entityFactory: AnimalSchemaTypeFactory.self, keyResolver: MockCacheKeyResolver())
  }

  override func entity(withKey key: CacheKey) -> CacheEntity? {
    return cache[key.key]
  }
}

struct MockCacheKeyResolver: CacheKeyResolver {
  func cacheKey(for: [String : Any]) -> CacheKey? {
    return nil
  }
}
