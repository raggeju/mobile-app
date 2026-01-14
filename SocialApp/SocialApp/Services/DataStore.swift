import Foundation
import SwiftUI

@MainActor
class DataStore: ObservableObject {
    @Published var users: [User] = []
    @Published var posts: [Post] = []
    @Published var follows: [Follow] = []
    @Published var comments: [Comment] = []

    @Published var isLoading = false
    @Published var error: String?

    init() {
        loadMockData()
    }

    private func loadMockData() {
        users = User.sampleUsers
        posts = Post.samplePosts(for: users)
    }

    // MARK: - User Operations

    func getUser(byId id: UUID) -> User? {
        users.first { $0.id == id }
    }

    func getUser(byUsername username: String) -> User? {
        users.first { $0.username.lowercased() == username.lowercased() }
    }

    // MARK: - Post Operations

    func getPosts(forUser userId: UUID) -> [Post] {
        posts.filter { $0.authorId == userId }
            .sorted { $0.createdAt > $1.createdAt }
    }

    func getExplorePosts() -> [Post] {
        posts.sorted { $0.createdAt > $1.createdAt }
    }

    func getHomeFeedPosts(forUser userId: UUID) -> [Post] {
        let followingIds = getFollowingIds(forUser: userId)
        return posts.filter { followingIds.contains($0.authorId) }
            .sorted { $0.createdAt > $1.createdAt }
    }

    func createPost(authorId: UUID, caption: String, mediaURL: String, mediaType: MediaType) {
        var author = getUser(byId: authorId)
        author?.postsCount += 1

        let newPost = Post(
            authorId: authorId,
            author: author,
            caption: caption,
            mediaURL: mediaURL,
            mediaType: mediaType
        )
        posts.insert(newPost, at: 0)

        if let index = users.firstIndex(where: { $0.id == authorId }) {
            users[index].postsCount += 1
        }
    }

    func toggleLike(postId: UUID) {
        guard let index = posts.firstIndex(where: { $0.id == postId }) else { return }
        posts[index].isLiked.toggle()
        posts[index].likesCount += posts[index].isLiked ? 1 : -1
    }

    func deletePost(postId: UUID) {
        guard let post = posts.first(where: { $0.id == postId }) else { return }
        posts.removeAll { $0.id == postId }

        if let userIndex = users.firstIndex(where: { $0.id == post.authorId }) {
            users[userIndex].postsCount = max(0, users[userIndex].postsCount - 1)
        }
    }

    // MARK: - Follow Operations

    func isFollowing(userId: UUID, targetUserId: UUID) -> Bool {
        follows.contains { $0.followerId == userId && $0.followingId == targetUserId }
    }

    func getFollowingIds(forUser userId: UUID) -> Set<UUID> {
        Set(follows.filter { $0.followerId == userId }.map { $0.followingId })
    }

    func getFollowers(forUser userId: UUID) -> [User] {
        let followerIds = follows.filter { $0.followingId == userId }.map { $0.followerId }
        return users.filter { followerIds.contains($0.id) }
    }

    func getFollowing(forUser userId: UUID) -> [User] {
        let followingIds = follows.filter { $0.followerId == userId }.map { $0.followingId }
        return users.filter { followingIds.contains($0.id) }
    }

    func follow(userId: UUID, targetUserId: UUID) {
        guard !isFollowing(userId: userId, targetUserId: targetUserId) else { return }

        let newFollow = Follow(followerId: userId, followingId: targetUserId)
        follows.append(newFollow)

        if let followerIndex = users.firstIndex(where: { $0.id == userId }) {
            users[followerIndex].followingCount += 1
        }
        if let followedIndex = users.firstIndex(where: { $0.id == targetUserId }) {
            users[followedIndex].followersCount += 1
        }
    }

    func unfollow(userId: UUID, targetUserId: UUID) {
        follows.removeAll { $0.followerId == userId && $0.followingId == targetUserId }

        if let followerIndex = users.firstIndex(where: { $0.id == userId }) {
            users[followerIndex].followingCount = max(0, users[followerIndex].followingCount - 1)
        }
        if let followedIndex = users.firstIndex(where: { $0.id == targetUserId }) {
            users[followedIndex].followersCount = max(0, users[followedIndex].followersCount - 1)
        }
    }

    func toggleFollow(userId: UUID, targetUserId: UUID) {
        if isFollowing(userId: userId, targetUserId: targetUserId) {
            unfollow(userId: userId, targetUserId: targetUserId)
        } else {
            follow(userId: userId, targetUserId: targetUserId)
        }
    }

    // MARK: - Comment Operations

    func getComments(forPost postId: UUID) -> [Comment] {
        comments.filter { $0.postId == postId }
            .sorted { $0.createdAt < $1.createdAt }
    }

    func addComment(postId: UUID, authorId: UUID, text: String) {
        let author = getUser(byId: authorId)
        let newComment = Comment(
            postId: postId,
            authorId: authorId,
            author: author,
            text: text
        )
        comments.append(newComment)

        if let postIndex = posts.firstIndex(where: { $0.id == postId }) {
            posts[postIndex].commentsCount += 1
        }
    }

    // MARK: - Search

    func searchUsers(query: String) -> [User] {
        guard !query.isEmpty else { return [] }
        let lowercasedQuery = query.lowercased()
        return users.filter {
            $0.username.lowercased().contains(lowercasedQuery) ||
            $0.displayName.lowercased().contains(lowercasedQuery)
        }
    }

    func getSuggestedUsers(forUser userId: UUID, limit: Int = 5) -> [User] {
        let followingIds = getFollowingIds(forUser: userId)
        return users.filter { $0.id != userId && !followingIds.contains($0.id) }
            .prefix(limit)
            .map { $0 }
    }
}
