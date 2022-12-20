#if canImport(SwiftUI)
  import FloxBxModels
  import SwiftUI
  internal struct TodoListItemView: View {
    @EnvironmentObject private var object: ApplicationObject
    @State private var text: String
    private let item: TodoContentItem

    internal var body: some View {
      Group {
        if #available(iOS 15.0, watchOS 8.0, macOS 12.0, *) {
          TextField("", text: self.$text)
            .onSubmit(self.beginSave)
            .foregroundColor(self.item.isSaved ? .primary : .secondary)
        } else {
          TextField(
            "",
            text: self.$text,
            onEditingChanged: self.beginSave(hasFinished:),
            onCommit: self.beginSave
          )
        }
      }
    }

    internal init(item: TodoContentItem) {
      self.item = item

      _text = .init(initialValue: self.item.text)
    }

    private func updatedItem() -> TodoContentItem {
      let title: String
      let tags: [String]
      let splits = text.split(separator: "#", omittingEmptySubsequences: true)
      title = splits.first.map(String.init) ?? ""
      tags = splits.dropFirst().map { $0.slugified() }

      return item.updatingTitle(title, tags: tags)
    }

    private func beginSave() {
      object.saveItem(updatedItem())
    }

    private func beginSave(hasFinished: Bool) {
      guard hasFinished else {
        return
      }
      beginSave()
    }
  }

  private struct TodoListItemView_Previews: PreviewProvider {
    // swiftlint:disable:next strict_fileprivate
    fileprivate static var previews: some View {
      TodoListItemView(item: .init(title: "Hello", tags: ["world", "Leo"]))
    }
  }
#endif
