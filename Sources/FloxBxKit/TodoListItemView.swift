import SwiftUI

extension TodoContentItem {
  func updatingTitle(_ title: String) -> TodoContentItem {
    TodoContentItem(clientID: self.clientID, serverID: self.serverID, title: title)
  }
}

struct TodoListItemView: View {
  @EnvironmentObject var object: ApplicationObject
  @State var title: String
  let item: TodoContentItem

  init(item: TodoContentItem) {
    self.item = item
    _title = .init(initialValue: self.item.title)
  }

  func updatedItem() -> TodoContentItem {
    item.updatingTitle(title)
  }

  func beginSave() {
    object.saveItem(updatedItem())
  }

  func beginSave(hasFinished: Bool) {
    guard hasFinished else {
      return
    }
    beginSave()
  }

  var body: some View {
    if #available(iOS 15.0, watchOS 8.0, macOS 12.0, *) {
      TextField("", text: self.$title).onSubmit(self.beginSave).foregroundColor(self.item.isSaved ? .primary : .secondary)
    } else {
      TextField("", text: self.$title, onEditingChanged: self.beginSave(hasFinished:), onCommit: self.beginSave)
    }
  }
}

struct SwiftUIView_Previews: PreviewProvider {
  static var previews: some View {
    TodoListItemView(item: .init(title: "Hello"))
  }
}
