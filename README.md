# SE4020 – Mobile Application Design & Development
## Assignment 01 — NurseryConnect iOS MVP

> **Submission Instructions:** Edit this file directly with your report. No separate documentation is required. Commit all your Swift/Xcode project files to this repository alongside this README.

---

## Student Details

| Field | Details |
|---|---|
| **Student ID** | *IT22134776* |
| **Student Name** | *L.S.B Hemarathne* |
| **Chosen User Role** | *Parent* |
| **Selected Feature 1** | *Daily Diary Viewing* |
| **Selected Feature 2** | *Incident Report Viewing & Acknowledgment* |

---

## 01. Feature Selection & Role Justification

### Chosen User Role
*The user role I selected for the NurseryConnect system is the Parent/Guardian. This role mainly focuses on allowing parents to view their child’s daily activities such as meals, sleep, and overall wellbeing. Parents can also receive and acknowledge incident reports, which helps meet EYFS requirements for informing parents on the same day.*

*In addition, parents can only access their own child’s information. This follows UK GDPR principles like data minimisation and helps make sure that sensitive data is kept private and secure.*

*I chose this role because it has a clear and simple user journey, which makes it suitable for a Minimum Viable Product (MVP). It also directly supports better communication between the nursery and parents, while still considering important legal and data protection requirements.*

### Selected Features
*List and describe the two key features you have chosen to implement.*

**Feature 1: Daily Diary Viewing**

Parent views a chronological log of their child’s day: arrival, activities, sleep, meals, nappy changes, mood. Each entry shows time, notes, and type‑specific details (e.g., portion size for meals).

Core parent need; read‑only data; easily populated with mock data; demonstrates SwiftUI lists, navigation, and custom views.

**Feature 2: Incident Report Viewing & Acknowledgment**

Parent views incident reports (date, category, description, action taken) and can digitally acknowledge each report. Acknowledgment is timestamped and persisted.

Complements diary (routine + safety). Includes interactive element (button with alert). Directly addresses EYFS legal obligation for same‑day parent notification.

### Justification
*The two selected features, Daily Diary Viewing and Incident Report Viewing & Acknowledgment, are appropriate for the Parent/Guardian role because they directly address the main needs of parents. Parents want to stay informed about their child’s daily routine, such as meals, sleep, and activities, which is supported by the Daily Diary feature. At the same time, they need to be aware of any safety-related issues, which is handled through the Incident Report feature. This also aligns with EYFS requirements, where parents must be informed about incidents on the same day.*

*These features represent a realistic 4-week MVP scope because they are simple and focused. The system does not require a backend or real-time functionality, as all data can be stored locally using SwiftData with preloaded sample data. The parent role is limited to viewing and acknowledging information, which reduces complexity and makes development manageable within the given timeframe.*

*The two features also complement each other to create a coherent user experience. The Daily Diary provides positive and routine updates about the child’s day, while Incident Reports handle important and serious situations. Together, they give parents a complete view of their child’s experience at the nursery. Both features follow a similar interface design, making the app easy to use and consistent.*

---

## 02. App Functionality

### Overview
*NurseryConnect is a mobile application designed to help parents and caregivers keep track of children’s daily activities in a structured and organized way. The app mainly focuses on recording important information such as meals, sleep patterns, daily activities, and any incidents that occur during the day. All data is stored locally using SwiftData, allowing users to easily manage and access information for each child.*
*The application is built using a tab-based navigation system with three main sections: Home, Diary, and Incidents. The Home tab acts as a dashboard where users can view a summary of a selected child, including recent diary entries and any incidents that still need acknowledgment. The Diary tab allows users to log daily activities by selecting different categories such as meals, sleep, or wellbeing, each with specific input fields. The Incidents tab is used to record and manage any safety-related events, including details like description, location, and acknowledgment status.*
*The app uses a centralized state management approach to ensure that data is synchronized across all screens. Users can switch between multiple children, and all records are maintained separately for each child. Overall, NurseryConnect provides a simple and efficient way to monitor and document a child’s daily routine while keeping all relevant information easily accessible in one place.*

### Screen Descriptions

**Screen 1 — Parent's Home Screen**

*The home screen is a clean dashboard for the NurseryConnect app. It greets the parent, shows the current date and selected child, and gives a quick snapshot of key nursery updates like diary entries, open alerts, age, and parent details. It also provides quick access cards for today’s diary and incident reports, so the most important information is easy to see at a glance.*

<p align="left">
  <img src="Resources/screen01.png" width="300">
  <img src="Resources/screen01(dark).PNG" width="300">
</p>

**Screen 2 — Daily Diary Screen**

*The diary screen shows a child’s diary timeline and lets the user browse nursery updates in a structured way. It loads the currently selected child, displays a header with the child’s name and entry count, and groups diary items by date so the latest updates are easy to scan. If no child is selected, it shows an empty-state message telling the user to choose a child from Home. The main behavior is implemented in DiaryScreen.swift and the detail view opens in DiaryDetailScreen.swift.*

*The user interacts with it in a few simple ways: they can switch between children from the Home screen, filter diary entries with the chip row or the top-right menu, and tap any diary row to open a detailed view. Each diary item then shows more context based on its type, such as meal details, sleep timing, nappy information, or wellbeing notes.*

<img src="Resources/diary screen.png" width="300">

**Screen 3 — Incident Screen**

*The incident screen is basically the place where parents can check any accident or incident reports for the selected child. It shows a short overview at the top, how many reports there are, and lets the user filter them by category. If there are no incidents, it shows a simple empty message instead. The main list is in IncidentsListScreen.swift.*

*When the user taps one incident, it opens the detailed report in IncidentDetailScreen.swift. That screen shows the time, location, category, description, action taken, and witnesses if there are any. If the report is not acknowledged yet, the user can tap the acknowledge button, confirm it in the popup, and then the app marks it as read and shows a success message.*

<img src="Resources/screen03.png" width="300">

### Navigation
**Pattern Used: Tab-Based Navigation with NavigationStack**
*The app uses a TabView architecture combined with NavigationStack for hierarchical navigation:*
```
NurseryConnectRootView (Root)
├── TabView
│   ├── Tab 1: NavigationStack → HomeScreen
│   ├── Tab 2: NavigationStack → DiaryScreen → DiaryDetailScreen
│   └── Tab 3: NavigationStack → IncidentsListScreen → IncidentDetailScreen
```
Key characteristics:

Bottom Tab Navigation: Three main tabs at the root level (Home, Diary, Incidents) accessed via TabView
Stack-based Drill-down: Each tab contains a NavigationStack that enables drill-down navigation to detail screens
NavigationLink navigation: All detail screens use NavigationLink for declarative, swiftUI-native navigation
DiaryScreen → DiaryDetailScreen (tapping a diary entry)
IncidentsListScreen → IncidentDetailScreen (tapping an incident report)
HomeScreen → DiaryScreen or IncidentsListScreen (tapping card shortcuts)

Examples from code:

IncidentsListScreen.swift:* NavigationLink(destination: IncidentDetailScreen(incident: incident, onUpdate: loadIncidents))*

HomeScreen.swift:* Navigation links to DiaryScreen and IncidentsListScreen from home cards*

## Data Persistence

NurseryConnect uses **SwiftData** — Apple's modern replacement for Core Data.

### Why SwiftData

| Feature | Benefit |
|---|---|
| Native SwiftUI integration | Access model context via `@Environment(\.modelContext)` |
| Simpler API | Declarative `FetchDescriptor` instead of `NSFetchRequest` |
| Type safety | `@Model` macro provides compile-time guarantees |
| Modern Swift | Leverages Swift macros and `Codable` patterns |
| Auto relationships | Cascade deletes via `@Relationship(deleteRule: .cascade)` |

### Models

| Model | Description |
|---|---|
| `Child` | Profile data — name, date of birth, parent name |
| `DiaryEntry` | Daily activity logs with type-specific fields (meals, sleep, nappy, wellbeing) |
| `Incident` | Safety incident records with acknowledgment tracking |

### Setup

Configured in `NurseryConnectApp.swift`:

```swift
.modelContainer(for: [Child.self, DiaryEntry.self, Incident.self])
```

### Data flow

1. `DataManager` receives the model context via `setup(modelContext:)`
2. Queries use `FetchDescriptor` with predicates to filter data by child
3. Changes are persisted with `try? modelContext?.save()`
4. Deleting a `Child` automatically cascades to their related entries and incidents


### Error Handling

NurseryConnect uses **graceful degradation** over explicit error alerts — the app never crashes unexpectedly, and users always see helpful guidance when something is unavailable.

### Philosophy

Rather than throwing errors, the app:
- Returns sensible defaults (`[]`, `nil`, default enum values)
- Displays contextual empty states with user guidance
- Validates state consistency when data changes
- Uses optionals strategically to avoid force unwrapping
- Shows confirmation dialogs for destructive actions

---

### 1. Silent failures with fallback values

Missing `modelContext` or a failed fetch returns an empty array instead of crashing.

```swift
// DataManager.swift
func fetchChildren() -> [Child] {
    guard let modelContext = modelContext else { return [] }
    let descriptor = FetchDescriptor<Child>(sortBy: [SortDescriptor(\.name)])
    return (try? modelContext.fetch(descriptor)) ?? []
}
```

---

### 2. Missing data handling

Optional fields are safely unwrapped with meaningful fallback strings.

```swift
// Incident.swift
var formattedAcknowledgedDate: String {
    guard let ackDate = acknowledgedDate else { return "Not acknowledged" }
    return DateFormatters.dateTimeFormatter.string(from: ackDate)
}
```

---

### 3. State consistency protection

When a selected child is deleted, `AppState` automatically falls back to the first available child rather than holding a stale reference.

```swift
// AppState.swift
func refreshChildren(using dataManager: DataManager) {
    let fetchedChildren = dataManager.fetchChildren()
    children = fetchedChildren

    if let selectedChild,
       fetchedChildren.contains(where: { $0.id == selectedChild.id }) {
        return
    }
    selectedChild = fetchedChildren.first
}
```

---

### 4. UI state fallbacks

Screens use `ContentUnavailableView` instead of showing a blank screen.

```swift
// DiaryScreen.swift / IncidentsListScreen.swift
Group {
    if let child = selectedChild {
        // Show content
    } else {
        ContentUnavailableView(
            "No child selected",
            systemImage: "person.crop.circle.badge.questionmark",
            description: Text("Choose a child from Home to see diary updates.")
        )
    }
}
```

---

### 5. Data type conversions with fallbacks

Corrupted or missing raw values fall back to safe defaults rather than crashing.

```swift
// DiaryEntry.swift
var type: DiaryEntryType {
    get { DiaryEntryType(rawValue: typeRaw) ?? .activity }
    set { typeRaw = newValue.rawValue }
}

var portionConsumed: PortionSize? {
    get { portionConsumedRaw.flatMap { PortionSize(rawValue: $0) } }
    set { portionConsumedRaw = newValue?.rawValue }
}
```

---

### 6. Confirmation dialogs for destructive actions

Critical actions require explicit confirmation to prevent accidental changes.

```swift
// IncidentDetailScreen.swift
.alert("Acknowledge Incident", isPresented: $showingAcknowledgeAlert) {
    Button("Cancel", role: .cancel) { }
    Button("Acknowledge", role: .destructive) {
        performAcknowledge()
    }
} message: {
    Text("By acknowledging this incident report, you confirm...")
}
```

---

## 03. User Interface Design

### Visual design

NurseryConnect uses a calm, professional visual language designed for parents and childcare staff who need to read updates quickly and confidently.

| Element | Approach |
|---|---|
| **Colour** | Soft teal as the primary accent; green = complete, orange = pending, red = high severity |
| **Backgrounds** | Subtle gradient shell with light material cards for depth without visual noise |
| **Typography** | SwiftUI system styles (`headline`, `body`, `caption`) with semibold weights for key labels |
| **Layout** | Card-based sections with generous spacing, rounded corners, and predictable alignment |
| **Tone** | Safety and compliance content is visually emphasised but not alarming — balancing reassurance with accountability |

---

### Usability

| Feature | Detail |
|---|---|
| Navigation clarity | Three-tab structure (Home, Diary, Incidents) with stack navigation for drill-down |
| Progressive disclosure | Summary cards on Home lead to full records only when needed |
| Child context persistence | Selected child is shared across all screens |
| Fast filtering | Horizontal filter chips and toolbar menus to narrow entries quickly |
| Empty states | Contextual guidance instead of blank screens when no records exist |
| Immediate feedback | Unread badges, acknowledgement status cards, and success toasts after key actions |
| Safety for destructive actions | Confirmation alert before committing incident acknowledgement |

---

### UI components

#### Standard SwiftUI

`TabView` · `NavigationStack` · `NavigationLink` · `ScrollView` · `LazyVStack` · `HStack` · `VStack` · `Group` · `Text` · `Image` · `Label` · `Button` · `Menu` · `ToolbarItem` · `Divider` · `Alert` · `ContentUnavailableView` · `RoundedRectangle` · `Circle` · `Capsule` · `LinearGradient`

#### Custom components

| Component | Purpose |
|---|---|
| `AppShellBackground` | Reusable gradient background to unify screen appearance |
| `SurfaceCard` | Material card with rounded corners, border tint, and shadow |
| `SectionHeaderView` | Standardised section titles with subtitle and optional trailing content |
| `FilterChip` | Capsule filter control with selected/unselected visual states |
| `ChildAvatarCard` | Tappable child selector with avatar, selected border, and compact layout |
| `StatCard` | Small metric card for quick-status values |
| `HomeCard` | Navigation card with icon, subtitle, preview text, and optional unread badge |
| `DetailCard` | Consistent label/value block for structured information display |
| `PortionProgressBar` | Visual meal portion tracker |
| `SuccessToast` | Transient confirmation feedback after key actions |

---

## 04. Swift & SwiftUI Knowledge

### Code Quality

The project is structured clearly by responsibility, making it easy to maintain:

- **Models** — domain entities and business data (`Child`, `DiaryEntry`, `Incident`, enums)
- **ViewModels** — shared app state and data access logic (`AppState`, `DataManager`)
- **Views** — screen-level UI and reusable UI components
- **Utilities** — shared helpers (date formatting, mock data preload)
- **App entry point** — app lifecycle and model container setup

Separation of concerns follows an MVVM-style approach: Views focus on rendering and user interaction, `AppState` manages UI state (selected child, loaded child list), and `DataManager` handles persistence reads/writes via SwiftData with focused methods for the UI. Models encapsulate domain behaviour with computed properties (e.g. formatted dates, sleep duration, enum mapping from persisted raw values).

Naming conventions are consistent and readable throughout — types use `PascalCase` (`HomeScreen`, `IncidentDetailScreen`, `DateFormatters`), properties and functions use `camelCase` (`fetchIncidents`, `refreshChildren`, `selectedChild`), and view helper functions are descriptive and intention-revealing (`headerView`, `emptyStateView`, `loadEntries`, `refreshDashboardMetrics`).

---

### Code Examples — Best Practices

**Example 1 — State management with safe selection refresh logic**

```swift
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
```

This is a strong example because it uses `ObservableObject` + `@Published` correctly for reactive SwiftUI updates, keeps `selectedChild` valid when data changes to avoid stale references, centralises state mutation in one place rather than scattering logic across views, and uses `@MainActor` to ensure UI-safe state updates.

---

**Example 2 — Type-safe grouping and sorting in the data layer**

```swift
func groupDiaryEntriesByDate(_ entries: [DiaryEntry]) -> [(date: Date, entries: [DiaryEntry])] {
    let grouped = Dictionary(grouping: entries) { entry -> Date in
        Calendar.current.startOfDay(for: entry.timestamp)
    }
    return grouped.sorted { $0.key > $1.key }.map { (date: $0.key, entries: $0.value) }
}
```

This is a strong example because it places transformation logic in the data layer rather than inside the view body, uses built-in Swift APIs (`Dictionary(grouping:)`, `sorted`, `map`) for concise and readable code, produces a UI-ready structure (date-grouped sections) that reduces duplicated logic across screens, and improves testability since the grouping behaviour is isolated in a pure function.

---

### Advanced Concepts

- **Environment objects and observable state** — Shared state (`DataManager`, `AppState`) is injected once at the root level using `@StateObject` and consumed across tabs and screens via `@EnvironmentObject`, keeping the dependency graph clean and predictable.
- **SwiftData persistence** — The app uses `@Model` entities with relationships, `FetchDescriptor`, predicates, and save operations through `ModelContext` for structured, type-safe local persistence.
- **Custom SwiftUI components and modular UI** — Reusable components (`SurfaceCard`, `SectionHeaderView`, `FilterChip`, `StatCard`, `HomeCard`) reduce duplication and keep individual screens focused on their own concerns.
- **View lifecycle and async UI tasks** — The root view uses `.task` for setup and loading, and screens react to selection changes using `onAppear` and `onChange` for responsive, data-driven UI.
- **Animations** — Acknowledgement feedback uses `withAnimation` to deliver toast-style success messaging, adding polish to user interactions.
- **Domain modelling best practices** — Persisted raw string values are wrapped by type-safe computed enum properties (e.g. `DiaryEntry.type`, `portionConsumed`, `mood`), balancing SwiftData compatibility with strongly typed UI and business logic.

---
## 05. Testing & Debugging

### Testing

The app was tested using a combination of unit testing and manual scenario-based testing. For automated testing, a small XCTest suite was added focused on stable model logic — enum mapping, computed values, and state updates. UI flows were validated manually in the simulator and on device, as a dedicated UI test target has not yet been added.

---

### Unit Tests

A representative unit test verifies that incident acknowledgement correctly updates both the boolean state and the timestamp:

```swift
func testIncidentAcknowledgeUpdatesState() {
    let incident = Incident(
        date: Date(),
        category: .minorAccident,
        incidentDescription: "Minor fall",
        actionTaken: "Cleaned and comforted",
        witnesses: "Staff",
        location: "Play area"
    )
    XCTAssertFalse(incident.isAcknowledged)
    XCTAssertNil(incident.acknowledgedDate)
    incident.acknowledge()
    XCTAssertTrue(incident.isAcknowledged)
    XCTAssertNotNil(incident.acknowledgedDate)
}
```

Additional unit tests were written for:

- `DiaryEntry` raw-value to enum mapping (`typeRaw` ↔ `type`)
- `PortionSize` percentage mapping (100 / 50 / 0 expectations for key values)

---

### UI Tests

A separate automated UI test bundle has not been implemented yet. However, the following scenarios were covered through manual testing:

- App launch and initial mock data load
- Tab navigation between Home, Diary, and Incidents
- Child selection updating content across all screens
- Diary filtering by entry type
- Incident filtering by category
- Incident acknowledgement flow (alert confirmation, success toast, and updated status)

---

### Manual Testing

The following test cases were executed manually, including edge cases:

- **Normal flow** — Select child → view daily summary → open diary details → open incident details → acknowledge incident
- **Empty/fallback states** — Verified "no child selected" and "no entries/incidents" views render correctly
- **Data consistency** — Confirmed selected child remains valid after refresh and screen changes
- **Status transitions** — Confirmed unread incident count decreases after acknowledgement
- **Edge cases** — Long diary text notes, no witnesses text, already-acknowledged incidents, and zero matching filter results
- **Relaunch behaviour** — Confirmed mock data is not duplicated on repeated launches

---

### Debugging

Notable bugs encountered during development and how they were resolved:

- **Selected child becoming stale after data refresh** — Traced to selection state not being revalidated after a fetch. Fixed by re-checking whether the selected child still exists in the refreshed data and defaulting to the first child if not found.
- **Potential duplicate mock data on relaunch** — Identified a repeated seeding risk during app setup. Fixed by checking for existing children before preloading mock data.
- **Incident list not reflecting acknowledgement immediately** — Identified through detail-to-list flow testing. Fixed by triggering a refresh callback after acknowledgement so the list view and unread counters update right away.

---

---

## 06. Regulatory Compliance Report

> This section demonstrates my understanding of the regulatory requirements relevant to the NurseryConnect system and my chosen role and features.

---

### Understanding of Regulations

#### UK GDPR

The two features I built — the daily diary and incident reporting — both handle personal data, so UK GDPR applies directly.

The main data processed includes:

| Data category | Examples | Lawful basis (UK GDPR) |
|---|---|---|
| Child identifiers | Name, date of birth, parent name | Art. 6(1)(b) – contract (childcare agreement) |
| Daily activity records | Meal intake, sleep duration, nappy changes, mood | Art. 6(1)(c) – legal obligation (EYFS welfare requirements) |
| Incident reports | Description of accident, action taken, witnesses, location | Art. 6(1)(c) – legal obligation (Children Act 1989, RIDDOR) |
| Acknowledgment data | Timestamp of parent acknowledgment | Art. 6(1)(c) – legal obligation (EYFS same-day notification) |

Key obligations relevant to my features:

- **Data minimisation (Article 5(1)(c))** — the app only collects what is needed: child identifiers, diary entries, and incident details. Nothing excessive is stored.
- **Lawfulness, fairness & transparency (Article 5(1)(a))** — in production, a privacy notice would explain to parents that diary and incident data are processed to fulfil childcare and safeguarding obligations.
- **Special category data (Article 9)** — health-related diary entries (sleep, nappy changes) and incident reports (e.g. allergic reactions, first aid) count as special category data. The lawful basis is Article 9(2)(b), covering processing under employment and social protection law, which applies to childcare settings.
- **Security (Article 32)** — the app uses SwiftData with iOS file-level encryption. A production system would also need AES-256 encryption at rest and TLS 1.3 in transit.
- **Accountability (Article 5(2))** — timestamped incident acknowledgements support a basic audit trail. A full system would also log who viewed or modified each record.

---

#### EYFS 2024

The EYFS statutory framework is directly relevant to both features:

- **Accident and injury notification** — providers must notify parents of any accident or injury on the same day. The incident acknowledgement flow with a timestamp directly supports this, creating a digital record that could be shown to Ofsted.
- **Learning and development records** — EYFS requires providers to track each child's progress. The daily diary (activities, meals, sleep) contributes to this, even in the MVP where parents only view entries. In production, keyworkers would log observations against EYFS learning areas.
- **Safeguarding** — incident reports must be stored confidentially. The app's local-only storage supports this in the MVP; a production version would use encrypted cloud backup with strict access controls.

---

#### Ofsted

Ofsted inspects nurseries against the Education Inspection Framework. The most relevant areas for my features are:

- **Record-keeping** — inspectors review incident logs and parent notification evidence. The app provides a clear incident list with acknowledgement timestamps that could be demonstrated during an inspection.
- **Parental engagement** — Ofsted looks for evidence that parents are kept informed. The diary and incident features both support this. A production system would ideally allow PDF exports of acknowledged incidents.
- **Safeguarding audits** — acknowledgement timestamps show that parents were notified, which is a key compliance point. Ofsted would also expect unacknowledged incidents to trigger escalation (e.g. a manager alert), which is noted in my design but not implemented in the MVP.

---

#### Children Act 1989

The Children Act 1989 places a duty on providers to safeguard and promote children's welfare. Relevant points for my features:

- **Secure record-keeping** — all child data is stored on-device only and is inaccessible to other apps. A production system would add encrypted backups and role-based access so only a child's own parent can view their records.
- **Duty to inform parents** — the incident acknowledgement feature directly fulfils this by requiring parents to confirm they have read the report.
- **Safeguarding escalation** — the app supports typed incident categories (e.g. safeguarding concern, medical incident) for proper classification. In production, unacknowledged safeguarding incidents would need to trigger automatic alerts to the Setting Manager.

---

#### FSA Guidelines

FSA guidelines are not directly applicable to the Parent/Guardian role. However, the diary feature does display meal information (food offered, portion consumed), which in production would need to consider FSA allergen labelling rules if shared with parents. The MVP does not implement allergen alerts, but a full system would include them.

---

### Compliance by Design

The app follows an MVVM pattern, and this structure directly supports several regulatory requirements:

| Layer | Components | Role in compliance |
|---|---|---|
| Model | SwiftData `@Model` classes (`Child`, `DiaryEntry`, `Incident`) | Encapsulates data and business logic (e.g. `acknowledge()` method). Validation and retention rules are enforced here. |
| View | SwiftUI View structs (`HomeScreen`, `DiaryScreen`, `IncidentDetailScreen`) | Responsible only for presentation. No direct data mutation — ensures compliance logic cannot be bypassed by UI bugs. |
| ViewModel | `DataManager` | Fetches data, prepares it for display, and handles user actions (e.g. `acknowledgeIncident()`). Acts as the gatekeeper for compliance rules. |

How specific requirements map to the design:

| Requirement | How MVVM + SwiftData implements it |
|---|---|
| Data minimisation | The ViewModel fetches only the selected child's data using predicates. Views never query the database directly. |
| Audit trail (partial) | `Incident` records `acknowledgedDate` when the ViewModel calls `acknowledgeIncident()`. The timestamp is set by business logic, not the UI. |
| Security | SwiftData uses iOS data protection. The ViewModel never caches data outside the secure container. |
| Testability | MVVM allows unit testing of compliance rules (e.g. verifying `acknowledge()` sets both `isAcknowledged` and `acknowledgedDate`) without UI automation. |

Where full compliance is not yet implemented, a production system would need:

| Missing feature | Why it is needed | How it would be added |
|---|---|---|
| Authentication & MFA | Ensure only the correct parent accesses their child's data | New `AuthViewModel`; protected routes check auth state before showing data |
| Encryption at rest (cloud) | Protect data if device is lost | Repository pattern with a `CloudRepository` that encrypts before upload |
| Encryption in transit | Prevent interception | `APIClient` service called by ViewModel; TLS 1.3 enforced |
| Audit logs | Demonstrate accountability | `AuditLog` Model; ViewModel calls `logEvent()` before every fetch or acknowledgement |
| Push notifications | Fulfil EYFS same-day requirement proactively | `NotificationViewModel` subscribes to remote push and updates local SwiftData on receipt |
| Data retention policies | Automatically delete data after the legal period | `RetentionService` runs on launch and deletes expired records via `ModelContext` |
| Parental consent management | Explicit consent for special category data | `Consent` Model and `ConsentViewModel`; consent screen shown before diary or incidents are displayed |
| Role-based access control | Prevent keyworkers from seeing unassigned children | User role included in every ViewModel API request; backend filters results |
| Escalation for unacknowledged incidents | Ensure no incident is missed | `IncidentViewModel` timer triggers escalation API after a set period |

---

### Critical Analysis

A few genuine tensions came up when thinking about compliance and usability together:

**Acknowledgement friction** — requiring a parent to tap "Acknowledge" and confirm an alert adds extra steps and could cause anxiety. A mitigation would be to include a clear, non-alarming message explaining the action, and optionally a "I have questions" button to message the Setting Manager directly.

**Data minimisation vs feature richness** — GDPR encourages collecting only what is necessary, but parents naturally want detailed updates. The MVP keeps fields lean (e.g. portion size rather than exact grams). A production system could offer optional "additional notes" behind a separate consent step.

**Local persistence vs cloud backup** — local-only storage limits exposure but risks data loss if the device is damaged. In production, end-to-end encrypted cloud sync with a user-controlled backup toggle would address this, with data encrypted on-device before upload and decrypted only by the parent's biometric-protected key.

**No authentication in MVP** — the MVP assumes the device is physically secured by the parent. A production app would require biometric authentication (Face ID) on launch before any child data is displayed.

**Offline access vs real-time compliance** — the app works offline via SwiftData, but EYFS requires immediate notification of incidents. In production, incidents would sync to a server on reconnection, and background push notifications would alert parents even when the app is closed.

**Incident detail overload** — Ofsted requires detailed records, but showing witnesses, location, and other fields all at once may overwhelm parents. Progressive disclosure — summary first, expandable sections for additional detail — would balance completeness with readability.

**MVVM boilerplate vs MVP speed** — strict MVVM adds extra files and structure, which can slow down early development. The app uses a lightweight `DataManager` as a single ViewModel-like service to keep things manageable. In production this would be refactored into per-screen ViewModels with clearly defined interfaces.
---

## 07. Documentation

### (a) Design Choices

*My main design choice was to keep the app simple, calm, and easy to scan because the target user is a parent who mainly wants quick updates about their child. I used a tab-based layout with separate NavigationStack flows for Home, Diary, and Incidents. I chose this because it keeps the main sections obvious and avoids making the app feel crowded. Each tab has one clear purpose, so the user does not have to dig through too many screens to find the information they need.*

*For the colour scheme, I used a soft teal as the main accent colour with light cards and subtle background gradients. I chose teal because it feels friendly and trustworthy, which works well for a nursery app. I also kept the design neutral and clean so important information like incident acknowledgements and diary updates stands out more clearly. Status colours such as green, orange, and red are only used where they actually help with meaning.*

*The data model was designed around the real structure of the app: one child can have many diary entries and many incidents. I used separate models for Child, DiaryEntry, and Incident because it keeps the code easier to understand and makes the relationships clearer. DiaryEntry also uses raw-value fields and computed properties for things like meal portion, mood, and nappy type, which made it easier to support different diary entry types without duplicating a lot of code.*

*I also kept the UI component-based by using reusable cards, chips, and headers. This made the screens look more consistent and saved time because I could reuse the same styling across the whole app instead of building each screen from scratch.*

### (b) Implementation Decisions

*For data persistence, I used SwiftData because it fits naturally with SwiftUI and keeps the code much cleaner than setting up a separate database layer. The app stores data locally on the device, which is enough for the MVP because the assignment focuses on UI, workflow, and data handling rather than a full production backend. I also used a mock data preloader so the app starts with sample children, diary entries, and incidents, which helps demonstrate the screens properly without needing manual setup every time.*

*I did not use any third-party libraries. Everything was built with Apple frameworks such as SwiftUI, SwiftData, Foundation, and Combine. I kept it this way because it reduced dependency risk and made the project easier to maintain. It also matched the assignment scope better, since the main aim was to show a working native iOS MVP rather than integrate extra packages.*

*For MVP scope, I simplified a few things on purpose. I did not add login, cloud sync, push notifications, or a real backend because those features would add a lot of complexity and were not necessary for the core user journey. I also kept the child selection logic simple by letting the parent switch between locally stored children from the Home screen. This was enough to demonstrate the main functionality while staying realistic for the timeframe of the assignment.*

*Another implementation decision was to keep acknowledgement as a local action with a timestamp. That was enough to show the workflow for incident reports and the parent confirmation step, without building a full audit system. The app also uses safe fallback values and empty states instead of aggressive error popups, because I wanted the app to feel stable and easy to use even when some data is missing.*

### (c) Challenges

*One challenge was modelling diary entries because different entry types need different fields. For example, meal entries need food and portion details, while sleep entries need start and end times. I solved this by using one DiaryEntry model with optional type-specific properties and computed properties to safely convert raw values into enums. This kept the data model flexible without making it messy.*

*Another challenge was keeping the selected child in sync across all screens. Since the app allows switching between children, I had to make sure the diary and incident screens always showed the correct data after a change. I resolved this by using AppState as shared observable state and refreshing the selected child whenever the child list changes. That stopped the app from showing stale data after deletions or selection changes.*

*Grouping diary entries by date was also a small challenge because I wanted the timeline to feel readable instead of showing one long list. I fixed this by grouping entries with Calendar.current.startOfDay(for:) and sorting the groups in reverse order so the newest updates appear first. This made the diary screen easier to scan and more useful for parents.*

*From a design point of view, it was difficult to balance a clean UI with enough information on the screen. I solved this by using summary cards on the Home screen and moving detailed content into the Diary and Incident detail views. That way the app feels lightweight at first glance, but the user can still open full details when needed.*


---

## 08. Reflection

### What went well?

*The part that went best was turning the requirements into a clean and usable app flow. I am happy with how the Home, Diary, and Incidents sections connect naturally through the tab layout, and how the user can quickly understand where to go. I am also satisfied with the consistency of the UI, especially the reusable cards, chips, and headers which made the app look more polished.*

*From the technical side, I am happy that the data model stayed manageable. Using separate Child, DiaryEntry, and Incident models with clear relationships made development easier and helped me avoid confusion later when adding filters, grouping, and acknowledgements. I am also satisfied with how local persistence and mock data were set up, because it made the MVP functional without depending on a backend.*

*Overall, I feel this project met the core Parent role goals well: parents can check daily updates and acknowledge incidents in a simple way. For the assignment timeline, I think the final scope was realistic and complete enough for an MVP.*

### What would you do differently?

*If I started again, I would spend more time on planning before coding. I began implementation quickly, but I realized later that writing a clearer screen-by-screen plan and data flow diagram early on would have reduced rework. Next time I would define all screen states (normal, empty, filtered, and error states) from the beginning.*

*I would also improve testing earlier in the process instead of leaving most validation to the end. Even though I did manual testing while building, I would add more unit tests for DataManager and model conversions sooner. This would help catch small issues faster, especially with optional fields and filtered lists.*

*In terms of technology choices, SwiftData was a good fit for MVP, but if this became a full product I would plan for cloud sync, authentication, role-based access, and proper audit logging from the start. For time management, I would split work into weekly mini-milestones with dedicated time for documentation, because writing detailed reports at the end was more time-consuming than expected.*

### AI Tool Usage

*I used AI tools mainly for support during development and documentation. The main tool used was GitHub Copilot in VS Code for code suggestions, refactoring support, and writing/report polishing. I also used AI assistance to improve wording quality in some documentation sections while keeping the technical content based on my own implementation decisions.*
*Also use Claude AI to create the Readme file structure (ex: table, lines, spacing)*

*How AI was used in this assignment:*
- *Refine wording and structure of README sections to be clearer and more professional.*
- *Help review consistency between implemented features and written explanations.*

---

*SE4020 — Mobile Application Design & Development | Semester 1, 2026 | SLIIT*



