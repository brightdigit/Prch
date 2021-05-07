@testable import FloxBxKit
import XCTVapor

final class AppTests: XCTestCase {
    func testHelloWorld() throws {
      let app = Application(.testing)
      try Server.configure(app)
      
      defer { app.shutdown() }

      try app.test(.GET, "hello", afterResponse: { res in
          XCTAssertEqual(res.status, .ok)
          XCTAssertEqual(res.body.string, "Hello, world!")
      })
    }
}
