# 🚀 Quick Start Guide - Build & Test in 5 Minutes

This guide will get your Kanban Board running in Xcode in under 5 minutes.

## 📋 Prerequisites

- **macOS 13.0 (Ventura)** or later
- **Xcode 14.0+** ([Download from App Store](https://apps.apple.com/app/xcode/id497799835))

## 🎯 Method 1: Create New Xcode Project (Recommended)

### Step 1: Create New Project

1. Open **Xcode**
2. Choose **File > New > Project** (or ⌘⇧N)
3. Select **macOS** tab
4. Choose **App** template
5. Click **Next**

### Step 2: Configure Project

Fill in these settings:
- **Product Name:** `KanbanBoard`
- **Team:** Your development team (or leave as None)
- **Organization Identifier:** `com.yourname` (or anything)
- **Interface:** **SwiftUI** ✅
- **Language:** **Swift** ✅
- **Storage:** None (we have custom persistence)
- **Include Tests:** ✅ (optional)

Click **Next** and save OUTSIDE this repository folder (e.g., Desktop/KanbanBoard)

### Step 3: Add Source Files

1. In Xcode's **Navigator** (left sidebar), right-click on the **KanbanBoard** folder (the one with blue icon)
2. Choose **Add Files to "KanbanBoard"...**
3. Navigate to this repository's `KanbanBoard/` folder
4. Select ALL items:
   - `KanbanBoardApp.swift`
   - `Models/` folder
   - `ViewModels/` folder
   - `Views/` folder
   - `Services/` folder
5. ✅ Check **"Copy items if needed"**
6. ✅ Check **"Create groups"** (not references)
7. ✅ Check **Add to targets: KanbanBoard**
8. Click **Add**

### Step 4: Delete Template Files

Xcode created a default `ContentView.swift` and `KanbanBoardApp.swift`. Delete them:
1. In Navigator, find the OLD `ContentView.swift` (created by Xcode template)
2. Right-click → **Delete** → **Move to Trash**
3. Do the same for the OLD `KanbanBoardApp.swift`

**Keep the NEW ones you just imported!**

### Step 5: Verify File Structure

Your Navigator should look like this:
```
KanbanBoard/
├── KanbanBoardApp.swift      ← Your imported one
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
├── Services/
│   └── PersistenceManager.swift
├── Assets.xcassets/
└── Preview Content/
```

### Step 6: Build & Run 🎉

1. Select **My Mac** as the run destination (top toolbar)
2. Press **⌘R** or click the **Play ▶** button
3. Your Kanban Board launches with sample tasks!

---

## 🎯 Method 2: Quick Import (Alternative)

If you want to work directly in this repository:

### Step 1: Open Xcode

1. Open **Xcode**
2. Choose **File > Open...**
3. Navigate to this repository folder
4. Select the **entire folder** (not individual files)
5. Click **Open**

### Step 2: Create Xcode Project File

Since there's no `.xcodeproj` yet:

1. In Xcode, choose **File > New > Project**
2. Select **macOS > App**
3. Configure:
   - **Product Name:** `KanbanBoard`
   - **Interface:** SwiftUI
   - **Language:** Swift
4. **IMPORTANT:** Save it INSIDE this repository folder (select the root folder)
5. When prompted "Replace?", choose **Merge** (don't replace)

### Step 3: Add Existing Files

1. Right-click on **KanbanBoard** folder in Navigator
2. **Add Files to "KanbanBoard"...**
3. Select the `KanbanBoard/` folder from repository
4. ✅ Check all options mentioned in Method 1
5. Delete duplicate template files

### Step 4: Run

Press **⌘R** to build and run!

---

## 🎯 Method 3: Command Line (For Swift Developers)

Create a simple Swift Package to test:

```bash
# Navigate to repository
cd /path/to/simple-task-tracker-app

# Open in Xcode (it will recognize the structure)
open -a Xcode KanbanBoard/

# In Xcode: File > New > Project in Current Folder
# Then add files as described above
```

---

## ✅ Verify It Works

After running, you should see:

1. **Window with 3 columns:**
   - Backlog (left)
   - In Progress (middle)
   - Done (right)

2. **Top toolbar:**
   - "Kanban Board" title
   - "+ New Task" button

3. **Project filter bar:**
   - Three project buttons (Work, Personal, Learning)
   - Task count

4. **Sample tasks** distributed across columns with colored dots

5. **Drag & drop:**
   - Drag any task to another column
   - It moves and saves automatically

6. **Click project filter:**
   - Click "Work" → other tasks dim to 30% opacity
   - Click again → all tasks full opacity

---

## 🐛 Troubleshooting

### "No such module 'SwiftUI'"
- Ensure **macOS deployment target** is 13.0+
- Check in Project Settings > General > Minimum Deployments

### "Cannot find type 'Task' in scope"
- Make sure ALL files are added to the **KanbanBoard target**
- Right-click each file → Show File Inspector → Check target membership

### Drag & drop not working
- Ensure you're running on **macOS 13.0+**
- Check that `UniformTypeIdentifiers` is imported in `KanbanColumnView.swift`

### Build errors about missing files
- Verify file paths in Navigator (should be relative, not absolute)
- Clean build folder: **Product > Clean Build Folder** (⌘⇧K)
- Restart Xcode

### "The file couldn't be opened because there is no such file"
- Make sure you **copied items** when adding files (check "Copy items if needed")
- Files should be inside Xcode project folder, not just referenced

### App crashes on launch
- Check Console for errors (**View > Debug Area > Activate Console**)
- Most common: Missing Info.plist keys (should be auto-generated)

---

## 🎨 Customize Before Running

### Change Default Projects

Edit `KanbanBoard/Models/Project.swift:27-31`:

```swift
static let templates: [Project] = [
    Project(name: "Frontend", colorHex: "#3B82F6"),
    Project(name: "Backend", colorHex: "#EF4444"),
    Project(name: "DevOps", colorHex: "#8B5CF6")
]
```

### Change Window Size

Edit `KanbanBoard/KanbanBoardApp.swift:14`:

```swift
.frame(minWidth: 1200, minHeight: 800)  // Bigger window
```

### Disable Sample Data

Edit `KanbanBoard/ViewModels/KanbanViewModel.swift:33-37`:

```swift
// Comment out this line:
// if tasks.isEmpty { createSampleTasks() }
```

---

## 📁 Where Data is Stored

Once running, your data saves to:
```
~/Library/Application Support/KanbanBoard/
├── tasks.json
└── projects.json
```

**View saved data:**
```bash
cat ~/Library/Application\ Support/KanbanBoard/tasks.json
```

**Reset to fresh state:**
```bash
rm -rf ~/Library/Application\ Support/KanbanBoard/
```

---

## 🎯 Test Checklist

After running, test these features:

- [ ] **Create task:** Click "+ New Task", fill form, click "Add Task"
- [ ] **Drag task:** Drag from Backlog → In Progress (should move)
- [ ] **Filter project:** Click "Work" button (others should dim)
- [ ] **Delete task:** Hover over task, click X button
- [ ] **Persistence:** Quit app, reopen (tasks should remain)
- [ ] **Auto-save:** Drag task, force-quit immediately, reopen (move should be saved)

---

## 🎓 Next Steps

Once it's running:

1. **Read the docs:**
   - [ARCHITECTURE.md](ARCHITECTURE.md) - Deep technical dive
   - [SETUP.md](SETUP.md) - Customization guide
   - [README.md](README.md) - Feature overview

2. **Customize:**
   - Change project names/colors
   - Modify window size
   - Adjust auto-save delay

3. **Extend:**
   - Add search functionality
   - Implement keyboard shortcuts
   - Add due dates
   - Enable iCloud sync

See [SETUP.md - Future Enhancements](SETUP.md#-future-enhancements) for 30+ improvement ideas.

---

## 💡 Tips

- **Xcode Shortcuts:**
  - ⌘R = Run
  - ⌘B = Build
  - ⌘. = Stop
  - ⌘⇧K = Clean Build
  - ⌘⇧O = Quick Open

- **Debug Console:**
  - View > Debug Area > Show Debug Area (⌘⇧Y)
  - See print statements and errors

- **SwiftUI Previews:**
  - Some views have `#Preview` blocks
  - Click "Resume" in canvas to see live preview
  - Faster than full app builds for UI tweaks

---

## 🆘 Still Having Issues?

1. **Check Xcode version:** Xcode > About Xcode (should be 14.0+)
2. **Check macOS version:** Apple menu > About This Mac (should be 13.0+)
3. **Clean everything:**
   ```bash
   # In Xcode:
   Product > Clean Build Folder (⌘⇧K)

   # Close Xcode, then:
   rm -rf ~/Library/Developer/Xcode/DerivedData/KanbanBoard-*
   ```
4. **Start fresh:** Follow Method 1 again with a new Xcode project

---

**Ready to build! 🚀**

Choose Method 1 (recommended) and you'll be running in < 5 minutes.
