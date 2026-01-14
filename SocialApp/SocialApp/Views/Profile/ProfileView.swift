import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var dataStore: DataStore
    @EnvironmentObject var authViewModel: AuthViewModel

    @State private var showSettings = false
    @State private var showEditProfile = false
    @State private var selectedPost: Post?
    @State private var showPostDetail = false
    @State private var selectedTab = 0

    private var currentUser: User? {
        authViewModel.currentUser
    }

    private var userPosts: [Post] {
        guard let userId = currentUser?.id else { return [] }
        return dataStore.getPosts(forUser: userId)
    }

    private let columns = [
        GridItem(.flexible(), spacing: 2),
        GridItem(.flexible(), spacing: 2),
        GridItem(.flexible(), spacing: 2)
    ]

    var body: some View {
        NavigationStack {
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
            .navigationTitle(currentUser?.username ?? "Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showSettings = true }) {
                        Image(systemName: "line.3.horizontal")
                            .font(.title3)
                    }
                }
            }
            .sheet(isPresented: $showSettings) {
                SettingsView()
            }
            .sheet(isPresented: $showEditProfile) {
                EditProfileView()
            }
            .navigationDestination(isPresented: $showPostDetail) {
                if let post = selectedPost {
                    PostDetailView(post: post)
                }
            }
        }
    }

    private var profileHeader: some View {
        HStack(spacing: 24) {
            ProfileImageView(url: currentUser?.profileImageURL, size: 80)

            HStack(spacing: 32) {
                StatView(value: currentUser?.postsCount ?? 0, label: "Posts")

                NavigationLink(destination: FollowersListView(userId: currentUser?.id ?? UUID(), isFollowers: true)) {
                    StatView(value: currentUser?.followersCount ?? 0, label: "Followers")
                }

                NavigationLink(destination: FollowersListView(userId: currentUser?.id ?? UUID(), isFollowers: false)) {
                    StatView(value: currentUser?.followingCount ?? 0, label: "Following")
                }
            }
        }
        .padding()
    }

    private var profileBio: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(currentUser?.displayName ?? "")
                .font(.subheadline)
                .fontWeight(.semibold)

            if let bio = currentUser?.bio, !bio.isEmpty {
                Text(bio)
                    .font(.subheadline)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal)
    }

    private var actionButtons: some View {
        HStack(spacing: 8) {
            Button(action: { showEditProfile = true }) {
                Text("Edit Profile")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .frame(height: 36)
                    .background(Color(.systemGray5))
                    .foregroundColor(.primary)
                    .cornerRadius(8)
            }

            Button(action: {}) {
                Text("Share Profile")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .frame(height: 36)
                    .background(Color(.systemGray5))
                    .foregroundColor(.primary)
                    .cornerRadius(8)
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

                    Text("Share your first photo or video")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
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
}

struct StatView: View {
    let value: Int
    let label: String

    var body: some View {
        VStack(spacing: 2) {
            Text("\(value)")
                .font(.headline)
                .fontWeight(.bold)

            Text(label)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .foregroundColor(.primary)
    }
}

struct TabButton: View {
    let icon: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundColor(isSelected ? .primary : .secondary)

                Rectangle()
                    .fill(isSelected ? Color.primary : Color.clear)
                    .frame(height: 1)
            }
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    ProfileView()
        .environmentObject(AuthViewModel())
        .environmentObject(DataStore())
}
