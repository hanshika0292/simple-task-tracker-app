//
//  KanbanBoardApp.swift
//  KanbanBoard
//
//  Main app entry point for macOS
//

import SwiftUI

@main
struct KanbanBoardApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .frame(minWidth: 900, minHeight: 600)
        }
        .windowStyle(.hiddenTitleBar)
        .windowResizability(.contentSize)
        .commands {
            // Custom menu commands
            CommandGroup(after: .newItem) {
                Button("New Task") {
                    NotificationCenter.default.post(name: .addTask, object: nil)
                }
                .keyboardShortcut("n", modifiers: .command)
            }
        }
    }
}

extension Notification.Name {
    static let addTask = Notification.Name("addTask")
}
