//
//  Enums.swift
//  NurseryConnect
//
//  Created by Supun Liyanage on 4/3/26.
//

import Foundation

enum DiaryEntryType: String, CaseIterable {
    case arrival = "Arrival"
    case departure = "Departure"
    case activity = "Activity"
    case sleep = "Sleep"
    case meal = "Meal"
    case nappy = "Nappy / Toilet"
    case wellbeing = "Wellbeing"
    
    var iconName: String {
        switch self {
        case .arrival: return "figure.walk.arrival"
        case .departure: return "figure.walk.departure"
        case .activity: return "figure.play"
        case .sleep: return "bed.double.fill"
        case .meal: return "fork.knife"
        case .nappy: return "drop.fill"
        case .wellbeing: return "face.smiling"
        }
    }
    
    var color: String {
        switch self {
        case .arrival, .departure: return "blue"
        case .activity: return "green"
        case .sleep: return "purple"
        case .meal: return "orange"
        case .nappy: return "teal"
        case .wellbeing: return "pink"
        }
    }
}

enum PortionSize: String, CaseIterable {
    case all = "All"
    case most = "Most"
    case half = "Half"
    case little = "Little"
    case none = "None"
    case refused = "Refused"
    
    var percentageValue: Int {
        switch self {
        case .all: return 100
        case .most: return 75
        case .half: return 50
        case .little: return 25
        case .none, .refused: return 0
        }
    }
}

enum NappyType: String, CaseIterable {
    case wet = "Wet"
    case dirty = "Dirty"
    case both = "Both"
    case none = "None"
    case dry = "Dry"
}

enum MoodRating: String, CaseIterable {
    case veryHappy = "😊 Very Happy"
    case happy = "🙂 Happy"
    case neutral = "😐 Neutral"
    case unsettled = "😕 Unsettled"
    case upset = "😢 Upset"
    case poorly = "🤒 Poorly"
}

enum IncidentCategory: String, CaseIterable {
    case minorAccident = "Minor Accident"
    case firstAid = "Required First Aid"
    case allergicReaction = "Allergic Reaction"
    case safeguarding = "Safeguarding Concern"
    case medicalIncident = "Medical Incident"
    case nearMiss = "Near Miss"
    
    var severityColor: String {
        switch self {
        case .minorAccident, .nearMiss: return "yellow"
        case .firstAid: return "orange"
        case .allergicReaction, .medicalIncident: return "red"
        case .safeguarding: return "purple"
        }
    }
    
    var iconName: String {
        switch self {
        case .minorAccident: return "bandage.fill"
        case .firstAid: return "cross.case.fill"
        case .allergicReaction: return "allergens"
        case .safeguarding: return "shield.fill"
        case .medicalIncident: return "stethoscope"
        case .nearMiss: return "exclamationmark.triangle.fill"
        }
    }
}
