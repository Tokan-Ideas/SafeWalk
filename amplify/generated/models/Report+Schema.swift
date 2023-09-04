// swiftlint:disable all
import Amplify
import Foundation

extension Report {
  // MARK: - CodingKeys 
   public enum CodingKeys: String, ModelKey {
    case id
    case lastUpdatedByPhoneId
    case reportType
    case latitude
    case longitude
    case timeStamp
    case negatedCounter
    case createdAt
    case updatedAt
  }
  
  public static let keys = CodingKeys.self
  //  MARK: - ModelSchema 
  
  public static let schema = defineSchema { model in
    let report = Report.keys
    
    model.authRules = [
      rule(allow: .public, operations: [.create, .update, .delete, .read])
    ]
    
    model.listPluralName = "Reports"
    model.syncPluralName = "Reports"
    
    model.attributes(
      .primaryKey(fields: [report.id])
    )
    
    model.fields(
      .field(report.id, is: .required, ofType: .string),
      .field(report.lastUpdatedByPhoneId, is: .optional, ofType: .string),
      .field(report.reportType, is: .optional, ofType: .string),
      .field(report.latitude, is: .optional, ofType: .string),
      .field(report.longitude, is: .optional, ofType: .string),
      .field(report.timeStamp, is: .optional, ofType: .string),
      .field(report.negatedCounter, is: .optional, ofType: .int),
      .field(report.createdAt, is: .optional, isReadOnly: true, ofType: .dateTime),
      .field(report.updatedAt, is: .optional, isReadOnly: true, ofType: .dateTime)
    )
    }
}

extension Report: ModelIdentifiable {
  public typealias IdentifierFormat = ModelIdentifierFormat.Default
  public typealias IdentifierProtocol = DefaultModelIdentifier<Self>
}