import Foundation

#if canImport(FoundationNetworking)
  import FoundationNetworking
#endif

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

  func fetch() throws -> Credentials? {
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
    guard let existingItem = item as? [String: Any],
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

    if let existingItem = tokenItem as? [String: Any],
       let passwordData = existingItem[kSecValueData as String] as? Data,
       let token = String(data: passwordData, encoding: String.Encoding.utf8),
       tokenStatus == errSecSuccess {
      return Credentials(username: account, password: password, token: token)
    } else {
      return Credentials(username: account, password: password)
    }
  }

  func save(credentials: Credentials) throws {
    try upsertAccount(credentials.username, andPassword: credentials.password)
    if let token = credentials.token {
      try upsertAccount(credentials.username, andToken: token)
    }
  }
}
