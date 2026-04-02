//
//  NurseryConnectApp.swift
//  NurseryConnect
//
//  Created by Supun Liyanage on 4/3/26.
//

import SwiftUI
import SwiftData

@main
struct NurseryConnectApp: App {
    var body: some Scene {
        WindowGroup {
            NurseryConnectRootView()
        }
        .modelContainer(for: [Child.self, DiaryEntry.self, Incident.self])
    }
}
