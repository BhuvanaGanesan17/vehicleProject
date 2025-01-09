# vehicle

A new Flutter project.

## Getting Started

This project is a Flutter-based application for booking vehicles with a
dynamic form flow. The app features one question per screen, 
implemented with Bloc for state management, SQLite for offline persistence, and RESTful API integration.


## Features
- **One Question Per Screen**: Navigate through individual screens for each form question.
- **Dynamic Data**: Options fetched dynamically via RESTful APIs.
- **Offline Support**: Save intermediate form data using SQLite.
- **User-Friendly UI**: Material Design with validation and error messages for invalid inputs.

---
## Screens
1. **Name Screen**:
    - Collects the user's first and last name.
    - Validates non-empty inputs.

2. **Number of Wheels Screen**:
    - Displays radio button options for selecting the number of wheels.
    - Data is dynamically fetched from the API.
    -Validates non-empty inputs.

3. **Vehicle Type Screen**:
    - Displays radio button options for selecting vehicle types (e.g., truck,car, bike).
    - Options are fetched dynamically from the API.
    - Validates  inputs.

4. **Specific Model Screen**:
    - Displays radio buttons for vehicle models, including names and images.
    - Models are fetched based on the selected vehicle type.
    - Validates non-empty inputs.

5. **Date Range for Booking**:
    - Includes a date range picker for selecting rental dates.
    - Blocks unavailable dates using data from the API.
    - Validates non-empty inputs.

---

## Tech Stack
- **Frontend**: Flutter (Material Design)
- **State Management**: Bloc
- **Database**: SQLite for offline persistence
- **API Integration**: RESTful APIs for dynamic data fetching and form submission

---


