# Frontend Application Structure

This directory contains the main Flutter application code organized in a clean architecture pattern.

## Directory Structure

### 1. presentation/
Contains all UI-related code following the presentation layer pattern.
- **screens/**: Full screens/pages of the application
- **widgets/**: Reusable UI components used across different screens
A HomeScreen that displays a welcome message, or a CustomButton widget that can be reused throughout the app



### 2. data/
Handles all data-related operations following the data layer pattern.
- **models/**: Data model classes representing application data structures  (like User model with id, name, email)
- **repositories/**: Repository classes handling data operations and business logic
- **services/**: Service classes for external API calls and data fetching

### 3. core/
Contains core functionality and utilities used throughout the app.
- **utils/**: Utility functions and helper classes
- **constants/**: Constant values, configurations, and app-wide settings
Date formatting utilities or app-wide constants like API URLs

### 4. main.dart
The entry point of the Flutter application that:
- Initializes the Flutter application
- Sets up the MaterialApp widget
- Configures the initial route
- Imports necessary dependencies

## Architecture
The application follows a clean architecture pattern with clear separation of concerns:
- Presentation Layer (UI)
- Data Layer (Business Logic)
- Core Layer (Utilities and Constants)

This structure promotes:
- Maintainability
- Testability
- Scalability
- Code reusability 


The architecture follows a clear flow:
1. UI components in the presentation layer make requests
2. These requests go through repositories in the data layer
3. Repositories use services to fetch data from external sources
4. The data is transformed into models and sent back to the UI