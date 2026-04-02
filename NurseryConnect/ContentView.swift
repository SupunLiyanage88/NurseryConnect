//
//  ContentView.swift
//  NurseryConnect
//
//  Created by Supun Liyanage on 4/3/26.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
            AppShellBackground()
            ContentUnavailableView(
                "NurseryConnect",
                systemImage: "house.fill",
                description: Text("The redesigned app opens from the root tab view.")
            )
        }
    }
}

#Preview {
    ContentView()
}
