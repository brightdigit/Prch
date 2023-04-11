struct SimpleCreds {
  let userName: String
  let password: String
  let token: String?

  var httpHeaders: [String: String] {
    fatalError()
  }
}
