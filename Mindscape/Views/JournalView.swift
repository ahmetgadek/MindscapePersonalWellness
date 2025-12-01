import SwiftUI

struct JournalView: View {
    @StateObject private var viewModel = JournalViewModel()
    @ObservedObject private var languageService = LanguageService.shared
    
    var body: some View {
        NavigationView {
            Group {
                if viewModel.entries.isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "book.closed")
                            .font(.system(size: 60))
                            .foregroundColor(.secondary)
                        Text(NSLocalizedString("journal_no_entries", comment: ""))
                            .font(.title2)
                            .fontWeight(.semibold)
                        Text(NSLocalizedString("journal_start_journaling", comment: ""))
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .padding()
                } else {
                    List {
                        ForEach(viewModel.entries) { entry in
                            JournalEntryRow(entry: entry)
                        }
                        .onDelete { indexSet in
                            for index in indexSet {
                                viewModel.deleteEntry(viewModel.entries[index])
                            }
                        }
                    }
                }
            }
            .navigationTitle(NSLocalizedString("journal_title", comment: ""))
            .onAppear {
                viewModel.loadEntries()
            }
        }
    }
}

struct JournalEntryRow: View {
    let entry: JournalEntry
    @ObservedObject private var languageService = LanguageService.shared
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(formatDate(entry.date))
                .font(.caption)
                .foregroundColor(.secondary)
            
            Text(entry.description)
                .font(.body)
            
            if let landscape = entry.landscapeDescription {
                Text(landscape)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .padding(.top, 4)
            }
        }
        .padding(.vertical, 4)
    }
}

