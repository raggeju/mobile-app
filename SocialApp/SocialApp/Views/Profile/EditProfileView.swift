import SwiftUI
import PhotosUI

struct EditProfileView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @Environment(\.dismiss) private var dismiss

    @State private var displayName: String = ""
    @State private var bio: String = ""
    @State private var selectedItem: PhotosPickerItem?

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    HStack {
                        Spacer()
                        VStack(spacing: 8) {
                            ProfileImageView(
                                url: authViewModel.currentUser?.profileImageURL,
                                size: 80
                            )

                            PhotosPicker(selection: $selectedItem, matching: .images) {
                                Text("Change Photo")
                                    .font(.subheadline)
                                    .foregroundColor(.blue)
                            }
                        }
                        Spacer()
                    }
                }
                .listRowBackground(Color.clear)

                Section {
                    HStack {
                        Text("Name")
                            .frame(width: 100, alignment: .leading)
                        TextField("Name", text: $displayName)
                    }

                    HStack {
                        Text("Username")
                            .frame(width: 100, alignment: .leading)
                        Text(authViewModel.currentUser?.username ?? "")
                            .foregroundColor(.secondary)
                    }

                    HStack(alignment: .top) {
                        Text("Bio")
                            .frame(width: 100, alignment: .leading)
                        TextField("Bio", text: $bio, axis: .vertical)
                            .lineLimit(3...6)
                    }
                }

                Section {
                    NavigationLink("Personal Information") {
                        Text("Personal Information Settings")
                    }
                }
            }
            .navigationTitle("Edit Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        saveProfile()
                    }
                    .fontWeight(.semibold)
                }
            }
            .onAppear {
                displayName = authViewModel.currentUser?.displayName ?? ""
                bio = authViewModel.currentUser?.bio ?? ""
            }
        }
    }

    private func saveProfile() {
        authViewModel.updateProfile(displayName: displayName, bio: bio)
        dismiss()
    }
}

#Preview {
    EditProfileView()
        .environmentObject(AuthViewModel())
}
