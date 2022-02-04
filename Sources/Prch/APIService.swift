public struct APIService<ResponseType: APIResponseValue> {
  public let id: String
  public let tag: String
  public let method: String
  public let path: String
  public let hasBody: Bool
  public let isUpload: Bool
  public let securityRequirements: [SecurityRequirement]

  public init(id: String,
              tag: String = "",
              method: String,
              path: String,
              hasBody: Bool,
              isUpload: Bool = false,
              securityRequirements: [SecurityRequirement] = []) {
    self.id = id
    self.tag = tag
    self.method = method
    self.path = path
    self.hasBody = hasBody
    self.isUpload = isUpload
    self.securityRequirements = securityRequirements
  }
}

extension APIService: CustomStringConvertible {
  public var name: String {
    "\(tag.isEmpty ? "" : "\(tag).")\(id)"
  }

  public var description: String {
    "\(name): \(method) \(path)"
  }
}
