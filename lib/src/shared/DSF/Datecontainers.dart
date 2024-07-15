import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:premier/src/styles/app_colors.dart';

class DateContainer extends StatefulWidget {
  final String title;
  final String range;
  final Function(DateTime) onDateSelected;
  DateTime? selectedDate;


  DateContainer({
    Key? key,
    required this.title,
    required this.range,
    required this.selectedDate,

    required this.onDateSelected,
  }) : super(key: key);

  @override
  _DateContainerState createState() => _DateContainerState();
}

class _DateContainerState extends State<DateContainer> {
  //DateTime? selectedDate;

  @override
  Widget build(BuildContext context) {
    return  Container(
        margin: EdgeInsets.only(left: 10, right: 10),
        child: GestureDetector(
            onTap: () async {
              final DateTime? picked = await showDatePicker(
                context: context,
                initialDate: widget.selectedDate ?? DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime.now(),
                builder: (BuildContext context, Widget? child) {
                  return Theme(
                    data: ThemeData.light().copyWith(
                      primaryColor: AppColors.primary, // Set your desired color here
                      accentColor: AppColors.primary,
                      colorScheme: ColorScheme.light(primary: AppColors.primary),
                      buttonTheme: ButtonThemeData(
                          textTheme: ButtonTextTheme.primary),
                    ),
                    child: child!,
                  );
                },
              );

              if (picked != null && picked != widget.selectedDate) {
                setState(() {
                  widget.selectedDate = picked;
                  widget.onDateSelected?.call(picked);
                });
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 60,
                width: 150,
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black38,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        widget.title,
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        widget.selectedDate != null
                            ? DateFormat('yyyy-MM-dd').format(widget.selectedDate!)
                            : widget.range,
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

    );

  }
}