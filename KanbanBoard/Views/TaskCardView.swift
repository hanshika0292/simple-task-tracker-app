//
//  TaskCardView.swift
//  KanbanBoard
//
//  Individual task card with project color indicator
//

import SwiftUI

struct TaskCardView: View {
    let task: Task
    let project: Project?
    let isDimmed: Bool
    let onDelete: () -> Void

    @State private var isHovering = false
    @State private var isExpanded = false

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(alignment: .top) {
                // Project color indicator
                if let project = project {
                    Circle()
                        .fill(project.color)
                        .frame(width: 8, height: 8)
                        .padding(.top, 2)
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text(task.title)
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(.primary)

                    if !task.description.isEmpty {
                        Text(task.description)
                            .font(.system(size: 11))
                            .foregroundColor(.secondary)
                            .lineLimit(isExpanded ? nil : 2)
                    }

                    // Show notes if expanded
                    if isExpanded && !task.notes.isEmpty {
                        Text(task.notes)
                            .font(.system(size: 10, design: .monospaced))
                            .foregroundColor(.secondary.opacity(0.8))
                            .padding(6)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color(nsColor: .textBackgroundColor))
                            .cornerRadius(4)
                    }

                    HStack(spacing: 6) {
                        if let project = project {
                            Text(project.name)
                                .font(.system(size: 10, weight: .medium))
                                .foregroundColor(project.color)
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(project.color.opacity(0.15))
                                .cornerRadius(4)
                        }

                        // Expand button if there are notes
                        if !task.notes.isEmpty {
                            Button(action: { isExpanded.toggle() }) {
                                HStack(spacing: 2) {
                                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                                    Text(isExpanded ? "Less" : "More")
                                }
                                .font(.system(size: 9, weight: .medium))
                                .foregroundColor(.secondary)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }

                Spacer()

                // Delete button (shows on hover)
                if isHovering {
                    Button(action: onDelete) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.secondary)
                            .imageScale(.small)
                    }
                    .buttonStyle(.plain)
                    .help("Delete task")
                }
            }
        }
        .padding(10)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(nsColor: .controlBackgroundColor))
        .cornerRadius(6)
        .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
        .opacity(isDimmed ? 0.3 : 1.0)
        .overlay(
            RoundedRectangle(cornerRadius: 6)
                .stroke(isHovering ? Color.accentColor.opacity(0.3) : Color.clear, lineWidth: 1)
        )
        .onHover { hovering in
            isHovering = hovering
        }
    }
}
