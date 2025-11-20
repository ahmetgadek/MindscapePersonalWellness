import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    @StateObject private var galleryViewModel = GalleryViewModel()
    @StateObject private var journalViewModel = JournalViewModel()
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.clear
                    .contentShape(Rectangle())
                    .onTapGesture {
                        hideKeyboard()
                    }
                
                ScrollView {
                    VStack(spacing: 24) {
                        VStack(alignment: .leading, spacing: 16) {
                            Text("How was your day?")
                                .font(.title2)
                                .fontWeight(.semibold)
                            
                            Text("Describe your day, and we'll transform it into a unique landscape of your inner world.")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            
                            TextEditor(text: $viewModel.todayDescription)
                                .frame(height: 150)
                                .padding(8)
                                .background(Color(.systemGray6))
                                .cornerRadius(12)
                        }
                        .padding()
                        
                        Button(action: {
                            hideKeyboard()
                            viewModel.generateLandscape()
                        }) {
                            HStack {
                                if viewModel.isGenerating {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                } else {
                                    Text("Create Landscape")
                                        .fontWeight(.semibold)
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(viewModel.todayDescription.isEmpty ? Color.gray : Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                        }
                        .disabled(viewModel.todayDescription.isEmpty || viewModel.isGenerating)
                        .padding(.horizontal)
                        
                        if let landscape = viewModel.generatedLandscape {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Your Landscape")
                                    .font(.headline)
                                
                                Text(landscape)
                                    .font(.body)
                                    .padding()
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .background(Color(.systemGray6))
                                    .cornerRadius(12)
                                
                                Button(action: {
                                    let entry = JournalEntry(
                                        description: viewModel.todayDescription,
                                        landscapeDescription: landscape
                                    )
                                    galleryViewModel.saveLandscape(entry)
                                    journalViewModel.addEntry(entry)
                                    viewModel.todayDescription = ""
                                    viewModel.generatedLandscape = nil
                                }) {
                                    Text("Save to Journal")
                                        .fontWeight(.semibold)
                                        .frame(maxWidth: .infinity)
                                        .padding()
                                        .background(Color.green)
                                        .foregroundColor(.white)
                                        .cornerRadius(12)
                                }
                            }
                            .padding()
                        }
                    }
                }
                .scrollDismissesKeyboard(.interactively)
            }
            .navigationTitle("Mindscape")
        }
    }
    
    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

