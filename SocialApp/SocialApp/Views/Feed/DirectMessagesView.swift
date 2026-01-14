import SwiftUI

struct DirectMessagesView: View {
    @EnvironmentObject var dataStore: DataStore
    @EnvironmentObject var authViewModel: AuthViewModel

    @State private var searchText = ""
    @State private var selectedUser: User?
    @State private var showChat = false

    private var conversations: [User] {
        // For demo, show some users as conversations
        Array(dataStore.users.prefix(5))
    }

    var body: some View {
        List {
            ForEach(conversations) { user in
                ConversationRowView(user: user)
                    .onTapGesture {
                        selectedUser = user
                        showChat = true
                    }
            }
        }
        .listStyle(.plain)
        .searchable(text: $searchText, prompt: "Search")
        .navigationTitle("Messages")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {}) {
                    Image(systemName: "square.and.pencil")
                }
            }
        }
        .navigationDestination(isPresented: $showChat) {
            if let user = selectedUser {
                ChatView(user: user)
            }
        }
    }
}

struct ConversationRowView: View {
    let user: User

    var body: some View {
        HStack(spacing: 12) {
            ProfileImageView(url: user.profileImageURL, size: 56)

            VStack(alignment: .leading, spacing: 4) {
                Text(user.displayName)
                    .font(.subheadline)
                    .fontWeight(.semibold)

                Text("Tap to start chatting")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
            }

            Spacer()

            Text("1h")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 4)
    }
}

struct ChatView: View {
    let user: User

    @State private var messageText = ""

    var body: some View {
        VStack(spacing: 0) {
            // Messages area
            ScrollView {
                VStack(spacing: 16) {
                    // User info header
                    VStack(spacing: 8) {
                        ProfileImageView(url: user.profileImageURL, size: 80)

                        Text(user.displayName)
                            .font(.headline)

                        Text("@\(user.username)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)

                        Text(user.bio)
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.top, 40)
                    .padding(.bottom, 20)

                    // Placeholder for messages
                    Text("Start a conversation with \(user.displayName)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding()
            }

            Divider()

            // Message input
            HStack(spacing: 12) {
                Button(action: {}) {
                    Image(systemName: "camera.fill")
                        .font(.title2)
                        .foregroundColor(.blue)
                }

                TextField("Message...", text: $messageText)
                    .textFieldStyle(.plain)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(Color(.systemGray6))
                    .cornerRadius(20)

                if !messageText.isEmpty {
                    Button("Send") {
                        // Send message
                        messageText = ""
                    }
                    .fontWeight(.semibold)
                } else {
                    Button(action: {}) {
                        Image(systemName: "mic.fill")
                            .font(.title2)
                            .foregroundColor(.blue)
                    }
                }
            }
            .padding()
        }
        .navigationTitle(user.username)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {}) {
                    Image(systemName: "video")
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        DirectMessagesView()
            .environmentObject(AuthViewModel())
            .environmentObject(DataStore())
    }
}
