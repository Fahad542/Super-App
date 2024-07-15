import 'package:premier/src/services/local/base/auth_view_model.dart';
import 'package:premier/src/services/local/navigation_service.dart';
import 'package:premier/src/services/remote/base/api_view_model.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class CustomSupervisorMenuItem {
  final String label;
  final GestureTapCallback onPress;
  final bool isParent;
  final List<CustomSupervisorMenuItem>? children;

  CustomSupervisorMenuItem({
    required this.label,
    required this.onPress,
    required this.isParent,
    this.children,
  });
}

class SupervisorMenuViewModel extends ReactiveViewModel with ApiViewModel, AuthViewModel {
  final BuildContext context;

  SupervisorMenuViewModel(this.context);


  onLogout() {
    Scaffold.of(context).closeDrawer();
    authService.user = null;
    NavService.login();
  }

  List<CustomSupervisorMenuItem> get menuItems => [
        CustomSupervisorMenuItem(
          label: "Main Dashboard",
          isParent: true,
          onPress: () {
            NavService.dashboard();
            Scaffold.of(context).closeDrawer();
          },
        ),
        CustomSupervisorMenuItem(
          label: "Supervisor Dashboard",
          isParent: true,
          onPress: () {
            NavService.supervisorDashboard();
            Scaffold.of(context).closeDrawer();
          },
        ),
      ];
}
