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
    @State private var newTaskTitle = ""
    @State private var newTaskDescription = ""
    @State private var selectedProjectId: UUID?

    var body: some View {
        VStack(spacing: 0) {
            // Top toolbar
            HStack {
                Text("Kanban Board")
                    .font(.system(size: 20, weight: .semibold))

                Spacer()

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
                        tasks: viewModel.tasks(for: status),
                        viewModel: viewModel
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
                selectedProjectId: $selectedProjectId
            )
        }
    }
}

// MARK: - Add Task Sheet

struct AddTaskSheet: View {
    @ObservedObject var viewModel: KanbanViewModel
    @Binding var isPresented: Bool
    @Binding var title: String
    @Binding var description: String
    @Binding var selectedProjectId: UUID?

    var body: some View {
        VStack(spacing: 16) {
            Text("New Task")
                .font(.system(size: 16, weight: .semibold))

            TextField("Task title", text: $title)
                .textFieldStyle(.roundedBorder)

            TextField("Description (optional)", text: $description, axis: .vertical)
                .textFieldStyle(.roundedBorder)
                .lineLimit(3...6)

            Picker("Project", selection: $selectedProjectId) {
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

            HStack(spacing: 12) {
                Button("Cancel") {
                    isPresented = false
                    resetFields()
                }
                .keyboardShortcut(.cancelAction)

                Button("Add Task") {
                    if !title.isEmpty, let projectId = selectedProjectId {
                        viewModel.addTask(
                            title: title,
                            description: description,
                            projectId: projectId
                        )
                        isPresented = false
                        resetFields()
                    }
                }
                .keyboardShortcut(.defaultAction)
                .disabled(title.isEmpty || selectedProjectId == nil)
            }
        }
        .padding(20)
        .frame(width: 400)
    }

    private func resetFields() {
        title = ""
        description = ""
        selectedProjectId = viewModel.projects.first?.id
    }
}

#Preview {
    ContentView()
}
