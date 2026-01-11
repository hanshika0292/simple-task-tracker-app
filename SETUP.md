# Kanban Board - Setup Guide

A lightweight, distraction-free personal Kanban board for macOS built with Swift and SwiftUI.

## 🚀 Quick Start

### 1. Create New Xcode Project

1. Open Xcode
2. **File > New > Project**
3. Select **macOS > App**
4. Fill in:
   - **Product Name:** KanbanBoard
   - **Interface:** SwiftUI
   - **Language:** Swift
   - **Minimum macOS:** 13.0 or later
5. Click **Next** and save

### 2. Add Source Files

Copy all the Swift files from this repository into your Xcode project:

```
KanbanBoard/
├── KanbanBoardApp.swift          # ← Main app entry point
├── Models/
│   ├── Task.swift
│   ├── Project.swift
│   └── TaskStatus.swift
├── ViewModels/
│   └── KanbanViewModel.swift
├── Views/
│   ├── ContentView.swift
│   ├── KanbanColumnView.swift
│   ├── TaskCardView.swift
│   └── ProjectFilterView.swift
└── Services/
    └── PersistenceManager.swift
```

**How to add files to Xcode:**
- Right-click on your project in the navigator
- **Add Files to "KanbanBoard"**
- Select all Swift files
- ✅ Check "Copy items if needed"
- Click **Add**

### 3. Run the App

1. Select your Mac as the run destination
2. Press **⌘R** or click the Play button
3. The app will launch with sample tasks across 3 projects

## 📁 Data Storage

Tasks and projects are automatically saved to:
```
~/Library/Application Support/KanbanBoard/
├── tasks.json
└── projects.json
```

Data persists between launches. To reset:
```bash
rm -rf ~/Library/Application\ Support/KanbanBoard
```

## 🎯 Core Features

### ✅ Implemented Now

- **3-column Kanban layout** (Backlog, In Progress, Done)
- **Multi-project support** (up to 3 default projects: Work, Personal, Learning)
- **Drag & drop** tasks between columns
- **Project filtering** with opacity-based dimming (not hiding)
- **Color-coded projects** for visual organization
- **Local JSON persistence** with auto-save
- **Add/delete tasks** with keyboard shortcuts
- **Hover effects** and minimal styling
- **Sample data** on first launch

### 🎨 UI/UX Decisions

- **Opacity filtering:** Unselected projects dim to 30% opacity instead of hiding
- **Color indicators:** Small circles show project colors on each task card
- **Minimal chrome:** Hidden title bar, clean borders, subtle shadows
- **Hover interactions:** Delete button appears on hover, column borders highlight
- **Native macOS feel:** System colors, native drag-and-drop, standard controls

## 🏗️ Architecture Deep Dive

### Data Flow

```
User Action → ViewModel → Model Update → Auto-save → Persistence
                ↓
            @Published
                ↓
          SwiftUI Update
```

### Key Design Patterns

1. **MVVM (Model-View-ViewModel)**
   - Models: Pure data structures (Task, Project, TaskStatus)
   - ViewModels: Business logic + state (KanbanViewModel)
   - Views: UI presentation only

2. **Reactive State Management**
   - `@Published` properties trigger UI updates
   - Combine framework for debounced auto-save
   - Single source of truth in ViewModel

3. **Persistence Strategy**
   - JSON files in Application Support directory
   - Debounced saves (0.5s delay to batch updates)
   - Lazy loading on app launch

4. **Drag & Drop Protocol**
   - `NSItemProvider` wraps task UUID
   - `onDrag` modifier on source tasks
   - `onDrop` modifier on target columns
   - UTType.text for cross-app compatibility

### State Management Decisions

**Why Observable Pattern?**
- Simple for single-window apps
- Automatic SwiftUI binding
- No external dependencies

**Why Debounced Auto-Save?**
- Prevents file thrashing during rapid changes
- Improves perceived performance
- Guarantees eventual consistency

**Why JSON over Core Data?**
- Human-readable debugging
- Easy export/backup
- Overkill for small data sets
- Simpler codebase

## 🔮 Future Enhancements

### Phase 1: Core Improvements
- [ ] **Search & filters** - Full-text search across tasks
- [ ] **Keyboard shortcuts** - J/K navigation, quick add (⌘N)
- [ ] **Task editing** - In-place editing without sheets
- [ ] **Due dates** - Calendar picker + visual indicators
- [ ] **Priority levels** - High/Medium/Low badges

### Phase 2: Power Features
- [ ] **iCloud sync** - CloudKit integration for multi-device
- [ ] **Subtasks** - Nested checklists within tasks
- [ ] **Tags system** - Custom tags beyond projects
- [ ] **Archive completed** - Move done tasks to archive
- [ ] **Undo/redo** - NSUndoManager integration

### Phase 3: Advanced
- [ ] **Time tracking** - Pomodoro-style timers
- [ ] **Notifications** - Reminders for due tasks
- [ ] **Export/import** - Markdown, CSV, JSON
- [ ] **Custom columns** - User-defined workflow stages
- [ ] **Dark mode refinements** - Custom color schemes

### Phase 4: Integrations
- [ ] **Calendar integration** - Sync with macOS Calendar
- [ ] **URL schemes** - Deep linking (kanban://add-task)
- [ ] **Shortcuts app** - Siri shortcuts for quick add
- [ ] **Menu bar app** - Quick capture without opening window
- [ ] **Share extension** - Add tasks from other apps

## 🛠️ Customization Guide

### Change Project Colors

Edit `Project.swift:20-24`:
```swift
static let templates: [Project] = [
    Project(name: "Work", colorHex: "#3B82F6"),    // Blue
    Project(name: "Home", colorHex: "#EF4444"),    // Red
    Project(name: "Study", colorHex: "#8B5CF6")    // Purple
]
```

### Add More Projects

In `KanbanViewModel.swift`, modify `createSampleTasks()` or add UI for project creation.

### Adjust Window Size

In `KanbanBoardApp.swift:14`:
```swift
.frame(minWidth: 1200, minHeight: 800)  // Larger default
```

### Change Auto-Save Delay

In `KanbanViewModel.swift:42`:
```swift
.debounce(for: .seconds(1.0), scheduler: DispatchQueue.main)
```

### Customize Task Card Appearance

Edit `TaskCardView.swift:23-51` for spacing, fonts, colors.

## 📦 Dependencies

**Zero external dependencies!** This app uses only:
- SwiftUI (built-in)
- Combine (built-in)
- Foundation (built-in)

## 🐛 Troubleshooting

### Tasks not saving?
Check permissions for `~/Library/Application Support/` or review console logs for persistence errors.

### Drag & drop not working?
Ensure you're running macOS 13.0+ and the app is sandboxed correctly.

### Build errors?
Verify all files are added to the target (check target membership in File Inspector).

## 📝 License

MIT License - feel free to modify and extend!

---

Built with ❤️ for distraction-free productivity.
