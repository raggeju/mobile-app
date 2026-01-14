import SwiftUI
import PhotosUI

struct CreatePostView: View {
    @EnvironmentObject var dataStore: DataStore
    @EnvironmentObject var authViewModel: AuthViewModel
    @Environment(\.dismiss) private var dismiss

    @State private var selectedItem: PhotosPickerItem?
    @State private var selectedImageData: Data?
    @State private var caption = ""
    @State private var isUploading = false
    @State private var showMediaPicker = true

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                if let imageData = selectedImageData,
                   let uiImage = UIImage(data: imageData) {
                    // Preview selected image
                    selectedImagePreview(uiImage: uiImage)
                } else {
                    // Media picker
                    mediaPickerView
                }
            }
            .navigationTitle("New Post")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }

                if selectedImageData != nil {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Share") {
                            sharePost()
                        }
                        .fontWeight(.semibold)
                        .disabled(isUploading)
                    }
                }
            }
        }
    }

    private func selectedImagePreview(uiImage: UIImage) -> some View {
        ScrollView {
            VStack(spacing: 16) {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxHeight: 400)

                VStack(alignment: .leading, spacing: 8) {
                    HStack(alignment: .top, spacing: 12) {
                        ProfileImageView(
                            url: authViewModel.currentUser?.profileImageURL,
                            size: 40
                        )

                        TextField("Write a caption...", text: $caption, axis: .vertical)
                            .lineLimit(5...10)
                    }
                    .padding()

                    Divider()

                    // Additional options
                    OptionRowView(icon: "location", title: "Add Location")
                    OptionRowView(icon: "person.crop.rectangle", title: "Tag People")
                    OptionRowView(icon: "music.note", title: "Add Music")
                }

                Button(action: { selectedImageData = nil }) {
                    Text("Choose Different Photo")
                        .foregroundColor(.blue)
                }
                .padding()
            }
        }
    }

    private var mediaPickerView: some View {
        VStack(spacing: 24) {
            Spacer()

            Image(systemName: "photo.on.rectangle.angled")
                .font(.system(size: 80))
                .foregroundColor(.secondary)

            Text("Select a photo or video to share")
                .font(.headline)
                .foregroundColor(.secondary)

            VStack(spacing: 12) {
                PhotosPicker(selection: $selectedItem, matching: .any(of: [.images, .videos])) {
                    HStack {
                        Image(systemName: "photo.stack")
                        Text("Select from Library")
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                }

                Button(action: {}) {
                    HStack {
                        Image(systemName: "camera")
                        Text("Take Photo")
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(Color(.systemGray5))
                    .foregroundColor(.primary)
                    .cornerRadius(12)
                }
            }
            .padding(.horizontal, 40)

            Spacer()
        }
        .onChange(of: selectedItem) { oldValue, newValue in
            Task {
                if let data = try? await newValue?.loadTransferable(type: Data.self) {
                    selectedImageData = data
                }
            }
        }
    }

    private func sharePost() {
        guard let currentUser = authViewModel.currentUser else { return }
        isUploading = true

        // Simulate upload delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            // Create post with a placeholder image URL
            let randomSeed = Int.random(in: 1000...9999)
            dataStore.createPost(
                authorId: currentUser.id,
                caption: caption,
                mediaURL: "https://picsum.photos/seed/new\(randomSeed)/600/600",
                mediaType: .image
            )

            isUploading = false
            dismiss()
        }
    }
}

struct OptionRowView: View {
    let icon: String
    let title: String

    var body: some View {
        Button(action: {}) {
            HStack {
                Image(systemName: icon)
                    .frame(width: 24)
                Text(title)
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding()
            .foregroundColor(.primary)
        }
    }
}

#Preview {
    CreatePostView()
        .environmentObject(AuthViewModel())
        .environmentObject(DataStore())
}
