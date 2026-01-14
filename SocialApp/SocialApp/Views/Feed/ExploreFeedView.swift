import SwiftUI

struct ExploreFeedView: View {
    @EnvironmentObject var dataStore: DataStore
    @EnvironmentObject var authViewModel: AuthViewModel

    @State private var searchText = ""
    @State private var selectedPost: Post?
    @State private var showPostDetail = false
    @State private var selectedUser: User?
    @State private var showUserProfile = false

    private var filteredUsers: [User] {
        if searchText.isEmpty {
            return []
        }
        return dataStore.searchUsers(query: searchText)
    }

    private var explorePosts: [Post] {
        dataStore.getExplorePosts()
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
                    if !searchText.isEmpty {
                        // Search results
                        searchResultsView
                    } else {
                        // Explore grid
                        exploreGridView
                    }
                }
            }
            .searchable(text: $searchText, prompt: "Search users")
            .navigationTitle("Explore")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(isPresented: $showPostDetail) {
                if let post = selectedPost {
                    PostDetailView(post: post)
                }
            }
            .navigationDestination(isPresented: $showUserProfile) {
                if let user = selectedUser {
                    UserProfileView(user: user)
                }
            }
        }
    }

    private var searchResultsView: some View {
        LazyVStack(spacing: 0) {
            if filteredUsers.isEmpty {
                VStack(spacing: 16) {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 40))
                        .foregroundColor(.secondary)

                    Text("No users found")
                        .font(.headline)
                        .foregroundColor(.secondary)
                }
                .padding(.top, 60)
            } else {
                ForEach(filteredUsers) { user in
                    UserRowView(user: user) {
                        selectedUser = user
                        showUserProfile = true
                    }
                    Divider()
                }
            }
        }
    }

    private var exploreGridView: some View {
        LazyVGrid(columns: columns, spacing: 2) {
            ForEach(explorePosts) { post in
                ExploreGridItem(post: post)
                    .onTapGesture {
                        selectedPost = post
                        showPostDetail = true
                    }
            }
        }
    }
}

struct ExploreGridItem: View {
    let post: Post

    var body: some View {
        GeometryReader { geometry in
            AsyncImage(url: URL(string: post.mediaURL)) { phase in
                switch phase {
                case .empty:
                    Rectangle()
                        .fill(Color(.systemGray5))
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: geometry.size.width, height: geometry.size.width)
                        .clipped()
                case .failure:
                    Rectangle()
                        .fill(Color(.systemGray5))
                        .overlay {
                            Image(systemName: "photo")
                                .foregroundColor(.secondary)
                        }
                @unknown default:
                    EmptyView()
                }
            }
            .overlay(alignment: .topTrailing) {
                if post.mediaType == .video {
                    Image(systemName: "play.fill")
                        .font(.caption)
                        .foregroundColor(.white)
                        .padding(6)
                }
            }
        }
        .aspectRatio(1, contentMode: .fit)
    }
}

#Preview {
    ExploreFeedView()
        .environmentObject(AuthViewModel())
        .environmentObject(DataStore())
}
