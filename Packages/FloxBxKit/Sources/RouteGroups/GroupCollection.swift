import Vapor

public protocol GroupCollection: RouteCollection {
  associatedtype RouteGroupKeyType: Hashable
  func groupBuilder(routes: RoutesBuilder) -> GroupBuilder<RouteGroupKeyType>
  func boot(groups: GroupBuilder<RouteGroupKeyType>) throws
}

extension GroupCollection {
  public func boot(routes: RoutesBuilder) throws {
    let groupBuilder = self.groupBuilder(routes: routes)
    try boot(groups: groupBuilder)
  }
}
