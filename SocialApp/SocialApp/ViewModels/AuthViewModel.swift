import Foundation
import SwiftUI

@MainActor
class AuthViewModel: ObservableObject {
    @Published var currentUser: User?
    @Published var isAuthenticated = false
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let userDefaultsKey = "currentUser"

    init() {
        loadSavedUser()
    }

    private func loadSavedUser() {
        if let data = UserDefaults.standard.data(forKey: userDefaultsKey),
           let user = try? JSONDecoder().decode(User.self, from: data) {
            currentUser = user
            isAuthenticated = true
        }
    }

    private func saveUser(_ user: User) {
        if let data = try? JSONEncoder().encode(user) {
            UserDefaults.standard.set(data, forKey: userDefaultsKey)
        }
    }

    func login(username: String, password: String) {
        isLoading = true
        errorMessage = nil

        // Simulate network delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }

            // For demo purposes, accept any non-empty credentials
            if username.isEmpty || password.isEmpty {
                self.errorMessage = "Please enter both username and password"
                self.isLoading = false
                return
            }

            // Check if user exists in sample data, otherwise create new
            if let existingUser = User.sampleUsers.first(where: {
                $0.username.lowercased() == username.lowercased()
            }) {
                self.currentUser = existingUser
            } else {
                self.currentUser = User(
                    username: username,
                    displayName: username.capitalized,
                    bio: "New to SocialApp!"
                )
            }

            self.saveUser(self.currentUser!)
            self.isAuthenticated = true
            self.isLoading = false
        }
    }

    func signUp(username: String, displayName: String, password: String, confirmPassword: String) {
        isLoading = true
        errorMessage = nil

        // Validation
        guard !username.isEmpty else {
            errorMessage = "Username is required"
            isLoading = false
            return
        }

        guard !displayName.isEmpty else {
            errorMessage = "Display name is required"
            isLoading = false
            return
        }

        guard password.count >= 6 else {
            errorMessage = "Password must be at least 6 characters"
            isLoading = false
            return
        }

        guard password == confirmPassword else {
            errorMessage = "Passwords do not match"
            isLoading = false
            return
        }

        // Simulate network delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
            guard let self = self else { return }

            // Check if username is taken
            if User.sampleUsers.contains(where: {
                $0.username.lowercased() == username.lowercased()
            }) {
                self.errorMessage = "Username is already taken"
                self.isLoading = false
                return
            }

            let newUser = User(
                username: username,
                displayName: displayName,
                bio: ""
            )

            self.currentUser = newUser
            self.saveUser(newUser)
            self.isAuthenticated = true
            self.isLoading = false
        }
    }

    func logout() {
        currentUser = nil
        isAuthenticated = false
        UserDefaults.standard.removeObject(forKey: userDefaultsKey)
    }

    func updateProfile(displayName: String, bio: String) {
        guard var user = currentUser else { return }

        user.displayName = displayName
        user.bio = bio
        currentUser = user
        saveUser(user)
    }
}
