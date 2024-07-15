import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:premier/generated/assets.dart';
import 'package:premier/src/styles/app_colors.dart';
import 'package:premier/src/styles/text_theme.dart';

class DashboardItemCard extends StatelessWidget {
  final String title;
  final String icon;
  final Function onTap;
  final Function onUpcomingTap;
  final bool isActive;

  const DashboardItemCard({
    Key? key,
    required this.title,
    required this.icon,
    required this.onTap,
    required this.isActive,
    required this.onUpcomingTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      onTap: () {
        if (isActive)
          onTap();
        else
          onUpcomingTap();
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.1),
              blurRadius: 9,
              spreadRadius: 1,
              blurStyle: BlurStyle.solid,
              offset: Offset(0, 0),
            )
          ],
          color: AppColors.white,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
              height: 62,
              width: 62,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                  child: Center(
                    child: Image.network(
                      icon,
                      height: 36,
                      width: 36,
                    ),
                  ),
                ),
              ),
            ),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyling.smallBold.copyWith(color: AppColors.primary),
            ),
          ],
        ),
      )
    );
  }
}
