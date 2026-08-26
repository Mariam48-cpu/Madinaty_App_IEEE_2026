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
