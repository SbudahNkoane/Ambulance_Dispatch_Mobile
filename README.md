# 🚑 Ambulance Dispatch and Tracking System

The **Ambulance Dispatch and Tracking System** is a Flutter-based project designed to simplify the process of requesting and tracking ambulances in Bloemfontein. The system consists of two main components:

1. **Mobile Application**: Allows users to request ambulances, track them in real-time, and manage their profiles.
2. **Admin Dashboard**: A Flutter Web-based interface for managing ambulances, verifying accounts, and assigning requests. For the admin dashboard and web functionalities, please refer to the Repository [Ambulance_Dispatch_Application_Admin](https://github.com/SbudahNkoane/Ambulance_Dispatch_Application_Admin.git).

This project leverages **Flutter** for both the mobile and web platforms, with **Firebase** as the backend for authentication, database, and real-time tracking. Additionally, it uses the **Google Maps API** for ambulance location tracking and real-time map integration.

## 📖 How It Works
1. **Request Ambulances**: Users log in and request an ambulance.
2. **Track Status**: View real-time updates and status of ambulance requests.
3. **Location Tracking**: Track ambulance locations on Google Maps.

---

## ✨ Features
- User registration and login.
- Profile management and password reset.
- Real-time ambulance request and tracking using Google Maps.
- Account verification applications for users.
- Paramedic access for selecting and dispatching ambulances.
---

## 🛠️ Technologies Used
- **Frontend**: Flutter
- **Backend**: Firebase (Firestore, Authentication, Realtime Database)
- **Mapping and Location Tracking**: Google Maps API
- **Platform**: Mobile (ios and android)

---

## 🚀 Installation Guide

### Prerequisites:
- Flutter installed on your machine. [Install Flutter](https://flutter.dev/docs/get-started/install)
- Firebase project set up. [Set up Firebase](https://firebase.google.com/docs/flutter/setup)
- Google Maps API key obtained. [Get an API Key](https://developers.google.com/maps/documentation/android-sdk/get-api-key)

### Steps to Run the Project:
1. **Clone the Repository**:
   ```bash
   git clone https://github.com/SbudahNkoane/Ambulance_Dispatch_Mobile.git
   cd Ambulance_Dispatch_Mobile

2. **Install Dependencies**:
   ```bash
   flutter pub get

3. ### Set up Google Maps API:
- Go to the Google Cloud Console.
- Enable the Maps SDK for Android and Maps SDK for iOS.
- Generate an API key and add it to your project:
  - **For Android**: Add the API key to the android/app/src/main/AndroidManifest.xml file:
    ```bash
    <meta-data
    android:name="com.google.android.geo.API_KEY"
    android:value="YOUR_API_KEY_HERE"/>
  - **For iOS**: Add the API key to the ios/Runner/AppDelegate.swift file:
    ```bash
    GMSServices.provideAPIKey("YOUR_API_KEY_HERE")
4. **Run the App**:
   ```bash
   flutter run
## 🌐 Web Version
[Ambulance_Dispatch_Application_Admin](https://github.com/SbudahNkoane/Ambulance_Dispatch_Application_Admin.git)

## 📞 Contact
For any queries or support, feel free to reach out:

Email: sbudahnkoane1@gmail.com
