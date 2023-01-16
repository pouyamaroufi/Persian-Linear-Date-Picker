[![pub package](https://img.shields.io/pub/v/persian.svg)](https://pub.dartlang.org/packages/persian_linear_date_picker)

Utilities and Humanizer for Persian language and culture.

## Features
* Linear Date Picker.
* Customizable Labels.
* Convert PersianDate to Gregorian numbers.
* Can be used in Dart and Flutter projects.
* Supports all mobile platforms (Android, iOS).
* Include Example Project.


## Getting Started

In your `pubspec.yaml` file add:

```dart
dependencies:
  persian_linear_date_picker: any
```

## Usage

Import the package:

```dart
import 'package:persian_linear_date_picker/persian_linear_date_picker.dart';
```

Then, use the extension methods:

```dart
PersianLinearDatePicker(
              endDate: '1405/12/29',
              initialDate: "1401/10/26",
              startDate: "1300/01/01",
              dateChangeListener: (String selectedDate) {
                print(selectedDate);
              },
              showMonthName: true,
              columnWidth: 90,
              labelStyle:
                  const TextStyle(fontFamily: 'IS_B', color: Colors.blue),
              selectedRowStyle: const TextStyle(fontFamily: 'IS_B'),
              unselectedRowStyle: const TextStyle(fontFamily: 'IS_UL'),
              isPersian: true,
            ), 
```


```dart
PersianLinearDatePicker(
              yearText: 'Year',
              monthText: 'Month',
              dayText: 'Day',
              endDate: '2025/11/20',
              initialDate: "2023/05/17",
              startDate: "1980/04/10",
              dateChangeListener: (String selectedDate) {
                print(selectedDate);
              },
              showMonthName: true,
              columnWidth: 90,
              labelStyle:
                  const TextStyle(fontFamily: 'DIN', color: Colors.blue),
              selectedRowStyle: const TextStyle(
                  fontFamily: 'DIN', fontWeight: FontWeight.bold),
              unselectedRowStyle: const TextStyle(fontFamily: 'DIN'),
              isPersian: false,
            ),
```
