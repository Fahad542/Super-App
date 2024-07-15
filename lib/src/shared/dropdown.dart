import 'package:flutter/material.dart';

class MyDropdownButton extends StatefulWidget {
  final Function(int) onMonthSelected;
  final Key? key;

  MyDropdownButton({required this.onMonthSelected, this.key}) : super(key: key);

  @override
  _MyDropdownButtonState createState() => _MyDropdownButtonState();
}

class _MyDropdownButtonState extends State<MyDropdownButton> {
  List<String> month = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];
  int selectedMonthIndex = 1; // Start from January (index 1)

  @override
  Widget build(BuildContext context) {
    return DropdownButton<int>(
      key: widget.key,
      value: selectedMonthIndex,
      onChanged: (int? newIndex) {
        if (newIndex != null) {
          setState(() {
            selectedMonthIndex = newIndex;

            widget.onMonthSelected(selectedMonthIndex);
          });
        }
      },
      items: List.generate(month.length, (index) {
        return DropdownMenuItem<int>(
          value: index + 1,
          // Adjust the value to start from 1
          child: Text(month[index]), // Display individual month string
        );
      }),
    );
  }
}




class Dropdownyear extends StatefulWidget {
  final Function(String) Selectedyear;

  Dropdownyear({required this.Selectedyear});

  @override
  _DropdownyearState createState() => _DropdownyearState();
}

class _DropdownyearState extends State<Dropdownyear> {
  String selectedYear="2023";

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: selectedYear,
      onChanged: (String? newValue) {
        setState(() {
          selectedYear = newValue!;
          widget.Selectedyear(selectedYear!);
        });
      },
      items: <String>[
        '2023',
        '2024',
        '2025',
        '2026',
        '2027',
        '2028',
        '2029',
        '2030',
        '2031',
        '2032',
        '2033',
        '2034',
        '2035', // Corrected the duplicate entry
      ].map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}












