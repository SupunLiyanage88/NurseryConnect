//
//  SharedUIComponents.swift
//  NurseryConnect
//
//  Created by Copilot.
//

import SwiftUI

struct AppShellBackground: View {
    var body: some View {
        LinearGradient(
            colors: [
                Color(uiColor: .systemBackground),
                Color("PrimaryTeal").opacity(0.12),
                Color(uiColor: .secondarySystemBackground)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
    }
}

struct SectionHeaderView: View {
    let title: String
    let subtitle: String?
    var trailing: AnyView? = nil

    init(title: String, subtitle: String? = nil, trailing: AnyView? = nil) {
        self.title = title
        self.subtitle = subtitle
        self.trailing = trailing
    }

    var body: some View {
        HStack(alignment: .firstTextBaseline) {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                    .fontWeight(.semibold)
                if let subtitle {
                    Text(subtitle)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
            Spacer(minLength: 12)
            if let trailing {
                trailing
            }
        }
    }
}

struct SurfaceCard<Content: View>: View {
    var tint: Color = .primary
    var content: () -> Content

    init(tint: Color = .primary, @ViewBuilder content: @escaping () -> Content) {
        self.tint = tint
        self.content = content
    }

    var body: some View {
        content()
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(.thinMaterial)
            .overlay(
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .strokeBorder(tint.opacity(0.14), lineWidth: 1)
            )
            .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
            .shadow(color: .black.opacity(0.06), radius: 16, x: 0, y: 8)
    }
}

struct FilterChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline.weight(.semibold))
                .lineLimit(1)
                .padding(.horizontal, 14)
                .padding(.vertical, 9)
                .background(isSelected ? Color("PrimaryTeal") : Color(uiColor: .secondarySystemBackground))
                .foregroundStyle(isSelected ? .white : .primary)
                .clipShape(Capsule(style: .continuous))
                .overlay(
                    Capsule(style: .continuous)
                        .strokeBorder(isSelected ? Color.clear : Color.primary.opacity(0.08), lineWidth: 1)
                )
        }
        .buttonStyle(.plain)
    }
}

struct ChildAvatarCard: View {
    let child: Child
    let isSelected: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 10) {
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [Color("PrimaryTeal").opacity(0.20), Color("PrimaryTeal").opacity(0.06)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 68, height: 68)

                    Image(systemName: child.profileImageName ?? "person.fill")
                        .font(.system(size: 28, weight: .semibold))
                        .foregroundStyle(isSelected ? Color("PrimaryTeal") : .secondary)
                }

                Text(child.name)
                    .font(.footnote.weight(.semibold))
                    .foregroundStyle(.primary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.85)
            }
            .padding(12)
            .frame(width: 112)
            .background(.thinMaterial)
            .overlay(
                RoundedRectangle(cornerRadius: 22, style: .continuous)
                    .strokeBorder(isSelected ? Color("PrimaryTeal") : Color.primary.opacity(0.08), lineWidth: isSelected ? 2 : 1)
            )
            .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
            .shadow(color: .black.opacity(isSelected ? 0.10 : 0.05), radius: 12, x: 0, y: 6)
        }
        .buttonStyle(.plain)
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color

    var body: some View {
        SurfaceCard(tint: color) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.title3.weight(.semibold))
                    .foregroundStyle(color)
                    .frame(width: 44, height: 44)
                    .background(color.opacity(0.12))
                    .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))

                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.secondary)
                    Text(value)
                        .font(.headline)
                        .foregroundStyle(.primary)
                        .lineLimit(1)
                }
                Spacer(minLength: 0)
            }
        }
    }
}

struct HomeCard: View {
    let title: String
    let subtitle: String
    let icon: String
    let color: Color
    let previewText: String
    var badgeCount: Int = 0

    var body: some View {
        SurfaceCard(tint: color) {
            VStack(alignment: .leading, spacing: 14) {
                HStack(alignment: .center, spacing: 12) {
                    Image(systemName: icon)
                        .font(.title3.weight(.semibold))
                        .foregroundStyle(color)
                        .frame(width: 44, height: 44)
                        .background(color.opacity(0.12))
                        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))

                    VStack(alignment: .leading, spacing: 3) {
                        Text(title)
                            .font(.headline)
                            .foregroundStyle(.primary)
                        Text(subtitle)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }

                    Spacer(minLength: 8)

                    if badgeCount > 0 {
                        Text("\(badgeCount)")
                            .font(.caption.weight(.bold))
                            .padding(.horizontal, 10)
                            .padding(.vertical, 6)
                            .background(Color.red)
                            .foregroundStyle(.white)
                            .clipShape(Capsule(style: .continuous))
                    }

                    Image(systemName: "chevron.right")
                        .font(.footnote.weight(.semibold))
                        .foregroundStyle(.secondary)
                }

                Divider()
                    .opacity(0.5)

                Text(previewText)
                    .font(.subheadline)
                    .foregroundStyle(.primary)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }
}

struct DetailCard: View {
    let title: String
    let value: String

    var body: some View {
        SurfaceCard {
            VStack(alignment: .leading, spacing: 8) {
                Text(title)
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.secondary)
                Text(value)
                    .font(.body)
                    .foregroundStyle(.primary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }
}

struct PortionProgressBar: View {
    let portion: PortionSize

    private var accentColor: Color {
        switch portion {
        case .all, .most: return .green
        case .half: return .blue
        case .little: return .orange
        case .none, .refused: return .red
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Capsule(style: .continuous)
                        .fill(Color.primary.opacity(0.08))
                        .frame(height: 14)

                    Capsule(style: .continuous)
                        .fill(
                            LinearGradient(
                                colors: [accentColor, accentColor.opacity(0.75)],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: geometry.size.width * CGFloat(portion.percentageValue) / 100, height: 14)
                }
            }
            .frame(height: 14)

            Text("\(portion.rawValue) eaten • \(portion.percentageValue)%")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }
}

struct DiaryRow: View {
    let entry: DiaryEntry

    var body: some View {
        SurfaceCard(tint: diaryColor(for: entry.type)) {
            HStack(alignment: .top, spacing: 12) {
                Image(systemName: entry.type.iconName)
                    .font(.headline.weight(.semibold))
                    .foregroundStyle(diaryColor(for: entry.type))
                    .frame(width: 40, height: 40)
                    .background(diaryColor(for: entry.type).opacity(0.12))
                    .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))

                VStack(alignment: .leading, spacing: 8) {
                    HStack(alignment: .firstTextBaseline) {
                        Text(entry.type.rawValue)
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(.primary)
                        Spacer(minLength: 8)
                        Text(entry.formattedTime)
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(.secondary)
                    }

                    Text(entry.notes)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                }
            }
        }
    }

    private func diaryColor(for type: DiaryEntryType) -> Color {
        switch type {
        case .arrival, .departure: return .blue
        case .activity: return .green
        case .sleep: return .purple
        case .meal: return .orange
        case .nappy: return .teal
        case .wellbeing: return .pink
        }
    }
}

struct IncidentRow: View {
    let incident: Incident

    var body: some View {
        SurfaceCard(tint: severityColor(for: incident.category)) {
            VStack(alignment: .leading, spacing: 12) {
                HStack(alignment: .top, spacing: 12) {
                    Image(systemName: incident.category.iconName)
                        .font(.headline.weight(.semibold))
                        .foregroundStyle(severityColor(for: incident.category))
                        .frame(width: 40, height: 40)
                        .background(severityColor(for: incident.category).opacity(0.12))
                        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))

                    VStack(alignment: .leading, spacing: 6) {
                        HStack(alignment: .firstTextBaseline) {
                            Text(incident.category.rawValue)
                                .font(.subheadline.weight(.semibold))
                            Spacer(minLength: 8)
                            Text(incident.formattedDate)
                                .font(.caption.weight(.semibold))
                                .foregroundStyle(.secondary)
                        }

                        Text(incident.incidentDescription)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .lineLimit(2)
                    }
                }

                HStack {
                    Label(incident.location, systemImage: "mappin.and.ellipse")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.secondary)
                        .lineLimit(1)

                    Spacer()

                    statusBadge
                }
            }
        }
    }

    private var statusBadge: some View {
        HStack(spacing: 6) {
            Image(systemName: incident.isAcknowledged ? "checkmark.circle.fill" : "exclamationmark.circle.fill")
            Text(incident.isAcknowledged ? "Acknowledged" : "Needs review")
        }
        .font(.caption.weight(.semibold))
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .foregroundStyle(incident.isAcknowledged ? .green : .orange)
        .background((incident.isAcknowledged ? Color.green : Color.orange).opacity(0.12))
        .clipShape(Capsule(style: .continuous))
    }

    private func severityColor(for category: IncidentCategory) -> Color {
        switch category.severityColor {
        case "red": return .red
        case "orange": return .orange
        case "yellow": return .yellow
        case "purple": return .purple
        default: return .gray
        }
    }
}

struct SuccessToast: View {
    let message: String

    var body: some View {
        VStack {
            Spacer()
            HStack(spacing: 10) {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundStyle(.green)
                Text(message)
                    .font(.subheadline.weight(.semibold))
                Spacer(minLength: 0)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .background(.ultraThinMaterial)
            .overlay(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .strokeBorder(Color.primary.opacity(0.08), lineWidth: 1)
            )
            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
            .shadow(color: .black.opacity(0.14), radius: 16, x: 0, y: 8)
            .padding(.horizontal, 20)
            .padding(.bottom, 28)
        }
        .transition(.move(edge: .bottom).combined(with: .opacity))
        .animation(.spring(response: 0.35, dampingFraction: 0.85), value: message)
    }
}

extension DiaryEntry {
    var formattedDateTime: String {
        DateFormatters.dateTimeFormatter.string(from: timestamp)
    }
}
