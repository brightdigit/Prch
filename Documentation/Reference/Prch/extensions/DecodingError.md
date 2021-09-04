**EXTENSION**

# `DecodingError`
```swift
public extension DecodingError
```

## Methods
### `mismatch(ofType:withCodingPath:)`

```swift
static func mismatch<MismatchType>(
  ofType type: MismatchType.Type,
  withCodingPath codingPath: [CodingKey] = [StringCodingKey(string: "")]
) -> DecodingError
```
