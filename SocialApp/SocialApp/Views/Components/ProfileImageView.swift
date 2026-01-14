import SwiftUI

struct ProfileImageView: View {
    let url: String?
    var size: CGFloat = 40

    var body: some View {
        AsyncImage(url: URL(string: url ?? "")) { phase in
            switch phase {
            case .empty:
                placeholderView
            case .success(let image):
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            case .failure:
                placeholderView
            @unknown default:
                placeholderView
            }
        }
        .frame(width: size, height: size)
        .clipShape(Circle())
        .overlay(Circle().stroke(Color(.systemGray4), lineWidth: 0.5))
    }

    private var placeholderView: some View {
        Circle()
            .fill(
                LinearGradient(
                    colors: [.gray.opacity(0.3), .gray.opacity(0.1)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .overlay {
                Image(systemName: "person.fill")
                    .font(.system(size: size * 0.4))
                    .foregroundColor(.gray)
            }
    }
}

#Preview {
    VStack(spacing: 20) {
        ProfileImageView(url: "https://picsum.photos/200", size: 80)
        ProfileImageView(url: nil, size: 60)
        ProfileImageView(url: "invalid", size: 40)
    }
}
