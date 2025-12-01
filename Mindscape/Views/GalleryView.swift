import SwiftUI

struct GalleryView: View {
    @StateObject private var viewModel = GalleryViewModel()
    @State private var showImagePicker = false
    @State private var selectedImage: UIImage?
    @State private var showAddImageSheet = false
    @ObservedObject private var languageService = LanguageService.shared
    
    var body: some View {
        NavigationView {
            Group {
                if viewModel.landscapes.isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "photo.on.rectangle.angled")
                            .font(.system(size: 60))
                            .foregroundColor(.secondary)
                        Text(NSLocalizedString("gallery_no_landscapes", comment: ""))
                            .font(.title2)
                            .fontWeight(.semibold)
                        Text(NSLocalizedString("gallery_create_first", comment: ""))
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                        
                        Button(action: {
                            showImagePicker = true
                        }) {
                            Label(NSLocalizedString("gallery_add_image", comment: ""), systemImage: "plus.circle.fill")
                                .font(.headline)
                                .padding()
                                .frame(maxWidth: 200)
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(12)
                        }
                        .padding(.top)
                    }
                    .padding()
                } else {
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(viewModel.landscapes) { landscape in
                                LandscapeCard(entry: landscape, viewModel: viewModel)
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle(NSLocalizedString("gallery_title", comment: ""))
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showImagePicker = true
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .onAppear {
                viewModel.loadLandscapes()
            }
            .sheet(isPresented: $showImagePicker) {
                ImagePicker(selectedImage: $selectedImage)
            }
            .onChange(of: selectedImage) { newImage in
                if newImage != nil {
                    showAddImageSheet = true
                }
            }
            .sheet(isPresented: $showAddImageSheet) {
                AddImageSheet(image: selectedImage, viewModel: viewModel) {
                    selectedImage = nil
                }
            }
        }
    }
}

struct LandscapeCard: View {
    let entry: JournalEntry
    let viewModel: GalleryViewModel
    @ObservedObject private var languageService = LanguageService.shared
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(formatDate(entry.date))
                .font(.caption)
                .foregroundColor(.secondary)
            
            if let imageId = entry.imageId,
               let image = ImageService.shared.loadImage(withId: imageId) {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 200)
                    .clipped()
                    .cornerRadius(12)
            }
            
            if let landscape = entry.landscapeDescription {
                Text(landscape)
                    .font(.body)
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
            }
            
            Text(entry.description)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .lineLimit(3)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
        .contextMenu {
            Button(role: .destructive, action: {
                viewModel.deleteEntry(entry)
            }) {
                Label(NSLocalizedString("delete", comment: ""), systemImage: "trash")
            }
        }
    }
}

struct AddImageSheet: View {
    let image: UIImage?
    let viewModel: GalleryViewModel
    let onDismiss: () -> Void
    
    @State private var description: String = ""
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                if let image = image {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxHeight: 300)
                        .cornerRadius(12)
                        .padding()
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(NSLocalizedString("gallery_description_optional", comment: ""))
                        .font(.headline)
                    
                    TextEditor(text: $description)
                        .frame(height: 100)
                        .padding(8)
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                }
                .padding()
                
                Button(action: {
                    if let image = image {
                        viewModel.createEntryWithImage(
                            description: description.isEmpty ? NSLocalizedString("gallery_image", comment: "") : description,
                            landscapeDescription: nil,
                            image: image
                        )
                    }
                    dismiss()
                    onDismiss()
                }) {
                    Text(NSLocalizedString("gallery_save_image", comment: ""))
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
                .padding(.horizontal)
                
                Spacer()
            }
            .navigationTitle(NSLocalizedString("gallery_add_image_title", comment: ""))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(NSLocalizedString("cancel", comment: "")) {
                        dismiss()
                        onDismiss()
                    }
                }
            }
        }
    }
}

