#if canImport(SwiftUI)
  import SwiftUI

  extension View {
    @available(iOS 15.0, watchOS 8.0, *)
    private func forEmailAddress2021() -> some View {
      #if os(macOS)
        self
      #else
        textInputAutocapitalization(.never)
          .disableAutocorrection(true)
      #endif
    }

    private func forEmailAddress2020() -> some View {
      textContentType(.emailAddress)
      #if os(iOS)
        .keyboardType(.emailAddress)
        .autocapitalization(.none)
      // swiftlint:disable indentation_width
      #elseif os(macOS)
          .textCase(.none)
      #endif
      // swiftlint:enable indentation_width
    }

    public func forEmailAddress() -> some View {
      let view = forEmailAddress2020()

      if #available(iOS 15.0, watchOS 8.0, *) {
        return AnyView(view.forEmailAddress2021())
      } else {
        return AnyView(view)
      }
    }
  }
#endif
