#if canImport(SwiftUI)
  import SwiftUI

  internal struct LoginView: View {
    @EnvironmentObject private var object: ApplicationObject
    @State private var emailAddress: String = ""
    @State private var password: String = ""
    #if os(watchOS)
      @State private var presentLoginOrSignup = false
    #endif

    private var content: some View {
      // swiftlint:disable:next closure_body_length
      VStack {
        #if !os(watchOS)
          Spacer()
          Image("Logo").resizable().scaledToFit().layoutPriority(-1)
          Text("FloxBx")
            .font(/*@START_MENU_TOKEN@*/ .title/*@END_MENU_TOKEN@*/)
            .fontWeight(.ultraLight)
            .padding()
          Spacer()
        #endif
        VStack {
          TextField("Email Address", text: $emailAddress)
            .textFieldStyle(FBTextFieldStyle())
            .forEmailAddress()

          SecureField("Password", text: $password).textFieldStyle(FBTextFieldStyle())
        }.padding()

        #if os(watchOS)
          Button(action: {
            self.presentLoginOrSignup = true
          }, label: {
            Text("Get Started")
              .fontWeight(.bold)
          })
        #else
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
        #endif
        Spacer()
      }.padding().frame(maxWidth: 300, maxHeight: 500)
    }

    internal var body: some View {
      #if os(watchOS)
        self.content.sheet(isPresented: self.$presentLoginOrSignup, content: {
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
        })
      #else
        self.content
      #endif
    }

    internal init() {}
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
