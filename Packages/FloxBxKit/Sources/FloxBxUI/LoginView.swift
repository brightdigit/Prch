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

  #if os(macOS)
    extension NSTextContentType {
      static var emailAddress: NSTextContentType = .username
    }
  #endif

  extension View {
    @available(iOS 15.0, watchOS 8.0, *)
    fileprivate func forEmailAddress2021() -> some View {
      // var view : some View
      #if os(macOS)
        self
      #else
        textInputAutocapitalization(.never)
          .disableAutocorrection(true)
      #endif
    }

    fileprivate func forEmailAddress2020() -> some View {
      // var view : some View

      textContentType(.emailAddress)
      #if os(iOS)
        .keyboardType(.emailAddress)
        .autocapitalization(.none)
      #elseif os(macOS)
        .textCase(.none)
      #endif
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

  struct LoginView: View {
    @EnvironmentObject var object: ApplicationObject
    @State var emailAddress: String = ""
    @State var password: String = ""
    #if os(watchOS)
      @State var presentLoginOrSignup = false
    #endif

    init() {}

    var content: some View {
      VStack {
        #if !os(watchOS)
          Spacer()
          Image("Logo").resizable().scaledToFit().layoutPriority(-1)
          Text("FloxBx").font(/*@START_MENU_TOKEN@*/ .title/*@END_MENU_TOKEN@*/).fontWeight(.ultraLight).padding()
          Spacer()
        #endif
        VStack {
          TextField("Email Address", text: $emailAddress).textFieldStyle(FBTextFieldStyle())
            .forEmailAddress()

          SecureField("Password", text: $password).textFieldStyle(FBTextFieldStyle())
        }.padding()

        #if os(watchOS)
          Button(action: {
            self.presentLoginOrSignup = true
          }, label: {
            Text("Get Started").fontWeight(.bold)
          })
        #else
          HStack {
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
      }.padding().frame(maxWidth: 300, maxHeight: 500)
    }

    var body: some View {
      #if os(watchOS)
        self.content.sheet(isPresented: self.$presentLoginOrSignup, content: {
          VStack {
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

  struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
      ForEach(ColorScheme.allCases, id: \.self) {
        LoginView().preferredColorScheme($0)
      }
    }
  }
#endif
