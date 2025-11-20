import SwiftUI

struct JournalView: View {
    @StateObject private var viewModel = JournalViewModel()
    
    var body: some View {
        NavigationView {
            Group {
                if viewModel.entries.isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "book.closed")
                            .font(.system(size: 60))
                            .foregroundColor(.secondary)
                        Text("No Entries Yet")
                            .font(.title2)
                            .fontWeight(.semibold)
                        Text("Start journaling your thoughts and feelings")
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
            .navigationTitle("Journal")
            .onAppear {
                viewModel.loadEntries()
            }
        }
    }
}

struct JournalEntryRow: View {
    let entry: JournalEntry
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(entry.date, style: .date)
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

