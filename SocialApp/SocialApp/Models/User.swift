import Foundation

struct User: Identifiable, Codable, Hashable {
    let id: UUID
    var username: String
    var displayName: String
    var bio: String
    var profileImageURL: String?
    var followersCount: Int
    var followingCount: Int
    var postsCount: Int
    let createdAt: Date

    init(
        id: UUID = UUID(),
        username: String,
        displayName: String,
        bio: String = "",
        profileImageURL: String? = nil,
        followersCount: Int = 0,
        followingCount: Int = 0,
        postsCount: Int = 0,
        createdAt: Date = Date()
    ) {
        self.id = id
        self.username = username
        self.displayName = displayName
        self.bio = bio
        self.profileImageURL = profileImageURL
        self.followersCount = followersCount
        self.followingCount = followingCount
        self.postsCount = postsCount
        self.createdAt = createdAt
    }
}

extension User {
    static let placeholder = User(
        username: "username",
        displayName: "Display Name",
        bio: "This is a bio"
    )

    static let sampleUsers: [User] = [
        User(
            username: "johndoe",
            displayName: "John Doe",
            bio: "Photography enthusiast | Travel lover",
            profileImageURL: "https://picsum.photos/seed/user1/200",
            followersCount: 1234,
            followingCount: 567,
            postsCount: 42
        ),
        User(
            username: "janedoe",
            displayName: "Jane Doe",
            bio: "Artist & Designer",
            profileImageURL: "https://picsum.photos/seed/user2/200",
            followersCount: 5678,
            followingCount: 234,
            postsCount: 89
        ),
        User(
            username: "alexsmith",
            displayName: "Alex Smith",
            bio: "Tech geek | Coffee addict",
            profileImageURL: "https://picsum.photos/seed/user3/200",
            followersCount: 890,
            followingCount: 456,
            postsCount: 23
        ),
        User(
            username: "sarahwilson",
            displayName: "Sarah Wilson",
            bio: "Foodie | Chef | Recipe creator",
            profileImageURL: "https://picsum.photos/seed/user4/200",
            followersCount: 3456,
            followingCount: 789,
            postsCount: 156
        ),
        User(
            username: "mikebrown",
            displayName: "Mike Brown",
            bio: "Fitness trainer | Healthy lifestyle",
            profileImageURL: "https://picsum.photos/seed/user5/200",
            followersCount: 7890,
            followingCount: 123,
            postsCount: 234
        )
    ]
}
