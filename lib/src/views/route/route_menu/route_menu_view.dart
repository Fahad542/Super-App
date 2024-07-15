import 'package:flutter/material.dart';
import 'package:premier/generated/assets.dart';
import 'package:premier/src/base/utils/utils.dart';
import 'package:premier/src/shared/spacing.dart';
import 'package:premier/src/styles/app_colors.dart';
import 'package:premier/src/styles/text_theme.dart';
import 'package:premier/src/views/dsf/dsf_menu/dsf_menu_view_model.dart';
import 'package:stacked/stacked.dart';

class DSFMenuView extends StatelessWidget {
  const DSFMenuView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<DSFMenuViewModel>.reactive(
      builder: (context, model, child) {
        return SizedBox(
          width: context.screenSize().width,
          child: Scaffold(
            extendBodyBehindAppBar: true,
            body: SafeArea(
              child: Stack(
                children: [
                  Container(
                    height: context.screenSize().height,
                  ),
                  SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.fromLTRB(20, 50, 20, 50),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [AppColors.secondary, AppColors.white],
                            ),
                          ),
                          child: Image.asset(
                            Assets.imagesLogomain2,
                            fit: BoxFit.contain,
                          ),
                        ),
                        VerticalSpacing(20),
                        Column(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: Image.network(
                                "https://cdn.iconscout.com/icon/free/png-256/avatar-370-456322.png",
                                height: 80,
                                width: 80,
                              ),
                            ),
                            VerticalSpacing(5),
                            Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                      text: model
                                              .authService.user?.data?.userName
                                              .toString() ??
                                          "",
                                      style: TextStyling.largeBold),
                                  TextSpan(
                                    text:
                                        "(${model.authService.user?.data?.loginType.toString()})",
                                    style: TextStyling.mediumRegular
                                        .copyWith(color: AppColors.darkGrey),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        VerticalSpacing(30),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 18),
                          child: Column(
                            children: model.menuItems.map((e) {
                              return InkWell(
                                onTap: () {
                                  e.onPress();
                                },
                                child: Container(
                                  padding: EdgeInsets.fromLTRB(0, 0, 0, 15),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        e.label,
                                        style: TextStyling.mediumBold
                                            .copyWith(color: AppColors.primary),
                                      ),
                                      Icon(
                                        Icons.arrow_forward_ios,
                                        color: AppColors.primary,
                                        size: 20,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                        SizedBox(
                          height: 60,
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 20,
                      left: 20,
                      child: InkWell(
                        splashColor: Colors.transparent,
                        onTap: (){
                          Navigator.pop(context);
                        },
                        child: Icon(
                    Icons.arrow_back_ios,
                    color: AppColors.primary,
                  ),
                      )),
                ],
              ),
            ),
          ),
        );
      },
      viewModelBuilder: () => DSFMenuViewModel(context),
    );
  }
}

class MenuChildTileModel {
  final String title;
  final Function onTap;

  MenuChildTileModel({required this.title, required this.onTap});
}

class MenuTile extends StatefulWidget {
  final String title;
  final Function onTap;
  final bool isParent;
  final int currentIndex;
  final int collapsedIndex;
  final List<MenuChildTileModel>? children;

  const MenuTile({
    Key? key,
    required this.title,
    required this.onTap,
    this.children,
    required this.isParent,
    required this.currentIndex,
    required this.collapsedIndex,
  }) : super(key: key);

  @override
  State<MenuTile> createState() => _MenuTileState();
}

class _MenuTileState extends State<MenuTile> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            setState(() {
              widget.onTap();
            });
          },
          child: Container(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.title,
                  style:
                      TextStyling.largeBold.copyWith(color: AppColors.primary),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: AppColors.primary,
                  size: 20,
                )
              ],
            ),
          ),
        ),
        if (widget.currentIndex != widget.collapsedIndex)
          Padding(
            padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
            child: Column(
              children: widget.children
                      ?.map((e) => InkWell(
                            onTap: () {
                              widget.onTap();
                            },
                            child: Container(
                              margin: EdgeInsets.fromLTRB(0, 0, 0, 15),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.title,
                                    style: TextStyling.mediumBold.copyWith(
                                        color:
                                            AppColors.primary.withOpacity(0.8)),
                                  ),
                                ],
                              ),
                            ),
                          ))
                      .toList() ??
                  [],
            ),
          )
      ],
    );
  }
}
