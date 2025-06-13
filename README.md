# Dear Diary

Dear Diary is a modern and minimalistic responsive mobile diary app built with Flutter. It allows users to securely log their thoughts, rate their days, and attach images — all stored using Firebase services. The app supports both email/password and Google Sign-In authentication methods, dark/light mode toggling, and offers rich features like image upload, search, and filtering by mood.

## Video Demo
<a href="https://github.com/user-attachments/assets/16b011b5-d600-441e-aeb6-d7667a8d1a33">
  <img src="https://github.com/user-attachments/assets/16b011b5-d600-441e-aeb6-d7667a8d1a33" width="300" height="600" />
</a>

## Features

- 🔐 **User Authentication**
  - Sign up / Login using **Email & Password**
  - Login using **Google Sign-In**
  - **Forgot Password** functionality

- 📅 **Diary Entries**
  - Create, edit, and delete entries
  - Add a **daily rating (1–5 stars)**
  - Attach **multiple images** to each entry
  - Organize entries by **date**

- 🌗 **Dark Mode**
  - Toggle between light and dark themes with a switch

- 🔍 **Search & Filter**
  - Search diary entries by keywords
  - Filter by rating to track mood patterns

- 📱 **Responsive Design**
  - Optimized for different screen sizes and orientations

- ☁️ **Firebase Integration**
  - Firebase Auth for user login
  - Firebase Firestore for entry storage
  - Stores uploaded images using Firebase Storage
  - 
### 📽️ Dear Diary - App Walkthrough

Click below to watch a full walkthrough of the app with feature explanations and usage demo:

[![Watch the Demo](https://img.youtube.com/vi/hyzMhzjlwRg/maxresdefault.jpg)](https://www.youtube.com/watch?v=hyzMhzjlwRg)


## Getting Started

1. **Clone the repo**
   ```bash
   git clone https://github.com/yourusername/dear-diary-app.git
   cd dear-diary-app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```
   
3. **Run the app**
   ```bash
   flutter run
   ```

##  Project Structure 

```
├── main.dart                           # Entry point of the app and initial routing
├── firebase_options.dart               # Firebase project configuration

├── models/
│   ├── diary_entry_model.dart          # Data model for diary entries

├── services/
│   ├── auth_service.dart               # Firebase authentication (email/password + Google Sign-In)
│   ├── diary_entry_service.dart        # CRUD operations for Firestore
│   ├── storage_service.dart            # Handles image uploads to Firebase Storage

├── views/
│   ├── login_view.dart                 # User login screen
│   ├── signup_view.dart                # New user registration screen
│   ├── forgot_password_view.dart       # Password reset UI
│   ├── diary_list_view.dart            # Main screen displaying diary entries
│   ├── add_edit_diary_entry_view.dart  # Screen for adding or editing diary entries

├── widgets/
│   ├── diary_entry_card.dart           # Widget to display individual diary entries

├── providers/
│   ├── theme_provider.dart             # Manages light/dark mode theme switching
``` 

## Dependencies

**🔐 Authentication**
- firebase_auth
- firebase_ui_auth
- firebase_ui_oauth_google
- google_sign_in

**📄 Data & Storage**
- cloud_firestore
- firebase_storage
- shared_preferences
- path_provider

**🖼️ Media Handling**
- image_picker
- file_picker

**🧠 State Management**
- provider

**🌐 Utilities**
- firebase_core
- intl
- uuid

##  License

This project is open source and available under the [MIT License](LICENSE).


