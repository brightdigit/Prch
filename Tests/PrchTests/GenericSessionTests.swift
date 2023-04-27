import Prch
import XCTest

struct MockGenericSuccess: Codable, Equatable {
  internal init(id: UUID = .init()) {
    self.id = id
  }

  let id: UUID
}

struct MockGenericRequest: GenericRequest, Equatable {
  internal init(path: String, parameters: [String: String], method: String, headers: [String: String], body: Data? = nil, requiresCredentials: Bool) {
    self.path = path
    self.parameters = parameters
    self.method = method
    self.headers = headers
    self.body = body
    self.requiresCredentials = requiresCredentials
  }

  static func random() -> Self {
    let parameters = Dictionary.random(withCount: 5)
    let headers = Dictionary.random(withCount: 5)
    let body = Data.random()

    return .init(
      path: UUID().uuidString,
      parameters: parameters,
      method: UUID().uuidString,
      headers: headers,
      body: body,
      requiresCredentials: false
    )
  }

  let path: String

  let parameters: [String: String]

  let method: String

  let headers: [String: String]

  let body: Data?

  let requiresCredentials: Bool

  typealias SuccessType = MockGenericSuccess
}

extension Dictionary where Key == String, Value == String {
  static func random(withCount count: Int) -> Self {
    Dictionary(uniqueKeysWithValues: (0 ..< count).map { _ in
      UUID()
    }.map { key in
      (key.uuidString, key.uuidString)
    })
  }
}

extension Data {
  static func random(withCount count: Int = 255) -> Self {
    Data((0 ..< count).map { _ in
      UInt8.random(in: 0 ... 255)
    })
  }
}

final class GenericSessionTests: XCTestCase {
  func testSuccess() async throws {
    // expected response from service
    let expected = MockGenericSuccess()

    // mock request
    let mockRequest = MockGenericRequest.random()

    // expectation that request is generated
    let requestCalledExpectation = expectation(
      description: "request called"
    )

    // response with data and status code
    let expectedResponse = try MockGenericResponse(value: expected)

    // expected request properties
    let expectedHeaders = Dictionary.random(withCount: 5)
    let expectedBaseURLComponents: URLComponents = .random()

    let session = MockGenericSession { request in
      XCTAssertEqual(
        request.baseURLComponents,
        expectedBaseURLComponents
      )
      XCTAssertEqual(
        request.headers,
        expectedHeaders
      )
      XCTAssertEqual(
        request.request as? MockGenericRequest,
        mockRequest
      )
      requestCalledExpectation.fulfill()
      return expectedResponse
    }

    // create the service
    let service = GenericServiceImpl(
      baseURLComponents: expectedBaseURLComponents,
      credentialsContainer: SimpleCredContainer(),
      session: session,
      headers: expectedHeaders
    )

    // make the call
    let actual = try await service.request(mockRequest)

    // verify values match
    XCTAssertEqual(actual, expected)

    // and expectation is fulfilled
    await fulfillment(of: [requestCalledExpectation])
  }
}
