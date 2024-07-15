import 'package:flutter/material.dart';
import 'package:premier/generated/assets.dart';
import 'package:premier/src/styles/app_colors.dart';
import 'package:premier/src/styles/text_theme.dart';

class TextOnImage extends StatelessWidget {
  const TextOnImage({
    required this.text,
  });
  final String text;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(50), topRight: Radius.circular(50), bottomLeft: Radius.circular(50)),
      ),
      height: 100,
      width: 100,
      child: Center(
        child: Stack(
          children: [
            Image.asset(Assets.imagesStore,),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                padding: EdgeInsets.all(5),
                child: Center(
                  child: Text(
                    text,
                    style: TextStyling.extraLargeBold.copyWith(color: AppColors.white, fontSize: 36),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}