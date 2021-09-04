**STRUCT**

# `StringCodingKey`

```swift
public struct StringCodingKey: CodingKey, ExpressibleByStringLiteral
```

## Properties
### `stringValue`

```swift
public var stringValue: String
```

### `intValue`

```swift
public var intValue: Int?
```

## Methods
### `init(string:)`

```swift
public init(string: String)
```

### `init(stringValue:)`

```swift
public init?(stringValue: String)
```

#### Parameters

| Name | Description |
| ---- | ----------- |
| stringValue | The string value of the desired key. |

### `init(intValue:)`

```swift
public init?(intValue: Int)
```

#### Parameters

| Name | Description |
| ---- | ----------- |
| intValue | The integer value of the desired key. |

### `init(stringLiteral:)`

```swift
public init(stringLiteral value: String)
```

#### Parameters

| Name | Description |
| ---- | ----------- |
| value | The value of the new instance. |