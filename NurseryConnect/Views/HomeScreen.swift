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
    @State private var todayDiaryCount = 0

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                headerView

                if appState.children.isEmpty {
                    emptyStateView
                } else {
                    childSelectorView

                    if let child = selectedChild {
                        snapshotGrid(for: child)
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
            refreshDashboardMetrics()
        }
        .onChange(of: appState.selectedChild?.id) { _, _ in
            refreshDashboardMetrics()
        }
    }

    private var headerView: some View {
        SurfaceCard(tint: Color("PrimaryTeal")) {
            VStack(alignment: .leading, spacing: 16) {
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Hello again")
                            .font(.caption.weight(.semibold))
                            .textCase(.uppercase)
                            .tracking(0.8)
                            .foregroundStyle(.secondary)

                        Text(parentGreetingName)
                            .font(.title2.weight(.bold))
                            .foregroundStyle(Color("PrimaryTeal"))
                            .lineLimit(1)

                        Text("A calm view of today’s nursery updates.")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
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

                    Label("\(todayDiaryCount) diary updates", systemImage: "book.pages.fill")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.secondary)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(Color.primary.opacity(0.06))
                        .clipShape(Capsule())
                }
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

    private func snapshotGrid(for child: Child) -> some View {
        VStack(alignment: .leading, spacing: 14) {
            SectionHeaderView(
                title: "Today’s snapshot",
                subtitle: "What matters right now"
            )

            LazyVGrid(
                columns: [
                    GridItem(.flexible(), spacing: 14),
                    GridItem(.flexible(), spacing: 14)
                ],
                spacing: 14
            ) {
                StatCard(
                    title: "Diary updates",
                    value: "\(todayDiaryCount)",
                    icon: "book.pages.fill",
                    color: .blue
                )

                StatCard(
                    title: "Open alerts",
                    value: "\(unacknowledgedCount)",
                    icon: unacknowledgedCount == 0 ? "checkmark.seal.fill" : "exclamationmark.shield.fill",
                    color: unacknowledgedCount == 0 ? .green : .orange
                )

                StatCard(
                    title: "Age",
                    value: child.ageInYears == 1 ? "1 year" : "\(child.ageInYears) years",
                    icon: "birthday.cake.fill",
                    color: .pink
                )

                StatCard(
                    title: "Parent",
                    value: child.parentName,
                    icon: "person.fill",
                    color: Color("PrimaryTeal")
                )
            }
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

    private func refreshDashboardMetrics() {
        guard let child = selectedChild else {
            unacknowledgedCount = 0
            todayDiaryCount = 0
            return
        }

        let diaryEntries = dataManager.fetchDiaryEntries(for: child)
        todayDiaryCount = diaryEntries.filter { Calendar.current.isDateInToday($0.timestamp) }.count

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
