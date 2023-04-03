import Foundation
import StealthyStash
extension Data {
  func string(encoding: String.Encoding = .utf8) -> String? {
    String(data: self, encoding: encoding)
  }
}

extension AnyStealthyProperty {
  
  public var dataString: String {
    self.property.dataString
  }
}


extension StealthyProperty {
    public var dataString: String {
      String(data: data, encoding: .utf8) ?? ""
    }
}
public struct CompositeCredentialsQueryBuilder: ModelQueryBuilder {
  public static func updates(from previousItem: Credentials, to newItem: Credentials) -> [StealthyPropertyUpdate] {
    let newPasswordData = newItem.password.data(using: .utf8).map {
      InternetPasswordItem(account: newItem.username, data: $0)
    }

    let oldPasswordData = previousItem.password.data(using: .utf8).map {
      InternetPasswordItem(account: previousItem.username, data: $0)
    }

    let previousTokenData = previousItem.token.flatMap {
      $0.data(using: .utf8)
    }.map {
      GenericPasswordItem(account: previousItem.username, data: $0)
    }

    let newTokenData = newItem.token.flatMap {
      $0.data(using: .utf8)
    }.map {
      GenericPasswordItem(account: newItem.username, data: $0)
    }

    let passwordUpdate = StealthyPropertyUpdate(previousProperty: oldPasswordData, newProperty: newPasswordData)
    let tokenUpdate = StealthyPropertyUpdate(previousProperty: previousTokenData, newProperty: newTokenData)
    return [passwordUpdate, tokenUpdate]
  }

  public static func properties(from model: Credentials, for _: ModelOperation) -> [AnyStealthyProperty] {
    let passwordData = model.password.data(using: .utf8)
    

    let passwordProperty: AnyStealthyProperty = .init(
      property: InternetPasswordItem(
        account: model.username,
        data: passwordData ?? .init()
      )
    )

    let tokenData = model.token.flatMap {
      $0.data(using: .utf8)
    }

    let tokenProperty: AnyStealthyProperty = .init(
      property: GenericPasswordItem(
        account: model.username,
        data: tokenData ?? .init()
      )
    )

    return [passwordProperty, tokenProperty]
  }

  public static func queries(from _: Void) -> [String: Query] {
    [
      "password": TypeQuery(type: .internet),
      "token": TypeQuery(type: .generic)
    ]
  }

  public static func model(from properties: [String: [AnyStealthyProperty]]) throws -> Credentials? {
    for internet in properties["password"] ?? [] {
      for generic in properties["token"] ?? [] {
        if internet.account == generic.account {
          return .init(username: internet.account, password: internet.dataString, token: generic.dataString)
        }
      }
    }
    let properties = properties.values.flatMap { $0 }.enumerated().sorted { lhs, rhs in
      if lhs.element.propertyType == rhs.element.propertyType {
        return lhs.offset < rhs.offset
      } else {
        return lhs.element.propertyType == .internet
      }
    }.map(\.element)

    guard let username = properties.map(\.account).first else {
      return nil
    }
    guard let password = properties
      .first(where: { $0.propertyType == .internet })?
      .dataString else {
        return nil
      }
    let token = properties.first { $0.propertyType == .generic && $0.account == username }?.data

    return Credentials(username: username, password: password, token: token?.string())
  }

  public typealias QueryType = Void

  public typealias StealthyModelType = Credentials
}
