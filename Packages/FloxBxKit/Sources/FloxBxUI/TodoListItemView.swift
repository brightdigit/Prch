#if canImport(SwiftUI)
  import FloxBxModels
  import SwiftUI
  internal struct TodoListItemView: View {
    @EnvironmentObject private var object: ApplicationObject
    @State private var title: String
    private let item: TodoContentItem

    internal var body: some View {
      Group {
        if #available(iOS 15.0, watchOS 8.0, macOS 12.0, *) {
          TextField("", text: self.$title)
            .onSubmit(self.beginSave)
            .foregroundColor(self.item.isSaved ? .primary : .secondary)
        } else {
          TextField(
            "",
            text: self.$title,
            onEditingChanged: self.beginSave(hasFinished:),
            onCommit: self.beginSave
          )
        }
      }.onChange(of: item.title) { newValue in
        self.title = newValue
      }
    }

    internal init(item: TodoContentItem) {
      self.item = item
      _title = .init(initialValue: self.item.title)
    }

    private func updatedItem() -> TodoContentItem {
      item.updatingTitle(title)
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
      TodoListItemView(item: .init(title: "Hello"))
    }
  }
#endif
