// swiftlint:disable all
import Amplify
import Foundation

// Contains the set of classes that conforms to the `Model` protocol. 

final public class AmplifyModels: AmplifyModelRegistration {
  public let version: String = "f551d7de39b93cb9e77736d8390bf29e"
  
  public func registerModels(registry: ModelRegistry.Type) {
    ModelRegistry.register(modelType: Report.self)
  }
}