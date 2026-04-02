//
//  MockDataPreloader.swift
//  NurseryConnect
//
//  Created by Supun Liyanage on 4/3/26.
//

import Foundation
import SwiftData

struct MockDataPreloader {
    static func preloadIfNeeded(modelContext: ModelContext) {
        // Check if data already exists
        let childDescriptor = FetchDescriptor<Child>()
        guard let existingChildren = try? modelContext.fetch(childDescriptor), existingChildren.isEmpty else {
            print("Mock data already loaded, skipping...")
            return
        }
        
        print("Preloading mock data...")
        
        // Create a child (Emma)
        let emma = Child(
            name: "Emma Johnson",
            dateOfBirth: Calendar.current.date(byAdding: .year, value: -3, to: Date())!,
            parentName: "Sarah Johnson",
            profileImageName: "person.circle.fill"
        )
        modelContext.insert(emma)
        
        // Today's diary entries
        let now = Date()
        let calendar = Calendar.current
        
        // Arrival
        let arrival = DiaryEntry(
            timestamp: calendar.date(bySettingHour: 8, minute: 30, second: 0, of: now)!,
            type: .arrival,
            notes: "Emma arrived happy and waved goodbye to Mum"
        )
        arrival.child = emma
        emma.diaryEntries.append(arrival)
        
        // Morning activity
        let activity = DiaryEntry(
            timestamp: calendar.date(bySettingHour: 9, minute: 15, second: 0, of: now)!,
            type: .activity,
            notes: "Enjoyed painting at the art table. Made a beautiful flower picture."
        )
        activity.child = emma
        emma.diaryEntries.append(activity)
        
        // Morning snack
        let snack = DiaryEntry(
            timestamp: calendar.date(bySettingHour: 10, minute: 0, second: 0, of: now)!,
            type: .meal,
            notes: "Morning snack time"
        )
        snack.child = emma
        snack.foodOffered = "Apple slices and rice cakes"
        snack.portionConsumed = .most
        emma.diaryEntries.append(snack)
        
        // Sleep
        let sleep = DiaryEntry(
            timestamp: calendar.date(bySettingHour: 12, minute: 30, second: 0, of: now)!,
            type: .sleep,
            notes: "Slept well after lunch"
        )
        sleep.child = emma
        sleep.sleepStart = calendar.date(bySettingHour: 12, minute: 30, second: 0, of: now)
        sleep.sleepEnd = calendar.date(bySettingHour: 14, minute: 15, second: 0, of: now)
        emma.diaryEntries.append(sleep)
        
        // Lunch
        let lunch = DiaryEntry(
            timestamp: calendar.date(bySettingHour: 12, minute: 0, second: 0, of: now)!,
            type: .meal,
            notes: "Lunch time"
        )
        lunch.child = emma
        lunch.foodOffered = "Chicken pasta with peas, followed by yoghurt"
        lunch.portionConsumed = .most
        emma.diaryEntries.append(lunch)
        
        // Nappy change
        let nappy = DiaryEntry(
            timestamp: calendar.date(bySettingHour: 9, minute: 45, second: 0, of: now)!,
            type: .nappy,
            notes: "Regular nappy change"
        )
        nappy.child = emma
        nappy.nappyType = .wet
        nappy.nappyConcerns = "None"
        emma.diaryEntries.append(nappy)
        
        // Wellbeing check
        let wellbeing = DiaryEntry(
            timestamp: calendar.date(bySettingHour: 11, minute: 0, second: 0, of: now)!,
            type: .wellbeing,
            notes: "Morning wellbeing check"
        )
        wellbeing.child = emma
        wellbeing.mood = .veryHappy
        emma.diaryEntries.append(wellbeing)
        
        // Incident from yesterday
        let yesterday = calendar.date(byAdding: .day, value: -1, to: now)!
        let incident = Incident(
            date: calendar.date(bySettingHour: 10, minute: 30, second: 0, of: yesterday)!,
            category: .minorAccident,
            incidentDescription: "Emma tripped while running in the playground. She fell on her hands and knees.",
            actionTaken: "Staff comforted Emma, cleaned minor graze on knee with water and applied a cold compress. Parent notified immediately.",
            witnesses: "Teaching Assistant (Maria)",
            location: "Outdoor playground"
        )
        incident.child = emma
        emma.incidents.append(incident)
        
        // Another older incident (already acknowledged)
        let lastWeek = calendar.date(byAdding: .day, value: -7, to: now)!
        let oldIncident = Incident(
            date: calendar.date(bySettingHour: 14, minute: 15, second: 0, of: lastWeek)!,
            category: .firstAid,
            incidentDescription: "Emma got a small splinter in her finger during woodwork activity.",
            actionTaken: "Splinter carefully removed with tweezers. Area cleaned and plaster applied.",
            witnesses: "Room Leader",
            location: "Creative area"
        )
        oldIncident.child = emma
        oldIncident.isAcknowledged = true
        oldIncident.acknowledgedDate = lastWeek
        emma.incidents.append(oldIncident)
        
        try? modelContext.save()
        print("Mock data preloaded successfully!")
    }
}
