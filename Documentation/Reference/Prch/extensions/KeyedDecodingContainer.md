**EXTENSION**

# `KeyedDecodingContainer`
```swift
public extension KeyedDecodingContainer
```

## Methods
### `decodeAny(_:forKey:)`

```swift
func decodeAny<T>(_: T.Type, forKey key: K) throws -> T
```

### `decodeAnyIfPresent(_:forKey:)`

```swift
func decodeAnyIfPresent<T>(_: T.Type, forKey key: K) throws -> T?
```

### `toDictionary()`

```swift
func toDictionary() throws -> [String: Any]
```

### `decode(_:)`

```swift
func decode<T>(_ key: KeyedDecodingContainer.Key) throws -> T where T: Decodable
```

### `decodeIfPresent(_:)`

```swift
func decodeIfPresent<T>(_ key: KeyedDecodingContainer.Key
) throws -> T? where T: Decodable
```

### `decodeIfPresent(_:)`

```swift
func decodeIfPresent(_ key: KeyedDecodingContainer.Key) throws -> DateTime
```

### `decodeAny(_:)`

```swift
func decodeAny<T>(_ key: K) throws -> T
```

### `decodeAnyIfPresent(_:)`

```swift
func decodeAnyIfPresent<T>(_ key: K) throws -> T?
```

### `decodeArray(_:safeArrayDecoding:)`

```swift
func decodeArray<T: Decodable>(
  _ key: K,
  safeArrayDecoding: Bool = false
) throws -> [T]
```

### `decodeArrayIfPresent(_:)`

```swift
func decodeArrayIfPresent<T: Decodable>(_ key: K) throws -> [T]?
```
