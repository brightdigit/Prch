@testable import FloxBxServerKit
import Foundation
import XCTest
import XCTVapor

final class AppTests: XCTestCase {
  func testHelloWorld() throws {
    let app = Application(.testing)
    try Server.configure(app)

    defer { app.shutdown() }

    let emailAddress = UUID().uuidString
    let password = UUID().uuidString

    try app.test(.POST, "users") { request in
      try request.content.encode(
        CreateUserRequestContent(emailAddress: emailAddress, password: password)
      )
    } afterResponse: { response in
      do {
        _ = try response.content.decode(CreateUserResponseContent.self)
      } catch {
        XCTAssertNil(error)
        return
      }
    }
  }
}
