**EXTENSION**

# `DateFormatter`
```swift
public extension DateFormatter
```

## Methods
### `init(formatString:locale:timeZone:calendar:)`

```swift
convenience init(
  formatString: String,
  locale: Locale? = nil,
  timeZone: TimeZone? = nil,
  calendar: Calendar? = nil
)
```

### `init(dateStyle:timeStyle:)`

```swift
convenience init(dateStyle: DateFormatter.Style, timeStyle: DateFormatter.Style)
```

### `string(from:)`

```swift
func string(from dateDay: DateDay) -> String
```
