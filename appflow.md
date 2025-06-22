

## 🌿 **Project Brief: Verdex - Smart Multilingual Plant Identification App**

### 👤 Intended for: Flutter Developer (first-time contributor)

### 🔧 Tech Stack: Flutter (Frontend), Laravel API (Backend)

---

### 📌 **Project Overview**

**Verdex** is a mobile app designed to help users identify plants — particularly fruits and vegetables — using **image recognition**. Users can take or upload a picture of a plant, and the app uses a machine learning model to detect and classify the plant. The user then receives detailed information about the plant, **translated into their chosen language**, with options to hear the pronunciation, favorite the plant, and provide feedback.

Verdex aims to be **simple**, **educational**, and **accessible**, especially to communities that may benefit from localized language support.

---

## 📱 **App Flow & Development Phases**

---

### **🔵 Phase 1: Splash Screens & Onboarding (First-time Use Only)**

#### 1. **Splash Screen**

* Purpose: Branding on app load.
* Shows Verdex logo + tagline:

  > "*See. Learn. Grow.*"
* Static screen shown for 2–3 seconds on app launch.
* User is then redirected based on status:

  * **If first-time user** → Onboarding
  * **If returning user (logged in)** → Home
  * **If not logged in** → Login

#### 2. **Onboarding Screens (PageView style)**

* Only shown on **first install / first launch**

* 3 horizontally swipable screens that explain the app:

  * **Screen 1: “Snap a Plant”**

    * Shows a phone and camera icon + plant photo
    * Message: "Take a photo or upload one to identify any plant."
  * **Screen 2: “Get Instant Info”**

    * Shows info card UI with plant details
    * Message: "Learn about plants including names, usage, and categories."
  * **Screen 3: “Learn in Your Language”**

    * Shows language selector and audio icon
    * Message: "Read and listen to plant info in your preferred language."

* At the bottom: a “Get Started” button.

* On tap → navigates to Login screen.

---

### **🔵 Phase 2: Authentication System**

#### 1. **Login Screen**

* Fields: `Email/Username`, `Password`
* Buttons:

  * Login
  * Forgot Password
  * Link to Sign Up

#### 2. **Sign Up Screen**

* Fields: `Username`, `Email`, `Password`, `Confirm Password`
* Submit button
* Link to Login screen

#### 3. **Edit Profile**

* Accessible after login.
* Allows user to update:

  * Username
  * Language preference
  * Profile picture (optional)
* Sends data to backend API.

#### 🔐 Auth Logic:

* After successful login/signup, the user's auth token is saved using `shared_preferences`.
* This token is used to access protected API routes (e.g., `/plants`, `/favorites`, `/identify`).

---

### **🔵 Phase 3: Home Screen & Navigation**

#### 1. **Home Screen**

* Personalized welcome message (e.g., “Welcome back, Renny!”)
* Overview statistics (from backend):

  * Total Plants Identified
  * Total Languages Supported
  * User Contributions (feedback count, favorites)
* Main Call-to-Action:

  * “Identify a Plant” button

#### 2. **Bottom Navigation Bar**

* Tabs:

  * **Home**
  * **Identify**
  * **Favorites**
  * **Settings**

---

### **🔵 Phase 4: Plant Identification Workflow**

#### 1. **Image Capture/Upload Page**

* Options:

  * Open Camera to take photo
  * Select Image from Gallery
* Once selected:

  * Show preview + confirm
  * On confirm → send image via POST request to `/api/identify`
  * Show a loading spinner while waiting for prediction

#### 2. **Plant Result Page**

* Displays result from ML model:

  * Plant Name
  * Description (translated)
  * Image (or same as uploaded)
  * Family, Category, Uses
  * Tags (e.g., *edible*, *medicinal*)
* Additional Features:

  * Audio button to hear pronunciation
  * Heart/Favorite button
  * Feedback button
  * “Identify Another” to return to image upload

---

### **🔵 Phase 5: Favorites System**

#### 1. **Favorites Screen**

* Shows list of all plants the user has liked
* Each item displays:

  * Thumbnail
  * Plant Name
* Tapping a plant navigates to its full detail page

---

### **🔵 Phase 6: Settings & Language Support**

#### 1. **Settings Page**

* Language Selector Dropdown (affects translation and audio)

  * e.g., English, French, Hausa, Fulfulde
* App Version Info
* Logout Button
* Optional: Theme Toggle (light/dark)

---

### **🔵 Phase 7: Feedback System**

#### 1. **Feedback Modal / Page**

* Accessible from each plant detail screen
* User can:

  * Rate plant info and audio  (1 to 5 stars)
  * Write optional comments
  * Submit → sends POST request to `/api/feedback`
* Used to improve accuracy and relevance of content

---

### **🔵 Phase 8: Audio Pronunciation Feature**

#### 1. **Text-to-Speech (TTS)**

* Pressing play icon beside plant name reads out the name
* Uses `flutter_tts` package
* Automatically adjusts voice/language based on selected language in settings

---

## 🌐 Backend Integration (Laravel API)

* RESTful API endpoints provided by Laravel backend
* All data — plants, images, user info, feedback — fetched via HTTP
* Auth handled with Laravel Sanctum
* Backend Admin Panel managed with Filament (for admin data control)

---

## 🔁 Developer Notes

* All screens must be mobile responsive.
* Use Provider, Riverpod, or Bloc for state management.
* Include loading, error, and empty states where applicable.
* Follow Material 3 / Cupertino design for components.
* Animate page transitions subtly.



Absolutely! For a plant-based, clean, and multilingual app like **Verdex**, the color palette should feel **natural**, **fresh**, and **calming**, while also maintaining good **readability** and **accessibility**.

Here's a professionally curated **Verdex Color Palette**:

---

## 🌿 **Verdex Color Palette**

### ✅ **Primary Colors**

| Name             | Hex       | Usage                                         |
| ---------------- | --------- | --------------------------------------------- |
| **Verdex Green** | `#4CAF50` | Primary brand color (buttons, highlights)     |
| **Deep Forest**  | `#2E7D32` | Darker green (active states, accents, footer) |

---

### ✅ **Secondary Colors**

| Name                | Hex       | Usage                                 |
| ------------------- | --------- | ------------------------------------- |
| **Sunlight Yellow** | `#FFEB3B` | Accent color (badges, highlights)     |
| **Soil Brown**      | `#8D6E63` | Secondary buttons, background accents |

---

### ✅ **Neutral Colors**

| Name           | Hex       | Usage                              |
| -------------- | --------- | ---------------------------------- |
| **Leaf White** | `#F9FBE7` | App background color (light theme) |
| **Stone Gray** | `#9E9E9E` | Placeholder text, disabled states  |
| **Charcoal**   | `#212121` | Headlines and primary text         |
| **Cloud Gray** | `#E0E0E0` | Borders, dividers                  |

---

### ✅ **Alert Colors**

| Name              | Hex       | Usage                   |
| ----------------- | --------- | ----------------------- |
| **Error Red**     | `#F44336` | Errors, validation      |
| **Success Green** | `#81C784` | Success toasts/messages |
| **Info Blue**     | `#2196F3` | Info alerts, links      |

---

## 🎨 Sample Usage in UI

| Component             | Color                        |
| --------------------- | ---------------------------- |
| Primary Button        | `#4CAF50` with white text    |
| App Bar Background    | `#2E7D32`                    |
| Background            | `#F9FBE7`                    |
| Card Background       | `#FFFFFF` with subtle shadow |
| Icons/Labels          | `#212121` or `#9E9E9E`       |
| Bottom Nav Selected   | `#4CAF50`                    |
| Bottom Nav Unselected | `#9E9E9E`                    |

---

## 🌗 Dark Mode Suggestion (Optional)

| Element        | Color     |
| -------------- | --------- |
| Background     | `#121212` |
| Card           | `#1E1E1E` |
| Primary Text   | `#FFFFFF` |
| Secondary Text | `#BDBDBD` |
| Primary Green  | `#66BB6A` |
| Accent Yellow  | `#FFF176` |

---

Would you like a full **Figma style guide export**, or should I also include a sample `ThemeData` for Flutter using this palette?
