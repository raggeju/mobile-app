import SwiftUI

@main
struct SocialAppApp: App {
    @StateObject private var authViewModel = AuthViewModel()
    @StateObject private var dataStore = DataStore()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(authViewModel)
                .environmentObject(dataStore)
        }
    }
}
