//
//  PersistenceManager.swift
//  KanbanBoard
//
//  Handles JSON-based local persistence
//

import Foundation

class PersistenceManager {
    static let shared = PersistenceManager()

    private let tasksFileName = "tasks.json"
    private let projectsFileName = "projects.json"

    private var dataDirectory: URL {
        let paths = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)
        let appSupportDir = paths[0].appendingPathComponent("Lifeboard", isDirectory: true)

        // Create directory if it doesn't exist
        if !FileManager.default.fileExists(atPath: appSupportDir.path) {
            try? FileManager.default.createDirectory(at: appSupportDir, withIntermediateDirectories: true)
        }

        return appSupportDir
    }

    private var tasksURL: URL {
        dataDirectory.appendingPathComponent(tasksFileName)
    }

    private var projectsURL: URL {
        dataDirectory.appendingPathComponent(projectsFileName)
    }

    // MARK: - Tasks Persistence

    func saveTasks(_ tasks: [Task]) {
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            let data = try encoder.encode(tasks)
            try data.write(to: tasksURL)
        } catch {
            print("Error saving tasks: \(error)")
        }
    }

    func loadTasks() -> [Task] {
        guard FileManager.default.fileExists(atPath: tasksURL.path) else {
            return []
        }

        do {
            let data = try Data(contentsOf: tasksURL)
            let decoder = JSONDecoder()
            return try decoder.decode([Task].self, from: data)
        } catch {
            print("Error loading tasks: \(error)")
            return []
        }
    }

    // MARK: - Projects Persistence

    func saveProjects(_ projects: [Project]) {
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            let data = try encoder.encode(projects)
            try data.write(to: projectsURL)
        } catch {
            print("Error saving projects: \(error)")
        }
    }

    func loadProjects() -> [Project] {
        guard FileManager.default.fileExists(atPath: projectsURL.path) else {
            return []
        }

        do {
            let data = try Data(contentsOf: projectsURL)
            let decoder = JSONDecoder()
            return try decoder.decode([Project].self, from: data)
        } catch {
            print("Error loading projects: \(error)")
            return []
        }
    }

    // MARK: - Utility

    func clearAllData() {
        try? FileManager.default.removeItem(at: tasksURL)
        try? FileManager.default.removeItem(at: projectsURL)
    }
}
