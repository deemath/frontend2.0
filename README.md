# frontend

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.



## Component Interaction:

- home_screen.dart uses styles from theme.dart
- home_screen.dart displays data from post_model.dart
- spotify_service.dart fetches data for post_model.dart
- All components can access theme styles using Theme.of(context)



## Data Fetching Flow:
 User opens Home Screen
   ↓
   Screen initializes (loading state)
   ↓
   API Service makes request to backend
   ↓
   Backend returns post data
   ↓
   Data is converted to Post models
   ↓
   Posts list is updated
   ↓
   Loading state ends
   ↓
   Posts are displayed in list
