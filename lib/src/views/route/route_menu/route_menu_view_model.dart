import 'package:premier/src/services/local/base/auth_view_model.dart';
import 'package:premier/src/services/local/navigation_service.dart';
import 'package:premier/src/services/remote/base/api_view_model.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class CustomRouteMenuItem {
  final String label;
  final GestureTapCallback onPress;
  final bool isParent;
  final List<CustomRouteMenuItem>? children;

  CustomRouteMenuItem({
    required this.label,
    required this.onPress,
    required this.isParent,
    this.children,
  });
}

class RouteMenuViewModel extends ReactiveViewModel with ApiViewModel, AuthViewModel {
  final BuildContext context;

  RouteMenuViewModel(this.context);


  onLogout() {
    Scaffold.of(context).closeDrawer();
    authService.user = null;
    NavService.login();
  }

  List<CustomRouteMenuItem> get menuItems => [
        CustomRouteMenuItem(
          label: "Main Dashboard",
          isParent: true,
          onPress: () {
            NavService.dashboard();
            Scaffold.of(context).closeDrawer();
          },
        ),
        CustomRouteMenuItem(
          label: "Route Dashboard",
          isParent: true,
          onPress: () {
            NavService.route();
            Scaffold.of(context).closeDrawer();
          },
        ),
      ];
}
