# Kanban Board - Architecture Documentation

## 📐 System Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                      KanbanBoardApp                         │
│                    (App Entry Point)                        │
└────────────────────┬────────────────────────────────────────┘
                     │
                     ▼
┌─────────────────────────────────────────────────────────────┐
│                       ContentView                           │
│              (Main Container + Toolbar)                     │
└─────┬───────────────┬───────────────┬───────────────────────┘
      │               │               │
      ▼               ▼               ▼
┌──────────┐  ┌──────────────┐  ┌──────────────┐
│ Project  │  │  Backlog     │  │ In Progress  │  Done
│ Filter   │  │  Column      │  │  Column      │  Column
└────┬─────┘  └──────┬───────┘  └──────┬───────┘  └──┬────
     │               │                  │              │
     │               ▼                  ▼              ▼
     │         ┌──────────────────────────────────────────┐
     │         │         TaskCardView (Repeating)         │
     │         └──────────────────────────────────────────┘
     │                           │
     └───────────────────────────┼───────────────────────┐
                                 │                       │
                                 ▼                       ▼
                    ┌────────────────────┐   ┌──────────────────┐
                    │  KanbanViewModel   │◄──│ PersistenceManager│
                    │  (State + Logic)   │   │  (JSON Storage)   │
                    └────────┬───────────┘   └──────────────────┘
                             │
                             ▼
                    ┌────────────────────┐
                    │   Models           │
                    │  • Task            │
                    │  • Project         │
                    │  • TaskStatus      │
                    └────────────────────┘
```

## 🔄 Data Flow

### 1. User Creates Task

```
User clicks "New Task"
      ↓
AddTaskSheet presented
      ↓
User fills form → clicks "Add Task"
      ↓
viewModel.addTask(title, description, projectId)
      ↓
Task appended to @Published tasks array
      ↓
SwiftUI automatically re-renders affected views
      ↓
Combine debounces for 0.5s
      ↓
PersistenceManager.saveTasks() writes JSON
```

### 2. User Drags Task

```
User drags TaskCardView
      ↓
onDrag { NSItemProvider(task.id.uuidString) }
      ↓
User drops on KanbanColumnView
      ↓
onDrop { handleDrop(providers) }
      ↓
Extract task ID from NSItemProvider
      ↓
viewModel.moveTask(task, to: newStatus)
      ↓
Task status updated in array
      ↓
SwiftUI re-renders both columns
      ↓
Auto-save triggered
```

### 3. User Filters Projects

```
User clicks project filter button
      ↓
viewModel.toggleProjectFilter(projectId)
      ↓
selectedProjectId updated (@Published)
      ↓
All TaskCardViews re-render with isTaskDimmed()
      ↓
Non-matching tasks fade to 30% opacity
```

## 🧩 Component Responsibilities

### Models (Data Layer)

**Task.swift**
- Pure data structure
- Identifiable for SwiftUI ForEach
- Codable for JSON serialization
- Contains: title, description, status, projectId, timestamps

**Project.swift**
- Identifiable + Codable
- Color hex → SwiftUI Color conversion
- Static templates for default projects
- Extension: Color(hex:) for hex parsing

**TaskStatus.swift**
- Enum for type safety
- CaseIterable for column iteration
- Raw values match display names

### ViewModels (Business Logic)

**KanbanViewModel.swift**
- Single source of truth (SSOT)
- ObservableObject with @Published properties
- CRUD operations: addTask, updateTask, deleteTask, moveTask
- Filtering logic: tasks(for:), isTaskDimmed()
- Auto-save with Combine debouncing
- Project management
- Sample data generation

### Views (Presentation Layer)

**ContentView.swift**
- Top-level container
- Toolbar with "New Task" button
- ProjectFilterView integration
- HStack of 3 KanbanColumnViews
- AddTaskSheet presentation

**KanbanColumnView.swift**
- Single status column
- Header with count badge
- ScrollView for task list
- Drop target for drag-and-drop
- isTargeted state for visual feedback

**TaskCardView.swift**
- Individual task representation
- Project color indicator (circle)
- Hover state for delete button
- Opacity based on filter
- onDrag gesture

**ProjectFilterView.swift**
- Horizontal list of project buttons
- Active state highlighting
- "Clear" button when filtered
- Task count display

### Services (Infrastructure)

**PersistenceManager.swift**
- Singleton pattern
- JSON encoding/decoding
- File system operations
- Application Support directory management
- Separate files for tasks/projects
- Error handling with graceful degradation

## 🎨 Design Decisions

### Why MVVM Over MVC/VIPER?

**Pros:**
- Natural fit for SwiftUI's reactive paradigm
- Less boilerplate than VIPER
- Clear separation without over-engineering
- Easy to test business logic

**Cons:**
- View can become complex (mitigated by sub-components)
- ViewModel can grow large (future: split by feature)

### Why @Published Over @State?

- State lives in ViewModel (not View)
- Survives view recreation
- Single source of truth
- Easy to add computed properties

### Why Debounced Auto-Save?

**Without debouncing:**
- Rapid drag-and-drop = 10+ saves/second
- File system thrashing
- Poor performance on slower disks

**With 0.5s debounce:**
- Batch multiple changes
- Save only after user stops interacting
- Still feels instant (below perception threshold)

### Why Opacity Filtering Instead of Hiding?

**Design philosophy:**
- User maintains context of all tasks
- Filtered view is still "complete picture"
- Prevents confusion ("where did my tasks go?")
- Enables cross-project comparisons

**Implementation:**
```swift
.opacity(isDimmed ? 0.3 : 1.0)
```

### Why JSON Over Core Data?

| Aspect | JSON | Core Data |
|--------|------|-----------|
| Complexity | Low | High |
| Debugging | Easy (human-readable) | Hard (binary format) |
| Migrations | Manual | Automatic |
| Performance | Good (<1000 tasks) | Excellent (>10k tasks) |
| iCloud Sync | Manual | Built-in |

**Decision:** Start simple, migrate later if needed.

## 🔐 Data Persistence Strategy

### File Locations

```
~/Library/Application Support/KanbanBoard/
├── tasks.json       # Array of Task objects
└── projects.json    # Array of Project objects
```

### JSON Structure

**tasks.json:**
```json
[
  {
    "id": "UUID-STRING",
    "title": "Review Q1 roadmap",
    "description": "Align with team",
    "status": "backlog",
    "projectId": "PROJECT-UUID",
    "createdAt": "2024-01-15T10:30:00Z",
    "updatedAt": "2024-01-15T10:30:00Z"
  }
]
```

**projects.json:**
```json
[
  {
    "id": "UUID-STRING",
    "name": "Work",
    "colorHex": "#3B82F6"
  }
]
```

### Save/Load Lifecycle

```
App Launch
    ↓
loadProjects() → Empty? → Create templates
    ↓
loadTasks() → Empty? → Create samples
    ↓
Normal operation
    ↓
Any @Published change
    ↓
Debounce 0.5s
    ↓
saveTasks() / saveProjects()
    ↓
App Quit (automatic - no manual save needed)
```

## 🎯 Drag & Drop Implementation

### Protocol

1. **Drag Source** (TaskCardView)
```swift
.onDrag {
    NSItemProvider(object: task.id.uuidString as NSString)
}
```

2. **Drop Target** (KanbanColumnView)
```swift
.onDrop(of: [UTType.text], isTargeted: $isTargeted) { providers in
    handleDrop(providers)
}
```

3. **Data Transfer**
```swift
provider.loadItem(forTypeIdentifier: UTType.text.identifier) { data, error in
    let taskIdString = String(data: data, encoding: .utf8)
    let taskId = UUID(uuidString: taskIdString)
    viewModel.moveTask(task, to: newStatus)
}
```

### Why UTType.text?

- **Universal:** Works across macOS apps
- **Simple:** String-based transfer
- **Reliable:** Native framework support

Alternative: Custom UTType for type safety (future enhancement)

## 🚀 Performance Considerations

### Current Scale

- **Target:** 3 projects, ~100 tasks
- **Load time:** <50ms (JSON parsing)
- **Save time:** <10ms (debounced)
- **Memory:** ~1MB (entire dataset in RAM)

### Optimization Points

1. **If tasks > 1000:**
   - Migrate to Core Data
   - Implement lazy loading
   - Use NSFetchedResultsController

2. **If columns lag:**
   - Add virtual scrolling (LazyVStack)
   - Cache filtered results
   - Memoize project lookups

3. **If saves slow down:**
   - Increase debounce to 1s
   - Implement dirty tracking
   - Save only changed objects

## 🧪 Testability

### Unit Test Targets

**KanbanViewModel:**
- ✅ addTask() creates task in correct status
- ✅ moveTask() updates status and timestamp
- ✅ deleteTask() removes from array
- ✅ filtering logic returns correct tasks
- ✅ project lookup finds correct project

**PersistenceManager:**
- ✅ saveTasks() writes valid JSON
- ✅ loadTasks() handles missing file
- ✅ JSON encoding/decoding round-trip

### UI Test Targets

- ✅ Drag task from Backlog to In Progress
- ✅ Filter by project dims other tasks
- ✅ Add task via sheet creates card
- ✅ Delete button removes task

## 🔮 Extension Points

### How to Add Features

**1. Add Due Dates**
```swift
// Models/Task.swift
var dueDate: Date?

// Views/TaskCardView.swift
if let dueDate = task.dueDate {
    Text(dueDate, style: .date)
}
```

**2. Add Search**
```swift
// ViewModels/KanbanViewModel.swift
@Published var searchQuery = ""

func filteredTasks(for status: TaskStatus) -> [Task] {
    tasks(for: status).filter { task in
        searchQuery.isEmpty ||
        task.title.localizedCaseInsensitiveContains(searchQuery)
    }
}
```

**3. Add iCloud Sync**
```swift
// Replace PersistenceManager with NSPersistentCloudKitContainer
// Migrate JSON → Core Data
// Enable CloudKit capability in Xcode
```

## 📚 Key Technologies

- **SwiftUI:** Declarative UI framework
- **Combine:** Reactive programming (debouncing)
- **Codable:** JSON serialization
- **NSItemProvider:** Drag & drop data transfer
- **UniformTypeIdentifiers:** Type system for drag & drop
- **FileManager:** File system operations
- **ObservableObject:** Reactive state management

## 🎓 Learning Resources

- [Apple's SwiftUI Tutorials](https://developer.apple.com/tutorials/swiftui)
- [Combine Framework Documentation](https://developer.apple.com/documentation/combine)
- [MVVM in SwiftUI](https://www.avanderlee.com/swiftui/mvvm/)
- [Drag & Drop in macOS](https://developer.apple.com/documentation/swiftui/drag-and-drop)

---

**Architecture Version:** 1.0
**Last Updated:** 2024-01-11
