import SwiftUI

struct PostCardView: View {
    @EnvironmentObject var dataStore: DataStore
    @EnvironmentObject var authViewModel: AuthViewModel

    let post: Post
    var onUserTap: ((User) -> Void)?
    var onCommentTap: (() -> Void)?

    @State private var showComments = false

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Header
            if let author = post.author {
                PostHeaderView(
                    author: author,
                    timeAgo: post.timeAgoString,
                    onUserTap: { onUserTap?(author) }
                )
            }

            // Media
            AsyncImage(url: URL(string: post.mediaURL)) { phase in
                switch phase {
                case .empty:
                    Rectangle()
                        .fill(Color(.systemGray5))
                        .aspectRatio(1, contentMode: .fit)
                        .overlay {
                            ProgressView()
                        }
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                case .failure:
                    Rectangle()
                        .fill(Color(.systemGray5))
                        .aspectRatio(1, contentMode: .fit)
                        .overlay {
                            Image(systemName: "photo")
                                .font(.largeTitle)
                                .foregroundColor(.secondary)
                        }
                @unknown default:
                    EmptyView()
                }
            }

            // Video indicator
            if post.mediaType == .video {
                HStack {
                    Spacer()
                    Image(systemName: "play.circle.fill")
                        .font(.title)
                        .foregroundColor(.white)
                        .shadow(radius: 2)
                    Spacer()
                }
                .padding(.top, -50)
            }

            // Actions
            PostActionsView(
                post: post,
                onLikeTap: {
                    dataStore.toggleLike(postId: post.id)
                },
                onCommentTap: {
                    showComments = true
                    onCommentTap?()
                },
                onShareTap: {
                    // Handle share
                }
            )

            // Likes count
            if post.likesCount > 0 {
                Text("\(post.likesCount) likes")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .padding(.horizontal)
                    .padding(.bottom, 4)
            }

            // Caption
            if !post.caption.isEmpty, let author = post.author {
                HStack(alignment: .top, spacing: 4) {
                    Text(author.username)
                        .fontWeight(.semibold)
                    Text(post.caption)
                }
                .font(.subheadline)
                .padding(.horizontal)
                .padding(.bottom, 4)
            }

            // Comments preview
            if post.commentsCount > 0 {
                Button(action: { showComments = true }) {
                    Text("View all \(post.commentsCount) comments")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.horizontal)
                .padding(.bottom, 8)
            }
        }
        .sheet(isPresented: $showComments) {
            CommentsView(post: post)
        }
    }
}

struct PostHeaderView: View {
    let author: User
    let timeAgo: String
    var onUserTap: (() -> Void)?

    var body: some View {
        HStack(spacing: 12) {
            Button(action: { onUserTap?() }) {
                ProfileImageView(url: author.profileImageURL, size: 36)
            }

            VStack(alignment: .leading, spacing: 2) {
                Button(action: { onUserTap?() }) {
                    Text(author.username)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                }

                Text(timeAgo)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Spacer()

            Menu {
                Button(action: {}) {
                    Label("Share", systemImage: "square.and.arrow.up")
                }
                Button(action: {}) {
                    Label("Copy Link", systemImage: "link")
                }
                Button(role: .destructive, action: {}) {
                    Label("Report", systemImage: "exclamationmark.triangle")
                }
            } label: {
                Image(systemName: "ellipsis")
                    .foregroundColor(.primary)
                    .padding(8)
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 10)
    }
}

struct PostActionsView: View {
    let post: Post
    var onLikeTap: () -> Void
    var onCommentTap: () -> Void
    var onShareTap: () -> Void

    var body: some View {
        HStack(spacing: 16) {
            Button(action: onLikeTap) {
                Image(systemName: post.isLiked ? "heart.fill" : "heart")
                    .font(.title2)
                    .foregroundColor(post.isLiked ? .red : .primary)
            }

            Button(action: onCommentTap) {
                Image(systemName: "bubble.right")
                    .font(.title2)
                    .foregroundColor(.primary)
            }

            Button(action: onShareTap) {
                Image(systemName: "paperplane")
                    .font(.title2)
                    .foregroundColor(.primary)
            }

            Spacer()

            Button(action: {}) {
                Image(systemName: "bookmark")
                    .font(.title2)
                    .foregroundColor(.primary)
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 10)
    }
}

#Preview {
    PostCardView(
        post: Post.samplePosts(for: User.sampleUsers).first!
    )
    .environmentObject(DataStore())
    .environmentObject(AuthViewModel())
}
