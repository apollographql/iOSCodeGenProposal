public protocol CacheEntityFactory {
  static func entityType(forTypename __typename: String) -> CacheEntity.Type?
}

public protocol ReadTransaction: AnyObject {
  var entityFactory: CacheEntityFactory.Type { get }
  func entity<T: CacheEntity>(withKey: String) -> T?
}

extension ReadTransaction {
  func entity(withData data: [String: Any]) -> CacheEntity? {
    guard let typename = data["__typename"] as? String,
          let type = entityFactory.entityType(forTypename: typename) else {
      return nil
    }

    return type.init(in: self, data: data)
  }
}

open class CacheEntity {
  let _transaction: ReadTransaction
  var data: [String: Any]

  public required init(in transaction: ReadTransaction, data: [String: Any] = [:]) {
    self._transaction = transaction
    self.data = data
  }

  var cacheKey: String { "" } // TODO
}

public final class CacheReference<T: CacheEntity> {
  var entity: T?
  private let _transaction: ReadTransaction

  init(entity: T) {
    self.entity = entity
    _transaction = entity._transaction
  }
}

/// A reference to a cache record.
public struct CacheKey {
  public let key: String

  public init(key: String) {
    self.key = key
  }
}
