#if canImport(SwiftUI)
  import SwiftUI

  internal struct LoginView: View {
    @EnvironmentObject private var object: ApplicationObject
    @State private var emailAddress: String = ""
    @State private var password: String = ""
    #if os(watchOS)
      @State private var presentLoginOrSignup = false
    #endif

    private var logoTitleView: some View {
      Group {
        Spacer()
        Image("Logo").resizable().scaledToFit().layoutPriority(-1)
        Text("FloxBx")
          .font(/*@START_MENU_TOKEN@*/ .title/*@END_MENU_TOKEN@*/)
          .fontWeight(.ultraLight)
          .padding()
        Spacer()
      }
    }

    private var loginForm: some View {
      VStack {
        TextField("Email Address", text: $emailAddress)
          .textFieldStyle(FBTextFieldStyle())
          .forEmailAddress()

        SecureField("Password", text: $password).textFieldStyle(FBTextFieldStyle())
      }.padding()
    }

    private var formButtons: some View {
      HStack {
        Button(action: {
          self.object.beginSignIn(
            withCredentials: .init(
              username: self.emailAddress,
              password: self.password
            )
          )
        }, label: {
          Text("Sign In").fontWeight(.light)
        }).buttonStyle(FBButtonStyle())
        Spacer()
        Button(
          action: {
            self.object.beginSignup(
              withCredentials: .init(
                username: self.emailAddress,
                password: self.password
              )
            )
          }, label: {
            Text("Sign Up").fontWeight(.bold)
          }
        )
      }.padding()
    }

    private var content: some View {
      VStack {
        #if !os(watchOS)
          logoTitleView
        #endif
        loginForm

        #if os(watchOS)
          Button(action: {
            self.presentLoginOrSignup = true
          }, label: {
            Text("Get Started")
              .fontWeight(.bold)
          })
        #else
          formButtons
        #endif
        Spacer()
      }.padding().frame(maxWidth: 300, maxHeight: 500)
    }

    internal var body: some View {
      #if os(watchOS)
        self.content.sheet(
          isPresented: self.$presentLoginOrSignup,
          content: self.watchForm
        )
      #else
        self.content
      #endif
    }

    internal init() {}

    private func watchForm() -> some View {
      VStack {
        Text("Sign up new account or sign in existing?")
        Spacer()
        Button("Sign Up") {
          self.object
            .beginSignup(
              withCredentials: .init(
                username: self.emailAddress,
                password: self.password
              )
            )
        }
        Button("Sign In") {
          self.object.beginSignIn(
            withCredentials: .init(
              username: self.emailAddress,
              password: self.password
            )
          )
        }
      }
    }
  }

  private struct LoginView_Previews: PreviewProvider {
    // swiftlint:disable:next strict_fileprivate
    fileprivate static var previews: some View {
      ForEach(ColorScheme.allCases, id: \.self) {
        LoginView().preferredColorScheme($0)
      }
    }
  }
#endif
