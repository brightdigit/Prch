import Foundation

public extension DateFormatter {
  convenience init(
    formatString: String,
    locale: Locale? = nil,
    timeZone: TimeZone? = nil,
    calendar: Calendar? = nil
  ) {
    self.init()
    dateFormat = formatString
    if let locale = locale {
      self.locale = locale
    }
    if let timeZone = timeZone {
      self.timeZone = timeZone
    }
    if let calendar = calendar {
      self.calendar = calendar
    }
  }

  convenience init(dateStyle: DateFormatter.Style, timeStyle: DateFormatter.Style) {
    self.init()
    self.dateStyle = dateStyle
    self.timeStyle = timeStyle
  }
}

public extension DateFormatter {
  func string(from dateDay: DateDay) -> String {
    string(from: dateDay.date)
  }
}
