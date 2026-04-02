//
//  IncidentDetailScreen.swift
//  NurseryConnect
//
//  Created by Supun Liyanage on 4/3/26.
//

import SwiftUI

struct IncidentDetailScreen: View {
    let incident: Incident
    let onUpdate: () -> Void
    @EnvironmentObject private var dataManager: DataManager
    @State private var isAcknowledged: Bool
    @State private var showingAcknowledgeAlert = false
    @State private var showSuccessMessage = false
    
    init(incident: Incident, onUpdate: @escaping () -> Void) {
        self.incident = incident
        self.onUpdate = onUpdate
        _isAcknowledged = State(initialValue: incident.isAcknowledged)
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                heroCard
                statusCard

                VStack(alignment: .leading, spacing: 14) {
                    SectionHeaderView(title: "Report details", subtitle: "Everything recorded for this incident")
                    DetailCard(title: "Date & time", value: incident.formattedDateTime)
                    DetailCard(title: "Location", value: incident.location)
                    DetailCard(title: "Category", value: incident.category.rawValue)
                    DetailCard(title: "Description", value: incident.incidentDescription)
                    DetailCard(title: "Action taken", value: incident.actionTaken)
                    if !incident.witnesses.isEmpty {
                        DetailCard(title: "Witnesses", value: incident.witnesses)
                    }
                }

                bodyMapView

                if !isAcknowledged {
                    acknowledgeButton
                } else {
                    acknowledgedInfoView
                }

                regulatoryNote
            }
            .padding(.horizontal, 18)
            .padding(.vertical, 16)
        }
        .background(AppShellBackground())
        .navigationTitle("Incident Report")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Acknowledge Incident", isPresented: $showingAcknowledgeAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Acknowledge", role: .destructive) {
                performAcknowledge()
            }
        } message: {
            Text("By acknowledging this incident report, you confirm you have read and understood the information. This will be timestamped and recorded for compliance with EYFS requirements.")
        }
        .overlay(
            Group {
                if showSuccessMessage {
                    SuccessToast(message: "Incident acknowledged")
                }
            }
        )
    }
    
    private var heroCard: some View {
        SurfaceCard(tint: severityColor) {
            HStack(alignment: .top, spacing: 12) {
                Image(systemName: incident.category.iconName)
                    .font(.title2.weight(.semibold))
                    .foregroundStyle(severityColor)
                    .frame(width: 46, height: 46)
                    .background(severityColor.opacity(0.12))
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))

                VStack(alignment: .leading, spacing: 6) {
                    Text(incident.category.rawValue)
                        .font(.headline)
                    Text(incident.formattedDateTime)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    Text(incident.location)
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.secondary)
                }

                Spacer()
            }
        }
    }

    private var statusCard: some View {
        SurfaceCard(tint: isAcknowledged ? .green : .orange) {
            HStack(alignment: .center, spacing: 12) {
                Image(systemName: isAcknowledged ? "checkmark.seal.fill" : "exclamationmark.triangle.fill")
                    .foregroundStyle(isAcknowledged ? .green : .orange)

                VStack(alignment: .leading, spacing: 3) {
                    Text(isAcknowledged ? "Acknowledged" : "Awaiting acknowledgement")
                        .font(.headline)
                    Text(isAcknowledged ? "Recorded on \(incident.formattedAcknowledgedDate)" : "This report still needs parent review.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                Spacer()
            }
        }
    }
    
    private var bodyMapView: some View {
        SurfaceCard {
            VStack(alignment: .leading, spacing: 12) {
                SectionHeaderView(title: "Injury location", subtitle: "Placeholder body map for the MVP")

                HStack(spacing: 12) {
                    bodyMapPlaceholder(title: "Front")
                    bodyMapPlaceholder(title: "Back")
                }

                Text("A full interactive diagram can be added in a later release.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }

    private func bodyMapPlaceholder(title: String) -> some View {
        VStack(spacing: 10) {
            Text(title)
                .font(.caption.weight(.semibold))
                .foregroundStyle(.secondary)

            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(Color.primary.opacity(0.05))
                .frame(height: 150)
                .overlay(
                    VStack(spacing: 8) {
                        Image(systemName: "figure.stand")
                            .font(.title2)
                            .foregroundStyle(.secondary)
                        Text("Body map\nplaceholder")
                            .font(.caption)
                            .multilineTextAlignment(.center)
                            .foregroundStyle(.secondary)
                    }
                )
        }
    }
    
    private var acknowledgeButton: some View {
        Button(action: {
            showingAcknowledgeAlert = true
        }) {
            HStack(spacing: 10) {
                Image(systemName: "checkmark.circle")
                Text("Acknowledge Incident")
                    .fontWeight(.semibold)
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .background(Color("PrimaryTeal"))
            .foregroundStyle(.white)
            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        }
        .buttonStyle(.plain)
    }
    
    private var acknowledgedInfoView: some View {
        SurfaceCard(tint: .green) {
            VStack(alignment: .leading, spacing: 8) {
                Label("Parent acknowledgement recorded", systemImage: "clock.badge.checkmark")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.green)
                Text("This incident was acknowledged on \(incident.formattedAcknowledgedDate).")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }
    
    private var regulatoryNote: some View {
        SurfaceCard {
            VStack(alignment: .leading, spacing: 8) {
                Text("EYFS compliance")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.secondary)
                Text("Under EYFS statutory requirements, parents must be informed of all accidents and injuries on the same day. This digital acknowledgement serves as confirmation of receipt.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }
    
    private func performAcknowledge() {
        dataManager.acknowledgeIncident(incident)
        isAcknowledged = true
        onUpdate()
        
        withAnimation {
            showSuccessMessage = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation {
                showSuccessMessage = false
            }
        }
    }

    private var severityColor: Color {
        switch incident.category.severityColor {
        case "red": return .red
        case "orange": return .orange
        case "yellow": return .yellow
        case "purple": return .purple
        default: return .gray
        }
    }
}

extension Incident {
    var formattedDateTime: String {
        DateFormatters.dateTimeFormatter.string(from: date)
    }
}
