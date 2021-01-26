import Foundation

// Generated once for the entire project
@dynamicMemberLookup
public class Reference<Value> {
    fileprivate(set) public var value: Value

    init(value: Value) {
        self.value = value
    }

    public subscript<T>(dynamicMember keyPath: KeyPath<Value, T>) -> T {
        value[keyPath: keyPath]
    }
}

public class MutableReference<Value>: Reference<Value> {
    public subscript<T>(dynamicMember keyPath: WritableKeyPath<Value, T>) -> T {
        get { value[keyPath: keyPath] }
        set { value[keyPath: keyPath] = newValue }
    }
}
