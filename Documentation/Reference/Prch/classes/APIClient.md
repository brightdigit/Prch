**CLASS**

# `APIClient`

```swift
public class APIClient<SessionType: Session>
```

## Properties
### `api`

```swift
public let api: API
```

### `session`

```swift
public let session: SessionType
```

## Methods
### `init(api:session:)`

```swift
public init(api: API, session: SessionType)
```

### `request(_:_:)`

```swift
public func request<ResponseType>(
  _ request: APIRequest<ResponseType>,
  _ completion: @escaping (APIResult<ResponseType>) -> Void
) -> Task?
```
