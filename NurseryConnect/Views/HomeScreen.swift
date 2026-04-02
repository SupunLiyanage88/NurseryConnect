//
//  HomeScreen.swift
//  NurseryConnect
//
//  Created by Supun Liyanage on 4/3/26.

import SwiftUI
import SwiftData

struct HomeScreen: View {
    @EnvironmentObject private var dataManager: DataManager
    @EnvironmentObject private var appState: AppState
    @Environment(\.modelContext) private var modelContext
    @State private var unacknowledgedCount = 0

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 22) {
                headerView

                if appState.children.isEmpty {
                    emptyStateView
                } else {
                    childSelectorView

                    if let child = selectedChild {
                        summaryGrid(for: child)
                        diaryPreviewCard(for: child)
                        incidentsCard(for: child)
                    }
                }
            }
            .padding(.horizontal, 18)
            .padding(.vertical, 16)
        }
        .background(AppShellBackground())
        .navigationTitle("NurseryConnect")
        .navigationBarTitleDisplayMode(.large)
        .onAppear {
            dataManager.setup(modelContext: modelContext)
            appState.refreshChildren(using: dataManager)
            updateUnacknowledgedCount()
        }
        .onChange(of: appState.selectedChild?.id) { _, _ in
            updateUnacknowledgedCount()
        }
    }

    private var headerView: some View {
        SurfaceCard(tint: Color("PrimaryTeal")) {
            VStack(alignment: .leading, spacing: 16) {
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Good morning")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        Text(parentGreetingName)
                            .font(.title2.weight(.bold))
                            .foregroundStyle(Color("PrimaryTeal"))
                            .lineLimit(1)
                    }

                    Spacer()

                    Image(systemName: "sun.max.fill")
                        .font(.title2)
                        .foregroundStyle(.yellow)
                        .frame(width: 46, height: 46)
                        .background(.thinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                }

                HStack(spacing: 10) {
                    Label(Date.now.formatted(date: .abbreviated, time: .omitted), systemImage: "calendar")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.secondary)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(Color.primary.opacity(0.06))
                        .clipShape(Capsule())

                    if let child = selectedChild {
                        Label(child.name, systemImage: "person.fill")
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(Color("PrimaryTeal"))
                            .padding(.horizontal, 10)
                            .padding(.vertical, 6)
                            .background(Color("PrimaryTeal").opacity(0.12))
                            .clipShape(Capsule())
                    }
                }

                Text("Welcome back")
                    .font(.title2.weight(.bold))
                    .foregroundStyle(Color("PrimaryTeal"))
            }
        }
    }

    private var emptyStateView: some View {
        SurfaceCard {
            ContentUnavailableView(
                "No children available",
                systemImage: "person.2.slash.fill",
                description: Text("Mock data will load automatically once the store is ready.")
            )
        }
    }

    private var childSelectorView: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeaderView(
                title: "Children",
                subtitle: "Tap a child to view their updates"
            )

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(appState.children) { child in
                        ChildAvatarCard(
                            child: child,
                            isSelected: selectedChild?.id == child.id,
                            onTap: { appState.selectedChild = child }
                        )
                    }
                }
                .padding(.horizontal, 2)
            }
        }
    }

    private func summaryGrid(for child: Child) -> some View {
        VStack(alignment: .leading, spacing: 14) {
            SectionHeaderView(
                title: "At a glance",
                subtitle: "Quick details for today"
            )

            quickStatsView

            HStack(spacing: 14) {
                DetailCard(title: "Age", value: "\(child.ageInYears) years")
                DetailCard(title: "Date of birth", value: child.formattedDateOfBirth)
            }
        }
    }

    private var quickStatsView: some View {
        HStack(spacing: 16) {
            StatCard(
                title: "Unread",
                value: "\(unacknowledgedCount)",
                icon: unacknowledgedCount == 0 ? "checkmark.seal.fill" : "exclamationmark.shield.fill",
                color: unacknowledgedCount == 0 ? .green : .orange
            )
            StatCard(
                title: "Status",
                value: "At Nursery",
                icon: "checkmark.circle.fill",
                color: Color("PrimaryTeal")
            )
        }
    }

    private func diaryPreviewCard(for child: Child) -> some View {
        NavigationLink(destination: DiaryScreen()) {
            HomeCard(
                title: "Today's Diary",
                subtitle: "Latest update",
                icon: "book.fill",
                color: Color("PrimaryTeal"),
                previewText: getLatestDiaryPreview(for: child)
            )
        }
        .buttonStyle(.plain)
    }

    private func incidentsCard(for child: Child) -> some View {
        NavigationLink(destination: IncidentsListScreen()) {
            HomeCard(
                title: "Incident Reports",
                subtitle: unacknowledgedCount > 0 ? "\(unacknowledgedCount) unread" : "No unread reports",
                icon: "exclamationmark.shield.fill",
                color: unacknowledgedCount > 0 ? .orange : .gray,
                previewText: unacknowledgedCount > 0 ? "Tap to acknowledge" : "All incidents acknowledged",
                badgeCount: unacknowledgedCount
            )
        }
        .buttonStyle(.plain)
    }

    private var selectedChild: Child? {
        appState.selectedChild ?? appState.children.first
    }

    private var parentGreetingName: String {
        selectedChild?.parentName ?? "Parent"
    }

    private func updateUnacknowledgedCount() {
        guard let child = selectedChild else {
            unacknowledgedCount = 0
            return
        }

        let incidents = dataManager.fetchIncidents(for: child)
        unacknowledgedCount = incidents.filter { !$0.isAcknowledged }.count
    }

    private func getLatestDiaryPreview(for child: Child) -> String {
        let entries = dataManager.fetchDiaryEntries(for: child)
        guard let latest = entries.first else { return "No diary updates yet" }
        let snippet = latest.notes.trimmingCharacters(in: .whitespacesAndNewlines)
        return "\(latest.type.rawValue): \(snippet.prefix(64))\(snippet.count > 64 ? "..." : "")"
    }
}
