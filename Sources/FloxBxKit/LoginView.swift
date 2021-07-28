//
//  ContentView.swift
//  Shared
//
//  Created by Leo Dion on 5/10/21.
//

#if canImport(SwiftUI)
import SwiftUI

#if os(watchOS)
typealias FBTextFieldStyle = DefaultTextFieldStyle
#else
typealias FBTextFieldStyle = RoundedBorderTextFieldStyle
#endif

#if os(watchOS)
typealias FBButtonStyle = DefaultButtonStyle
#else
typealias FBButtonStyle = BorderlessButtonStyle
#endif


public struct LoginView: View {
  @EnvironmentObject var object: ApplicationObject
  @State var emailAddress : String = ""
  @State var password : String = ""
  #if os(watchOS)
  @State var presentLoginOrSignup = false
  #endif
  
  public init () {}
  
  public var content: some View {
    VStack{
      #if !os(watchOS)
      Spacer()
      Image("Logo").resizable().scaledToFit().layoutPriority(-1)
      Text("FloxBx").font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/).fontWeight(.ultraLight).padding()
      Spacer()
      #endif
      VStack{
      TextField("Email Address", text: $emailAddress).textFieldStyle(FBTextFieldStyle())
      SecureField("Password", text: $password).textFieldStyle(FBTextFieldStyle())
      }.padding()
      
        #if os(watchOS)
        Button(action: {
          self.presentLoginOrSignup = true
        }, label: {
          Text("Get Started").fontWeight(.bold)
        })
        #else
        HStack{
          Button(action: {
            self.object.beginSignIn(withCredentials: .init(username: self.emailAddress, password: self.password))
          }, label: {
            Text("Sign In").fontWeight(.light)
          }).buttonStyle(FBButtonStyle())
        Spacer()
          Button(action: {
            self.object.beginSignup(withCredentials: .init(username: self.emailAddress, password: self.password))
          }, label: {
            Text("Sign Up").fontWeight(.bold)
          })
        }.padding()
        #endif
      Spacer()
    }.padding().frame(maxWidth: 300,  maxHeight: 500)
  }
    public var body: some View {
      #if os(watchOS)
      self.content.sheet(isPresented: self.$presentLoginOrSignup, content: {
                          VStack{
                            Text("Sign up new account or sign in existing?")
                            Spacer()
                            Button("Sign Up") {
                              self.object.beginSignup(withCredentials: .init(username: self.emailAddress, password: self.password))
                            }
                            Button("Sign In") {
                              self.object.beginSignIn(withCredentials: .init(username: self.emailAddress, password: self.password))
                            }
                          }
      })
      #else
      self.content
      #endif
    }
}

public struct LoginView_Previews: PreviewProvider {
  public static var previews: some View {
      ForEach(ColorScheme.allCases, id: \.self) {
           LoginView().preferredColorScheme($0)
      }
  }
}
#endif
