public protocol CacheEntityFactory {
  static func entityType(forTypename __typename: String) -> CacheEntity.Type?
}

public protocol CacheTransaction: AnyObject {
  var entityFactory: CacheEntityFactory.Type { get }

  func entity<T: CacheEntity>(withKey: String) -> T?

  func cacheKey(for: CacheEntity) -> CacheKey?
}

extension CacheTransaction {
  func entity(withData data: [String: Any]) -> CacheEntity? {
    guard let typename = data["__typename"] as? String,
          let type = entityFactory.entityType(forTypename: typename) else {
      return nil
    }

    return type.init(in: self, data: data)
  }
}

open class CacheEntity {
  let _transaction: CacheTransaction
  var data: [String: Any]

  public required init(in transaction: CacheTransaction, data: [String: Any] = [:]) {
    self._transaction = transaction
    self.data = data
  }

//  var cacheKey: String { "" } // TODO
}

protocol AnyCacheReference: AnyObject {
}

public class CacheReference<T>: AnyCacheReference { // TODO: can this be a struct? Maybe property wrapper, use transaction from enclosing self?
  private let _transaction: CacheTransaction
  private(set) var entity: T?
  var cacheKey: CacheKey?

  init(entity: T) where T: CacheEntity {
    self.entity = entity
    _transaction = entity._transaction
  }

  init(key: CacheKey?, _ transaction: CacheTransaction) {
    self.cacheKey = key
    self._transaction = transaction
  }
}

public struct SomeCacheReference<T> {
//  private struct AnyCacheReference {
//    let value: CacheReferenceProtocol
//  }

  private let wrapped: AnyCacheReference

  init?<E>(wrapping reference: CacheReference<E>) where E: CacheEntity {
    guard E.self is T else { return nil }
    self.wrapped = reference
  }
}

/// Represents a key that references a record in the cache.
public struct CacheKey {
  public let key: String

  public init(key: String) {
    self.key = key
  }
}
