import PrchModel
import Foundation

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif


public protocol GenericSessionResponse {
  var statusCode : Int { get }
  var data : Data { get }
}

struct URLGenericSessionResponse : GenericSessionResponse {
  internal init(httpURLResponse: HTTPURLResponse, data: Data) {
    self.httpURLResponse = httpURLResponse
    self.data = data
  }
  
  internal init(_ tuple: (Data, URLResponse)) throws {
    guard let response = tuple.1 as? HTTPURLResponse else {
      throw RequestError.invalidResponse(tuple.1)
    }
    self.init(httpURLResponse: response, data: tuple.0)
  }
  
  let httpURLResponse: HTTPURLResponse
  let data: Data
  
  var statusCode: Int {
    return httpURLResponse.statusCode
  }
}


public protocol GenericSession<GenericSessionRequestType> {
  associatedtype GenericSessionRequestType
  func build<RequestType : GenericRequest>(
    request: RequestType,
    withBaseURL baseURLComponents: URLComponents,
    withHeaders headers: [String : String]
  ) throws -> GenericSessionRequestType
  
  func data(for request: GenericSessionRequestType) async throws -> GenericSessionResponse
}


extension URLSession : GenericSession {
  public typealias GenericSessionRequestType = URLRequest
  
  public func build<RequestType>(
    request: RequestType,
    withBaseURL baseURLComponents: URLComponents,
    withHeaders headers: [String : String]
  ) throws -> URLRequest
  where RequestType : GenericRequest {
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
  
  public func data(for request: GenericSessionRequestType) async throws -> GenericSessionResponse {
    let tuple : (Data, URLResponse) = try await self.data(for: request)
    return try URLGenericSessionResponse(tuple)
    
  }
}
public protocol GenericRequest {
  associatedtype SuccessType : Decodable
  var path : String { get }
  var parameters : [String : String] { get }
  var method : String { get }
  var headers : [String : String] { get }
  var body : Data? { get }
  var requiresCredentials : Bool { get }
}

public protocol GenericService {
  func request<RequestType : GenericRequest>(
    _ request: RequestType
  ) async throws -> RequestType.SuccessType
}

public class GenericServiceImpl<GenericRequestType> : GenericService {

  
 

  public  init(
    baseURLComponents: URLComponents,
    credentialsContainer: SimpleCredContainer = .init(),
    session: any GenericSession<GenericRequestType>,
    headers: [String : String] = [:]
  ) {
    self.baseURLComponents = baseURLComponents
    self.credentialsContainer = credentialsContainer
    self.session = session
    self.headers = headers
  }


  private let baseURLComponents: URLComponents
  private let credentialsContainer: SimpleCredContainer
  private let session: any GenericSession<GenericRequestType>
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

//  private func build<RequestType : GenericRequest>(request: RequestType,
//                     withBaseURL baseURLComponents: URLComponents,
//                     withHeaders headers: [String : String]
//  ) throws -> GenericSessionRequest  {
//    var componenents = baseURLComponents
//    componenents.path = "/\(request.path)"
//    componenents.queryItems = request.parameters.map(URLQueryItem.init)
//
//    guard let url = componenents.url else {
//      preconditionFailure()
//    }
//
//    var urlRequest =
//
//    urlRequest.httpMethod = request.method
//
//    let allHeaders = headers.merging(request.headers, uniquingKeysWith: { lhs, _ in lhs })
//
//    for (field, value) in allHeaders {
//      urlRequest.addValue(value, forHTTPHeaderField: field)
//    }
//
//    if let body = request.body {
//      urlRequest.httpBody = body
//    }
//
//    return urlRequest
//  }

public func request<RequestType>(_ request: RequestType) async throws -> RequestType.SuccessType where RequestType : GenericRequest {
  
  let credetials = request.requiresCredentials ? credentialsContainer : nil

  let headers = try await Self.headers(
        withCredentials: credetials,
        mergedWith: headers
      )

  let sessionRequest = try self.session.build(
    request: request,
    withBaseURL: baseURLComponents,
    withHeaders: headers
  )

  let response = try await session.data(for: sessionRequest)

  guard response.statusCode / 100 == 2 else {
    throw RequestError.invalidStatusCode(response.statusCode)
  }
  let data : Data = response.data
  let decoder = JSONDecoder()
  let successType = type(of: request).SuccessType
  return try decoder.decode(successType, from: data)
}
}
