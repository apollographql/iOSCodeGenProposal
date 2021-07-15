@propertyWrapper
public struct CacheField<T> {

  private var value: T? = nil

  public init() {}

  public var wrappedValue: T? {
    get { value }
    set { value = newValue }
  }

  public var projectedValue: CacheField { self }
}
