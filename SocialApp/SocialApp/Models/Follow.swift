import Foundation

struct Follow: Identifiable, Codable {
    let id: UUID
    let followerId: UUID
    let followingId: UUID
    let createdAt: Date

    init(
        id: UUID = UUID(),
        followerId: UUID,
        followingId: UUID,
        createdAt: Date = Date()
    ) {
        self.id = id
        self.followerId = followerId
        self.followingId = followingId
        self.createdAt = createdAt
    }
}
