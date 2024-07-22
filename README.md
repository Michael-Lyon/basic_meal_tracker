# Meal Tracker

Meal Tracker is a Flutter application that allows you to log meals and track food consumption over time. It is designed to help identify any correlations between food intake and health issues, such as stomach pain. The app supports adding, editing, and deleting meal entries, as well as filtering meals by date and viewing a bar chart of food consumption.

## Features

- Log meals with food name, date, and optional notes
- Edit existing meal entries
- Delete meal entries
- Filter meals by date range
- View a bar chart of food consumption over time
- User-friendly interface with icons and elevation


## Installation

1. Ensure you have Flutter installed on your machine. If not, follow the official installation guide [here](https://flutter.dev/docs/get-started/install).
2. Clone this repository:
   ```sh
   git clone https://github.com/Michael-Lyon/basic_meal_tracker.git
   ```
3. Navigate to the project directory:
   ```sh
   cd basic_meal_tracker
   ```
4. Install dependencies:
   ```sh
   flutter pub get
   ```
5. Run the application:
   ```sh
   flutter run
   ```

## Dependencies

- `provider`: ^6.0.0
- `sqflite`: ^2.0.0+4
- `path`: ^1.8.0
- `fl_chart`: ^0.36.0
- `intl`: ^0.17.0

## Project Structure

```
lib
├── db_helper.dart
├── main.dart
├── meal.dart
├── meal_provider.dart
```

- `db_helper.dart`: Contains the SQLite database helper functions.
- `main.dart`: The main entry point of the application.
- `meal.dart`: Defines the `Meal` model.
- `meal_provider.dart`: Contains the provider for managing meal state.
- `screens/`: Contains the different screens of the application.

## Usage

1. Open the app and view the list of meals.
2. To add a meal, click the floating action button with the plus icon.
3. Fill in the food name, date, and optional notes, then click "Add Meal".
4. To edit a meal, click the edit icon next to the meal entry, update the details, and click "Update Meal".
5. To delete a meal, click the delete icon next to the meal entry.
6. To filter meals by date range, click the filter icon in the app bar, select the date range, and click "OK".
7. To view the bar chart of food consumption, click the bar chart icon in the app bar.

## Contributing

Contributions are welcome! Please open an issue or submit a pull request for any changes or improvements.
