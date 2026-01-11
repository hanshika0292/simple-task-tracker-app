//
//  KanbanColumnView.swift
//  KanbanBoard
//
//  Single column with drag-and-drop support
//

import SwiftUI
import UniformTypeIdentifiers

struct KanbanColumnView: View {
    let status: TaskStatus
    let tasks: [Task]
    @ObservedObject var viewModel: KanbanViewModel
    let onEditTask: (Task) -> Void

    @State private var isTargeted = false

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Column header
            HStack {
                Text(status.displayName)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.primary)

                Spacer()

                Text("\(tasks.count)")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.secondary)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(Color.secondary.opacity(0.1))
                    .cornerRadius(4)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
            .background(Color(nsColor: .controlBackgroundColor))

            Divider()

            // Tasks list with drop zone
            ScrollView {
                VStack(spacing: 8) {
                    ForEach(tasks) { task in
                        TaskCardView(
                            task: task,
                            project: viewModel.project(for: task),
                            isDimmed: viewModel.isTaskDimmed(task),
                            onDelete: {
                                viewModel.deleteTask(task)
                            },
                            onEdit: {
                                onEditTask(task)
                            }
                        )
                        .onDrag {
                            // Create drag item with task ID
                            let itemProvider = NSItemProvider(object: task.id.uuidString as NSString)
                            return itemProvider
                        }
                    }

                    // Drop zone indicator when dragging
                    if isTargeted {
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(style: StrokeStyle(lineWidth: 2, dash: [5]))
                            .foregroundColor(.accentColor)
                            .frame(height: 60)
                            .overlay(
                                Text("Drop here")
                                    .font(.system(size: 11))
                                    .foregroundColor(.secondary)
                            )
                    }
                }
                .padding(12)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(nsColor: .textBackgroundColor))
            .onDrop(of: [UTType.text], isTargeted: $isTargeted) { providers in
                handleDrop(providers: providers)
            }
        }
        .frame(minWidth: 280)
        .background(Color(nsColor: .textBackgroundColor))
        .cornerRadius(8)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.secondary.opacity(0.2), lineWidth: 1)
        )
    }

    private func handleDrop(providers: [NSItemProvider]) -> Bool {
        guard let provider = providers.first else { return false }

        provider.loadItem(forTypeIdentifier: UTType.text.identifier, options: nil) { (data, error) in
            guard let data = data as? Data,
                  let taskIdString = String(data: data, encoding: .utf8),
                  let taskId = UUID(uuidString: taskIdString),
                  let task = viewModel.tasks.first(where: { $0.id == taskId })
            else { return }

            DispatchQueue.main.async {
                viewModel.moveTask(task, to: status)
            }
        }

        return true
    }
}
