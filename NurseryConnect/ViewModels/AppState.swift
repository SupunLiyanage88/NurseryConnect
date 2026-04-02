//
//  AppState.swift
//  NurseryConnect
//
//  Created by Copilot.
//

import Foundation
import SwiftData
import SwiftUI
import Combine

@MainActor
final class AppState: ObservableObject {
    @Published var children: [Child] = []
    @Published var selectedChild: Child?

    func refreshChildren(using dataManager: DataManager) {
        let fetchedChildren = dataManager.fetchChildren()
        children = fetchedChildren

        if let selectedChild,
           fetchedChildren.contains(where: { $0.id == selectedChild.id }) {
            return
        }

        selectedChild = fetchedChildren.first
    }
}
