import Vapor

public struct GroupBuilder<RouteGroupKeyType: Hashable> {
  public let groups: [RouteGroupKeyType: RoutesBuilder]

  public init(groups: [RouteGroupKeyType: RoutesBuilder]) {
    self.groups = groups
  }

  public func register<RouteGroupCollectionType: RouteGroupCollection>(
    collection: RouteGroupCollectionType
  ) throws where RouteGroupCollectionType.RouteGroupKeyType == RouteGroupKeyType {
    for (type, group) in collection.routeGroups {
      if let builder = groups[type] {
        try group(builder)
      }
    }
  }
}
