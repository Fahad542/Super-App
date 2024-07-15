import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:premier/src/configs/app_setup.locator.dart';
import 'package:premier/src/configs/app_setup.router.dart';
import 'package:stacked_services/stacked_services.dart';

class NavService {
  static NavigationService? _navigationService = locator<NavigationService>();

  // key
  static GlobalKey<NavigatorState>? get key => StackedService.navigatorKey;

  // on generate route
  static Route<dynamic>? Function(RouteSettings) get onGenerateRoute =>
      StackedRouter().onGenerateRoute;

  // nested routes with args for root navigator
  static Future<dynamic>? login({dynamic arguments}) => _navigationService!
      .clearStackAndShow(Routes.loginView, arguments: arguments);

  static Future<dynamic>? dashboard({dynamic arguments}) => _navigationService!
      .clearStackAndShow(Routes.dashboardView, arguments: arguments);

  //DSF
  static Future<dynamic>? dSF({dynamic arguments}) => _navigationService!
      .clearTillFirstAndShow(Routes.dSFView, arguments: arguments);

  static Future<dynamic>? dsfDetailTable({dynamic arguments}) =>
      _navigationService!
          .navigateTo(Routes.dsfDetailTableView, arguments: arguments);

  static Future<dynamic>? dSFBookingDetail({dynamic arguments}) =>
      _navigationService!
          .navigateTo(Routes.dSFBookingDetailView, arguments: arguments);

  //Routes
  static Future<dynamic>? route({dynamic arguments}) => _navigationService!
      .clearTillFirstAndShow(Routes.routeView, arguments: arguments);

  static Future<dynamic>? routeMap({dynamic arguments}) =>
      _navigationService!.navigateTo(Routes.routeMapView, arguments: arguments);

  static Future<dynamic>? allRouteMap({dynamic arguments}) =>
      _navigationService!
          .navigateTo(Routes.allRouteMapView, arguments: arguments);

  static Future<dynamic>? supervisorDashboard({dynamic arguments}) =>
      _navigationService!.clearTillFirstAndShow(Routes.supervisorDashboardView,
          arguments: arguments);
  static Future<dynamic>? salesrport({dynamic arguments}) =>
      _navigationService!.clearTillFirstAndShow(Routes.supervisorDashboardView,
          arguments: arguments);

  static Future<dynamic>? allSupervisorMap({dynamic arguments}) =>
      _navigationService!
          .navigateTo(Routes.allSupervisorMapView, arguments: arguments);

  static Future<dynamic>? pendingOrder({dynamic arguments}) =>
      _navigationService!
          .navigateTo(Routes.pendingOrderView, arguments: arguments);

  static Future<dynamic>? orderDetail({dynamic arguments}) =>
      _navigationService!
          .navigateTo(Routes.orderDetailView, arguments: arguments);
}
