# Verdex API Documentation

## Overview
The Verdex API is a RESTful service for plant identification, user management, feedback, notifications, and more. It powers both the mobile app and admin dashboard.

## Authentication
- Uses **Bearer token** (Laravel Sanctum)
- Obtain token via `/login` or `/register`
- Pass `Authorization: Bearer <token>` in headers for protected endpoints

## Error Handling
- All errors return JSON with `error` and `message` fields
- HTTP status codes indicate error type (400, 401, 403, 404, 422, 500)

## Endpoints

### Auth
- `POST /login` — User login
- `POST /register` — User registration
- `POST /logout` — Logout (auth required)

### User
- `GET /user` — Get current user profile
- `PUT /user` — Update profile
- `POST /change-password` — Change password

### Plants
- `GET /plants` — List plants
- `GET /plants/{id}` — Plant details
- `POST /plants` — Create plant (admin)
- `PUT /plants/{id}` — Update plant (admin)
- `DELETE /plants/{id}` — Delete plant (admin)
- `GET /plants/app/all` — All plants for app
- `GET /plants/app/search` — Search plants

### Categories
- `GET /categories` — List categories
- `POST /categories` — Create category (admin)
- `PUT /categories/{id}` — Update category (admin)
- `DELETE /categories/{id}` — Delete category (admin)

### Feedback
- `POST /feedback` — Submit feedback
- `GET /feedback` — List feedback (admin)
- `GET /feedback/{id}` — View feedback (admin)
- `PUT /feedback/{id}/respond` — Admin respond to feedback

### Notifications
- `GET /notifications` — List notifications
- `GET /notifications/unread-count` — Unread notification count
- `PUT /notifications/{id}/read` — Mark as read
- `PUT /notifications/mark-all-read` — Mark all as read
- `DELETE /notifications/{id}` — Delete notification
- `DELETE /notifications` — Clear all notifications

### Favorites
- `GET /favorites` — List favorites
- `POST /favorites` — Add favorite
- `DELETE /favorites/{plant_id}` — Remove favorite

### Activity Log
- `GET /activity-logs` — List activity logs (admin)

## Example Request
```
POST /login
{
  "email": "user@example.com",
  "password": "secret"
}
```

## Example Response
```
{
  "token": "...",
  "user": { ... }
}
```

## Feedback & Notification Endpoints
- **Submit Feedback**: `POST /feedback` (category, rating, message, contact)
- **Admin Respond**: `PUT /feedback/{id}/respond` (comment)
- **User gets notification**: `GET /notifications`
- **Mark as read**: `PUT /notifications/{id}/read`

## Pagination, Filtering, Sorting
- Most list endpoints support `?page=`, `?per_page=`, and resource-specific filters (e.g., `?status=pending`)
- Responses include `meta` with pagination info

## Status Codes
- `200 OK` — Success
- `201 Created` — Resource created
- `204 No Content` — Deleted
- `400 Bad Request` — Invalid input
- `401 Unauthorized` — Not authenticated
- `403 Forbidden` — No permission
- `404 Not Found` — Resource missing
- `422 Unprocessable Entity` — Validation error
- `500 Internal Server Error` — Server error

## Versioning
- Current version: v1 (default)
- Future: Use `/v2/` prefix for breaking changes

## Best Practices
- Always use HTTPS
- Handle errors gracefully
- Use pagination for large lists
- Validate all input
- Keep tokens secure 