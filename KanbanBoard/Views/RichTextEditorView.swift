//
//  RichTextEditorView.swift
//  KanbanBoard
//
//  Rich text editor with formatting toolbar for task notes
//

import SwiftUI

struct RichTextEditorView: View {
    @Binding var text: String
    @FocusState private var isFocused: Bool

    // Formatting state
    @State private var selectedFontSize: FontSize = .normal
    @State private var showingLinkDialog = false
    @State private var linkText = ""
    @State private var linkURL = ""

    enum FontSize: String, CaseIterable {
        case small = "Small"
        case normal = "Normal"
        case large = "Large"
        case extraLarge = "X-Large"

        var value: CGFloat {
            switch self {
            case .small: return 10
            case .normal: return 12
            case .large: return 14
            case .extraLarge: return 16
            }
        }
    }

    var body: some View {
        VStack(spacing: 8) {
            // Formatting toolbar
            HStack(spacing: 12) {
                // Font size picker
                Menu {
                    ForEach(FontSize.allCases, id: \.self) { size in
                        Button(size.rawValue) {
                            selectedFontSize = size
                        }
                    }
                } label: {
                    HStack(spacing: 4) {
                        Text("Size")
                        Image(systemName: "textformat.size")
                    }
                    .font(.system(size: 10))
                }
                .buttonStyle(.bordered)
                .controlSize(.small)

                Divider()
                    .frame(height: 16)

                // Bold
                Button(action: { insertFormatting("**", "**") }) {
                    Image(systemName: "bold")
                        .font(.system(size: 11))
                }
                .buttonStyle(.bordered)
                .controlSize(.small)
                .help("Bold (Markdown: **text**)")

                // Italic
                Button(action: { insertFormatting("_", "_") }) {
                    Image(systemName: "italic")
                        .font(.system(size: 11))
                }
                .buttonStyle(.bordered)
                .controlSize(.small)
                .help("Italic (Markdown: _text_)")

                Divider()
                    .frame(height: 16)

                // Hyperlink
                Button(action: { showingLinkDialog = true }) {
                    Image(systemName: "link")
                        .font(.system(size: 11))
                }
                .buttonStyle(.bordered)
                .controlSize(.small)
                .help("Insert link")

                // Code block
                Button(action: { insertFormatting("```\n", "\n```") }) {
                    Image(systemName: "chevron.left.forwardslash.chevron.right")
                        .font(.system(size: 10))
                }
                .buttonStyle(.bordered)
                .controlSize(.small)
                .help("Code block")

                // Bullet list
                Button(action: { insertFormatting("- ", "") }) {
                    Image(systemName: "list.bullet")
                        .font(.system(size: 11))
                }
                .buttonStyle(.bordered)
                .controlSize(.small)
                .help("Bullet point")

                Spacer()

                Text("\(text.count) chars")
                    .font(.system(size: 9))
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 6)
            .background(Color(nsColor: .controlBackgroundColor))
            .cornerRadius(6)

            // Text editor
            TextEditor(text: $text)
                .font(.system(size: selectedFontSize.value, design: .monospaced))
                .frame(minHeight: 180)
                .border(Color.secondary.opacity(0.3), width: 1)
                .cornerRadius(6)
                .focused($isFocused)

            // Formatting guide
            Text("Tip: Use Markdown - **bold**, _italic_, [link](url), ```code```")
                .font(.system(size: 9))
                .foregroundColor(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .sheet(isPresented: $showingLinkDialog) {
            LinkDialog(
                isPresented: $showingLinkDialog,
                linkText: $linkText,
                linkURL: $linkURL,
                onInsert: { text, url in
                    insertFormatting("[\(text)](\(url))", "")
                }
            )
        }
    }

    private func insertFormatting(_ prefix: String, _ suffix: String) {
        text += prefix
        if !suffix.isEmpty {
            text += suffix
            // Move cursor between prefix and suffix would require more complex text handling
        }
    }
}

// MARK: - Link Dialog

struct LinkDialog: View {
    @Binding var isPresented: Bool
    @Binding var linkText: String
    @Binding var linkURL: String
    var onInsert: (String, String) -> Void

    var body: some View {
        VStack(spacing: 16) {
            Text("Insert Link")
                .font(.system(size: 14, weight: .semibold))

            TextField("Link text", text: $linkText)
                .textFieldStyle(.roundedBorder)

            TextField("URL", text: $linkURL)
                .textFieldStyle(.roundedBorder)

            HStack(spacing: 12) {
                Button("Cancel") {
                    isPresented = false
                    resetFields()
                }
                .keyboardShortcut(.cancelAction)

                Button("Insert") {
                    if !linkText.isEmpty && !linkURL.isEmpty {
                        onInsert(linkText, linkURL)
                        isPresented = false
                        resetFields()
                    }
                }
                .keyboardShortcut(.defaultAction)
                .disabled(linkText.isEmpty || linkURL.isEmpty)
            }
        }
        .padding(20)
        .frame(width: 350)
    }

    private func resetFields() {
        linkText = ""
        linkURL = ""
    }
}
