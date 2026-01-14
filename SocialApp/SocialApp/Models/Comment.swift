import Foundation

struct Comment: Identifiable, Codable {
    let id: UUID
    let postId: UUID
    let authorId: UUID
    var author: User?
    var text: String
    var likesCount: Int
    var isLiked: Bool
    let createdAt: Date

    init(
        id: UUID = UUID(),
        postId: UUID,
        authorId: UUID,
        author: User? = nil,
        text: String,
        likesCount: Int = 0,
        isLiked: Bool = false,
        createdAt: Date = Date()
    ) {
        self.id = id
        self.postId = postId
        self.authorId = authorId
        self.author = author
        self.text = text
        self.likesCount = likesCount
        self.isLiked = isLiked
        self.createdAt = createdAt
    }

    var timeAgoString: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: createdAt, relativeTo: Date())
    }
}
