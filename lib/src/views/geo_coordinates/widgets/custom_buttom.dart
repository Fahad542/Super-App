import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../styles/app_colors.dart';

class custombuttom extends StatefulWidget {
  final String? title;
  final VoidCallback? onTap;
  const custombuttom({Key? key, required this.title, required this.onTap}) : super(key: key);

  @override
  State<custombuttom> createState() => _custombuttomState();
}

class _custombuttomState extends State<custombuttom> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: Container(
        padding: EdgeInsets.all(6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: AppColors.primary,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3), // changes the shadow position
            ),
          ],
        ),
        child: Text(
          widget.title.toString(),
          style: TextStyle(color: Colors.white, fontSize: 11),
        ),
      ),
    );

  }
}



class latlong extends StatefulWidget {
  final String? title;
  final VoidCallback? onTap;
  const latlong({Key? key, required this.title, required this.onTap}) : super(key: key);

  @override
  State<latlong> createState() => _latlongbuttomState();
}

class _latlongbuttomState extends State<latlong> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: Container(
        padding: EdgeInsets.all(4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          color: AppColors.red,
          boxShadow: [
            BoxShadow(
              color: Colors.red.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 9,
              offset: Offset(0, 2), // changes the shadow position
            ),
          ],
        ),
        child: Text(
          widget.title.toString(),
          style: TextStyle(color: Colors.white, fontSize: 10),
        ),
      ),
    );

  }
}
