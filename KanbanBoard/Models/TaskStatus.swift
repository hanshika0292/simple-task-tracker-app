//
//  TaskStatus.swift
//  KanbanBoard
//
//  Data model for task status columns
//

import Foundation

enum TaskStatus: String, Codable, CaseIterable {
    case backlog = "Backlog"
    case inProgress = "In Progress"
    case done = "Done"

    var displayName: String {
        self.rawValue
    }
}
