import Foundation

enum MediaType: String, Codable {
    case image
    case video
}

struct Post: Identifiable, Codable {
    let id: UUID
    let authorId: UUID
    var author: User?
    var caption: String
    var mediaURL: String
    var mediaType: MediaType
    var thumbnailURL: String?
    var likesCount: Int
    var commentsCount: Int
    var isLiked: Bool
    let createdAt: Date

    init(
        id: UUID = UUID(),
        authorId: UUID,
        author: User? = nil,
        caption: String,
        mediaURL: String,
        mediaType: MediaType = .image,
        thumbnailURL: String? = nil,
        likesCount: Int = 0,
        commentsCount: Int = 0,
        isLiked: Bool = false,
        createdAt: Date = Date()
    ) {
        self.id = id
        self.authorId = authorId
        self.author = author
        self.caption = caption
        self.mediaURL = mediaURL
        self.mediaType = mediaType
        self.thumbnailURL = thumbnailURL
        self.likesCount = likesCount
        self.commentsCount = commentsCount
        self.isLiked = isLiked
        self.createdAt = createdAt
    }

    var timeAgoString: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: createdAt, relativeTo: Date())
    }
}

extension Post {
    static func samplePosts(for users: [User]) -> [Post] {
        guard !users.isEmpty else { return [] }

        let captions = [
            "Beautiful sunset today! 🌅",
            "Coffee time ☕️",
            "Amazing view from the top!",
            "Just finished this masterpiece",
            "Weekend vibes",
            "New adventure begins",
            "Simple pleasures",
            "Making memories",
            "Nature at its finest",
            "City lights"
        ]

        return (0..<20).map { index in
            let user = users[index % users.count]
            let daysAgo = Double(index) * 0.5
            return Post(
                authorId: user.id,
                author: user,
                caption: captions[index % captions.count],
                mediaURL: "https://picsum.photos/seed/post\(index)/600/600",
                mediaType: index % 5 == 0 ? .video : .image,
                thumbnailURL: index % 5 == 0 ? "https://picsum.photos/seed/thumb\(index)/600/600" : nil,
                likesCount: Int.random(in: 10...5000),
                commentsCount: Int.random(in: 0...200),
                isLiked: Bool.random(),
                createdAt: Date().addingTimeInterval(-86400 * daysAgo)
            )
        }
    }
}
