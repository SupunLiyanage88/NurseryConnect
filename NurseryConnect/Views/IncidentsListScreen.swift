//
//  IncidentsListScreen.swift
//  NurseryConnect
//
//  Created by Supun Liyanage on 4/3/26.
//

import SwiftUI

struct IncidentsListScreen: View {
    @EnvironmentObject private var dataManager: DataManager
    @EnvironmentObject private var appState: AppState
    @State private var incidents: [Incident] = []
    @State private var selectedFilter: IncidentCategory?

    private var selectedChild: Child? {
        appState.selectedChild ?? appState.children.first
    }
    
    var body: some View {
        Group {
            if let child = selectedChild {
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 18) {
                        headerView(for: child)
                        filterChipsView

                        if filteredIncidents.isEmpty {
                            emptyStateView(for: child)
                        } else {
                            ForEach(filteredIncidents) { incident in
                                NavigationLink(destination: IncidentDetailScreen(incident: incident, onUpdate: loadIncidents)) {
                                    IncidentRow(incident: incident)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                    .padding(.horizontal, 18)
                    .padding(.vertical, 16)
                }
            } else {
                ContentUnavailableView(
                    "No child selected",
                    systemImage: "person.crop.circle.badge.questionmark",
                    description: Text("Choose a child from Home to review incident reports.")
                )
                .padding()
            }
        }
        .background(AppShellBackground())
        .navigationTitle("Incident Reports")
        .navigationBarTitleDisplayMode(.large)
        .onAppear(perform: loadIncidents)
        .onChange(of: selectedChild?.id) { _, _ in
            loadIncidents()
        }
    }
    
    private var filterChipsView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                FilterChip(title: "All", isSelected: selectedFilter == nil) {
                    selectedFilter = nil
                }
                ForEach(IncidentCategory.allCases, id: \.self) { category in
                    FilterChip(title: category.rawValue, isSelected: selectedFilter == category) {
                        selectedFilter = category
                    }
                }
            }
        }
    }
    
    private func headerView(for child: Child) -> some View {
        SurfaceCard(tint: .orange) {
            VStack(alignment: .leading, spacing: 10) {
                HStack(alignment: .firstTextBaseline) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Incident overview")
                            .font(.headline)
                        Text("Safeguarding and parent acknowledgements for \(child.name)")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }

                    Spacer()

                    Text("\(filteredIncidents.count)")
                        .font(.title3.weight(.bold))
                        .foregroundStyle(.orange)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(Color.orange.opacity(0.12))
                        .clipShape(Capsule())
                }

                Text(selectedFilter == nil ? "Track every report in one place." : "Filtered to \(selectedFilter?.rawValue ?? "") reports.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
    }

    private func emptyStateView(for child: Child) -> some View {
        SurfaceCard {
            ContentUnavailableView(
                "No incidents reported",
                systemImage: "checkmark.shield.fill",
                description: Text("\(child.name) has no incident records right now.")
            )
        }
    }
    
    private var filteredIncidents: [Incident] {
        if let filter = selectedFilter {
            return incidents.filter { $0.category == filter }
        }
        return incidents
    }
    
    private func loadIncidents() {
        guard let child = selectedChild else {
            incidents = []
            return
        }

        incidents = dataManager.fetchIncidents(for: child)
    }
}
