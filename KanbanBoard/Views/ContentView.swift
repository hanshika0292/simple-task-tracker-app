//
//  ContentView.swift
//  KanbanBoard
//
//  Main application view with 3-column layout
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = KanbanViewModel()
    @State private var showingAddTask = false
    @State private var showingProjectManager = false
    @State private var showingEditTask = false
    @State private var editingTask: Task?
    @State private var newTaskTitle = ""
    @State private var newTaskDescription = ""
    @State private var newTaskNotes = ""
    @State private var selectedProjectId: UUID?

    var body: some View {
        VStack(spacing: 0) {
            // Top toolbar
            HStack {
                Text("Kanban Board")
                    .font(.system(size: 20, weight: .semibold))

                Spacer()

                Button(action: {
                    showingProjectManager = true
                }) {
                    HStack(spacing: 4) {
                        Image(systemName: "folder.badge.gearshape")
                        Text("Projects")
                    }
                    .font(.system(size: 12))
                }
                .buttonStyle(.bordered)
                .help("Manage projects")

                Button(action: {
                    showingAddTask = true
                    selectedProjectId = viewModel.projects.first?.id
                }) {
                    HStack(spacing: 4) {
                        Image(systemName: "plus")
                        Text("New Task")
                    }
                    .font(.system(size: 12))
                }
                .buttonStyle(.borderedProminent)
                .help("Add new task")
            }
            .padding(16)
            .background(Color(nsColor: .windowBackgroundColor))

            Divider()

            // Project filter
            ProjectFilterView(viewModel: viewModel)

            Divider()

            // Kanban columns
            HStack(spacing: 16) {
                ForEach(TaskStatus.allCases, id: \.self) { status in
                    KanbanColumnView(
                        status: status,
                        tasks: viewModel.sortedTasks(for: status),
                        viewModel: viewModel,
                        onEditTask: openEditTask
                    )
                }
            }
            .padding(16)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(nsColor: .windowBackgroundColor))
        }
        .sheet(isPresented: $showingAddTask) {
            AddTaskSheet(
                viewModel: viewModel,
                isPresented: $showingAddTask,
                title: $newTaskTitle,
                description: $newTaskDescription,
                notes: $newTaskNotes,
                selectedProjectId: $selectedProjectId
            )
        }
        .sheet(isPresented: $showingProjectManager) {
            ProjectManagerSheet(viewModel: viewModel, isPresented: $showingProjectManager)
        }
        .sheet(isPresented: $showingEditTask) {
            if let task = editingTask {
                EditTaskSheet(
                    viewModel: viewModel,
                    isPresented: $showingEditTask,
                    task: task
                )
            }
        }
    }

    func openEditTask(_ task: Task) {
        editingTask = task
        showingEditTask = true
    }
}

// MARK: - Add Task Sheet

struct AddTaskSheet: View {
    @ObservedObject var viewModel: KanbanViewModel
    @Binding var isPresented: Bool
    @Binding var title: String
    @Binding var description: String
    @Binding var notes: String
    @Binding var selectedProjectId: UUID?

    var body: some View {
        VStack(spacing: 20) {
            // Header
            HStack {
                Text("New Task")
                    .font(.system(size: 18, weight: .semibold))
                Spacer()
            }

            // Title
            VStack(alignment: .leading, spacing: 6) {
                Text("Title")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.secondary)
                TextField("Enter task title", text: $title)
                    .textFieldStyle(.roundedBorder)
                    .font(.system(size: 14))
            }

            // Description
            VStack(alignment: .leading, spacing: 6) {
                Text("Short Description")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.secondary)
                TextField("Quick summary (optional)", text: $description, axis: .vertical)
                    .textFieldStyle(.roundedBorder)
                    .font(.system(size: 12))
                    .lineLimit(2...3)
            }

            // Rich text notes
            VStack(alignment: .leading, spacing: 6) {
                Text("Detailed Notes (optional)")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.secondary)

                RichTextEditorView(text: $notes)
            }

            Divider()

            // Project picker
            HStack {
                Text("Project:")
                    .font(.system(size: 12, weight: .medium))

                Picker("", selection: $selectedProjectId) {
                    ForEach(viewModel.projects) { project in
                        HStack {
                            Circle()
                                .fill(project.color)
                                .frame(width: 8, height: 8)
                            Text(project.name)
                        }
                        .tag(project.id as UUID?)
                    }
                }
                .pickerStyle(.menu)
                .frame(width: 150)

                Spacer()
            }

            // Action buttons
            HStack(spacing: 12) {
                Button("Cancel") {
                    isPresented = false
                    resetFields()
                }
                .keyboardShortcut(.cancelAction)

                Spacer()

                Button("Add Task") {
                    if !title.isEmpty, let projectId = selectedProjectId {
                        viewModel.addTask(
                            title: title,
                            description: description,
                            notes: notes,
                            projectId: projectId
                        )
                        isPresented = false
                        resetFields()
                    }
                }
                .keyboardShortcut(.defaultAction)
                .buttonStyle(.borderedProminent)
                .disabled(title.isEmpty || selectedProjectId == nil)
            }
        }
        .padding(24)
        .frame(width: 650, height: 550)
    }

    private func resetFields() {
        title = ""
        description = ""
        notes = ""
        selectedProjectId = viewModel.projects.first?.id
    }
}

// MARK: - Project Manager Sheet

struct ProjectManagerSheet: View {
    @ObservedObject var viewModel: KanbanViewModel
    @Binding var isPresented: Bool

    @State private var newProjectName = ""
    @State private var newProjectColor = "#3B82F6"
    @State private var editingProject: Project?

    let availableColors = [
        "#3B82F6", "#EF4444", "#10B981", "#F59E0B",
        "#8B5CF6", "#EC4899", "#06B6D4", "#84CC16"
    ]

    var body: some View {
        VStack(spacing: 20) {
            Text("Manage Projects")
                .font(.system(size: 16, weight: .semibold))

            // Existing projects list
            VStack(alignment: .leading, spacing: 8) {
                Text("Your Projects")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.secondary)

                ForEach(viewModel.projects) { project in
                    HStack {
                        Circle()
                            .fill(project.color)
                            .frame(width: 12, height: 12)

                        if editingProject?.id == project.id {
                            TextField("Project name", text: Binding(
                                get: { editingProject?.name ?? "" },
                                set: { newName in
                                    if var editing = editingProject {
                                        editing.name = newName
                                        editingProject = editing
                                    }
                                }
                            ))
                            .textFieldStyle(.roundedBorder)
                            .font(.system(size: 12))

                            Button("Save") {
                                if let editing = editingProject {
                                    viewModel.updateProject(editing)
                                    editingProject = nil
                                }
                            }
                            .buttonStyle(.borderedProminent)
                            .controlSize(.small)

                            Button("Cancel") {
                                editingProject = nil
                            }
                            .buttonStyle(.bordered)
                            .controlSize(.small)
                        } else {
                            Text(project.name)
                                .font(.system(size: 12))

                            Spacer()

                            Button(action: {
                                editingProject = project
                            }) {
                                Image(systemName: "pencil")
                                    .font(.system(size: 10))
                            }
                            .buttonStyle(.plain)
                            .help("Rename project")

                            Button(action: {
                                viewModel.deleteProject(project)
                            }) {
                                Image(systemName: "trash")
                                    .font(.system(size: 10))
                                    .foregroundColor(.red)
                            }
                            .buttonStyle(.plain)
                            .help("Delete project")
                            .disabled(viewModel.projects.count <= 1)
                        }
                    }
                    .padding(8)
                    .background(Color(nsColor: .controlBackgroundColor))
                    .cornerRadius(6)
                }
            }

            Divider()

            // Add new project
            VStack(alignment: .leading, spacing: 8) {
                Text("Add New Project")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.secondary)

                TextField("Project name", text: $newProjectName)
                    .textFieldStyle(.roundedBorder)

                HStack(spacing: 8) {
                    Text("Color:")
                        .font(.system(size: 11))
                        .foregroundColor(.secondary)

                    ForEach(availableColors, id: \.self) { colorHex in
                        Button(action: {
                            newProjectColor = colorHex
                        }) {
                            Circle()
                                .fill(Color(hex: colorHex) ?? .blue)
                                .frame(width: 20, height: 20)
                                .overlay(
                                    Circle()
                                        .stroke(newProjectColor == colorHex ? Color.accentColor : Color.clear, lineWidth: 2)
                                )
                        }
                        .buttonStyle(.plain)
                    }
                }

                Button(action: {
                    if !newProjectName.isEmpty {
                        viewModel.addProject(name: newProjectName, colorHex: newProjectColor)
                        newProjectName = ""
                    }
                }) {
                    HStack {
                        Image(systemName: "plus")
                        Text("Add Project")
                    }
                    .font(.system(size: 12))
                    .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .disabled(newProjectName.isEmpty)
            }

            Divider()

            Button("Done") {
                isPresented = false
            }
            .keyboardShortcut(.defaultAction)
        }
        .padding(20)
        .frame(width: 450)
    }
}

// MARK: - Edit Task Sheet

struct EditTaskSheet: View {
    @ObservedObject var viewModel: KanbanViewModel
    @Binding var isPresented: Bool
    let task: Task

    @State private var title: String
    @State private var description: String
    @State private var notes: String
    @State private var projectId: UUID

    init(viewModel: KanbanViewModel, isPresented: Binding<Bool>, task: Task) {
        self.viewModel = viewModel
        self._isPresented = isPresented
        self.task = task
        self._title = State(initialValue: task.title)
        self._description = State(initialValue: task.description)
        self._notes = State(initialValue: task.notes)
        self._projectId = State(initialValue: task.projectId)
    }

    var body: some View {
        VStack(spacing: 20) {
            // Header
            HStack {
                Text("Edit Task")
                    .font(.system(size: 18, weight: .semibold))
                Spacer()
                Button(action: {
                    viewModel.deleteTask(task)
                    isPresented = false
                }) {
                    HStack(spacing: 4) {
                        Image(systemName: "trash")
                        Text("Delete")
                    }
                    .foregroundColor(.red)
                    .font(.system(size: 12))
                }
                .buttonStyle(.bordered)
            }

            // Title
            VStack(alignment: .leading, spacing: 6) {
                Text("Title")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.secondary)
                TextField("Enter task title", text: $title)
                    .textFieldStyle(.roundedBorder)
                    .font(.system(size: 14))
            }

            // Description
            VStack(alignment: .leading, spacing: 6) {
                Text("Short Description")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.secondary)
                TextField("Quick summary (optional)", text: $description, axis: .vertical)
                    .textFieldStyle(.roundedBorder)
                    .font(.system(size: 12))
                    .lineLimit(2...3)
            }

            // Rich text notes
            VStack(alignment: .leading, spacing: 6) {
                Text("Detailed Notes (optional)")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.secondary)

                RichTextEditorView(text: $notes)
            }

            Divider()

            // Project and status
            HStack(spacing: 16) {
                HStack {
                    Text("Project:")
                        .font(.system(size: 12, weight: .medium))

                    Picker("", selection: $projectId) {
                        ForEach(viewModel.projects) { project in
                            HStack {
                                Circle()
                                    .fill(project.color)
                                    .frame(width: 8, height: 8)
                                Text(project.name)
                            }
                            .tag(project.id)
                        }
                    }
                    .pickerStyle(.menu)
                    .frame(width: 150)
                }

                Spacer()

                // Status display
                HStack {
                    Text("Status:")
                        .font(.system(size: 12, weight: .medium))
                    Text(task.status.displayName)
                        .font(.system(size: 12))
                        .foregroundColor(.secondary)
                }
            }

            // Action buttons
            HStack(spacing: 12) {
                Button("Cancel") {
                    isPresented = false
                }
                .keyboardShortcut(.cancelAction)

                Spacer()

                Button("Save Changes") {
                    var updatedTask = task
                    updatedTask.title = title
                    updatedTask.description = description
                    updatedTask.notes = notes
                    updatedTask.projectId = projectId
                    viewModel.updateTask(updatedTask)
                    isPresented = false
                }
                .keyboardShortcut(.defaultAction)
                .buttonStyle(.borderedProminent)
                .disabled(title.isEmpty)
            }
        }
        .padding(24)
        .frame(width: 650, height: 550)
    }
}

#Preview {
    ContentView()
}
