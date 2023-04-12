import PrchModel
import Foundation

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

struct SimpleCreds {
  let userName : String
  let password : String
  let token : String?
  
  
  var httpHeaders : [String : String] {
    fatalError()
  }
}

class SimpleCredContainer {
  func fetch() async throws -> SimpleCreds? {
    fatalError()
  }
}

struct SimpleRequest {
  let path : String
  let parameters : [String : String]
  let method : String
  let headers : [String : String]
  let body : Data?
  let requiresCredentials : Bool
}

class SimpleService {
  internal init(baseURLComponents: URLComponents, credentialsContainer: SimpleCredContainer, session: URLSession, headers: [String : String]) {
    self.baseURLComponents = baseURLComponents
    self.credentialsContainer = credentialsContainer
    self.session = session
    self.headers = headers
  }
  
  
  private let baseURLComponents: URLComponents
  private let credentialsContainer: SimpleCredContainer
  private let session: URLSession
  private let headers: [String: String]
  
  private static func headers(
    withCredentials credentialsContainer: SimpleCredContainer?,
    mergedWith headers: [String: String]
  ) async throws -> [String: String] {
    let creds = try await credentialsContainer?.fetch()
    
    let authorizationHeaders: [String: String]
    if let creds = creds {
      authorizationHeaders = creds.httpHeaders
    } else {
      authorizationHeaders = [:]
    }
    
    return headers.merging(authorizationHeaders) { _, rhs in
      rhs
    }
  }
  
  private func build(request: SimpleRequest,
                     withBaseURL baseURLComponents: URLComponents,
                     withHeaders headers: [String : String]
  ) throws -> URLRequest  {
    var componenents = baseURLComponents
    componenents.path = "/\(request.path)"
    componenents.queryItems = request.parameters.map(URLQueryItem.init)
    
    guard let url = componenents.url else {
      preconditionFailure()
    }
    
    var urlRequest = URLRequest(url: url)
    
    urlRequest.httpMethod = request.method
    
    let allHeaders = headers.merging(request.headers, uniquingKeysWith: { lhs, _ in lhs })
    
    for (field, value) in allHeaders {
      urlRequest.addValue(value, forHTTPHeaderField: field)
    }
    
    if let body = request.body {
      urlRequest.httpBody = body
    }
    
    return urlRequest
  }
  
  public func request(_ request: SimpleRequest) async throws -> Data? {
    let sessionRequest: URLRequest
    let credetials = request.requiresCredentials ? credentialsContainer : nil
    
    let headers = try await Self.headers(
          withCredentials: credetials,
          mergedWith: headers
        )
  
    sessionRequest = try self.build(
      request: request,
      withBaseURL: baseURLComponents,
      withHeaders: headers
    )
    
    let (data, urlResponse) = try await session.data(for: sessionRequest)
    
    guard let response = urlResponse as? HTTPURLResponse else {
      throw RequestError.invalidResponse(urlResponse)
    }
    
    guard response.statusCode / 100 == 2 else {
      throw RequestError.invalidStatusCode(response.statusCode)
    }
    return data
  }
}
