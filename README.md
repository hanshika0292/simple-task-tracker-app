# 📋 Kanban Board for macOS

A lightweight, distraction-free personal Kanban board built with Swift and SwiftUI. Manage tasks across multiple projects in one unified view without clutter.

![macOS](https://img.shields.io/badge/macOS-13.0+-blue)
![Swift](https://img.shields.io/badge/Swift-5.9+-orange)
![SwiftUI](https://img.shields.io/badge/SwiftUI-Native-green)
![License](https://img.shields.io/badge/license-MIT-lightgrey)

## ✨ Features

- **🎯 3-Column Kanban Layout** - Backlog, In Progress, Done
- **🎨 Multi-Project Support** - Up to 3 projects with color coding
- **🔍 Smart Filtering** - Dim (not hide) unselected projects for context
- **🖱️ Native Drag & Drop** - Move tasks between columns effortlessly
- **💾 Auto-Save** - JSON-based persistence with debounced writes
- **⌨️ Keyboard Shortcuts** - ⌘N for new tasks
- **🎨 Minimal Design** - Clean, distraction-free interface
- **📦 Zero Dependencies** - Uses only native macOS frameworks

## 🚀 Quick Start

### Prerequisites
- macOS 13.0 (Ventura) or later
- Xcode 14.0+

### Installation

1. **Clone this repository:**
```bash
git clone https://github.com/yourusername/kanban-board-macos.git
cd kanban-board-macos
```

2. **Open in Xcode:**
```bash
open KanbanBoard.xcodeproj
```

3. **Build and Run:**
- Select your Mac as the run destination
- Press ⌘R or click the Play button
- The app launches with sample tasks

**Or create from scratch:** See [SETUP.md](SETUP.md) for step-by-step instructions.

## 📸 Screenshots

```
┌─────────────────────────────────────────────────────────────┐
│  Kanban Board                                  [+ New Task]  │
├─────────────────────────────────────────────────────────────┤
│  Projects: [●Work] [●Personal] [●Learning]    8 tasks       │
├─────────────────────────────────────────────────────────────┤
│  ┌─Backlog──┐  ┌─In Progress─┐  ┌─Done──────┐             │
│  │ ● Task 1 │  │ ● Task 2     │  │ ● Task 3  │             │
│  │   Work   │  │   Personal   │  │   Learning│             │
│  │──────────│  │──────────────│  │───────────│             │
│  │ ● Task 4 │  │              │  │           │             │
│  │   Learning│  │              │  │           │             │
│  └──────────┘  └──────────────┘  └───────────┘             │
└─────────────────────────────────────────────────────────────┘
```

## 🏗️ Architecture

Built with **MVVM pattern** for clean separation and testability:

```
Models/
  ├── Task.swift           # Task data model
  ├── Project.swift        # Project with color coding
  └── TaskStatus.swift     # Backlog/InProgress/Done enum

ViewModels/
  └── KanbanViewModel.swift # State management + business logic

Views/
  ├── ContentView.swift     # Main container
  ├── KanbanColumnView.swift # Column with drag-and-drop
  ├── TaskCardView.swift    # Individual task card
  └── ProjectFilterView.swift # Filter UI

Services/
  └── PersistenceManager.swift # JSON file storage

KanbanBoardApp.swift       # App entry point
```

**Key Technologies:**
- SwiftUI for declarative UI
- Combine for reactive state management
- Codable for JSON serialization
- NSItemProvider for drag & drop

📖 **Deep Dive:** See [ARCHITECTURE.md](ARCHITECTURE.md) for detailed design decisions.

## 🎯 Usage

### Adding Tasks
1. Click **"+ New Task"** or press **⌘N**
2. Enter title, description (optional), and select project
3. Task appears in Backlog column

### Moving Tasks
- **Drag and drop** tasks between columns
- Status updates automatically
- Changes save within 0.5 seconds

### Filtering Projects
- Click a project button to focus
- Other projects dim to 30% opacity (still visible for context)
- Click again or press "Clear" to show all

### Deleting Tasks
- Hover over a task card
- Click the **X** button that appears

## 📁 Data Storage

Tasks and projects persist to:
```
~/Library/Application Support/KanbanBoard/
├── tasks.json
└── projects.json
```

**Backup your data:**
```bash
cp -r ~/Library/Application\ Support/KanbanBoard ~/Desktop/kanban-backup
```

**Reset to defaults:**
```bash
rm -rf ~/Library/Application\ Support/KanbanBoard
```

## 🔮 Roadmap

### Phase 1: Core Improvements
- [ ] Full-text search across tasks
- [ ] Advanced keyboard shortcuts (J/K navigation)
- [ ] In-place task editing
- [ ] Due dates with calendar picker
- [ ] Priority levels (High/Medium/Low)

### Phase 2: Power Features
- [ ] iCloud sync for multi-device
- [ ] Nested subtasks with checklists
- [ ] Custom tags beyond projects
- [ ] Archive for completed tasks
- [ ] Undo/redo support

### Phase 3: Integrations
- [ ] macOS Calendar sync
- [ ] Reminders app integration
- [ ] Siri Shortcuts support
- [ ] Menu bar quick capture
- [ ] Export to Markdown/CSV

📝 **See full list:** [SETUP.md - Future Enhancements](SETUP.md#-future-enhancements)

## 🛠️ Customization

### Change Project Colors
Edit `Models/Project.swift:20-24`:
```swift
static let templates: [Project] = [
    Project(name: "Work", colorHex: "#3B82F6"),
    Project(name: "Home", colorHex: "#EF4444"),
    Project(name: "Study", colorHex: "#8B5CF6")
]
```

### Adjust Window Size
Edit `KanbanBoardApp.swift:14`:
```swift
.frame(minWidth: 1200, minHeight: 800)
```

### Add More Columns
Edit `Models/TaskStatus.swift` and add cases:
```swift
enum TaskStatus: String, Codable, CaseIterable {
    case backlog = "Backlog"
    case inProgress = "In Progress"
    case review = "Review"  // New!
    case done = "Done"
}
```

## 🧪 Testing

### Run Unit Tests
```bash
xcodebuild test -scheme KanbanBoard -destination 'platform=macOS'
```

### Manual Testing Checklist
- [ ] Create task → appears in Backlog
- [ ] Drag task → updates status + saves
- [ ] Filter project → dims others
- [ ] Delete task → removes from list
- [ ] Restart app → data persists

## 🤝 Contributing

Contributions welcome! Please:
1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit changes (`git commit -m 'Add amazing feature'`)
4. Push to branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

MIT License - see [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Built with [SwiftUI](https://developer.apple.com/xcode/swiftui/)
- Inspired by [Trello](https://trello.com) and [Linear](https://linear.app)
- Color palette from [Tailwind CSS](https://tailwindcss.com/docs/customizing-colors)

## 📧 Contact

Questions or feedback? Open an issue or reach out!

---

**Built with ❤️ for distraction-free productivity on macOS**
