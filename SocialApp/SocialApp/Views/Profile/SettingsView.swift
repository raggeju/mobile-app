import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @Environment(\.dismiss) private var dismiss

    @State private var showLogoutAlert = false

    var body: some View {
        NavigationStack {
            List {
                Section {
                    SettingsRowView(icon: "person.circle", title: "Account")
                    SettingsRowView(icon: "bell", title: "Notifications")
                    SettingsRowView(icon: "lock", title: "Privacy")
                }

                Section {
                    SettingsRowView(icon: "moon", title: "Dark Mode")
                    SettingsRowView(icon: "textformat.size", title: "Accessibility")
                    SettingsRowView(icon: "globe", title: "Language")
                }

                Section {
                    SettingsRowView(icon: "questionmark.circle", title: "Help")
                    SettingsRowView(icon: "info.circle", title: "About")
                }

                Section {
                    Button(action: { showLogoutAlert = true }) {
                        HStack {
                            Image(systemName: "rectangle.portrait.and.arrow.right")
                                .foregroundColor(.red)
                                .frame(width: 24)
                            Text("Log Out")
                                .foregroundColor(.red)
                        }
                    }
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
            .alert("Log Out", isPresented: $showLogoutAlert) {
                Button("Cancel", role: .cancel) {}
                Button("Log Out", role: .destructive) {
                    authViewModel.logout()
                    dismiss()
                }
            } message: {
                Text("Are you sure you want to log out?")
            }
        }
    }
}

struct SettingsRowView: View {
    let icon: String
    let title: String

    var body: some View {
        NavigationLink(destination: Text(title)) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .foregroundColor(.primary)
                    .frame(width: 24)
                Text(title)
            }
        }
    }
}

#Preview {
    SettingsView()
        .environmentObject(AuthViewModel())
}
