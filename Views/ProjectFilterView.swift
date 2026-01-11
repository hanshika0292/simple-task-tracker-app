//
//  ProjectFilterView.swift
//  KanbanBoard
//
//  Simple project filter UI with color indicators
//

import SwiftUI

struct ProjectFilterView: View {
    @ObservedObject var viewModel: KanbanViewModel

    var body: some View {
        HStack(spacing: 12) {
            Text("Projects:")
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(.secondary)

            ForEach(viewModel.projects) { project in
                Button(action: {
                    viewModel.toggleProjectFilter(project.id)
                }) {
                    HStack(spacing: 6) {
                        Circle()
                            .fill(project.color)
                            .frame(width: 8, height: 8)

                        Text(project.name)
                            .font(.system(size: 12))
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(
                        viewModel.selectedProjectId == project.id
                            ? project.color.opacity(0.15)
                            : Color.clear
                    )
                    .cornerRadius(6)
                    .overlay(
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(
                                viewModel.selectedProjectId == project.id
                                    ? project.color
                                    : Color.secondary.opacity(0.2),
                                lineWidth: 1
                            )
                    )
                }
                .buttonStyle(.plain)
                .help("Filter by \(project.name)")
            }

            if viewModel.selectedProjectId != nil {
                Button(action: {
                    viewModel.clearFilter()
                }) {
                    Text("Clear")
                        .font(.system(size: 12))
                        .foregroundColor(.secondary)
                }
                .buttonStyle(.plain)
                .help("Show all projects")
            }

            Spacer()

            // Task count
            Text("\(viewModel.tasks.count) tasks")
                .font(.system(size: 12))
                .foregroundColor(.secondary)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .background(Color(nsColor: .controlBackgroundColor))
    }
}
