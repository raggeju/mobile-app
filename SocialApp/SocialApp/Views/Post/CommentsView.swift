import SwiftUI

struct CommentsView: View {
    @EnvironmentObject var dataStore: DataStore
    @EnvironmentObject var authViewModel: AuthViewModel
    @Environment(\.dismiss) private var dismiss

    let post: Post

    @State private var newCommentText = ""
    @FocusState private var isInputFocused: Bool

    private var comments: [Comment] {
        dataStore.getComments(forPost: post.id)
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 0) {
                        // Original post caption
                        if !post.caption.isEmpty, let author = post.author {
                            HStack(alignment: .top, spacing: 12) {
                                ProfileImageView(url: author.profileImageURL, size: 36)

                                VStack(alignment: .leading, spacing: 4) {
                                    HStack(spacing: 4) {
                                        Text(author.username)
                                            .fontWeight(.semibold)
                                        Text(post.caption)
                                    }
                                    .font(.subheadline)

                                    Text(post.timeAgoString)
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }

                                Spacer()
                            }
                            .padding()

                            Divider()
                        }

                        // Comments list
                        if comments.isEmpty {
                            VStack(spacing: 16) {
                                Text("No comments yet")
                                    .font(.headline)
                                    .foregroundColor(.secondary)

                                Text("Start the conversation")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 60)
                        } else {
                            ForEach(comments) { comment in
                                CommentRowView(comment: comment)
                            }
                        }
                    }
                }

                Divider()

                // Comment input
                commentInputView
            }
            .navigationTitle("Comments")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") {
                        dismiss()
                    }
                }
            }
        }
    }

    private var commentInputView: some View {
        HStack(spacing: 12) {
            ProfileImageView(
                url: authViewModel.currentUser?.profileImageURL,
                size: 36
            )

            TextField("Add a comment...", text: $newCommentText, axis: .vertical)
                .textFieldStyle(.plain)
                .lineLimit(1...4)
                .focused($isInputFocused)

            Button("Post") {
                postComment()
            }
            .fontWeight(.semibold)
            .disabled(newCommentText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
        }
        .padding()
        .background(Color(.systemBackground))
    }

    private func postComment() {
        guard let currentUserId = authViewModel.currentUser?.id,
              !newCommentText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return
        }

        dataStore.addComment(
            postId: post.id,
            authorId: currentUserId,
            text: newCommentText.trimmingCharacters(in: .whitespacesAndNewlines)
        )

        newCommentText = ""
        isInputFocused = false
    }
}

struct CommentRowView: View {
    let comment: Comment

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            ProfileImageView(url: comment.author?.profileImageURL, size: 36)

            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 4) {
                    Text(comment.author?.username ?? "Unknown")
                        .fontWeight(.semibold)
                    Text(comment.text)
                }
                .font(.subheadline)

                HStack(spacing: 16) {
                    Text(comment.timeAgoString)
                        .font(.caption)
                        .foregroundColor(.secondary)

                    if comment.likesCount > 0 {
                        Text("\(comment.likesCount) likes")
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundColor(.secondary)
                    }

                    Button("Reply") {
                        // Handle reply
                    }
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.secondary)
                }
            }

            Spacer()

            Button(action: {}) {
                Image(systemName: comment.isLiked ? "heart.fill" : "heart")
                    .font(.caption)
                    .foregroundColor(comment.isLiked ? .red : .secondary)
            }
        }
        .padding()
    }
}

#Preview {
    CommentsView(post: Post.samplePosts(for: User.sampleUsers).first!)
        .environmentObject(AuthViewModel())
        .environmentObject(DataStore())
}
