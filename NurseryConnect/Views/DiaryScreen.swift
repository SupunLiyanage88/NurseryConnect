//
//  DiaryScreen.swift
//  NurseryConnect
//
//  Created by Supun Liyanage on 4/3/26.
//

import SwiftUI

struct DiaryScreen: View {
    @EnvironmentObject private var dataManager: DataManager
    @EnvironmentObject private var appState: AppState
    @State private var diaryEntries: [DiaryEntry] = []
    @State private var selectedFilter: DiaryEntryType?

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

                        if filteredEntries.isEmpty {
                            emptyStateView(for: child)
                        } else {
                            ForEach(groupedEntries, id: \.date) { group in
                                VStack(alignment: .leading, spacing: 12) {
                                    sectionHeader(for: group.date, count: group.entries.count)

                                    ForEach(group.entries) { entry in
                                        NavigationLink(destination: DiaryDetailScreen(entry: entry)) {
                                            DiaryRow(entry: entry)
                                        }
                                        .buttonStyle(.plain)
                                    }
                                }
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
                    description: Text("Choose a child from Home to see diary updates.")
                )
                .padding()
            }
        }
        .background(AppShellBackground())
        .navigationTitle(navigationTitle)
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Menu {
                    Button("All") { selectedFilter = nil }
                    Divider()
                    ForEach(DiaryEntryType.allCases, id: \.self) { type in
                        Button(type.rawValue) { selectedFilter = type }
                    }
                } label: {
                    Image(systemName: "line.3.horizontal.decrease.circle")
                }
            }
        }
        .onAppear(perform: loadEntries)
        .onChange(of: selectedChild?.id) { _, _ in
            loadEntries()
        }
        .onChange(of: selectedFilter) { _, _ in
            // Refreshing is unnecessary because the filter is local state,
            // but this keeps the view responsive when selection changes.
        }
    }
    
    private var filterChipsView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                FilterChip(title: "All", isSelected: selectedFilter == nil) {
                    selectedFilter = nil
                }
                ForEach(DiaryEntryType.allCases, id: \.self) { type in
                    FilterChip(title: type.rawValue, isSelected: selectedFilter == type) {
                        selectedFilter = type
                    }
                }
            }
        }
    }

    private var navigationTitle: String {
        guard let name = selectedChild?.name else {
            return "Diary"
        }

        return "\(name)'s Diary"
    }

    private func headerView(for child: Child) -> some View {
        SurfaceCard(tint: Color("PrimaryTeal")) {
            VStack(alignment: .leading, spacing: 10) {
                HStack(alignment: .firstTextBaseline) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Daily diary")
                            .font(.headline)
                        Text("Updates for \(child.name)")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }

                    Spacer()

                    Text("\(filteredEntries.count)")
                        .font(.title3.weight(.bold))
                        .foregroundStyle(Color("PrimaryTeal"))
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(Color("PrimaryTeal").opacity(0.12))
                        .clipShape(Capsule())
                }

                Text(selectedFilter == nil ? "Browse the latest moments from today." : "Filtered to \(selectedFilter?.rawValue ?? "") entries.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
    }
    
    private func emptyStateView(for child: Child) -> some View {
        SurfaceCard {
            ContentUnavailableView(
                "No diary entries",
                systemImage: "book.closed.fill",
                description: Text("Check back later for updates about \(child.name)'s day.")
            )
        }
    }
    
    private var filteredEntries: [DiaryEntry] {
        if let filter = selectedFilter {
            return diaryEntries.filter { $0.type == filter }
        }
        return diaryEntries
    }
    
    private var groupedEntries: [(date: Date, entries: [DiaryEntry])] {
        dataManager.groupDiaryEntriesByDate(filteredEntries)
    }
    
    private func loadEntries() {
        guard let child = selectedChild else {
            diaryEntries = []
            return
        }

        diaryEntries = dataManager.fetchDiaryEntries(for: child)
    }
    
    private func sectionHeader(for date: Date, count: Int) -> some View {
        SectionHeaderView(
            title: DateFormatters.relativeDateString(from: date),
            subtitle: "\(count) entr\(count == 1 ? "y" : "ies")"
        )
    }
}
