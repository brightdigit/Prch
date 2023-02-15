#if canImport(SwiftUI)
  import FloxBxModels
  import SwiftUI
import FloxBxNetworking
  internal struct TodoListItemView: View {
    
      @available(*, deprecated)
    @EnvironmentObject private var object: ApplicationObject
    @StateObject private var itemObject: TodoObject
    
    //@State private var text: String
    //private let item: TodoContentItem

    internal var body: some View {
      Group {
        if #available(iOS 15.0, watchOS 8.0, macOS 12.0, *) {
          TextField("", text: self.$itemObject.text)
            .onSubmit(self.beginSave)
            .foregroundColor(self.itemObject.isSaved ? .primary : .secondary)
        } else {
          TextField(
            "",
            text: self.$itemObject.text,
            onEditingChanged: self.beginSave(hasFinished:),
            onCommit: self.beginSave
          )
       }
      }
    }

    internal init(item: TodoContentItem, groupActivityID: UUID?, service: any Service) {
      self._itemObject = .init(wrappedValue: .init(item: item, service: service, groupActivityID: groupActivityID))

      //_text = .init(initialValue: self.item.text)
    }

//    private func updatedItem() -> TodoContentItem {
//      let title: String
//      let tags: [String]
//      let splits = itemObject.text.split(separator: "#", omittingEmptySubsequences: true)
//      title = splits.first.map(String.init) ?? ""
//      tags = splits.dropFirst().map { $0.slugified() }
//
//      return itemObject.updatingTitle(title, tags: tags)
//    }

    private func beginSave() {
      itemObject.beginSave()
    }

    private func beginSave(hasFinished: Bool) {
      guard hasFinished else {
        return
      }
      beginSave()
    }
  }

//  private struct TodoListItemView_Previews: PreviewProvider {
//    // swiftlint:disable:next strict_fileprivate
//    fileprivate static var previews: some View {
//      TodoListItemView(item: .init(title: "Hello", tags: ["world", "Leo"]), groupActivityID: nil, service: )!
//    }
//  }
#endif
