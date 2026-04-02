//
//  NurseryConnectRootView.swift
//  NurseryConnect
//
//  Created by Copilot.
//

import SwiftUI
import SwiftData

struct NurseryConnectRootView: View {
    @Environment(\.modelContext) private var modelContext
    @StateObject private var dataManager = DataManager()
    @StateObject private var appState = AppState()

    var body: some View {
        TabView {
            NavigationStack {
                HomeScreen()
            }
            .tabItem {
                Label("Home", systemImage: "house.fill")
            }

            NavigationStack {
                DiaryScreen()
            }
            .tabItem {
                Label("Diary", systemImage: "book.pages.fill")
            }

            NavigationStack {
                IncidentsListScreen()
            }
            .tabItem {
                Label("Incidents", systemImage: "exclamationmark.shield.fill")
            }
        }
        .environmentObject(dataManager)
        .environmentObject(appState)
        .task {
            dataManager.setup(modelContext: modelContext)
            appState.refreshChildren(using: dataManager)
        }
    }
}
