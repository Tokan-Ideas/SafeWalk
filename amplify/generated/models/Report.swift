// swiftlint:disable all
import Amplify
import Foundation

public struct Report: Model {
  public let id: String
  public var lastUpdatedByPhoneId: String?
  public var reportType: String?
  public var latitude: String?
  public var longitude: String?
  public var timeStamp: String?
  public var negatedCounter: Int?
  public var createdAt: Temporal.DateTime?
  public var updatedAt: Temporal.DateTime?
  
  public init(id: String = UUID().uuidString,
      lastUpdatedByPhoneId: String? = nil,
      reportType: String? = nil,
      latitude: String? = nil,
      longitude: String? = nil,
      timeStamp: String? = nil,
      negatedCounter: Int? = nil) {
    self.init(id: id,
      lastUpdatedByPhoneId: lastUpdatedByPhoneId,
      reportType: reportType,
      latitude: latitude,
      longitude: longitude,
      timeStamp: timeStamp,
      negatedCounter: negatedCounter,
      createdAt: nil,
      updatedAt: nil)
  }
  internal init(id: String = UUID().uuidString,
      lastUpdatedByPhoneId: String? = nil,
      reportType: String? = nil,
      latitude: String? = nil,
      longitude: String? = nil,
      timeStamp: String? = nil,
      negatedCounter: Int? = nil,
      createdAt: Temporal.DateTime? = nil,
      updatedAt: Temporal.DateTime? = nil) {
      self.id = id
      self.lastUpdatedByPhoneId = lastUpdatedByPhoneId
      self.reportType = reportType
      self.latitude = latitude
      self.longitude = longitude
      self.timeStamp = timeStamp
      self.negatedCounter = negatedCounter
      self.createdAt = createdAt
      self.updatedAt = updatedAt
  }
}