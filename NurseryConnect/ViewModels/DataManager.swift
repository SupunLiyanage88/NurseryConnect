//
//  DataManager.swift
//  NurseryConnect
//
//  Created by Supun Liyanage on 4/3/26.
//

import Foundation
import Combine
import SwiftData
import SwiftUI

@MainActor
class DataManager: ObservableObject {
    @Published private var modelContext: ModelContext?
    
    func setup(modelContext: ModelContext) {
        self.modelContext = modelContext
        MockDataPreloader.preloadIfNeeded(modelContext: modelContext)
    }
    
    func fetchChildren() -> [Child] {
        guard let modelContext = modelContext else { return [] }
        let descriptor = FetchDescriptor<Child>(sortBy: [SortDescriptor(\.name)])
        return (try? modelContext.fetch(descriptor)) ?? []
    }
    
    func fetchDiaryEntries(for child: Child) -> [DiaryEntry] {
        guard let modelContext = modelContext else { return [] }
        let childID = child.persistentModelID
        let descriptor = FetchDescriptor<DiaryEntry>(
            predicate: #Predicate { $0.child?.persistentModelID == childID },
            sortBy: [SortDescriptor(\.timestamp, order: .reverse)]
        )
        return (try? modelContext.fetch(descriptor)) ?? []
    }
    
    func fetchIncidents(for child: Child) -> [Incident] {
        guard let modelContext = modelContext else { return [] }
        let childID = child.persistentModelID
        let descriptor = FetchDescriptor<Incident>(
            predicate: #Predicate { $0.child?.persistentModelID == childID },
            sortBy: [SortDescriptor(\.date, order: .reverse)]
        )
        return (try? modelContext.fetch(descriptor)) ?? []
    }
    
    func acknowledgeIncident(_ incident: Incident) {
        incident.acknowledge()
        try? modelContext?.save()
    }
    
    func groupDiaryEntriesByDate(_ entries: [DiaryEntry]) -> [(date: Date, entries: [DiaryEntry])] {
        let grouped = Dictionary(grouping: entries) { entry -> Date in
            Calendar.current.startOfDay(for: entry.timestamp)
        }
        return grouped.sorted { $0.key > $1.key }.map { (date: $0.key, entries: $0.value) }
    }
}
