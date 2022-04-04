//
//  File.swift
//  
//
//  Created by Leo Dion on 5/16/21.
//

public enum Configuration {
  
  public static let dsn = "https://d2a8d5241ccf44bba597074b56eb692d@o919385.ingest.sentry.io/5868822"

}
#if canImport(Combine) && canImport(SwiftUI)
import Combine
import SwiftUI
import Canary

struct EmptyError : Error {
  
}

public struct CredentialsContainer {
  
  static let accessGroup = "MLT7M394S7.com.brightdigit.FloxBx"
  func upsertAccount(_ account: String, andToken token: String) throws {
    let tokenData = token.data(using: String.Encoding.utf8)!
    let tokenQuery: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                     kSecAttrService as String: ApplicationObject.server,
                                kSecMatchLimit as String: kSecMatchLimitOne,
                                kSecReturnAttributes as String: true,
                                kSecReturnData as String: true,
                                kSecAttrAccessGroup as String: Self.accessGroup]
  var tokenItem: CFTypeRef?
  let tokenStatus = SecItemCopyMatching(tokenQuery as CFDictionary, &tokenItem)
    if tokenStatus == errSecItemNotFound {
      
      let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
      kSecAttrAccount as String: account,
      kSecValueData as String: tokenData,
      kSecAttrService as String: ApplicationObject.server,
      kSecAttrAccessGroup as String: Self.accessGroup]
      
      // on success
      let status = SecItemAdd(query as CFDictionary, nil)
      guard status == errSecSuccess else { throw KeychainError.unhandledError(status: status) }
    } else {
      
      let tokenQuery: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                       kSecAttrService as String: ApplicationObject.server,
                                       kSecAttrAccessGroup as String: Self.accessGroup]
      guard tokenStatus == errSecSuccess else { throw KeychainError.unhandledError(status: tokenStatus) }
      
      let attributes: [String: Any] = [kSecAttrAccount as String: account,
                                       kSecValueData as String: tokenData]
      let status = SecItemUpdate(tokenQuery as CFDictionary, attributes as CFDictionary)
      guard status != errSecItemNotFound else { throw KeychainError.noPassword }
      guard status == errSecSuccess else { throw KeychainError.unhandledError(status: status) }
    }
  }
  func upsertAccount(_ account: String, andPassword password: String) throws {
    let passwordData = password.data(using: String.Encoding.utf8)!
    let query: [String: Any] = [kSecClass as String: kSecClassInternetPassword,
                                kSecAttrServer as String: ApplicationObject.server,
                                kSecMatchLimit as String: kSecMatchLimitOne,
                                kSecReturnAttributes as String: true,
                                kSecReturnData as String: true,
                                kSecAttrAccessGroup as String: Self.accessGroup,
                                kSecAttrSynchronizable as String: kSecAttrSynchronizableAny]
    var item: CFTypeRef?
    let status = SecItemCopyMatching(query as CFDictionary, &item)
    if status == errSecItemNotFound {
      
      let query: [String: Any] = [kSecClass as String: kSecClassInternetPassword,
                                  kSecAttrAccount as String: account,
                                  kSecAttrServer as String: ApplicationObject.server,
                                  kSecValueData as String: passwordData,
                                  kSecAttrAccessGroup as String: Self.accessGroup,
                                  kSecAttrSynchronizable as String: kCFBooleanTrue!]
      
      // on success
      let status = SecItemAdd(query as CFDictionary, nil)
      guard status == errSecSuccess else { throw KeychainError.unhandledError(status: status) }
    } else {
      
      guard status == errSecSuccess else { throw KeychainError.unhandledError(status: status) }
      
        let query: [String: Any] = [kSecClass as String: kSecClassInternetPassword,
                                    kSecAttrServer as String: ApplicationObject.server,
                                    kSecAttrAccessGroup as String: Self.accessGroup,
                                    kSecAttrSynchronizable as String: kSecAttrSynchronizableAny]
      let attributes: [String: Any] = [kSecAttrAccount as String: account,
                                       kSecValueData as String: passwordData,
                                       kSecAttrSynchronizable as String: kCFBooleanTrue!]
      let status = SecItemUpdate(query as CFDictionary, attributes as CFDictionary)
      guard status != errSecItemNotFound else { throw KeychainError.noPassword }
      guard status == errSecSuccess else { throw KeychainError.unhandledError(status: status) }
    }
  }
  func fetch () throws -> Credentials? {
    let query: [String: Any] = [kSecClass as String: kSecClassInternetPassword,
                                kSecAttrServer as String: ApplicationObject.server,
                                kSecMatchLimit as String: kSecMatchLimitOne,
                                kSecReturnAttributes as String: true,
                                kSecReturnData as String: true,
                                kSecAttrAccessGroup as String: Self.accessGroup,
                                kSecAttrSynchronizable as String: kSecAttrSynchronizableAny]
    var item: CFTypeRef?
    let status = SecItemCopyMatching(query as CFDictionary, &item)
    guard status != errSecItemNotFound else { return nil }
    guard status == errSecSuccess else { throw KeychainError.unhandledError(status: status) }
    guard let existingItem = item as? [String : Any],
        let passwordData = existingItem[kSecValueData as String] as? Data,
        let password = String(data: passwordData, encoding: String.Encoding.utf8),
        let account = existingItem[kSecAttrAccount as String] as? String
    else {
        throw KeychainError.unexpectedPasswordData
    }
    
      let tokenQuery: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                       kSecAttrService as String: ApplicationObject.server,
                                  kSecMatchLimit as String: kSecMatchLimitOne,
                                  kSecReturnAttributes as String: true,
                                  kSecReturnData as String: true,
                                  kSecAttrAccessGroup as String: Self.accessGroup]
    var tokenItem: CFTypeRef?
    let tokenStatus = SecItemCopyMatching(tokenQuery as CFDictionary, &tokenItem)
    
    if let existingItem = tokenItem as? [String : Any],
        let passwordData = existingItem[kSecValueData as String] as? Data,
        let token = String(data: passwordData, encoding: String.Encoding.utf8),
        tokenStatus == errSecSuccess
     {
      return Credentials(username: account, password: password, token: token)
    } else {
      return Credentials(username: account, password: password)
    }
  }
  
  func save (credentials: Credentials) throws {
    try upsertAccount(credentials.username, andPassword: credentials.password)
    if let token = credentials.token {
    try upsertAccount(credentials.username, andToken: token)
    }
    
  }
}

public extension Result {
  init(success: Success?, failure: Failure?, otherwise: @autoclosure () -> Failure) {
    if let failure = failure {
      self = .failure(failure)
    } else if let success = success {
      self = .success(success)
    } else {
      self = .failure(otherwise())
    }
  }
}
public struct Credentials {
  public init(username: String, password: String, token: String? = nil) {
    self.username = username
    self.password = password
    self.token = token
  }
  
    let username: String
    let password: String
  let token: String?
  
  func withToken(_ token: String) -> Credentials {
    Credentials(username: username, password: password, token: token)
  }
}

enum KeychainError: Error {
    case unexpectedPasswordData
  case noPassword
    case unhandledError(status: OSStatus)
}

public class ApplicationObject: ObservableObject {
  @Published public var requiresAuthentication: Bool
  @Published var latestError : Error?
  @Published var token : String?
  @Published var items: [TodoContentItem]?
  
  let credentialsContainer = CredentialsContainer()
  let sentry = CanaryClient()
  
  static let baseURL : URL = {
    var components = URLComponents()
    components.host = ProcessInfo.processInfo.environment["HOST_NAME"]
    components.scheme = "https"
    return components.url!
  }()
  static let encoder = JSONEncoder()
  static let decoder = JSONDecoder()
  static let server = "floxbx.work"
  public init (items: [CreateTodoResponseContent]? = nil) {
    self.requiresAuthentication = true
    let authenticated = self.$token.map{$0 == nil}
    authenticated.receive(on: DispatchQueue.main).assign(to: &self.$requiresAuthentication)
    self.$token.share().compactMap{$0}.flatMap { token -> URLSession.DataTaskPublisher in
      
      let request = Self.request(withURLPath: "api/v1/todos", method: "GET", withToken: token)
      
      return URLSession.shared.dataTaskPublisher(for: request)
      
    }.map(\.data).decode(type: [TodoContentItem]?.self, decoder: Self.decoder)
    
    .replaceError(with: nil).receive(on: DispatchQueue.main).assign(to: &self.$items)
    
    try! self.sentry.start(withOptions: .init(dsn: Configuration.dsn))
  }
  
  public static func url(withPath path: String) -> URL {
    return baseURL.appendingPathComponent(path)
  }
  
  public static func request(withURLPath path: String, method: String = "GET", withToken token: String? = nil) -> URLRequest {
    let url = Self.url(withPath: path)
    var request = URLRequest(url: url)
    request.httpMethod = method
    request.addValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
    if let token = token {
      
      request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    }
    
    return request
  }
  
  public static func request<EncodableType : Encodable>(withURLPath path: String, method: String = "GET", withToken token: String? = nil, body: EncodableType? = nil)  throws -> URLRequest {
    var request = self.request(withURLPath: path, method: method, withToken: token)
    if let body = body {
    let httpBody = try encoder.encode(body)
    request.httpBody = httpBody
    }
    
    return request
  }
  
  public func begin() {
    let credentials: Credentials?
    let error: Error?
    
    do {
      credentials = try self.credentialsContainer.fetch()
      error = nil
    } catch let caughtError {
      error = caughtError
      credentials = nil
    }
    
    self.latestError = self.latestError ?? error
    
    if let credentials = credentials {
      self.beginSignIn(withCredentials: credentials)
    } else {
      DispatchQueue.main.async {
        self.requiresAuthentication = true
      }
      
    }

  }
  
  
  public func beginSignup(withCredentials credentials: Credentials) {
    var request = URLRequest(url: Self.url(withPath: "api/v1/users"))
    request.httpMethod = "POST"
    request.addValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
    let body = try! ApplicationObject.encoder.encode(CreateUserRequestContent(emailAddress: credentials.username, password: credentials.password))
    request.httpBody = body
    URLSession.shared.dataTask(with: request) { data, response, error in
      
      let result : Result<Data, Error> = Result<Data, Error>(success: data, failure: error, otherwise: EmptyError())
      let decodedResult = result.flatMap { data in
        Result {
          try ApplicationObject.decoder.decode(CreateUserResponseContent.self, from: data)
        }
      }
      let credentials = decodedResult.map{ content in
        return credentials.withToken(content.token)
      }
      let savingResult = credentials.flatMap{ creds in
        Result(catching: {try self.credentialsContainer.save(credentials: creds)}).map{
          creds
        }
      }
      DispatchQueue.main.async {
        switch savingResult {
        case .failure(let error):
          self.latestError = error
        case .success(let creds):
          self.beginSignIn(withCredentials: creds)
        }
        
      }
    }.resume()
  }
  public func beginSignIn(withCredentials credentials: Credentials) {
    let encoder = JSONEncoder()
    let decoder = JSONDecoder()
    var request = URLRequest(url: Self.url(withPath: "api/v1/tokens"))
    if let token = credentials.token {
      request.httpMethod = "GET"
      request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
      request.addValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
    } else {
      request.httpMethod = "POST"
      request.addValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
      let body = try! encoder.encode(CreateTokenRequestContent(emailAddress: credentials.username, password: credentials.password))
      request.httpBody = body
    }
    URLSession.shared.dataTask(with: request) { data, response, error in
      
      if credentials.token != nil, let response = response as? HTTPURLResponse {
        guard response.statusCode / 100 == 2 else {
          self.beginSignIn(withCredentials: Credentials(username: credentials.username, password: credentials.password))
          return
        }
      }
      let result : Result<Data, Error> = Result<Data, Error>(success: data, failure: error, otherwise: EmptyError())
      let decodedResult = result.flatMap { data in
        Result {
          try decoder.decode(CreateTokenResponseContent.self, from: data)
        }
      }
      let credentials = decodedResult.map{ content in
        return credentials.withToken(content.token)
      }
      let savingResult = credentials.flatMap{ creds in
        Result(catching: {try self.credentialsContainer.save(credentials: creds)}).map{
          creds
        }
      }
      DispatchQueue.main.async {
        switch savingResult {
        case .failure(let error):
          self.latestError = error
        case .success(let creds):
          self.token = creds.token
        }
        
      }
    }.resume()
  }
}
#endif
