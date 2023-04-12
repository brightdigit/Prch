//
//  File.swift
//  
//
//  Created by Leo Dion on 4/12/23.
//

import Foundation
import Prch

struct MockGenericResponse : GenericSessionResponse {
  static let encoder = JSONEncoder()
  internal init(statusCode: Int = 200, data: Data) {
    self.statusCode = statusCode
    self.data = data
  }
  
  internal init(statusCode : Int = 200, value: MockGenericSuccess) throws {
    let data = try Self.encoder.encode(value)
    self.init(statusCode: statusCode, data: data)
  }
  
  let statusCode: Int
  
  let data: Data
  
  
}
struct MockGenericSessionRequest {
  let request: any GenericRequest
  let baseURLComponents : URLComponents
  let headers : [String : String]
}

class MockGenericSession : GenericSession {
  typealias GenericSessionRequestType = MockGenericSessionRequest
  
  let responseFromRequest : (MockGenericSessionRequest) -> GenericSessionResponse
  
  internal init(
    responseFromRequest: @escaping (MockGenericSessionRequest) -> GenericSessionResponse
  ) {
    self.responseFromRequest = responseFromRequest
  }
  
  func build<RequestType>(
    request: RequestType,
    withBaseURL baseURLComponents: URLComponents,
    withHeaders headers: [String : String]
  ) throws -> MockGenericSessionRequest
  where RequestType : Prch.GenericRequest {
    return MockGenericSessionRequest(
      request: request,
      baseURLComponents: baseURLComponents,
      headers: headers
    )
  }
  
  func data(
    for request: MockGenericSessionRequest
  ) async throws -> Prch.GenericSessionResponse {
    responseFromRequest(request)
  }
}
