//
//  DiaryDetailScreen.swift
//  NurseryConnect
//
//  Created by Supun Liyanage on 4/3/26.
//

import SwiftUI

struct DiaryDetailScreen: View {
    let entry: DiaryEntry
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                headerCard

                sectionContent
            }
            .padding(.horizontal, 18)
            .padding(.vertical, 16)
        }
        .background(AppShellBackground())
        .navigationTitle(entry.type.rawValue)
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private var headerCard: some View {
        SurfaceCard(tint: accentColor) {
            VStack(alignment: .leading, spacing: 14) {
                HStack(alignment: .top) {
                    Image(systemName: entry.type.iconName)
                        .font(.title2.weight(.semibold))
                        .foregroundStyle(accentColor)
                        .frame(width: 46, height: 46)
                        .background(accentColor.opacity(0.12))
                        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))

                    Spacer()

                    Text(entry.formattedDateTime)
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.secondary)
                }

                Text(entry.type.rawValue)
                    .font(.title3.weight(.bold))

                Text(entry.notes)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }
    
    @ViewBuilder
    private var sectionContent: some View {
        switch entry.type {
        case .meal:
            mealDetailView
        case .sleep:
            sleepDetailView
        case .nappy:
            nappyDetailView
        case .wellbeing:
            wellbeingDetailView
        default:
            defaultDetailView
        }
    }

    private var mealDetailView: some View {
        VStack(alignment: .leading, spacing: 14) {
            SectionHeaderView(title: "Meal details", subtitle: "What was offered and how much was eaten")
            DetailCard(title: "Food offered", value: entry.foodOffered ?? "Not specified")
            DetailCard(title: "Portion consumed", value: entry.portionConsumed?.rawValue ?? "Not recorded")

            if let portion = entry.portionConsumed {
                SurfaceCard {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Portion visual")
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(.secondary)
                        PortionProgressBar(portion: portion)
                    }
                }
            }
        }
    }
    
    private var sleepDetailView: some View {
        VStack(alignment: .leading, spacing: 14) {
            SectionHeaderView(title: "Sleep details", subtitle: "Rest and nap timings")
            DetailCard(title: "Start time", value: entry.sleepStart.map { DateFormatters.timeFormatter.string(from: $0) } ?? "Not recorded")
            DetailCard(title: "End time", value: entry.sleepEnd.map { DateFormatters.timeFormatter.string(from: $0) } ?? "Not recorded")
            DetailCard(title: "Duration", value: entry.sleepDurationFormatted)
        }
    }
    
    private var nappyDetailView: some View {
        VStack(alignment: .leading, spacing: 14) {
            SectionHeaderView(title: "Nappy / toilet details", subtitle: "Change information and notes")
            DetailCard(title: "Type", value: entry.nappyType?.rawValue ?? "Not recorded")
            if let concerns = entry.nappyConcerns, !concerns.isEmpty {
                DetailCard(title: "Concerns", value: concerns)
            }
        }
    }
    
    private var wellbeingDetailView: some View {
        VStack(alignment: .leading, spacing: 14) {
            SectionHeaderView(title: "Wellbeing", subtitle: "Mood and emotional check-in")
            if let mood = entry.mood {
                SurfaceCard {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Mood rating")
                                .font(.caption.weight(.semibold))
                                .foregroundStyle(.secondary)
                            Text(mood.rawValue)
                                .font(.headline)
                        }

                        Spacer()

                        Image(systemName: "face.smiling")
                            .font(.title2)
                            .foregroundStyle(.pink)
                            .frame(width: 44, height: 44)
                            .background(Color.pink.opacity(0.12))
                            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                    }
                }
            }
        }
    }
    
    private var defaultDetailView: some View {
        VStack(alignment: .leading, spacing: 14) {
            SectionHeaderView(title: "Entry details", subtitle: "General note and timing")
            DetailCard(title: "Time", value: entry.formattedDateTime)
            DetailCard(title: "Notes", value: entry.notes)
        }
    }
    
    private var accentColor: Color {
        switch entry.type {
        case .meal: return .orange
        case .sleep: return .purple
        case .activity: return .green
        case .nappy: return .teal
        case .wellbeing: return .pink
        default: return .blue
        }
    }
}
