import SwiftUI

struct PostDetailView: View {
    @EnvironmentObject var dataStore: DataStore
    @EnvironmentObject var authViewModel: AuthViewModel

    let post: Post

    @State private var selectedUser: User?
    @State private var showUserProfile = false

    var body: some View {
        ScrollView {
            PostCardView(
                post: post,
                onUserTap: { user in
                    selectedUser = user
                    showUserProfile = true
                }
            )
        }
        .navigationTitle("Post")
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
        PostDetailView(post: Post.samplePosts(for: User.sampleUsers).first!)
            .environmentObject(AuthViewModel())
            .environmentObject(DataStore())
    }
}
