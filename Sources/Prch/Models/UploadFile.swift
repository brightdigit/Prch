import Foundation

/// A file upload
public struct UploadFile: Equatable {
  public let type: FileType
  public let fileName: String?
  public let mimeType: String?

  public init(type: FileType) {
    self.type = type
    fileName = nil
    mimeType = nil
  }

  public init(type: FileType, fileName: String, mimeType: String) {
    self.type = type
    self.fileName = fileName
    self.mimeType = mimeType
  }

  public enum FileType: Equatable {
    case data(Data)
    case url(URL)
  }

  func encode() -> Any {
    self
  }
}
