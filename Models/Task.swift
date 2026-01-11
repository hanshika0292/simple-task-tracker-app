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
    var status: TaskStatus
    var projectId: UUID
    var createdAt: Date
    var updatedAt: Date

    init(
        id: UUID = UUID(),
        title: String,
        description: String = "",
        status: TaskStatus = .backlog,
        projectId: UUID,
        createdAt: Date = Date(),
        updatedAt: Date = Date()
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.status = status
        self.projectId = projectId
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}
