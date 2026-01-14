import SwiftUI

struct HomeFeedView: View {
    @EnvironmentObject var dataStore: DataStore
    @EnvironmentObject var authViewModel: AuthViewModel

    @State private var selectedUser: User?
    @State private var showUserProfile = false

    private var feedPosts: [Post] {
        guard let currentUserId = authViewModel.currentUser?.id else {
            return []
        }
        return dataStore.getHomeFeedPosts(forUser: currentUserId)
    }

    private var suggestedUsers: [User] {
        guard let currentUserId = authViewModel.currentUser?.id else {
            return []
        }
        return dataStore.getSuggestedUsers(forUser: currentUserId)
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 0) {
                    // Stories placeholder
                    StoriesScrollView()

                    Divider()

                    if feedPosts.isEmpty {
                        emptyFeedView
                    } else {
                        ForEach(feedPosts) { post in
                            PostCardView(
                                post: post,
                                onUserTap: { user in
                                    selectedUser = user
                                    showUserProfile = true
                                }
                            )
                            Divider()
                        }
                    }
                }
            }
            .refreshable {
                // Refresh feed
            }
            .navigationTitle("SocialApp")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Image(systemName: "camera")
                        .font(.title3)
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: DirectMessagesView()) {
                        Image(systemName: "paperplane")
                            .font(.title3)
                    }
                }
            }
            .navigationDestination(isPresented: $showUserProfile) {
                if let user = selectedUser {
                    UserProfileView(user: user)
                }
            }
        }
    }

    private var emptyFeedView: some View {
        VStack(spacing: 24) {
            Spacer()
                .frame(height: 40)

            Image(systemName: "person.2.fill")
                .font(.system(size: 60))
                .foregroundColor(.secondary)

            VStack(spacing: 8) {
                Text("Welcome to SocialApp!")
                    .font(.title2)
                    .fontWeight(.bold)

                Text("Follow people to see their photos and videos here")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }

            // Suggested users
            if !suggestedUsers.isEmpty {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Suggested for you")
                        .font(.headline)
                        .padding(.horizontal)

                    ForEach(suggestedUsers) { user in
                        UserRowView(user: user) {
                            selectedUser = user
                            showUserProfile = true
                        }
                    }
                }
                .padding(.top, 16)
            }

            Spacer()
        }
        .padding(.horizontal)
    }
}

struct StoriesScrollView: View {
    @EnvironmentObject var dataStore: DataStore

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                // Your story
                VStack(spacing: 4) {
                    ZStack(alignment: .bottomTrailing) {
                        Circle()
                            .fill(Color(.systemGray5))
                            .frame(width: 70, height: 70)
                            .overlay {
                                Image(systemName: "person.fill")
                                    .font(.title)
                                    .foregroundColor(.gray)
                            }

                        Circle()
                            .fill(.blue)
                            .frame(width: 24, height: 24)
                            .overlay {
                                Image(systemName: "plus")
                                    .font(.caption)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                            }
                            .offset(x: 4, y: 4)
                    }

                    Text("Your story")
                        .font(.caption)
                        .lineLimit(1)
                }

                // Other stories
                ForEach(dataStore.users.prefix(6)) { user in
                    StoryAvatarView(user: user)
                }
            }
            .padding()
        }
    }
}

struct StoryAvatarView: View {
    let user: User

    var body: some View {
        VStack(spacing: 4) {
            ProfileImageView(url: user.profileImageURL, size: 70)
                .overlay {
                    Circle()
                        .stroke(
                            LinearGradient(
                                colors: [.purple, .pink, .orange],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 3
                        )
                        .frame(width: 76, height: 76)
                }

            Text(user.username)
                .font(.caption)
                .lineLimit(1)
                .frame(width: 70)
        }
    }
}

#Preview {
    HomeFeedView()
        .environmentObject(AuthViewModel())
        .environmentObject(DataStore())
}
