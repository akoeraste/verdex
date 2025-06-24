# Project Workflow & Database Schema (Verdex)

## 1. Project Workflow

### 1.1. Planning & Analysis
- Review existing codebase and migrations.
- Identify gaps between current schema and project requirements.
- Plan incremental migration updates (no destructive changes).

### 1.2. Backend Development
- Adapt existing migrations to match the required schema (add columns, new tables, but do not delete existing ones).
- Implement/adjust Eloquent models for all entities.
- Build RESTful API endpoints for all features (auth, plants, favorites, feedback, audio, stats, etc.).
- Integrate localization (translation JSONs, audio files).
- Set up media storage for images/audio.
- Implement admin panel features (CRUD, roles, permissions, activity log).
- Write backend tests.

### 1.3. Frontend Development (Flutter)
- Implement authentication and profile management.
- Integrate TFLite model for plant identification.
- Build plant library, details, favorites, feedback, and stats screens.
- Integrate localization (text/audio).
- Polish UI/UX (modern, responsive, dark/light mode).
- Write frontend tests.

### 1.4. ML Integration
- Place TFLite model in assets.
- Implement Dart service for inference.
- Map predictions to plant slugs.

### 1.5. Deployment & Maintenance
- Deploy backend (API, storage).
- Release Flutter app (Android/iOS/web).
- Monitor feedback and usage.
- Update docs as needed.

---

## 2. Database Schema (Finalized)

### 2.1. users
| Column               | Type             | Description                 |
|----------------------|------------------|-----------------------------|
| id                   | BigIncrements    | Primary key                 |
| username             | String, unique   |                             |
| email                | String, unique   |                             |
| password             | String           | Hashed                      |
| language_preference  | String           | ISO code (e.g., "en")       |
| avatar               | String, nullable | URL/path to avatar image    |
| created_at           | Timestamp        |                             |
| updated_at           | Timestamp        |                             |

### 2.2. plants
| Column           | Type             | Description                         |
|------------------|------------------|-------------------------------------|
| id               | BigIncrements    | Primary key                         |
| slug             | String, unique   | Translation JSON lookup key         |
| scientific_name  | String           | Latin binomial                      |
| family           | String, nullable | Taxonomic family                    |
| genus            | String, nullable | Genus                               |
| species          | String, nullable | Species epithet                     |
| origin           | String, nullable | Geographic origin                   |
| image_urls       | JSON             | Array of image URLs                 |
| habitat          | String, nullable | Natural habitat description         |
| uses             | JSON, nullable   | Array of uses (e.g. ["Medicinal"]) |
| toxicity_level   | String, nullable | e.g., "Non-toxic"                   |
| created_at       | Timestamp        |                                     |
| updated_at       | Timestamp        |                                     |

### 2.3. favorites
| Column      | Type                 | Description |
|-------------|----------------------|-------------|
| id          | BigIncrements        | Primary key |
| user_id     | ForeignKey users.id  |             |
| plant_id    | ForeignKey plants.id |             |
| created_at  | Timestamp            |             |
| updated_at  | Timestamp            |             |

### 2.4. feedback
| Column      | Type                          | Description                   |
|-------------|-------------------------------|-------------------------------|
| id          | BigIncrements                 | Primary key                   |
| user_id     | ForeignKey users.id, nullable | User or null                  |
| plant_id    | ForeignKey plants.id          |                               |
| is_correct  | Boolean                       | User indicated correct or not |
| comment     | Text, nullable                | Optional user comment         |
| created_at  | Timestamp                     |                               |
| updated_at  | Timestamp                     |                               |

### 2.5. audio_files
| Column      | Type                 | Description                       |
|-------------|----------------------|-----------------------------------|
| id          | BigIncrements        | Primary key                       |
| plant_id    | ForeignKey plants.id |                                   |
| language    | String               | ISO code (e.g., "en", "fr")       |
| audio_url   | String               | URL/path to audio file            |
| created_at  | Timestamp            |                                   |
| updated_at  | Timestamp            |                                   |

### 2.6. password_resets
| Column      | Type    | Description |
|-------------|---------|-------------|
| email       | String  |             |
| token       | String  |             |
| created_at  | Timestamp |           |

### 2.7. jobs
| Column        | Type         | Description |
|---------------|-------------|-------------|
| id            | BigIncrements| Primary key |
| queue         | String       |             |
| payload       | LongText     |             |
| attempts      | TinyInteger  |             |
| reserved_at   | Integer      |             |
| available_at  | Integer      |             |
| created_at    | Integer      |             |

### 2.8. failed_jobs
| Column      | Type      | Description |
|-------------|-----------|-------------|
| id          | BigIncrements | Primary key |
| uuid        | String    | Unique      |
| connection  | Text      |             |
| queue       | Text      |             |
| payload     | LongText  |             |
| exception   | LongText  |             |
| failed_at   | Timestamp |             |

### 2.9. personal_access_tokens
| Column         | Type      | Description |
|----------------|----------|-------------|
| id             | BigIncrements | Primary key |
| tokenable_type | String   |             |
| tokenable_id   | BigInt   |             |
| name           | String   |             |
| token          | String   | Unique      |
| abilities      | Text     | Nullable    |
| last_used_at   | Timestamp| Nullable    |
| expires_at     | Timestamp| Nullable    |
| created_at     | Timestamp|             |
| updated_at     | Timestamp|             |

### 2.10. sessions
| Column      | Type      | Description |
|-------------|-----------|-------------|
| id          | String    | Primary key |
| user_id     | ForeignKey users.id | Nullable |
| ip_address  | String    | Nullable    |
| user_agent  | Text      | Nullable    |
| payload     | LongText  |             |
| last_activity | Integer |             |

### 2.11. activity_log
| Column        | Type      | Description |
|---------------|-----------|-------------|
| id            | BigIncrements | Primary key |
| log_name      | String    | Nullable    |
| description   | Text      |             |
| subject_type  | String    | Nullable    |
| subject_id    | BigInt    | Nullable    |
| causer_type   | String    | Nullable    |
| causer_id     | BigInt    | Nullable    |
| properties    | JSON      | Nullable    |
| batch_uuid    | UUID      | Nullable    |
| event         | String    | Nullable    |
| created_at    | Timestamp |             |
| updated_at    | Timestamp |             |

### 2.12. media
| Column            | Type      | Description |
|-------------------|-----------|-------------|
| id                | BigIncrements | Primary key |
| model_type        | String    |             |
| model_id          | BigInt    |             |
| uuid              | UUID      | Nullable, Unique |
| collection_name   | String    |             |
| name              | String    |             |
| file_name         | String    |             |
| mime_type         | String    | Nullable    |
| disk              | String    |             |
| conversions_disk  | String    | Nullable    |
| size              | BigInt    |             |
| manipulations     | JSON      |             |
| custom_properties | JSON      |             |
| generated_conversions | JSON  |             |
| responsive_images | JSON      |             |
| order_column      | Integer   | Nullable, Indexed |
| created_at        | Timestamp | Nullable    |
| updated_at        | Timestamp | Nullable    |

### 2.13. permissions/roles (spatie/laravel-permission)
- permissions
- roles
- model_has_permissions
- model_has_roles
- role_has_permissions

---

## 3. Additional Tables Needed
- **favorites**: For user-plant favorites (if not present)
- **feedback**: For user feedback on plant identification
- **audio_files**: For storing plant name audio in multiple languages
- **plants**: If not already present, with all required columns

---

## 4. Migration Strategy
- **Do not delete existing tables.**
- Add missing columns/tables as new migrations.
- Update Eloquent models to match the new schema.
- Write data migration scripts if needed for legacy data.

---

## 5. Documentation & Communication
- Keep `docs/info.md` and `docs/workflow.md` up to date.
- Document all schema changes and API updates.
- Communicate major changes to the team before applying migrations. 