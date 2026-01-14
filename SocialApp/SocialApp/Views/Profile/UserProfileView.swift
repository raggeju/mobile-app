import SwiftUI

struct UserProfileView: View {
    @EnvironmentObject var dataStore: DataStore
    @EnvironmentObject var authViewModel: AuthViewModel
    @Environment(\.dismiss) private var dismiss

    let user: User

    @State private var selectedPost: Post?
    @State private var showPostDetail = false
    @State private var selectedTab = 0

    private var isCurrentUser: Bool {
        authViewModel.currentUser?.id == user.id
    }

    private var isFollowing: Bool {
        guard let currentUserId = authViewModel.currentUser?.id else { return false }
        return dataStore.isFollowing(userId: currentUserId, targetUserId: user.id)
    }

    private var userPosts: [Post] {
        dataStore.getPosts(forUser: user.id)
    }

    private let columns = [
        GridItem(.flexible(), spacing: 2),
        GridItem(.flexible(), spacing: 2),
        GridItem(.flexible(), spacing: 2)
    ]

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                // Profile header
                profileHeader

                // Bio
                profileBio

                // Action buttons
                actionButtons

                // Content tabs
                contentTabs

                // Posts grid
                postsGrid
            }
        }
        .navigationTitle(user.username)
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(isPresented: $showPostDetail) {
            if let post = selectedPost {
                PostDetailView(post: post)
            }
        }
    }

    private var profileHeader: some View {
        HStack(spacing: 24) {
            ProfileImageView(url: user.profileImageURL, size: 80)

            HStack(spacing: 32) {
                StatView(value: user.postsCount, label: "Posts")

                NavigationLink(destination: FollowersListView(userId: user.id, isFollowers: true)) {
                    StatView(value: user.followersCount, label: "Followers")
                }

                NavigationLink(destination: FollowersListView(userId: user.id, isFollowers: false)) {
                    StatView(value: user.followingCount, label: "Following")
                }
            }
        }
        .padding()
    }

    private var profileBio: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(user.displayName)
                .font(.subheadline)
                .fontWeight(.semibold)

            if !user.bio.isEmpty {
                Text(user.bio)
                    .font(.subheadline)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal)
    }

    private var actionButtons: some View {
        HStack(spacing: 8) {
            if isCurrentUser {
                Button(action: {}) {
                    Text("Edit Profile")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .frame(height: 36)
                        .background(Color(.systemGray5))
                        .foregroundColor(.primary)
                        .cornerRadius(8)
                }
            } else {
                Button(action: toggleFollow) {
                    Text(isFollowing ? "Following" : "Follow")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .frame(height: 36)
                        .background(isFollowing ? Color(.systemGray5) : Color.blue)
                        .foregroundColor(isFollowing ? .primary : .white)
                        .cornerRadius(8)
                }

                Button(action: {}) {
                    Text("Message")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .frame(height: 36)
                        .background(Color(.systemGray5))
                        .foregroundColor(.primary)
                        .cornerRadius(8)
                }
            }
        }
        .padding()
    }

    private var contentTabs: some View {
        HStack(spacing: 0) {
            TabButton(icon: "squareshape.split.3x3", isSelected: selectedTab == 0) {
                selectedTab = 0
            }

            TabButton(icon: "play.square", isSelected: selectedTab == 1) {
                selectedTab = 1
            }

            TabButton(icon: "person.crop.square", isSelected: selectedTab == 2) {
                selectedTab = 2
            }
        }
    }

    private var postsGrid: some View {
        Group {
            if userPosts.isEmpty {
                VStack(spacing: 16) {
                    Image(systemName: "camera")
                        .font(.system(size: 50))
                        .foregroundColor(.secondary)

                    Text("No Posts Yet")
                        .font(.title2)
                        .fontWeight(.bold)
                }
                .padding(.vertical, 60)
            } else {
                LazyVGrid(columns: columns, spacing: 2) {
                    ForEach(userPosts) { post in
                        ExploreGridItem(post: post)
                            .onTapGesture {
                                selectedPost = post
                                showPostDetail = true
                            }
                    }
                }
            }
        }
    }

    private func toggleFollow() {
        guard let currentUserId = authViewModel.currentUser?.id else { return }
        dataStore.toggleFollow(userId: currentUserId, targetUserId: user.id)
    }
}

#Preview {
    NavigationStack {
        UserProfileView(user: User.sampleUsers[0])
            .environmentObject(AuthViewModel())
            .environmentObject(DataStore())
    }
}
