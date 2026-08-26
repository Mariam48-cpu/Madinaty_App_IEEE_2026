# ☕ Madinaty

<p align="center">
  <strong>Discover. Personalize. Book. Enjoy.</strong>
</p>

<p align="center">
  A smart Flutter application for discovering cafés, personalizing recommendations,
  planning experiences with AI, booking tables, pre-ordering products, and managing
  the complete café experience in one place.
</p>


## 👥 Team Members

| Name | Role |
|---|---|
| **[Mohamed Atef]** | Flutter Developer |
| **[Mohamed Habib]** | Flutter Developer |
| **[Mariam sanad]** | Flutter Developer |
| **[Roaa Hisham]** | Flutter Developer |
---


## 📱 About The Project

**Madinaty** is a Flutter-based mobile application designed to provide users with a complete and personalized café discovery and booking experience.

The application combines café discovery, personalized recommendations, AI-powered planning, table reservations, pre-orders, digital booking passes, payments, favorites, reviews, notifications, and profile management into a single platform.

The project is built using **Flutter and Dart** and follows a **Feature-Based Clean Architecture** approach to keep the codebase scalable, maintainable, and easy to extend.

---

## ✨ Features

### 🔐 Authentication

- User registration
- User login
- Logout
- Password reset
- OTP verification
- Google Sign-In
- Firebase Authentication
- User profile management

---

### 🏠 Home & Personalized Recommendations

The home experience provides personalized café recommendations based on user preferences.

Users can personalize their experience through:

- Interests
- Mood
- Occasion
- Location

The recommendation system uses the user's preferences to provide more relevant café suggestions.

---

### 🔎 Café Discovery

Users can discover cafés around them and search for places based on different criteria.

Features include:

- Nearby cafés
- Café search
- Category filtering
- Map-based discovery
- Manual location selection
- Location permissions
- Google Places integration
- Café details
- Café location
- Café features
- Popular products
- Café menu

---

### 🗺️ Maps & Location

Madinaty provides location-aware discovery using:

- `flutter_map`
- `latlong2`
- `geolocator`
- `geocoding`
- `location`
- `flutter_polyline_points`

Users can:

- Detect their current location
- Select a location manually
- Pick a location from a map
- Discover nearby cafés
- View cafés on a map

---

### 🤖 AI Planner

Madinaty includes an AI-powered planner designed to help users create personalized plans and experiences.

Users can provide information such as:

- Mood
- Occasion
- Interests
- Custom prompts

The AI planner generates an experience plan and presents the result through a dedicated result interface.

The AI functionality is powered using Google's Generative AI integration.

---

### ❤️ Favorites

Users can save cafés and products to their favorites.

Supported operations include:

- Add favorite
- Remove favorite
- Toggle favorite
- Check favorite status
- View favorites
- Watch favorites for updates

Favorites are persisted remotely using Firebase.

---

### 📅 Table Booking

Users can reserve tables at cafés.

The booking flow includes:

1. Select café
2. Select date
3. Select time
4. Select number of guests
5. Select seating preference
6. Select occasion
7. Review reservation
8. Proceed to checkout

The application also provides:

- Seating map
- Time selection
- Date selection
- Booking summary
- Booking status
- Digital booking pass
- QR code

---

### 🎟️ Digital Pass

After completing a reservation, users receive a digital booking pass.

The digital pass contains the reservation information and QR code that can be used to identify the booking.

---

### 🛒 Cart

Users can add café products to their cart before completing their reservation.

Cart functionality includes:

- Add products
- Remove products
- Update quantity
- Clear cart
- Order notes
- Real-time cart updates
- Cart subtotal
- Pickup information

---

### 🍰 Pre-Orders

Users can pre-order café products as part of the booking journey.

The pre-order system supports:

- Creating pre-orders
- Viewing user pre-orders
- Updating pre-order status
- Cancelling pre-orders
- Watching pre-order updates
- Associating pre-orders with bookings
- Pickup time
- Order notes

The cart is processed into a pre-order after successful booking/payment.

---

### 💳 Checkout & Payments

Madinaty provides an integrated checkout experience.

Supported payment methods include:

- Credit / Debit Card
- Mobile Wallet

The application integrates with **Paymob** for payment processing.

The checkout flow handles:

- Reservation fee
- Pre-order amount
- Tax calculation
- Payment method selection
- Wallet number validation
- Paymob payment URL
- Payment WebView
- Payment completion
- Booking confirmation
- Cart clearing

---

### 🔔 Notifications

The application includes an in-app notification system.

Users can:

- View notifications
- Mark a notification as read
- Mark all notifications as read
- Delete notifications
- Receive notification updates

Notifications are stored under the user's Firebase Firestore data.

The application also uses:

- `flutter_local_notifications`

for local notification support.

---

### 👤 Profile

The profile section allows users to manage their account information.

Users can:

- View their profile
- Edit profile information
- Update profile picture
- Update personal information
- Manage preferences

Profile images are uploaded using Cloudinary.

---

### ⭐ Reviews & Ratings

Users can interact with café reviews and ratings.

Features include:

- View café reviews
- Submit reviews
- View user's review
- Watch review updates
- Rating summary
- Rating breakdown
- Interactive star rating
- Review filtering

---

### 🌍 Localization

Madinaty supports localized application content.

The project includes localization support for the application's UI and uses the **Cairo** font for Arabic interfaces.

Localization is implemented through:

- `flutter_localization`
- `localization`
- `flutter_localizations`

---

### 🎨 UI & UX

The application includes reusable UI components and loading states.

Examples include:

- Custom buttons
- Custom text fields
- Café cards
- Product cards
- Rating widgets
- Empty states
- Error states
- Loading widgets
- Skeleton loading screens

Skeleton screens are available for multiple features including:

- Home
- Discovery
- Favorites
- Cart
- Notifications
- Profile
- Reviews
- Search
- Payment
- Pre-orders
- Personalization
- AI Planner
- Onboarding

---

# 🏗️ Architecture

Madinaty follows a **Feature-Based Clean Architecture** structure.

Each feature is divided into three main layers:
```
Feature
│
├── data
│   ├── data_sources
│   ├── models
│   └── repositories
│
├── domain
│   ├── entities
│   ├── repositories
│   └── use_cases
│
└── presentation
    ├── view
    │   ├── screens
    │   └── widgets
    │
    └── view_model
        └── Cubit / Bloc
```
---

## 📂 Project Structure
```
lib/
│
├── core/
│   ├── constants/
│   ├── di/
│   ├── error/
│   ├── localization/
│   ├── network/
│   ├── routes/
│   ├── services/
│   ├── theme/
│   ├── utils/
│   └── widgets/
│       └── skeletons/
│
└── features/
    │
    ├── ai_planner/
    ├── app_section/
    ├── auth/
    ├── booking/
    ├── cafe/
    ├── cart/
    ├── checkout/
    ├── discovery/
    ├── favorites/
    ├── home/
    ├── notifications/
    ├── onboarding/
    ├── personalization/
    ├── pre_order/
    ├── profile/
    └── reviews/
```
---

## 🛠️ Tech Stack

### Frontend

- **Flutter**
- **Dart**
- **Material Design**
- **BLoC / Cubit** for state management
- **Clean Architecture**
- **Feature-Based Architecture**

### Backend & Cloud Services

- **Firebase Authentication**
- **Cloud Firestore**
- **Firebase Core**
- **Firebase Local Notifications**
- **Cloudinary** for profile image storage
- **Paymob** for payment processing
- **Google Places API** for café discovery
- **Google Generative AI** for AI-powered planning

### Maps & Location

- `flutter_map`
- `latlong2`
- `geolocator`
- `geocoding`
- `location`
- `flutter_polyline_points`

---

## 📦 Main Packages

| Package | Purpose |
|---|---|
| `flutter_bloc` | State management |
| `firebase_core` | Firebase initialization |
| `firebase_auth` | Authentication |
| `cloud_firestore` | Database and real-time data |
| `google_sign_in` | Google authentication |
| `get_it` | Dependency injection |
| `injectable` | Dependency injection code generation |
| `dio` | HTTP networking |
| `http` | HTTP requests |
| `flutter_map` | Interactive maps |
| `geolocator` | Device location |
| `geocoding` | Address and coordinates conversion |
| `google_generative_ai` | AI-powered planner |
| `webview_flutter` | Payment WebView |
| `flutter_local_notifications` | Local notifications |
| `flutter_localization` | Localization |
| `google_fonts` | Font management |
| `qr_flutter` | QR code generation |
| `image_picker` | Image selection |
| `toastification` | Toast notifications |
| `shared_preferences` | Local storage |
| `flutter_svg` | SVG support |
| `carousel_slider` | Carousel components |
| `equatable` | Value equality |
| `dartz` | Functional programming and error handling |

---

# 🔥 Firebase

Madinaty uses Firebase as one of its main backend services.

### Firebase Authentication

Firebase Authentication is used for:

- Email & password authentication
- Google Sign-In
- Password reset
- User authentication state

### Cloud Firestore

Firestore is used to store and manage application data including:

- Users
- Cafés
- Products
- Bookings
- Pre-orders
- Favorites
- Reviews
- Notifications
- User preferences

The application also uses Firestore real-time streams for features that require live updates.

---

# ☁️ Cloudinary

Cloudinary is used for uploading and storing user profile images.

The profile update flow supports:

1. Selecting an image
2. Uploading the image to Cloudinary
3. Receiving the hosted image URL
4. Updating the user's profile in Firestore

---

# 💳 Paymob Integration

Madinaty integrates **Paymob** to provide online payment functionality.

The checkout system supports:

- Credit / Debit Card
- Mobile Wallet
```
Payment flow:
Checkout
   │
   ├── Select Payment Method
   │
   ├── Calculate Total
   │
   ├── Create Paymob Payment
   │
   ├── Open Payment WebView
   │
   └── Payment Success
          │
          ├── Confirm Booking
          ├── Create Pre-Order
          └── Clear Cart
```
---

# 🤖 AI Planner Flow

The AI Planner uses user preferences and custom inputs to generate personalized café experiences.
```
User Input
    │
    ├── Mood
    ├── Occasion
    ├── Interests
    └── Custom Prompt
          │
          ▼
     AI Planner
          │
          ▼
   Generated Plan
          │
          ▼
     Result Screen
```
---

# 🔔 Notification Flow

Notifications are connected to important events throughout the application.

For example, when a booking or related process reaches an important status, a notification can be created for the user.

Notification flow:
```
User Action
    │
    ▼
Application Event
    │
    ▼
Create Notification
    │
    ▼
Firebase Firestore
    │
    ▼
Notification Cubit
    │
    ▼
Notifications Screen
```
Users can:

- View notifications
- Mark individual notifications as read
- Mark all notifications as read
- Delete notifications
- Receive real-time notification updates

---

# 🧩 Dependency Injection

The project uses **GetIt** and **Injectable** for dependency injection.

Dependencies such as:

- Firebase services
- Repositories
- Data sources
- Use cases
- Cubits
- Application services

are registered through the dependency injection layer.

Main dependency injection files:

core/di/
│
├── injection.dart
├── injection.config.dart
└── injection_container.dart


---

# 🧭 Application Flow

The main user journey in Madinaty follows the flow below:

```
                    ┌───────────────┐
                    │    Splash     │
                    └───────┬───────┘
                            │
                            ▼
                    ┌───────────────┐
                    │   Onboarding  │
                    └───────┬───────┘
                            │
                            ▼
                    ┌───────────────┐
                    │ Authentication│
                    └───────┬───────┘
                            │
                            ▼
                    ┌───────────────┐
                    │     Home      │
                    └───────┬───────┘
                            │
             ┌──────────────┼──────────────┐
             │              │              │
             ▼              ▼              ▼
        Discovery       AI Planner      Favorites
             │              │
             ▼              ▼
        Café Details    Generated Plan
             │              │
             └───────┬──────┘
                     │
                     ▼
                  Booking
                     │
                     ▼
                   Cart
                     │
                     ▼
                 Checkout
                     │
                     ▼
                  Paymob
                     │
                     ▼
              Booking Confirmation
                     │
            ┌────────┴────────┐
            ▼                 ▼
      Digital Pass       Notification
            │
            ▼
          QR Code
```
---

# 📱 Main Screens

The application contains multiple screens covering the complete café discovery, planning, booking, shopping, and account management experience.

### 🔐 Authentication

- Splash Screen
- Onboarding Screen
- Login Screen
- Sign Up Screen
- Forgot Password Screen
- OTP Verification Screen

### 🏠 Discovery & Planning

- Home Screen
- Discovery Screen
- Search Screen
- Café Details Screen
- Personalization Screen
- AI Planner Screen
- AI Planner Result Screen
- Favorites Screen

### 📅 Booking & Payment

- Booking Screen
- Seating Selection
- Date & Time Selection
- Booking Summary
- Checkout Screen
- Payment WebView
- Booking Confirmation
- Digital Pass Screen

### 🛒 Shopping

- Café Menu
- Product Details
- Cart Screen
- Pre-Order Screen

### 👤 Account

- Profile Screen
- Edit Profile Screen
- Settings Screen
- Notifications Screen
- Reviews Screen

---

# 🔐 Authentication Flow

The authentication system is implemented using Firebase Authentication.

```
User
 │
 ├── Sign Up
 │      │
 │      ▼
 │  Firebase Authentication
 │      │
 │      ▼
 │  Create / Update User Profile
 │
 └── Login
        │
        ▼
 Firebase Authentication
        │
        ▼
   Home Screen
```
---

# 🔑 Authentication

Madinaty uses Firebase Authentication to provide secure user authentication.

Supported authentication methods include:

- Email & Password
- Google Sign-In
- Password Reset
- OTP Verification
- Authentication State Management
- User Profile Creation

Authentication is integrated with the application's Clean Architecture and dependency injection layers.

---

# ❤️ Favorites Flow

Users can manage their favorite cafés and products.

Favorite flow:
```
User
    │
    ▼
Café / Product
    │
    ▼
Add / Remove Favorite
    │
    ▼
Favorites Repository
    │
    ▼
Firebase Firestore
    │
    ▼
Favorites Screen
```
The favorites feature supports real-time updates and favorite status checking.

---

# 📅 Booking Flow

The booking system allows users to reserve tables at cafés.

Booking flow:
```
Select Café
    │
    ▼
Select Date
    │
    ▼
Select Time
    │
    ▼
Select Number of Guests
    │
    ▼
Select Seating Preference
    │
    ▼
Select Occasion
    │
    ▼
Booking Summary
    │
    ▼
Checkout
    │
    ▼
Payment
    │
    ▼
Booking Confirmation
    │
    ▼
Digital Pass
    │
    ▼
QR Code
```
---

# 🛒 Cart & Pre-Order Flow

Users can add products from café menus to their cart and create pre-orders during the booking process.

Cart flow:
```
Café Menu
    │
    ▼
Product Selection
    │
    ▼
Add to Cart
    │
    ▼
Update Quantity
    │
    ▼
Cart Summary
    │
    ▼
Checkout
    │
    ▼
Successful Payment
    │
    ▼
Create Pre-Order
    │
    ▼
Associate with Booking
    │
    ▼
Clear Cart
```
---

# 🔔 Notifications & Booking Events

Notifications are connected to important events in the booking journey.

Examples include:

- Booking confirmation
- Booking status updates
- Pre-order updates
- Important booking events
- Profile-related events

Notification architecture:
```
Application Event
        │
        ▼
Create Notification
        │
        ▼
Firestore
        │
        ▼
Notification Stream
        │
        ▼
Notification Cubit
        │
        ▼
Notifications Screen
```
Notifications are stored under:

users/{uid}/notifications

The notification system supports real-time updates, read/unread status, and notification deletion.

---

# 📊 Data & Backend Structure

The application uses Firebase Firestore to manage application data.

Main collections include:

```
Firestore
│
├── users/
│   └── {uid}/
│       └── notifications/
│
├── cafes/
│
├── products/
│
├── bookings/
│
├── pre_orders/
│
├── favorites/
│
└── reviews/
```
---

# ⚙️ Requirements

Before running Madinaty, make sure the following tools are installed:

- Flutter SDK
- Dart SDK
- Android Studio or Visual Studio Code
- Android SDK
- Git
- A Firebase project
- Google Cloud API configuration
- Paymob account and integration credentials
- Cloudinary account

Recommended environment:

- Flutter 3.x or later
- Dart 3.x or later
- Android SDK 21+
- JDK 17+

---

# 🚀 Installation

Follow the steps below to run the project locally.

### 1. Clone the Repository

``
git clone https://github.com/your-username/madinaty.git
``


### 2. Navigate to the Project Directory

cd madinaty
3. Install Flutter Dependencies

Install all required project dependencies:

flutter pub get
4. Configure Firebase

Madinaty uses Firebase Authentication and Cloud Firestore.

Before running the application, make sure your Firebase project is configured correctly.

The project uses FlutterFire configuration:

lib/firebase_options.dart

If you need to configure Firebase again, install the FlutterFire CLI:

dart pub global activate flutterfire_cli

Then run:

flutterfire configure

Select the Firebase project and the platforms you want to support.

For Android, make sure the Firebase configuration file is available:

android/app/google-services.json

For iOS, make sure the Firebase configuration file is available:

ios/Runner/GoogleService-Info.plist

Firebase configuration files and project settings should match the Firebase project used by the application.

5. Configure Google Services

Madinaty uses Google services for café discovery, location-related functionality, and authentication.

Make sure the required APIs are enabled in your Google Cloud project.

Depending on the configured features, these may include:

Google Places API
Maps-related APIs
Geocoding services
Google Sign-In
Generative AI services

Add the required API keys using a secure configuration method.

Never commit private API keys or secrets to GitHub.

6. Configure Cloudinary

Cloudinary is used to upload user profile images.

Configure the required Cloudinary settings for profile image uploads.

The application requires:

Cloudinary Cloud Name
Upload Preset

Do not commit private credentials or secrets to the repository.

7. Configure Paymob

Paymob is used for payment processing.

Before testing the checkout flow, configure the required Paymob integration credentials.

The payment integration requires the appropriate:

API credentials
Integration configuration
Payment configuration

Use Paymob test credentials for development and testing.

Never commit Paymob secret credentials to GitHub.

8. Configure Location Permissions

Madinaty uses device location for nearby café discovery and map-based features.

For Android, make sure the required location permissions are configured in:

android/app/src/main/AndroidManifest.xml

Required permissions include:

<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />

For iOS, configure the required location usage descriptions inside:

ios/Runner/Info.plist
9. Run Flutter Doctor

Check that your development environment is configured correctly:

flutter doctor

Resolve any required issues reported by Flutter before running the application.

10. Check Connected Devices

To see available Android emulators and physical devices:

flutter devices

Make sure at least one supported device is available.

11. Run the Application

Run the application using:

flutter run

To run on a specific device:

flutter run -d <device-id>
🔐 Security

Madinaty integrates with multiple external services and therefore requires secure handling of credentials.

The following information should never be committed to the repository:

API keys
Secret keys
Payment credentials
Private Firebase credentials
Cloudinary secrets
Authentication secrets

For local development, use secure configuration methods appropriate for the environment.

If a secret is accidentally pushed to a public repository, immediately revoke and regenerate it.

🧪 Testing & Code Quality

Before submitting changes, run:

Static Analysis
flutter analyze
Unit and Widget Tests
flutter test
Check Flutter Environment
flutter doctor
🏗️ Building the Application
Android APK

Create a release APK:

flutter build apk --release

The generated APK will be available in:

build/app/outputs/flutter-apk/release/
Android App Bundle

For Google Play Store deployment:

flutter build appbundle --release

The generated App Bundle will be available in:

build/app/outputs/bundle/release/
iOS

For iOS release builds:

flutter build ios --release

iOS builds require macOS and Xcode.

📱 Application Modules

Madinaty is organized into independent feature modules.

features/
│
├── ai_planner/
├── app_section/
├── auth/
├── booking/
├── cafe/
├── cart/
├── checkout/
├── discovery/
├── favorites/
├── home/
├── notifications/
├── onboarding/
├── personalization/
├── pre_order/
├── profile/
└── reviews/

Each feature follows the project's Clean Architecture structure.

🔄 State Management

The application uses BLoC / Cubit for state management.

State management is responsible for handling:

Loading states
Success states
Error states
Empty states
User interactions
Real-time updates

Feature-specific Cubits and BLoCs communicate with the domain layer through use cases.

🧱 Clean Architecture

The application separates responsibilities into three main layers.

Data Layer

The data layer contains:

Models
Remote data sources
Local data sources where required
Repository implementations
Firebase operations
API communication
Domain Layer

The domain layer contains:

Entities
Repository interfaces
Use cases
Business logic
Presentation Layer

The presentation layer contains:

Screens
Widgets
Cubits
BLoCs
UI states
User interactions

This separation makes the application easier to maintain, test, and extend.

🔌 API & External Services

Madinaty communicates with several external services.

Service	Purpose
Firebase Authentication	User authentication
Cloud Firestore	Application database
Google Places	Café discovery
Google Sign-In	Authentication
Google Generative AI	AI Planner
Cloudinary	Profile image storage
Paymob	Payment processing
📍 Location Architecture

The location system provides location-aware café discovery.

User
 │
 ▼
Location Permission
 │
 ▼
Device Location
 │
 ▼
Latitude / Longitude
 │
 ├───────────────┐
 ▼               ▼
Map Services   Café Discovery
 │               │
 └───────┬───────┘
         ▼
    Nearby Cafés
         │
         ▼
   Discovery / Home

Users can also manually select a location to explore cafés in another area.

❤️ Favorites Architecture

The favorites feature follows the application's Clean Architecture.

User Action
     │
     ▼
Favorites Cubit
     │
     ▼
Use Case
     │
     ▼
Repository
     │
     ▼
Data Source
     │
     ▼
Firebase Firestore

The result is then reflected in the UI through the Cubit's state.

📅 Booking Architecture

The booking system coordinates the reservation process.

Booking Screen
      │
      ▼
Booking Cubit
      │
      ▼
Booking Use Cases
      │
      ▼
Booking Repository
      │
      ▼
Firestore
      │
      ▼
Booking Confirmation
      │
      ├───────────────┐
      ▼               ▼
Digital Pass     Notification
      │
      ▼
    QR Code
🛒 Cart & Pre-Order Architecture
Café Menu
    │
    ▼
Product Selection
    │
    ▼
Cart Cubit
    │
    ▼
Cart Repository
    │
    ▼
Checkout
    │
    ▼
Payment Success
    │
    ▼
Pre-Order Creation
    │
    ▼
Booking Association
    │
    ▼
Clear Cart
🔔 Notification Architecture

Notifications are stored under the authenticated user's Firestore document.

users/{uid}/notifications

The notification system supports:

Create notification
Retrieve notifications
Watch notifications
Mark notification as read
Mark all notifications as read
Delete notification

The real-time stream allows the application to update the notification interface when new notifications are created.

👤 Profile Architecture

The profile system allows users to manage their account information.

Profile Screen
      │
      ▼
Profile Cubit
      │
      ▼
Profile Use Case
      │
      ▼
Profile Repository
      │
      ├───────────────┐
      ▼               ▼
  Firestore       Cloudinary
      │               │
      └───────┬───────┘
              ▼
        Updated Profile

Profile images are uploaded to Cloudinary and the resulting image URL is stored with the user's profile data.

🤖 AI Planner Architecture

The AI Planner receives user inputs and generates a personalized experience.

User Input
    │
    ├── Mood
    ├── Occasion
    ├── Interests
    └── Custom Prompt
          │
          ▼
      AI Planner
          │
          ▼
 Google Generative AI
          │
          ▼
   Generated Response
          │
          ▼
   Result Screen
💳 Payment Architecture

The checkout system integrates Paymob into the booking journey.

Checkout
   │
   ▼
Payment Method
   │
   ├── Card
   │
   └── Mobile Wallet
          │
          ▼
     Payment Request
          │
          ▼
        Paymob
          │
          ▼
    Payment WebView
          │
          ▼
    Payment Result
          │
          ├───────────────┐
          ▼               ▼
   Confirm Booking    Create Pre-Order
          │
          ▼
      Clear Cart
          │
          ▼
   Booking Confirmation
🗄️ Firestore Data Model

The application uses Firestore collections to organize application data.

Firestore
│
├── users/
│   └── {uid}/
│       ├── profile data
│       └── notifications/
│
├── cafes/
│
├── products/
│
├── bookings/
│
├── pre_orders/
│
├── favorites/
│
└── reviews/

User-specific notification data is stored under:

users/{uid}/notifications
🔄 Real-Time Features

Firestore real-time listeners are used where live updates are required.

Examples include:

Notifications
Favorites
Cart updates
Booking updates
Pre-order updates
Reviews

This allows the application to react to backend changes without requiring the user to manually refresh the screen.

🌍 Localization

Madinaty supports localized application content.

The application uses:

flutter_localization
localization
flutter_localizations

Arabic interfaces use the Cairo font for improved readability and visual consistency.

🎨 UI Components

The application contains reusable UI components to maintain a consistent design.

Examples include:

Custom buttons
Custom text fields
Café cards
Product cards
Rating widgets
Loading widgets
Empty states
Error states
Skeleton screens
Custom navigation components
📸 Screenshots

Add screenshots of the application here.

Recommended screenshots:

Splash Screen
Onboarding
Login
Home
Discovery
Café Details
AI Planner
Booking
Cart
Checkout
Digital Pass
Notifications
Profile

Example:

## 📸 Screenshots

### Authentication

| Splash | Login | Sign Up |
|---|---|---|
| Screenshot | Screenshot | Screenshot |

### Discovery

| Home | Discovery | Café Details |
|---|---|---|
| Screenshot | Screenshot | Screenshot |

### Booking

| Booking | Checkout | Digital Pass |
|---|---|---|
| Screenshot | Screenshot | Screenshot |

### Account

| Profile | Notifications | Reviews |
|---|---|---|
| Screenshot | Screenshot | Screenshot |
🎥 Demo

Add a video demonstration of Madinaty here.

The recommended demo flow is:

Login
  ↓
Personalization
  ↓
Home
  ↓
Discover Café
  ↓
View Café Details
  ↓
AI Planner
  ↓
Book Table
  ↓
Add Products
  ↓
Checkout
  ↓
Paymob
  ↓
Booking Confirmation
  ↓
Digital Pass
  ↓
Notification
🧪 Testing Checklist

Before creating a release build, verify the following:

 User registration works
 User login works
 Google Sign-In works
 Password reset works
 Personalization is saved
 Café discovery works
 Location permissions work
 Maps load correctly
 Café details load correctly
 Favorites can be added and removed
 Booking can be created
 Seating selection works
 Cart operations work
 Pre-order creation works
 Checkout works
 Payment WebView opens correctly
 Booking confirmation works
 Digital pass is generated
 QR code is displayed
 Notifications are created
 Notifications update in real time
 Notifications can be marked as read
 Notifications can be deleted
 Profile can be updated
 Profile image upload works
 Reviews can be viewed
 Reviews can be submitted
 Localization works
🚀 Future Improvements

Possible future improvements include:

Firebase Cloud Messaging push notifications
Advanced recommendation algorithms
More AI-powered personalization
Café owner dashboard
Admin dashboard
Advanced booking availability management
Order tracking
Loyalty and rewards system
Promotional offers
Advanced analytics
Offline support
Automated integration testing
Improved accessibility
More payment methods
🤝 Contributing

Contributions are welcome.

1. Fork the Repository

Create your own fork of the project.

2. Create a Feature Branch
git checkout -b feature/your-feature
3. Make Your Changes

Implement the required feature or fix.

4. Run Analysis and Tests
flutter analyze
flutter test
5. Commit Your Changes
git add .
git commit -m "feat: add your feature"
6. Push Your Branch
git push origin feature/your-feature
7. Open a Pull Request

Create a Pull Request and describe your changes.

📝 Commit Convention

The project uses conventional commit-style messages.

Examples:

feat: add booking flow
fix: resolve notification issue
refactor: improve home architecture
docs: update README
style: update application UI
chore: update dependencies
test: add booking tests
👥 Team

Madinaty was developed as a collaborative Flutter project.

Name	Role
Mohamed Atef	Flutter Developer
Mohamed Habib	Flutter Developer
Mariam sanad	Flutter Developer
Roaa Hisham	Flutter Developer
📄 License

This project was developed for educational and project demonstration purposes.

Unless otherwise specified, all rights are reserved by the project team.
