public protocol ScalarType: Cacheable {}

extension String: ScalarType {}
extension Int: ScalarType {}
extension Bool: ScalarType {}
extension Float: ScalarType {}

extension ScalarType {
  public init(cacheData: Any, transaction: CacheTransaction) throws {
    self = cacheData as! Self
  }
}
