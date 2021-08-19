public protocol ScalarType: Cacheable {}

extension String: ScalarType {}
extension Int: ScalarType {}
extension Bool: ScalarType {}
extension Float: ScalarType {}

extension ScalarType {
  public static func value(with cacheData: Any, in transaction: CacheTransaction) throws -> Self {
    return cacheData as! Self
  }
}
