//
//  SwiftUIView.swift
//  
//
//  Created by Leo Dion on 5/21/21.
//

import SwiftUI

struct TodoList: View {
  @EnvironmentObject var object: ApplicationObject
  
    var body: some View {
      List(self.object.items ?? .init()) { item in
        Text(item.title)
      }
      .toolbar(content: {
                ToolbarItem(content: {
                  Image(systemName: "plus.circle.fill")
                })
      })
      .navigationTitle("Todos")
      
      
    }
}

struct TodoList_Previews: PreviewProvider {
    static var previews: some View {
      TodoList().environmentObject(ApplicationObject(items: [
        .init(title: "Do Stuff")
      ]))
    }
}
