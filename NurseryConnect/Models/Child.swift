//
//  Child.swift
//  NurseryConnect
//
//  Created by Supun Liyanage on 4/3/26.
//

import Foundation
import SwiftData

@Model
final class Child {
    var id: UUID = UUID()
    var name: String
    var dateOfBirth: Date
    var parentName: String
    var profileImageName: String? // Optional: SF Symbol name for avatar
    
    @Relationship(deleteRule: .cascade) var diaryEntries: [DiaryEntry] = []
    @Relationship(deleteRule: .cascade) var incidents: [Incident] = []
    
    init(name: String, dateOfBirth: Date, parentName: String, profileImageName: String? = nil) {
        self.name = name
        self.dateOfBirth = dateOfBirth
        self.parentName = parentName
        self.profileImageName = profileImageName
    }
    
    var ageInYears: Int {
        Calendar.current.dateComponents([.year], from: dateOfBirth, to: Date()).year ?? 0
    }
    
    var formattedDateOfBirth: String {
        DateFormatters.dateFormatter.string(from: dateOfBirth)
    }
}
