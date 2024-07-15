import 'package:premier/src/services/local/auth_service.dart';
import 'package:premier/src/services/local/background_serv.dart';
import 'package:premier/src/services/local/connectivity_service.dart';
import 'package:premier/src/services/local/keyboard_service.dart';
import 'package:premier/src/services/remote/api_service.dart';
import 'package:premier/src/views/dashboard/dashboard_view.dart';
import 'package:premier/src/views/dsf/dsf_booking_detail/dsf_booking_detail_view.dart';
import 'package:premier/src/views/dsf/dsf_dashboard/dsf_dashboard_view.dart';
import 'package:premier/src/views/dsf/dsf_detail_table/dsf_detail_table_view.dart';
import 'package:premier/src/views/login/login_view.dart';
import 'package:premier/src/views/route/all_route_map/all_route_map_view.dart';
import 'package:premier/src/views/route/route_dashboard/route_dashboard_view.dart';
import 'package:premier/src/views/route/route_map/route_map_view.dart';
import 'package:premier/src/views/supervisor/all_supervisor_map/all_supervisor_map_view.dart';
import 'package:premier/src/views/supervisor/order_detail/order_detail_view.dart';
import 'package:premier/src/views/supervisor/panding_order/panding_order_view.dart';
import 'package:premier/src/views/supervisor/supervisor_dashboard/supervisor_dashboard_view.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_services/stacked_services.dart';

@StackedApp(
  routes: [
    MaterialRoute(page: LoginView, initial: true),
    MaterialRoute(page: DashboardView),
    MaterialRoute(page: DSFView),
    MaterialRoute(page: DsfDetailTableView),
    MaterialRoute(page: DSFBookingDetailView),
    MaterialRoute(page: RouteView),
    MaterialRoute(page: RouteMapView),
    MaterialRoute(page: AllRouteMapView),
    MaterialRoute(page: SupervisorDashboardView),
    MaterialRoute(page: AllSupervisorMapView),
    MaterialRoute(page: PendingOrderView),
    MaterialRoute(page: OrderDetailView),
  ],
  dependencies: [
    // Lazy singletons
    LazySingleton(classType: DialogService),
    LazySingleton(classType: BottomSheetService),
    LazySingleton(classType: NavigationService),
    LazySingleton(classType: AuthService),
    LazySingleton(classType: ConnectivityService),
    LazySingleton(classType: ApiService),
  ],
)
class AppSetup {
  /** This class has no puporse besides housing the annotation that generates the required functionality **/
}
