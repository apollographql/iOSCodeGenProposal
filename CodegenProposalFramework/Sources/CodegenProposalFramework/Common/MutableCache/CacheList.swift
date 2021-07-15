@propertyWrapper
public struct CacheList<T> {

  private var value: [T] = []

  public init() {}

  public var wrappedValue: [T] {
    get { value }
    set { value = newValue }
  }

  public var projectedValue: CacheList { self }
}
