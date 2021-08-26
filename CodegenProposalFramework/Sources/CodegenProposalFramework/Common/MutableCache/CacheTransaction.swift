public protocol CacheEntityFactory {
  static func entityType(forTypename __typename: String) -> CacheEntity.Type?
}

public protocol CacheKeyResolver {
  func cacheKey(for: [String: Any]) -> CacheKey?
}

public class CacheTransaction {
  let entityFactory: CacheEntityFactory.Type
  let keyResolver: CacheKeyResolver
  private(set) var errors: [CacheError] = []
  private var fetchedEntities: [CacheKey: CacheEntity] = [:]

  init(
    entityFactory: CacheEntityFactory.Type,
    keyResolver: CacheKeyResolver
  ) {
    self.entityFactory = entityFactory
    self.keyResolver = keyResolver
  }

  func entity(withKey key: CacheKey) -> CacheEntity? {
    fetchedEntities[key] // TODO: if not fetched yet, fetch from store
  }

  func entity(withData data: [String: Any]) -> CacheEntity {
    let cacheKey = keyResolver.cacheKey(for: data)

    if let cacheKey = cacheKey, let entity = fetchedEntities[cacheKey] {
      return entity
    }

    guard let typename = data["__typename"] as? String,
          let type = entityFactory.entityType(forTypename: typename) else {
      fatalError()
    }

    let entity = type.init(transaction: self, data: data)
    if let cacheKey = cacheKey {
      fetchedEntities[cacheKey] = entity
    }

    return entity
  }

  func log(_ error: CacheError) {
    errors.append(error)
  }

  func log(_ error: Error) {
    // TODO
  }

//  func interface<T: CacheInterface>(withData data: [String: Any]) -> T {
//    return T.init(entity: entity(withData: data))
//  }
}

struct CacheError: Error {
  enum Reason: Error {
    case unrecognizedCacheData(_ data: Any, forType: Any.Type)
    case invalidEntityType(_ type: CacheEntity.Type, forInterface: CacheInterface.Type)
  }

  enum `Type` {
    case read, write
  }

  let reason: Reason
  let type: Type
  let field: String
  let object: AnyCacheObject?
}
