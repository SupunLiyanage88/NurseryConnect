//
//  Incident.swift
//  NurseryConnect
//
//  Created by Supun Liyanage on 4/3/26.
//

import Foundation
import SwiftData

@Model
final class Incident {
    var id: UUID = UUID()
    var date: Date
    var categoryRaw: String
    var incidentDescription: String
    var actionTaken: String
    var witnesses: String
    var location: String
    var isAcknowledged: Bool = false
    var acknowledgedDate: Date?
    @Relationship(inverse: \Child.incidents)
    var child: Child?
    
    init(date: Date, category: IncidentCategory, incidentDescription: String, actionTaken: String, witnesses: String, location: String) {
        self.date = date
        self.categoryRaw = category.rawValue
        self.incidentDescription = incidentDescription
        self.actionTaken = actionTaken
        self.witnesses = witnesses
        self.location = location
    }
    
    var category: IncidentCategory {
        get { IncidentCategory(rawValue: categoryRaw) ?? .minorAccident }
        set { categoryRaw = newValue.rawValue }
    }
    
    var formattedDate: String {
        DateFormatters.dateFormatter.string(from: date)
    }
    
    var formattedTime: String {
        DateFormatters.timeFormatter.string(from: date)
    }
    
    var formattedAcknowledgedDate: String {
        guard let ackDate = acknowledgedDate else { return "Not acknowledged" }
        return DateFormatters.dateTimeFormatter.string(from: ackDate)
    }
    
    func acknowledge() {
        isAcknowledged = true
        acknowledgedDate = Date()
    }
}
