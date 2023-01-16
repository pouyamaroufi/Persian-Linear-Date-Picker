// ignore_for_file: avoid_print
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:persian_linear_date_picker/persian_linear_date_picker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      locale: const Locale('fa'),
      supportedLocales: const [
        Locale('fa'),
      ],
      debugShowCheckedModeBanner: false,
      title: 'Persian Liner Date Picker',
      theme: ThemeData(
        fontFamily: 'IS',
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'انتخاب تاریخ شمسی و میلادی'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var pickedDate = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            clipBehavior: Clip.hardEdge,
            margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: Colors.blueAccent[100]!.withOpacity(0.2),
                  spreadRadius: 0,
                  blurRadius: 15,
                  offset: const Offset(0, 0),
                ),
              ],
            ),
            child: PersianLinearDatePicker(
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
          ),
          Container(
            clipBehavior: Clip.hardEdge,
            margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: Colors.blueAccent[100]!.withOpacity(0.2),
                  spreadRadius: 0,
                  blurRadius: 15,
                  offset: const Offset(0, 0),
                ),
              ],
            ),
            child: PersianLinearDatePicker(
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
          ),
        ],
      ),
    );
  }
}
