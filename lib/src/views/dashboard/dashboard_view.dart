import 'package:barcode/barcode.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:premier/generated/assets.dart';
import 'package:premier/src/base/utils/utils.dart';
import 'package:premier/src/services/local/navigation_service.dart';
import 'package:premier/src/shared/buttons.dart';
import 'package:premier/src/shared/dashboard_item_card.dart';
import 'package:premier/src/shared/input_field.dart';
import 'package:premier/src/shared/spacing.dart';
import 'package:premier/src/shared/top_app_bar.dart';
import 'package:premier/src/styles/app_colors.dart';
import 'package:premier/src/styles/text_theme.dart';
import 'package:stacked/stacked.dart';
import 'dashboard_view_model.dart';

class DashboardView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return ViewModelBuilder<DashboardViewModel>.reactive(
      builder: (context, model, child) {
        List<Widget> _widgetOptions = <Widget>[
          Column(
            children: [
              Padding(
                padding: EdgeInsets.all(20),
                child: DashboardCard(model: model,),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                child: GridView.builder(
                  shrinkWrap: true,
                  itemCount: model.items.length,
                  physics: BouncingScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 5,
                      mainAxisSpacing: 5,
                      childAspectRatio: 1),
                  itemBuilder: (BuildContext context, int index) {
                    return DashboardItemCard(
                      title: model.items[index].name,
                      icon: model.items[index].icon,
                      isActive: model.items[index].isActive,
                      onTap: () {
                        model.getNavigatorByItem(model.items[index].key,context);
                      },
                      onUpcomingTap: () {
                        showUpcomingDialog(context, () {
                          Navigator.pop(context);
                          model.notifyListeners();
                        });
                      },
                    );
                  },
                ),
              ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: context.screenSize().width,
              ),
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: Container(
                      color: AppColors.secondary,
                      child: CachedNetworkImage(
                        height: 120,
                        width: 120,
                        fit: BoxFit.cover,
                        imageUrl: model.authService.user?.data?.image ?? "https://cdn-icons-png.flaticon.com/512/3135/3135715.png",
                        placeholder: (context, url) =>
                            Center(child: Image.asset(Assets.imagesNoResultsFound)),
                        errorWidget: (context, url, error) =>
                            Center(child: Icon(Icons.error)),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: InkWell(
                      onTap: (){
                        model.pickImage();
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle
                        ),
                        height: 36,
                        width: 36,
                        child: Center(child: Icon(Icons.camera_alt_outlined, color: AppColors.white, size: 24,)),
                      ),
                    ),
                  ),
                ],
              ),
              VerticalSpacing(10),
              Text(
                "User Code:",
                style: TextStyling.largeBold.copyWith(
                    color: AppColors.black,
                    decoration: TextDecoration.underline),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                model.authService.user?.data?.userCode.toString() ?? "",
                style: TextStyling.largeBold.copyWith(color: AppColors.primary),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              VerticalSpacing(10),
              Text(
                "UserName:",
                style: TextStyling.largeBold.copyWith(
                    color: AppColors.black,
                    decoration: TextDecoration.underline),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                model.authService.user?.data?.userName.toString() ?? "",
                style: TextStyling.largeBold.copyWith(color: AppColors.primary),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              VerticalSpacing(10),
              Text(
                "Position:",
                style: TextStyling.largeBold.copyWith(
                    color: AppColors.black,
                    decoration: TextDecoration.underline),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                model.authService.user?.data?.loginType.toString() ?? "",
                style: TextStyling.largeBold.copyWith(color: AppColors.primary),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                VerticalSpacing(20),
                Image.asset(
                  Assets.imagesIcon,
                  width: context.screenSize().width * 0.6,
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(20, 30, 20, 0),
                  child: Form(
                    child: Builder(builder: (ctx) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          MainInputField(
                              label: "",
                              hint: "Enter Password",
                              controller: model.password,
                              error: "enter password",
                              isPassword: (model.isShowPassword) ? false : true,
                              suffixIcon: InkWell(
                                  splashColor: Colors.transparent,
                                  onTap: () {
                                    model.isShowPassword =
                                        !model.isShowPassword;
                                    model.notifyListeners();
                                  },
                                  child: Icon(
                                    Icons.remove_red_eye_outlined,
                                    size: 20,
                                    color: AppColors.primary,
                                  ))),
                          MainInputField(
                              label: "",
                              hint: "ReEnter Password",
                              controller: model.rePassword,
                              error: "re-enter password",
                              isPassword:
                                  (model.isShowRePassword) ? false : true,
                              suffixIcon: InkWell(
                                  splashColor: Colors.transparent,
                                  onTap: () {
                                    model.isShowRePassword =
                                        !model.isShowRePassword;
                                    model.notifyListeners();
                                  },
                                  child: Icon(
                                    Icons.remove_red_eye_outlined,
                                    size: 20,
                                    color: AppColors.primary,
                                  ))),
                          VerticalSpacing(30),
                          MainButton(
                              text: "Change Password",
                              onTap: () {
                                model.onChangePassword(context, ctx);
                              })
                        ],
                      );
                    }),
                  ),
                ),
              ],
            ),
          ),
          Container(),
        ];
        return SafeArea(
          child: Scaffold(
            appBar: DashboardAppBar(
              name: model.authService.user?.data?.userName.toString() ?? "",
              image: "https://cdn-icons-png.flaticon.com/512/3135/3135715.png",
            ),
            body: _widgetOptions.elementAt(model.selectedIndex),
            bottomNavigationBar: BottomNavigationBar(
                items: [
                  BottomNavigationBarItem(
                      icon: Icon(Icons.home_filled),
                      label: "Home",
                      backgroundColor: AppColors.primary),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.perm_identity_rounded),
                      label: "Profile",
                      backgroundColor: AppColors.primary),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.password),
                      label: "Change Password",
                      backgroundColor: AppColors.primary),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.logout),
                      label: "Logout",
                      backgroundColor: AppColors.primary),
                ],
                type: BottomNavigationBarType.shifting,
                currentIndex: model.selectedIndex,
                selectedItemColor: AppColors.white,
                selectedIconTheme: IconThemeData(shadows: [
                  Shadow(
                      color: AppColors.secondary,
                      offset: Offset(2, 2),
                      blurRadius: 2)
                ]),
                iconSize: 24,
                onTap: (int index) {
                  model.selectedIndex = index;
                  if (index == 3) {
                    showConfirmationDialog(context, () {
                      model.authService.logout();
                      NavService.login();
                      model.notifyListeners();
                    }, () {
                      model.selectedIndex = 0;
                      Navigator.pop(context);
                      model.notifyListeners();
                    });
                  }
                  model.notifyListeners();
                },
                elevation: 5),
          ),
        );
      },
      viewModelBuilder: () => DashboardViewModel(),
      onModelReady: (model) => model.init(context),
    );
  }

  void showConfirmationDialog(BuildContext context, Function onDone, Function onCanceled) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "Confirm",
            style: TextStyling.mediumBold.copyWith(color: AppColors.primary),
          ),
          content: Text(
            "Are you sure you want logout?",
            style: TextStyling.mediumRegular.copyWith(color: AppColors.primary),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                "Yes",
                style: TextStyling.mediumRegular
                    .copyWith(color: AppColors.primary),
              ),
              onPressed: () {
                onDone();
              },
            ),
            TextButton(
              child: Text(
                "No",
                style: TextStyling.mediumRegular.copyWith(color: AppColors.red),
              ),
              onPressed: () {
                onCanceled();
              },
            ),
          ],
        );
      },
    );
  }

  void showUpcomingDialog(BuildContext context, Function onClose) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "Info",
            style: TextStyling.mediumBold.copyWith(color: AppColors.primary),
          ),
          content: Text(
            "currently upAvailable",
            style: TextStyling.mediumRegular.copyWith(color: AppColors.primary),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                "Ok",
                style: TextStyling.mediumRegular
                    .copyWith(color: AppColors.primary),
              ),
              onPressed: () {
                onClose();
              },
            ),
          ],
        );
      },
    );
  }
}

class DashboardCard extends StatelessWidget {
  final DashboardViewModel model;
  const DashboardCard({Key? key, required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            boxShadow: AppColors.primaryBoxShadow,
            borderRadius: BorderRadius.circular(20),
          ),
          child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
            child: Container(
              width: context.screenSize().width,
              height: 200,
              decoration: BoxDecoration(
                color: AppColors.white,
                boxShadow: AppColors.primaryBoxShadow,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Stack(
                children: [
                  Container(
                    width: context.screenSize().width,
                    height: 200,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.primary
                    ),
                    width: context.screenSize().width * 0.26,
                  ),
                  Positioned(
                    left: context.screenSize().width * 0.08,
                    top: 0,
                    bottom: 0,
                    child: Row(
                      children: [
                        Center(
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(color: AppColors.white, width: 10,),
                                shape: BoxShape.circle
                            ),
                            child: ClipOval(
                                child: Container(
                                  color: AppColors.secondary,
                                  child: CachedNetworkImage(
                                    height: 120,
                                    width: 120,
                                    fit: BoxFit.cover,
                                    imageUrl: model.authService.user?.data?.image ?? "https://cdn-icons-png.flaticon.com/512/3135/3135715.png",
                                    placeholder: (context, url) =>
                                        Center(child: Image.asset(Assets.imagesNoResultsFound)),
                                    errorWidget: (context, url, error) =>
                                        Center(child: Icon(Icons.error)),
                                  ),
                                ),),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(model.authService.user?.data?.userName.toString() ?? "", style: TextStyling.mediumBold.copyWith(color: AppColors.primary),),
                            VerticalSpacing(5),
                            Text(model.authService.user?.data?.loginType.toString() ?? "", style: TextStyling.smallBold.copyWith(color: AppColors.secondary),),
                            Container(
                              decoration: BoxDecoration(
                                border: Border(bottom: BorderSide(color: AppColors.secondary,width: 3)),
                              ),
                              width: 30,
                            ),
                            VerticalSpacing(15),
                            Text("User Code:",style: TextStyling.smallRegular,),
                            BarcodeWidget(
                              barcode:  Barcode.code93(),
                              style: TextStyling.smallRegular.copyWith(color: AppColors.primary),
                              data: model.authService.user?.data?.userCode.toString() ?? "",
                              color: AppColors.primary,
                              width: 100,
                              height: 50,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: Container(
            decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(50), bottomRight: Radius.circular(20))
            ),
            height: 30,
            width: 30,
          ),
        ),
      ],
    );
  }
}