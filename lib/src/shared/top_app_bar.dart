import 'package:flutter/material.dart';
import 'package:premier/src/services/local/navigation_service.dart';
import 'package:premier/src/styles/app_colors.dart';
import 'package:premier/src/styles/text_theme.dart';

class DashboardAppBar extends PreferredSize {
  final String name;
  final String image;

  DashboardAppBar({
    Key? key,
    required this.name,
    required this.image,
  }) : super(preferredSize: Size.fromHeight(80), child: SizedBox.shrink());

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: AppColors.primary),
      height: 80,
      padding: EdgeInsets.only(top: 0, bottom: 0, left: 20, right: 20),
      margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Text(
                    "Salam,",
                    style: TextStyling.mediumRegular
                        .copyWith(color: AppColors.white),
                  ),
                ],
              ),
              Text(
                name.toUpperCase(),
                style: TextStyling.largeBold.copyWith(color: AppColors.white),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class MainAppBar extends PreferredSize {
  final String title;

  MainAppBar({
    required this.title,
    Key? key,
  }) : super(preferredSize: Size.fromHeight(80), child: SizedBox.shrink());

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: AppColors.white),
      height: 80,
      padding: EdgeInsets.only(top: 0, bottom: 0, left: 20, right: 20),
      margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          InkWell(
            splashColor: Colors.transparent,
              onTap: (){
                Scaffold.of(context).openDrawer();
              },
              child: Icon(
            Icons.menu,
            color: AppColors.primary,
            size: 24,
          )),
          Text(
            title,
            style: TextStyling.largeBold.copyWith(color: AppColors.primary),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          InkWell(
              splashColor: Colors.transparent,
              onTap: (){
                NavService.dashboard();
              },
              child: Icon(
                Icons.home_filled,
                color: AppColors.primary,
                size: 24,
              )),
        ],
      ),
    );
  }
}
