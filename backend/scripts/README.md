# Utility Scripts

This directory contains utility scripts for managing and maintaining the Verdex plant database.

## Scripts

### `check_plants.php`
A diagnostic script that:
- Lists all plants in the database
- Shows their image URLs
- Displays available storage folders
- Helps identify data inconsistencies

**Usage:**
```bash
php scripts/check_plants.php
```

### `fix_plant_images.php`
A maintenance script that:
- Fixes broken plant image URLs
- Reassigns images from available storage folders
- Updates the database with correct image paths
- Handles both string and array image URL formats

**Usage:**
```bash
php scripts/fix_plant_images.php
```

## Running Scripts

These scripts should be run from the backend root directory:

```bash
cd backend
php scripts/check_plants.php
php scripts/fix_plant_images.php
```

## Notes

- These scripts bootstrap the Laravel application to access models and database
- They require the Laravel environment to be properly configured
- Always backup your database before running maintenance scripts
- These scripts are for development/maintenance purposes only 