## Smart Multilingual Plant Identification System - VERDEX

### 1. System Overview

A mobile-first application for identifying plant species using an on-device ML model and delivering information in multiple languages. It comprises a **Flutter** frontend and a **Laravel** backend (with Filament Admin) for data management.

**Key Features:**

* User Authentication: Sign up, login, profile management (username, email, password, avatar, language preference).
* Plant Identification: Capture photo via camera or upload from gallery, run on-device classification (MobileNetV3 `.tflite`), display results.
* Multilingual Content: Core plant data stored in database; localized common names, descriptions, and audio fetched from JSON translation files.
* Favorites: Users can like/save plants.
* Feedback: Users submit correctness feedback and comments.
* Statistics Dashboard: Home screen shows total plants, favorites count, identification attempts.
* Audio Playback: Play prerecorded plant names in selected language.
* Admin Panel: Manage plants, audio files, user feedback, favorites via Filament Admin.

### 2. Technical Architecture

```
[Flutter App] <--> [Laravel API + Sanctum] <--> [MySQL Database]
                                   |
                                   --> [Storage: images, audio, translation JSON]
```

### 3. Backend Schema (MySQL)

#### 3.1 plants

| Column           | Type             | Description                         |
| ---------------- | ---------------- | ----------------------------------- |
| id               | BigIncrements    | Primary key                         |
| slug             | String (unique)  | Translation JSON lookup key         |
| scientific\_name | String           | Latin binomial                      |
| family           | String, nullable | Taxonomic family                    |
| genus            | String, nullable | Genus                               |
| species          | String, nullable | Species epithet                     |
| origin           | String, nullable | Geographic origin                   |
| image\_urls      | JSON             | Array of image URLs                 |
| habitat          | String, nullable | Natural habitat description         |
| uses             | JSON, nullable   | Array of uses (e.g. \["Medicinal"]) |
| toxicity\_level  | String, nullable | e.g., "Non-toxic"                   |
| created\_at      | Timestamp        |                                     |
| updated\_at      | Timestamp        |                                     |

#### 3.2 users

| Column               | Type             | Description                 |
| -------------------- | ---------------- | --------------------------- |
| id                   | BigIncrements    | Primary key                 |
| username             | String, unique   |                             |
| email                | String, unique   |                             |
| password             | String           | Hashed                      |
| language\_preference | String           | ISO code (e.g., "en")       |
| avatar               | String, nullable | URL or path to avatar image |
| created\_at          | Timestamp        |                             |
| updated\_at          | Timestamp        |                             |

#### 3.3 favorites

| Column      | Type                 | Description |
| ----------- | -------------------- | ----------- |
| id          | BigIncrements        | Primary key |
| user\_id    | ForeignKey users.id  |             |
| plant\_id   | ForeignKey plants.id |             |
| created\_at | Timestamp            |             |
| updated\_at | Timestamp            |             |

#### 3.4 feedback

| Column      | Type                          | Description                   |
| ----------- | ----------------------------- | ----------------------------- |
| id          | BigIncrements                 | Primary key                   |
| user\_id    | ForeignKey users.id, nullable | User or null                  |
| plant\_id   | ForeignKey plants.id          |                               |
| is\_correct | Boolean                       | User indicated correct or not |
| comment     | Text, nullable                | Optional user comment         |
| created\_at | Timestamp                     |                               |
| updated\_at | Timestamp                     |                               |

#### 3.5 audio\_files

| Column      | Type                 | Description                       |
| ----------- | -------------------- | --------------------------------- |
| id          | BigIncrements        | Primary key                       |
| plant\_id   | ForeignKey plants.id |                                   |
| language    | String               | ISO code (e.g., "en", "fr")       |
| audio\_url  | String               | URL or storage path to audio file |
| created\_at | Timestamp            |                                   |
| updated\_at | Timestamp            |                                   |

### 4. Translation Files

Stored under `resources/lang/{locale}/plants.json`:

```json
{
  "plants": {
    "neem": { "common_name": "Neem Tree", "description": "Medicinal tree.", "audio": "audio/neem-en.mp3" },
    "hibiscus-rosa-sinensis": { "common_name": "Hibiscus", "description": "Colorful flower.", "audio": "audio/hibiscus-en.mp3" }
  }
}
```

### 5. API Endpoints

| Method | Endpoint                   | Description                                   |
| ------ | -------------------------- | --------------------------------------------- |
| POST   | /api/register              | User signup                                   |
| POST   | /api/login                 | User login (returns token)                    |
| GET    | /api/user                  | Get authenticated user                        |
| PUT    | /api/user                  | Update profile                                |
| GET    | /api/plants                | List all plants                               |
| GET    | /api/plants/{slug}?lang=en | Get plant details + translation               |
| POST   | /api/favorites             | Add to favorites                              |
| GET    | /api/favorites             | List user favorites                           |
| POST   | /api/feedback              | Submit user feedback                          |
| GET    | /api/stats                 | System statistics (total plants, users, etc.) |

### 6. Flutter App Structure

```
/lib
  /models
    plant.dart, user.dart, feedback.dart
  /services
    api_service.dart, tflite_service.dart, audio_service.dart
  /screens
    login.dart, signup.dart, home.dart, plant_detail.dart, favorites.dart
  /widgets
    plant_card.dart, stats_dashboard.dart, language_selector.dart
  /utils
    constants.dart, localization.dart
/assets
  /audio/en/, /audio/fr/
```

### 7. ML Integration

* Include `plant_model.tflite` in `assets/models/`
* Use `tflite_flutter` to load and run inference in `TFLiteService`

### 8. UX/UI Notes

* **Modern card-based** UI with subtle shadows and rounded corners
* **Fast transitions** via Flutter’s `Hero` and `AnimatedContainer`
* **Dark/Light mode** support
* **Language switcher** persistent in app bar

---

This schema and description should give you a complete view to start implementation. Let me know if you need adjustments or further details in any section!
