import Vapor

public protocol RouteGroupCollection {
  associatedtype RouteGroupKeyType: Hashable
  var routeGroups: [RouteGroupKeyType: RouteCollectionBuilder] {
    get
  }
}
