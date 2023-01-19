[![pub package](https://img.shields.io/pub/v/persian_linear_date_picker.svg)](https://pub.dartlang.org/packages/persian_linear_date_picker)
[![pub package](https://img.shields.io/badge/platform-flutter-blue.svg)](https://github.com/pouyamaroufi/persian_linear_date_picker)

Shamsi Linear Date Picker for Persian language and culture.

<p align="center">
<img src="https://raw.githubusercontent.com/pouyamaroufi/Persian-Linear-Date-Picker/master/example/assets/cover/pouyamaroufi-lpdp-cover.png" alt="package cover" width='350px' aligment='center'>
</p>

## Features
* Linear Date Picker.
* Customizable Labels.
* Convert PersianDate to Gregorian numbers.
* Can be used in Dart and Flutter projects.
* Supports all platforms (Android, iOS, Windows, Linux, Mac).
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
