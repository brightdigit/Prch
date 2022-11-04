#if canImport(GroupActivities)
  import GroupActivities

  @available(iOS 15, *)
  public protocol SharePlayActivity: Identifiable, GroupActivity {
    associatedtype ConfigurationType
    init(configuration: ConfigurationType)
  }
#endif
