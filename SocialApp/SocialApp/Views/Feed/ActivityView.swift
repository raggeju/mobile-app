import SwiftUI

struct ActivityView: View {
    @EnvironmentObject var dataStore: DataStore
    @EnvironmentObject var authViewModel: AuthViewModel

    @State private var selectedUser: User?
    @State private var showUserProfile = false

    // Mock activity data
    private var activities: [ActivityItem] {
        dataStore.users.prefix(8).enumerated().map { index, user in
            ActivityItem(
                id: UUID(),
                user: user,
                type: ActivityType.allCases[index % ActivityType.allCases.count],
                timeAgo: "\(index + 1)h"
            )
        }
    }

    var body: some View {
        NavigationStack {
            List {
                Section("Today") {
                    ForEach(activities.prefix(3)) { activity in
                        ActivityRowView(activity: activity) {
                            selectedUser = activity.user
                            showUserProfile = true
                        }
                    }
                }

                Section("This Week") {
                    ForEach(activities.dropFirst(3)) { activity in
                        ActivityRowView(activity: activity) {
                            selectedUser = activity.user
                            showUserProfile = true
                        }
                    }
                }
            }
            .listStyle(.plain)
            .navigationTitle("Activity")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(isPresented: $showUserProfile) {
                if let user = selectedUser {
                    UserProfileView(user: user)
                }
            }
        }
    }
}

struct ActivityItem: Identifiable {
    let id: UUID
    let user: User
    let type: ActivityType
    let timeAgo: String
}

enum ActivityType: CaseIterable {
    case like
    case comment
    case follow
    case mention

    var description: String {
        switch self {
        case .like: return "liked your photo"
        case .comment: return "commented on your photo"
        case .follow: return "started following you"
        case .mention: return "mentioned you in a comment"
        }
    }
}

struct ActivityRowView: View {
    @EnvironmentObject var dataStore: DataStore
    @EnvironmentObject var authViewModel: AuthViewModel

    let activity: ActivityItem
    var onUserTap: (() -> Void)?

    private var isFollowing: Bool {
        guard let currentUserId = authViewModel.currentUser?.id else { return false }
        return dataStore.isFollowing(userId: currentUserId, targetUserId: activity.user.id)
    }

    var body: some View {
        HStack(spacing: 12) {
            Button(action: { onUserTap?() }) {
                ProfileImageView(url: activity.user.profileImageURL, size: 44)
            }

            VStack(alignment: .leading, spacing: 2) {
                HStack(spacing: 4) {
                    Text(activity.user.username)
                        .fontWeight(.semibold)
                    Text(activity.type.description)
                }
                .font(.subheadline)

                Text(activity.timeAgo)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Spacer()

            if activity.type == .follow {
                Button(action: toggleFollow) {
                    Text(isFollowing ? "Following" : "Follow")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(isFollowing ? Color(.systemGray5) : Color.blue)
                        .foregroundColor(isFollowing ? .primary : .white)
                        .cornerRadius(6)
                }
            } else {
                // Show thumbnail for likes/comments
                Rectangle()
                    .fill(Color(.systemGray5))
                    .frame(width: 44, height: 44)
                    .cornerRadius(4)
            }
        }
        .padding(.vertical, 4)
    }

    private func toggleFollow() {
        guard let currentUserId = authViewModel.currentUser?.id else { return }
        dataStore.toggleFollow(userId: currentUserId, targetUserId: activity.user.id)
    }
}

#Preview {
    ActivityView()
        .environmentObject(AuthViewModel())
        .environmentObject(DataStore())
}
