// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StackedRouterGenerator
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:flutter/material.dart' as _i14;
import 'package:flutter/material.dart';
import 'package:premier/src/models/DSF/get_all_dsf_model.dart' as _i16;
import 'package:premier/src/models/supervisor/supervisor_order_model.dart'
    as _i19;
import 'package:premier/src/shared/DSF/company_table_data.dart' as _i15;
import 'package:premier/src/views/dashboard/dashboard_view.dart' as _i3;
import 'package:premier/src/views/dsf/dsf_booking_detail/dsf_booking_detail_view.dart'
    as _i6;
import 'package:premier/src/views/dsf/dsf_dashboard/dsf_dashboard_view.dart'
    as _i4;
import 'package:premier/src/views/dsf/dsf_detail_table/dsf_detail_table_view.dart'
    as _i5;
import 'package:premier/src/views/login/login_view.dart' as _i2;
import 'package:premier/src/views/route/all_route_map/all_route_map_view.dart'
    as _i9;
import 'package:premier/src/views/route/route_dashboard/route_dashboard_view.dart'
    as _i7;
import 'package:premier/src/views/route/route_dashboard/route_dashboard_view_model.dart'
    as _i17;
import 'package:premier/src/views/route/route_map/route_map_view.dart' as _i8;
import 'package:premier/src/views/supervisor/all_supervisor_map/all_supervisor_map_view.dart'
    as _i11;
import 'package:premier/src/views/supervisor/order_detail/order_detail_view.dart'
    as _i13;
import 'package:premier/src/views/supervisor/panding_order/panding_order_view.dart'
    as _i12;
import 'package:premier/src/views/supervisor/supervisor_dashboard/supervisor_dashboard_view.dart'
    as _i10;
import 'package:premier/src/views/supervisor/supervisor_dashboard/supervisor_dashboard_view_model.dart'
    as _i18;
import 'package:stacked/stacked.dart' as _i1;
import 'package:stacked_services/stacked_services.dart' as _i20;

class Routes {
  static const loginView = '/';

  static const dashboardView = '/dashboard-view';

  static const dSFView = '/d-sf-view';

  static const dsfDetailTableView = '/dsf-detail-table-view';

  static const dSFBookingDetailView = '/d-sf-booking-detail-view';

  static const routeView = '/route-view';

  static const routeMapView = '/route-map-view';

  static const allRouteMapView = '/all-route-map-view';

  static const supervisorDashboardView = '/supervisor-dashboard-view';

  static const allSupervisorMapView = '/all-supervisor-map-view';

  static const pendingOrderView = '/pending-order-view';

  static const orderDetailView = '/order-detail-view';

  static const all = <String>{
    loginView,
    dashboardView,
    dSFView,
    dsfDetailTableView,
    dSFBookingDetailView,
    routeView,
    routeMapView,
    allRouteMapView,
    supervisorDashboardView,
    allSupervisorMapView,
    pendingOrderView,
    orderDetailView,
  };
}

class StackedRouter extends _i1.RouterBase {
  final _routes = <_i1.RouteDef>[
    _i1.RouteDef(
      Routes.loginView,
      page: _i2.LoginView,
    ),
    _i1.RouteDef(
      Routes.dashboardView,
      page: _i3.DashboardView,
    ),
    _i1.RouteDef(
      Routes.dSFView,
      page: _i4.DSFView,
    ),
    _i1.RouteDef(
      Routes.dsfDetailTableView,
      page: _i5.DsfDetailTableView,
    ),
    _i1.RouteDef(
      Routes.dSFBookingDetailView,
      page: _i6.DSFBookingDetailView,
    ),
    _i1.RouteDef(
      Routes.routeView,
      page: _i7.RouteView,
    ),
    _i1.RouteDef(
      Routes.routeMapView,
      page: _i8.RouteMapView,
    ),
    _i1.RouteDef(
      Routes.allRouteMapView,
      page: _i9.AllRouteMapView,
    ),
    _i1.RouteDef(
      Routes.supervisorDashboardView,
      page: _i10.SupervisorDashboardView,
    ),
    _i1.RouteDef(
      Routes.allSupervisorMapView,
      page: _i11.AllSupervisorMapView,
    ),
    _i1.RouteDef(
      Routes.pendingOrderView,
      page: _i12.PendingOrderView,
    ),
    _i1.RouteDef(
      Routes.orderDetailView,
      page: _i13.OrderDetailView,
    ),
  ];

  final _pagesMap = <Type, _i1.StackedRouteFactory>{
    _i2.LoginView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => _i2.LoginView(),
        settings: data,
      );
    },
    _i3.DashboardView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => _i3.DashboardView(),
        settings: data,
      );
    },
    _i4.DSFView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => _i4.DSFView(),
        settings: data,
      );
    },
    _i5.DsfDetailTableView: (data) {
      final args = data.getArgs<DsfDetailTableViewArguments>(nullOk: false);
      return MaterialPageRoute<dynamic>(
        builder: (context) => _i5.DsfDetailTableView(
            key: args.key,
            title: args.title,
            heading: args.heading,
            data: args.data,
            totalInv: args.totalInv,
            totalAmount: args.totalAmount),
        settings: data,
      );
    },
    _i6.DSFBookingDetailView: (data) {
      final args = data.getArgs<DSFBookingDetailViewArguments>(
        orElse: () => const DSFBookingDetailViewArguments(),
      );
      return MaterialPageRoute<dynamic>(
        builder: (context) =>
            _i6.DSFBookingDetailView(key: args.key, data: args.data),
        settings: data,
      );
    },
    _i7.RouteView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => _i7.RouteView(),
        settings: data,
      );
    },
    _i8.RouteMapView: (data) {
      final args = data.getArgs<RouteMapViewArguments>(nullOk: false);
      return MaterialPageRoute<dynamic>(
        builder: (context) =>
            _i8.RouteMapView(key: args.key, routesData: args.routesData),
        settings: data,
      );
    },
    _i9.AllRouteMapView: (data) {
      final args = data.getArgs<AllRouteMapViewArguments>(nullOk: false);
      return MaterialPageRoute<dynamic>(
        builder: (context) =>
            _i9.AllRouteMapView(key: args.key, routesData: args.routesData),
        settings: data,
      );
    },
    _i10.SupervisorDashboardView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => _i10.SupervisorDashboardView(),
        settings: data,
      );
    },
    _i11.AllSupervisorMapView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => _i11.AllSupervisorMapView(),
        settings: data,
      );
    },
    _i12.PendingOrderView: (data) {
      final args = data.getArgs<PendingOrderViewArguments>(nullOk: false);
      return MaterialPageRoute<dynamic>(
        builder: (context) => _i12.PendingOrderView(
            key: args.key, data: args.data, branchId: args.branchId),
        settings: data,
      );
    },
    _i13.OrderDetailView: (data) {
      final args = data.getArgs<OrderDetailViewArguments>(nullOk: false);
      return MaterialPageRoute<dynamic>(
        builder: (context) =>
            _i13.OrderDetailView(key: args.key, data: args.data),
        settings: data,
      );
    },
  };

  @override
  List<_i1.RouteDef> get routes => _routes;
  @override
  Map<Type, _i1.StackedRouteFactory> get pagesMap => _pagesMap;
}

class DsfDetailTableViewArguments {
  const DsfDetailTableViewArguments({
    this.key,
    required this.title,
    required this.heading,
    required this.data,
    required this.totalInv,
    required this.totalAmount,
  });

  final _i14.Key? key;

  final String title;

  final _i15.CompanyTableData heading;

  final List<_i15.CompanyTableData> data;

  final String totalInv;

  final String totalAmount;
}

class DSFBookingDetailViewArguments {
  const DSFBookingDetailViewArguments({
    this.key,
    this.data,
  });

  final _i14.Key? key;

  final _i16.AllDsfModelData? data;
}

class RouteMapViewArguments {
  const RouteMapViewArguments({
    this.key,
    required this.routesData,
  });

  final _i14.Key? key;

  final _i17.RoutesData routesData;
}

class AllRouteMapViewArguments {
  const AllRouteMapViewArguments({
    this.key,
    required this.routesData,
  });

  final _i14.Key? key;

  final List<_i17.RoutesData> routesData;
}

class PendingOrderViewArguments {
  const PendingOrderViewArguments({
    this.key,
    required this.data,
    this.branchId,
  });

  final _i14.Key? key;

  final _i18.NewCardData data;

  final String? branchId;
}

class OrderDetailViewArguments {
  const OrderDetailViewArguments({
    this.key,
    required this.data,
  });

  final _i14.Key? key;

  final _i19.SupervisorOrderModelData data;
}

extension NavigatorStateExtension on _i20.NavigationService {
  Future<dynamic> navigateToLoginView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.loginView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToDashboardView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.dashboardView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToDSFView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.dSFView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToDsfDetailTableView({
    _i14.Key? key,
    required String title,
    required _i15.CompanyTableData heading,
    required List<_i15.CompanyTableData> data,
    required String totalInv,
    required String totalAmount,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.dsfDetailTableView,
        arguments: DsfDetailTableViewArguments(
            key: key,
            title: title,
            heading: heading,
            data: data,
            totalInv: totalInv,
            totalAmount: totalAmount),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToDSFBookingDetailView({
    _i14.Key? key,
    _i16.AllDsfModelData? data,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.dSFBookingDetailView,
        arguments: DSFBookingDetailViewArguments(key: key, data: data),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToRouteView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.routeView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToRouteMapView({
    _i14.Key? key,
    required _i17.RoutesData routesData,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.routeMapView,
        arguments: RouteMapViewArguments(key: key, routesData: routesData),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToAllRouteMapView({
    _i14.Key? key,
    required List<_i17.RoutesData> routesData,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.allRouteMapView,
        arguments: AllRouteMapViewArguments(key: key, routesData: routesData),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToSupervisorDashboardView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.supervisorDashboardView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToAllSupervisorMapView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.allSupervisorMapView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToPendingOrderView({
    _i14.Key? key,
    required _i18.NewCardData data,
    String? branchId,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.pendingOrderView,
        arguments:
            PendingOrderViewArguments(key: key, data: data, branchId: branchId),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToOrderDetailView({
    _i14.Key? key,
    required _i19.SupervisorOrderModelData data,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.orderDetailView,
        arguments: OrderDetailViewArguments(key: key, data: data),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithLoginView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.loginView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithDashboardView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.dashboardView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithDSFView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.dSFView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithDsfDetailTableView({
    _i14.Key? key,
    required String title,
    required _i15.CompanyTableData heading,
    required List<_i15.CompanyTableData> data,
    required String totalInv,
    required String totalAmount,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(Routes.dsfDetailTableView,
        arguments: DsfDetailTableViewArguments(
            key: key,
            title: title,
            heading: heading,
            data: data,
            totalInv: totalInv,
            totalAmount: totalAmount),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithDSFBookingDetailView({
    _i14.Key? key,
    _i16.AllDsfModelData? data,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(Routes.dSFBookingDetailView,
        arguments: DSFBookingDetailViewArguments(key: key, data: data),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithRouteView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.routeView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithRouteMapView({
    _i14.Key? key,
    required _i17.RoutesData routesData,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(Routes.routeMapView,
        arguments: RouteMapViewArguments(key: key, routesData: routesData),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithAllRouteMapView({
    _i14.Key? key,
    required List<_i17.RoutesData> routesData,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(Routes.allRouteMapView,
        arguments: AllRouteMapViewArguments(key: key, routesData: routesData),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithSupervisorDashboardView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.supervisorDashboardView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithAllSupervisorMapView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.allSupervisorMapView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithPendingOrderView({
    _i14.Key? key,
    required _i18.NewCardData data,
    String? branchId,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(Routes.pendingOrderView,
        arguments:
            PendingOrderViewArguments(key: key, data: data, branchId: branchId),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithOrderDetailView({
    _i14.Key? key,
    required _i19.SupervisorOrderModelData data,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(Routes.orderDetailView,
        arguments: OrderDetailViewArguments(key: key, data: data),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }
}
