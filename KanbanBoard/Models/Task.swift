//
//  Task.swift
//  KanbanBoard
//
//  Core task model with project association
//

import Foundation

struct Task: Identifiable, Codable {
    let id: UUID
    var title: String
    var description: String
    var notes: String  // For longer text, code samples, thoughts
    var status: TaskStatus
    var projectId: UUID
    var createdAt: Date
    var updatedAt: Date

    init(
        id: UUID = UUID(),
        title: String,
        description: String = "",
        notes: String = "",
        status: TaskStatus = .backlog,
        projectId: UUID,
        createdAt: Date = Date(),
        updatedAt: Date = Date()
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.notes = notes
        self.status = status
        self.projectId = projectId
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}
