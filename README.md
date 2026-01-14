# SocialApp - Instagram-like Social Network for iOS

A SwiftUI-based social network mobile app for iPhone featuring photo/video sharing, user feeds, and social interactions.

## Features

- **Authentication**: Login and Sign Up with username/password
- **Home Feed**: View posts from people you follow
- **Explore Feed**: Discover new posts and search for users
- **Create Posts**: Share photos and videos with captions
- **User Profiles**: View personal feeds, followers, and following
- **Follow System**: Follow/unfollow users to curate your feed
- **Activity Feed**: See likes, comments, and new followers
- **Direct Messages**: Chat with other users

## Project Structure

```
SocialApp/
├── SocialApp.xcodeproj/
├── SocialApp/
│   ├── SocialAppApp.swift          # App entry point
│   ├── ContentView.swift           # Root view
│   ├── Models/
│   │   ├── User.swift              # User model
│   │   ├── Post.swift              # Post model
│   │   ├── Follow.swift            # Follow relationship model
│   │   └── Comment.swift           # Comment model
│   ├── Views/
│   │   ├── MainTabView.swift       # Main tab navigation
│   │   ├── Auth/
│   │   │   ├── LoginView.swift
│   │   │   └── SignUpView.swift
│   │   ├── Feed/
│   │   │   ├── HomeFeedView.swift
│   │   │   ├── ExploreFeedView.swift
│   │   │   ├── ActivityView.swift
│   │   │   └── DirectMessagesView.swift
│   │   ├── Profile/
│   │   │   ├── ProfileView.swift
│   │   │   ├── UserProfileView.swift
│   │   │   ├── EditProfileView.swift
│   │   │   ├── FollowersListView.swift
│   │   │   └── SettingsView.swift
│   │   ├── Post/
│   │   │   ├── CreatePostView.swift
│   │   │   ├── PostDetailView.swift
│   │   │   └── CommentsView.swift
│   │   └── Components/
│   │       ├── PostCardView.swift
│   │       ├── ProfileImageView.swift
│   │       └── UserRowView.swift
│   ├── ViewModels/
│   │   └── AuthViewModel.swift
│   ├── Services/
│   │   └── DataStore.swift
│   └── Resources/
│       └── Assets.xcassets/
```

## Requirements

- iOS 17.0+
- Xcode 15.0+
- Swift 5.0+

## Getting Started

1. Open `SocialApp/SocialApp.xcodeproj` in Xcode
2. Select your target device or simulator
3. Build and run the project (⌘ + R)

## Architecture

The app follows the MVVM (Model-View-ViewModel) architecture:

- **Models**: Data structures for User, Post, Follow, and Comment
- **Views**: SwiftUI views organized by feature
- **ViewModels**: Business logic and state management
- **Services**: Data layer with DataStore for managing app state

## Key Components

### DataStore
Central state management that handles:
- User data and authentication state
- Posts CRUD operations
- Follow/unfollow relationships
- Comments and likes
- Search functionality

### AuthViewModel
Manages authentication flow:
- Login/logout
- User registration
- Profile updates
- Session persistence

## Demo Data

The app includes mock data for demonstration:
- Sample users with profile images
- Sample posts with images from picsum.photos
- Pre-populated followers and following relationships

## Future Enhancements

- Backend API integration
- Real-time messaging with WebSockets
- Push notifications
- Video playback
- Stories feature
- Image filters and editing
- Location tagging
- Hashtag support
