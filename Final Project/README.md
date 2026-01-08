# A & H Hotels Management System

A comprehensive hotel management system built with Flutter and Supabase.

## Features

- **Admin Panel**: Manage hotels, bookings, orders, and customer data
- **Customer App**: Book rooms, parking, and order from cafeteria
- **Multiple Hotels**: 5 hotels across major Pakistani cities
- **Room Types**: VIP, Business, and Economy rooms
- **Cafeteria**: Wide variety of Pakistani foods and drinks
- **Customer Service**: Contact support for each hotel

## Setup

1. Clone the repository
2. Run `flutter pub get`
3. Set up Supabase:
   - Create a new Supabase project
   - Update the URL and anon key in `lib/services/supabase_service.dart`
   - Create the necessary tables (hotels, bookings, orders, etc.)
4. Run `flutter pub run flutter_launcher_icons` to generate app icons
5. Run the app: `flutter run`

## Project Structure

- `lib/models/`: Data models
- `lib/views/`: UI screens
- `lib/controllers/`: Business logic
- `lib/services/`: API services
- `lib/utils/`: Utilities and constants

## Technologies Used

- Flutter
- Supabase
- Provider (State Management)
- Flutter Animate (Animations)
