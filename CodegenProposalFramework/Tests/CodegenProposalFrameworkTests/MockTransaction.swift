@testable import CodegenProposalFramework
@testable import AnimalSchema

class MockTransaction: CacheTransaction {

  var cache: [String: Object] = [:]

  init() {
    super.init(objectFactory: AnimalSchemaTypeFactory.self, keyResolver: MockCacheKeyResolver())
  }

  override func object(withKey key: CacheKey) -> Object? {
    return cache[key.key]
  }
}

struct MockCacheKeyResolver: CacheKeyResolver {
  func cacheKey(for: [String : Any]) -> CacheKey? {
    return nil
  }
}
