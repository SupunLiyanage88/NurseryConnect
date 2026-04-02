//
//  DiaryEntry.swift
//  NurseryConnect
//
//  Created by Supun Liyanage on 4/3/26.
//

import Foundation
import SwiftData

@Model
final class DiaryEntry {
    var id: UUID = UUID()
    var timestamp: Date
    var typeRaw: String // Stored as raw string for SwiftData compatibility
    var notes: String
    @Relationship(inverse: \Child.diaryEntries)
    var child: Child?
    
    // Meal-specific
    var foodOffered: String?
    var portionConsumedRaw: String?
    
    // Sleep-specific
    var sleepStart: Date?
    var sleepEnd: Date?
    
    // Nappy-specific
    var nappyTypeRaw: String?
    var nappyConcerns: String?
    
    // Wellbeing-specific
    var moodRaw: String?
    
    init(timestamp: Date, type: DiaryEntryType, notes: String) {
        self.timestamp = timestamp
        self.typeRaw = type.rawValue
        self.notes = notes
    }
    
    var type: DiaryEntryType {
        get { DiaryEntryType(rawValue: typeRaw) ?? .activity }
        set { typeRaw = newValue.rawValue }
    }
    
    var portionConsumed: PortionSize? {
        get { portionConsumedRaw.flatMap { PortionSize(rawValue: $0) } }
        set { portionConsumedRaw = newValue?.rawValue }
    }
    
    var nappyType: NappyType? {
        get { nappyTypeRaw.flatMap { NappyType(rawValue: $0) } }
        set { nappyTypeRaw = newValue?.rawValue }
    }
    
    var mood: MoodRating? {
        get { moodRaw.flatMap { MoodRating(rawValue: $0) } }
        set { moodRaw = newValue?.rawValue }
    }
    
    var formattedTime: String {
        DateFormatters.timeFormatter.string(from: timestamp)
    }
    
    var formattedDate: String {
        DateFormatters.dateFormatter.string(from: timestamp)
    }
    
    var sleepDurationFormatted: String {
        guard let start = sleepStart, let end = sleepEnd else { return "N/A" }
        let duration = end.timeIntervalSince(start)
        let hours = Int(duration) / 3600
        let minutes = (Int(duration) % 3600) / 60
        return "\(hours)h \(minutes)m"
    }
}
