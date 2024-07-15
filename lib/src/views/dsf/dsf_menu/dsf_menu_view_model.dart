import 'package:premier/src/services/local/base/auth_view_model.dart';
import 'package:premier/src/services/local/navigation_service.dart';
import 'package:premier/src/services/remote/base/api_view_model.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class CustomDSFMenuItem {
  final String label;
  final GestureTapCallback onPress;
  final bool isParent;
  final List<CustomDSFMenuItem>? children;

  CustomDSFMenuItem({
    required this.label,
    required this.onPress,
    required this.isParent,
    this.children,
  });
}

class DSFMenuViewModel extends ReactiveViewModel with ApiViewModel, AuthViewModel {
  final BuildContext context;

  DSFMenuViewModel(this.context);


  onLogout() {
    Scaffold.of(context).closeDrawer();
    authService.user = null;
    NavService.login();
  }

  List<CustomDSFMenuItem> get menuItems => [
        CustomDSFMenuItem(
          label: "Main Dashboard",
          isParent: true,
          onPress: () {
            NavService.dashboard();
            Scaffold.of(context).closeDrawer();
          },
        ),
        CustomDSFMenuItem(
          label: "DSF Dashboard",
          isParent: true,
          onPress: () {
            NavService.dSF();
            Scaffold.of(context).closeDrawer();
          },
        ),
      ];
}
