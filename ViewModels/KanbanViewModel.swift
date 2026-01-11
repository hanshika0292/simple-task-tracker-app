//
//  KanbanViewModel.swift
//  KanbanBoard
//
//  State management and business logic for the Kanban board
//

import Foundation
import Combine

class KanbanViewModel: ObservableObject {
    @Published var tasks: [Task] = []
    @Published var projects: [Project] = []
    @Published var selectedProjectId: UUID?

    private let persistenceManager = PersistenceManager.shared
    private var cancellables = Set<AnyCancellable>()

    init() {
        loadData()
        setupAutoSave()
    }

    // MARK: - Data Loading

    private func loadData() {
        let loadedProjects = persistenceManager.loadProjects()
        if loadedProjects.isEmpty {
            // First launch - create default projects
            projects = Project.templates
            persistenceManager.saveProjects(projects)
        } else {
            projects = loadedProjects
        }

        tasks = persistenceManager.loadTasks()

        // Create sample tasks if empty (first launch)
        if tasks.isEmpty {
            createSampleTasks()
        }
    }

    private func setupAutoSave() {
        // Auto-save tasks when they change
        $tasks
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .sink { [weak self] tasks in
                self?.persistenceManager.saveTasks(tasks)
            }
            .store(in: &cancellables)

        // Auto-save projects when they change
        $projects
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .sink { [weak self] projects in
                self?.persistenceManager.saveProjects(projects)
            }
            .store(in: &cancellables)
    }

    // MARK: - Task Management

    func addTask(title: String, description: String, projectId: UUID) {
        let newTask = Task(
            title: title,
            description: description,
            status: .backlog,
            projectId: projectId
        )
        tasks.append(newTask)
    }

    func updateTask(_ task: Task) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            var updatedTask = task
            updatedTask.updatedAt = Date()
            tasks[index] = updatedTask
        }
    }

    func deleteTask(_ task: Task) {
        tasks.removeAll { $0.id == task.id }
    }

    func moveTask(_ task: Task, to newStatus: TaskStatus) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            var updatedTask = task
            updatedTask.status = newStatus
            updatedTask.updatedAt = Date()
            tasks[index] = updatedTask
        }
    }

    // MARK: - Filtering

    func tasks(for status: TaskStatus) -> [Task] {
        tasks.filter { $0.status == status }
    }

    func filteredTasks(for status: TaskStatus) -> [Task] {
        let statusTasks = tasks(for: status)
        guard let selectedProjectId = selectedProjectId else {
            return statusTasks
        }
        return statusTasks.filter { $0.projectId == selectedProjectId }
    }

    func project(for task: Task) -> Project? {
        projects.first { $0.id == task.projectId }
    }

    func isTaskDimmed(_ task: Task) -> Bool {
        guard let selectedProjectId = selectedProjectId else {
            return false
        }
        return task.projectId != selectedProjectId
    }

    // MARK: - Project Management

    func addProject(name: String, colorHex: String) {
        let newProject = Project(name: name, colorHex: colorHex)
        projects.append(newProject)
    }

    func toggleProjectFilter(_ projectId: UUID) {
        if selectedProjectId == projectId {
            selectedProjectId = nil // Clear filter
        } else {
            selectedProjectId = projectId
        }
    }

    func clearFilter() {
        selectedProjectId = nil
    }

    // MARK: - Sample Data

    private func createSampleTasks() {
        guard projects.count >= 3 else { return }

        let workId = projects[0].id
        let personalId = projects[1].id
        let learningId = projects[2].id

        let sampleTasks = [
            Task(title: "Review Q1 roadmap", description: "Align with team priorities", status: .backlog, projectId: workId),
            Task(title: "Fix authentication bug", description: "Users can't log in with SSO", status: .inProgress, projectId: workId),
            Task(title: "Deploy to staging", description: "Test new API endpoints", status: .done, projectId: workId),

            Task(title: "Book dentist appointment", description: "Overdue checkup", status: .backlog, projectId: personalId),
            Task(title: "Plan weekend trip", description: "Research hiking trails", status: .inProgress, projectId: personalId),

            Task(title: "Complete SwiftUI course", description: "Chapters 5-7", status: .backlog, projectId: learningId),
            Task(title: "Read Combine documentation", description: "Focus on publishers", status: .inProgress, projectId: learningId),
            Task(title: "Build sample Kanban app", description: "Practice drag and drop", status: .done, projectId: learningId)
        ]

        tasks = sampleTasks
        persistenceManager.saveTasks(tasks)
    }
}
