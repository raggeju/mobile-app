import SwiftUI

struct FollowersListView: View {
    @EnvironmentObject var dataStore: DataStore
    @EnvironmentObject var authViewModel: AuthViewModel

    let userId: UUID
    let isFollowers: Bool

    @State private var selectedUser: User?
    @State private var showUserProfile = false

    private var users: [User] {
        if isFollowers {
            return dataStore.getFollowers(forUser: userId)
        } else {
            return dataStore.getFollowing(forUser: userId)
        }
    }

    var body: some View {
        List {
            if users.isEmpty {
                VStack(spacing: 16) {
                    Image(systemName: isFollowers ? "person.2" : "person.badge.plus")
                        .font(.system(size: 40))
                        .foregroundColor(.secondary)

                    Text(isFollowers ? "No followers yet" : "Not following anyone")
                        .font(.headline)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 60)
                .listRowSeparator(.hidden)
            } else {
                ForEach(users) { user in
                    UserRowView(user: user) {
                        selectedUser = user
                        showUserProfile = true
                    }
                    .listRowInsets(EdgeInsets())
                }
            }
        }
        .listStyle(.plain)
        .navigationTitle(isFollowers ? "Followers" : "Following")
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(isPresented: $showUserProfile) {
            if let user = selectedUser {
                UserProfileView(user: user)
            }
        }
    }
}

#Preview {
    NavigationStack {
        FollowersListView(userId: UUID(), isFollowers: true)
            .environmentObject(AuthViewModel())
            .environmentObject(DataStore())
    }
}
