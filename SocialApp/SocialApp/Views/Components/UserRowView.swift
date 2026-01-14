import SwiftUI

struct UserRowView: View {
    @EnvironmentObject var dataStore: DataStore
    @EnvironmentObject var authViewModel: AuthViewModel

    let user: User
    var showFollowButton: Bool = true
    var onTap: (() -> Void)?

    private var isCurrentUser: Bool {
        authViewModel.currentUser?.id == user.id
    }

    private var isFollowing: Bool {
        guard let currentUserId = authViewModel.currentUser?.id else { return false }
        return dataStore.isFollowing(userId: currentUserId, targetUserId: user.id)
    }

    var body: some View {
        HStack(spacing: 12) {
            Button(action: { onTap?() }) {
                ProfileImageView(url: user.profileImageURL, size: 50)
            }

            Button(action: { onTap?() }) {
                VStack(alignment: .leading, spacing: 2) {
                    Text(user.username)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)

                    Text(user.displayName)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }

            Spacer()

            if showFollowButton && !isCurrentUser {
                Button(action: toggleFollow) {
                    Text(isFollowing ? "Following" : "Follow")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(isFollowing ? Color(.systemGray5) : Color.blue)
                        .foregroundColor(isFollowing ? .primary : .white)
                        .cornerRadius(8)
                }
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
    }

    private func toggleFollow() {
        guard let currentUserId = authViewModel.currentUser?.id else { return }
        dataStore.toggleFollow(userId: currentUserId, targetUserId: user.id)
    }
}

#Preview {
    VStack {
        UserRowView(user: User.sampleUsers[0])
        UserRowView(user: User.sampleUsers[1], showFollowButton: false)
    }
    .environmentObject(DataStore())
    .environmentObject(AuthViewModel())
}
