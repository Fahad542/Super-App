import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:premier/src/base/utils/Constants.dart';
import 'package:premier/src/configs/app_setup.locator.dart';
import 'package:premier/src/models/DSF/companysalereportmodel.dart';
import 'package:premier/src/models/DSF/customer_model_data.dart';
import 'package:premier/src/models/DSF/dahsboard_data.dart';
import 'package:premier/src/models/DSF/get_all_dsf_model.dart';
import 'package:premier/src/models/DSF/salesreport_model.dart';
import 'package:premier/src/models/ROUTES/all_salesman_model.dart';
import 'package:premier/src/models/ROUTES/route_planing_dashboard.dart';
import 'package:premier/src/models/Rsm_model/rsm.dart';
import 'package:premier/src/models/map_model/map_model_data.dart';
import 'package:premier/src/models/supervisor/get_all_branches_model.dart';
import 'package:premier/src/models/supervisor/products_by_order.dart';
import 'package:premier/src/models/supervisor/products_by_order_for_inv.dart';
import 'package:premier/src/models/supervisor/reason_model.dart';
import 'package:premier/src/models/supervisor/salesman_location_model.dart';
import 'package:premier/src/models/supervisor/salesman_model.dart';
import 'package:premier/src/models/supervisor/supervisor_dashboard_model.dart';
import 'package:premier/src/models/supervisor/supervisor_order_model.dart';
import 'package:premier/src/models/user.dart';
import 'package:premier/src/services/local/auth_service.dart';
import 'package:premier/src/services/local/flavor_service.dart';
import 'package:premier/src/services/remote/Intersepters/SuperAppIntersepter.dart';
import 'package:premier/src/services/remote/api_client.dart';
import 'package:premier/src/services/remote/api_result.dart';
import 'package:premier/src/services/remote/network_exceptions.dart';
import 'package:premier/src/views/geo_coordinates/request_details/request_details_view_model.dart';

import '../../models/DSF/CompanyDsfSaleDetailmodel.dart';
import '../../models/DSF/company_dsf_sale_Detail.dart';
import '../../models/DSF/dsf_company_customer_details.dart';
import '../../models/DSF/dsfcompanydetailmodel.dart';
import '../../models/DSF/fm_model.dart';
import '../../models/DSF/supervisor_model.dart';
import '../../models/DSF/supervisorlist.dart';
import '../../models/DSF/zm_company_sales_model.dart';
import '../../models/DSF/zm_dsf.dart';
import '../../models/Gm_model/gm1_model.dart';
import '../../models/SMM_Customer/ssm_model.dart';
import '../../models/SM_customer/sm_customer.dart';
import '../../models/ZSM_customer/zsm.dart';
import '../../models/customer_report/azsm_model.dart';
import '../../models/customer_report/customer_report_model.dart';
import '../../models/customer_report/dsf_customer_report_model.dart';
import '../../models/customer_report/fse_model.dart';
import '../../models/customer_report/supervisor_customer_report_mode.dart';
import '../../models/customer_report/total_customer_model.dart';
import '../../models/customer_report/total_uc_model.dart';
import '../../models/customers_model/azsm.dart';
import '../../models/customers_model/fse.dart';
import '../../models/customers_model/gm_sale_report_model.dart';
import '../../models/customers_model/rsm_model.dart';
import '../../models/customers_model/sm_sale_report.dart';
import '../../models/customers_model/ssm_sale_report_model.dart';
import '../../models/customers_model/zsm_model.dart';
import '../../models/geo_coordinates/geo_coordinates.dart';
import '../../models/geo_coordinates/request_details_model.dart';
import '../../models/version_model.dart';

class ApiService {
  ApiClient? _apiClient;
  ApiClient? _apiB2BClient;
  ApiClient? _apiB2BNewClient;

  Dio? _dio;
  AuthService user = locator<AuthService>();

  ApiService() {
    _dio = Dio();
    _apiClient = ApiClient(Dio(),
        baseUrl: FlavorService.getSuperAppBaseApi,
        interceptors: [SuperAppApiInterceptor()]);
    _apiB2BClient = ApiClient(Dio(),
        baseUrl: FlavorService.getSuperAppB2BBaseApi,
        interceptors: [SuperAppB2BApiInterceptor()]);
    _apiB2BNewClient = ApiClient(Dio(),
        baseUrl: FlavorService.getSuperAppB2BNewBaseApi,
        interceptors: [SuperAppB2BApiInterceptor()]);
  }

  Future<ApiResult<UserModel>?> login(BuildContext context, String loginName,
      String loginPass) async {
    try {
      var response = await _apiClient?.postReq(
        "/Login",
        data: {"loginname": loginName, "loginpass": loginPass},
      );
      if (response?.statusCode != 200) {
        Constants.customErrorSnack(context, response?.message.toString() ?? "");
        return null;
      }
      return ApiResult.success(data: UserModel.fromJson(response!.data));
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e)!);
    }
  }

  Future<ApiResult<bool>> changePassword(BuildContext context,
      String userPass) async {
    try {
      var response = await _apiClient?.postReq(
        "/ChangePassword",
        data: {"user_id": user.user?.data?.userId, "userpass": userPass},
      );
      Constants.customSuccessSnack(context, response?.message.toString() ?? "");
      return ApiResult.success(
          data: (response?.statusCode == 200) ? true : false);
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e)!);
    }
  }

  Future<ApiResult<AllDsfModel>?> getAllDSF(BuildContext context) async {
    try {
      var response = await _apiClient?.postReq(
        "/DsfList",
        data: {
          "branch_id": user.user?.data?.branchId.toString(),
          "user_id": user.user?.data?.userId.toString(),
          "login_type": user.user?.data?.loginType.toString(),
          "user_code": user.user?.data?.userCode.toString()
        },
      );
      if (response?.statusCode != 200) {
        Constants.customErrorSnack(context, response?.message.toString() ?? "");
        return null;
      }
      return ApiResult.success(data: AllDsfModel.fromJson(response!.data));
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e)!);
    }
  }

  Future<ApiResult<DFSDashboardData>?> getDSFDashboard(BuildContext context,
      String startDate, String endDate,
      {String? id, String? type, String? code}) async {
    //print("Userid: ${id ?? user.user?.data?.userId.toString()},Login_Type:${type ?? user.user?.data?.loginType.toString()},User_Code:${code ?? user.user?.data?.userCode.toString()},StartDate:${startDate} EndDate:${endDate}");
    try {
      var response = await _apiClient?.postReq(
        "/DashboardSummary",
        data: {
          "branch_id": user.user?.data?.branchId.toString(),
          "user_id": id ?? user.user?.data?.userId.toString(),
          "login_type": type ?? user.user?.data?.loginType.toString(),
          "user_code": code ?? user.user?.data?.userCode.toString(),
          "start_date": startDate,
          "end_date": endDate
        },
      );
      if (response?.statusCode != 200) {
        Constants.customErrorSnack(context, response?.message.toString() ?? "");
        return null;
      }
      return ApiResult.success(data: DFSDashboardData.fromJson(response!.data));
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e)!);
    }
  }

  Future<ApiResult<CustomerModelData>?> getDSFCustomers(BuildContext context,
      String status, String startDate, String endDate,
      {String? id, String? type, String? code}) async {
    try {
      var response = await _apiClient?.postReq(
        "/CustomerWiseSale",
        data: {
          "branch_id": user.user?.data?.branchId.toString(),
          "user_id": id ?? user.user?.data?.userId.toString(),
          "login_type": type ?? user.user?.data?.loginType.toString(),
          "user_code": code ?? user.user?.data?.userCode.toString(),
          "api_status": status,
          "start_date": startDate,
          "end_date": endDate
        },
      );
      if (response?.statusCode != 200) {
        Constants.customErrorSnack(context, response?.message.toString() ?? "");
        return null;
      }
      return ApiResult.success(
          data: CustomerModelData.fromJson(response!.data));
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e)!);
    }
  }

  Future<ApiResult<CustomerModelData>?> getDSFOrders(BuildContext context,
      String date,
      {String? id, String? type, String? code}) async {
    try {
      var response = await _apiClient?.postReq(
        "/BookingWiseSale",
        data: {
          "branch_id": user.user?.data?.branchId.toString(),
          "user_id": id ?? user.user?.data?.userId.toString(),
          "login_type": type ?? user.user?.data?.loginType.toString(),
          "user_code": code ?? user.user?.data?.userCode.toString(),
          "start_date": date
        },
      );
      if (response?.statusCode != 200) {
        Constants.customErrorSnack(context, response?.message.toString() ?? "");
        return null;
      }
      return ApiResult.success(
          data: CustomerModelData.fromJson(response!.data));
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e)!);
    }
  }

  Future<ApiResult<AllSalesManModel>?> getAllSalesMan(
      BuildContext context) async {
    try {
      var response = await _apiClient?.postReq(
        "/SalesmanList",
        data: {
          "user_id": user.user?.data?.userId.toString(),
          "login_type": user.user?.data?.loginType.toString(),
          "user_code": user.user?.data?.userCode.toString(),
          "branch_id": user.user?.data?.branchId.toString()
        },
      );
      if (response?.statusCode != 200) {
        Constants.customErrorSnack(context, response?.message.toString() ?? "");
        return null;
      }
      return ApiResult.success(data: AllSalesManModel.fromJson(response!.data));
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e)!);
    }
  }

  Future<ApiResult<RoutePlanningDashboardModel>?> getRoutePlanningDashboard(
      BuildContext context,
      {String? code}) async {
    try {
      var response = await _apiClient?.postReq(
        "/RoutePlanningDashboard",
        data: {
          "branch_id": user.user?.data?.branchId.toString(),
          "user_id": user.user?.data?.userId.toString(),
          "login_type": (code != null)
              ? "SALESMAN"
              : user.user?.data?.loginType.toString(),
          "user_code": code ?? user.user?.data?.userCode.toString()
        },
      );
      if (response?.statusCode != 200) {
        Constants.customErrorSnack(context, response?.message.toString() ?? "");
        return null;
      }
      return ApiResult.success(
          data: RoutePlanningDashboardModel.fromJson(response!.data));
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e)!);
    }
  }

  Future<ApiResult<SalesManLocationModel>?> getSalesManLocation(
      BuildContext context) async {
    try {
      var response = await _apiClient?.postReq(
        "/GetLastLocationUser",
        data: {
          "branch_id": user.user?.data?.branchId.toString(),
          "user_id": user.user?.data?.userId.toString(),
          "login_type": user.user?.data?.loginType.toString(),
          "user_code": user.user?.data?.userCode.toString()
        },

      );
      if (response?.statusCode != 200) {
        Constants.customErrorSnack(context, response?.message.toString() ?? "");
        return null;
      }
      return ApiResult.success(
          data: SalesManLocationModel.fromJson(response!.data));
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e)!);
    }
  }

  Future<ApiResult<AllBranchesModel>?> getAllBranch(
      BuildContext context) async {
    try {
      var response = await _apiB2BClient?.getReq(
          "/listBranch.php?user_id=${user.user?.data?.userId
              .toString()}&login_type=${user.user?.data?.loginType
              .toString()}&user_code=${user.user?.data?.userCode.toString()}",
          wantJsonParse: true);
      if (response?.statusCode != 200) {
        Constants.customErrorSnack(context, response?.message.toString() ?? "");
        return null;
      }
      return ApiResult.success(data: AllBranchesModel.fromJson(response!.data));
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e)!);
    }
  }

  Future<ApiResult<SupervisorDashboardModel>?> getSupervisorDashboardData(
      BuildContext context, String? branchId) async {
    try {
      var response = await _apiB2BClient?.getReq(
          "/dashboardService.php?branch_id=${branchId ??
              user.user?.data?.branchId.toString()}",
          wantJsonParse: true);
      if (response?.statusCode != 200) {
        Constants.customErrorSnack(context, response?.message.toString() ?? "");
        return null;
      }
      return ApiResult.success(
          data: SupervisorDashboardModel.fromJson(response!.data));
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e)!);
    }
  }

  Future<ApiResult<SupervisorOrderModel>?> getOrderData(BuildContext context,
      String status, String fromDate, String toDate,
      {String? branchId}) async {
    print(
        "json Data:/listOrders.php?branch_id=${branchId}&status=$status&from_date=$fromDate&to_date=$toDate");
    try {
      // print("Sand Data 1:${status},${fromDate} ,${toDate},${branchId},${user.user?.data?.branchId.toString()}");
      var response = await _apiB2BClient?.getReq(
          "/listOrders.php?branch_id=${branchId}&status=$status&from_date=$fromDate&to_date=$toDate",
          wantJsonParse: true);
      if (response?.statusCode != 200) {
        Constants.customErrorSnack(context, response?.message.toString() ?? "");
        return null;
      }
      return ApiResult.success(
          data: SupervisorOrderModel.fromJson(response!.data));
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e)!);
    }
  }

  Future<ApiResult<String>?> assignDeliveryDate(BuildContext context,
      String orderId, String deliveryDate) async {
    try {
      var response = await _apiB2BClient?.getReq(
          "/date_change.php?order_id=$orderId&delivery_date=$deliveryDate",
          wantJsonParse: true);
      if (response?.statusCode != 200) {
        Constants.customErrorSnack(context, response?.message.toString() ?? "");
        return null;
      }
      return ApiResult.success(data: response?.message ?? "");
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e)!);
    }
  }

  Future<ApiResult<String>?> orderConfirmation(BuildContext context,
      String orderId) async {
    try {
      var response = await _apiB2BClient
          ?.getReq("/status_change.php?order_id=$orderId", wantJsonParse: true);
      if (response?.statusCode != 200) {
        Constants.customErrorSnack(context, response?.message.toString() ?? "");
        return null;
      }
      return ApiResult.success(data: response?.message ?? "");
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e)!);
    }
  }

  Future<ApiResult<String>?> orderCancellation(BuildContext context,
      String orderId, String remarks) async {
    try {
      var response = await _apiB2BNewClient?.getReq(
          "/status_change.php?order_id=$orderId&status=7&remarks=$remarks",
          wantJsonParse: true);
      if (response?.statusCode != 200) {
        Constants.customErrorSnack(context, response?.message.toString() ?? "");
        return null;
      }
      return ApiResult.success(data: response?.message ?? "");
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e)!);
    }
  }

  Future<ApiResult<ProductsByOrder>?> getProductsByOrderData(
      BuildContext context, String orderId) async {
    try {
      var response = await _apiB2BClient?.getReq(
          "/listOrdersProducts.php?order_id=$orderId",
          wantJsonParse: true);
      if (response?.statusCode != 200) {
        Constants.customErrorSnack(context, response?.message.toString() ?? "");
        return null;
      }
      return ApiResult.success(data: ProductsByOrder.fromJson(response!.data));
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e)!);
    }
  }

  Future<ApiResult<String>?> assignSalesMan(BuildContext context,
      String orderId, String saleManName, String saleManId) async {
    try {
      var response = await _apiB2BClient?.getReq(
          "/status_change_bms.php?order_id=$orderId&order_status=4&salesman_id=$saleManId&salesman_name=$saleManName",
          wantJsonParse: true);
      if (response?.statusCode != 200) {
        Constants.customErrorSnack(context, response?.message.toString() ?? "");
        return null;
      }
      return ApiResult.success(data: response?.message ?? "");
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e)!);
    }
  }


  Future<ApiResult<String>?> datechange(BuildContext context,
      String orderId, String forward_date) async {
    try {
      var response = await _apiB2BClient?.getReq(
          "/forward_date.php?order_id=$orderId&forward_date=$forward_date",
          wantJsonParse: true);
      if (response?.statusCode != 200) {
        Constants.customErrorSnack(context, response?.message.toString() ?? "");
        return null;
      }
      print(response?.message);
      Constants.customSuccessSnack(context, "Status Updated Successfully");
      return ApiResult.success(data: response?.message ?? "");
    } catch (e) {
      print(ApiResult.failure(error: NetworkExceptions.getDioException(e)!));
      return ApiResult.failure(error: NetworkExceptions.getDioException(e)!);
    }
  }

  Future<ApiResult<String>?> addRemark(BuildContext context, String orderId,
      String remarks) async {
    try {
      var response = await _apiB2BClient?.getReq(
          "/status_change_bms.php?order_id=$orderId&remarks=$remarks",
          wantJsonParse: true);
      if (response?.statusCode != 200) {
        Constants.customErrorSnack(context, response?.message.toString() ?? "");
        return null;
      }
      return ApiResult.success(data: response?.message ?? "");
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e)!);
    }
  }

  Future<ApiResult<SalesManModel>?> getSalesMan(BuildContext context,
      String? branchId) async {
    try {
      var response = await _apiB2BClient?.getReq(
          "/listSalesman.php?branch_id=${branchId ??
              user.user?.data?.branchId.toString()}",
          wantJsonParse: true);
      if (response?.statusCode != 200) {
        Constants.customErrorSnack(context, response?.message.toString() ?? "");
        return null;
      }
      return ApiResult.success(data: SalesManModel.fromJson(response!.data));
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e)!);
    }
  }

  Future<ApiResult<ReasonModel>?> getReasons(BuildContext context,
      String? branchId) async {
    try {
      var response = await _apiB2BClient?.getReq(
          "/listReason.php?branch_id=${branchId ??
              user.user?.data?.branchId.toString()}",
          wantJsonParse: true);
      if (response?.statusCode != 200) {
        Constants.customErrorSnack(context, response?.message.toString() ?? "");
        return null;
      }
      return ApiResult.success(data: ReasonModel.fromJson(response!.data));
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e)!);
    }
  }

  Future<ApiResult<ProductsByOrderForInv>?> getProductsByOrderDataForInv(
      BuildContext context, bool isFinal, String orderId) async {
    try {
      var response = await _apiB2BNewClient?.getReq(
          isFinal
              ? "/listProformaProductsFinal.php?order_id=$orderId"
              : "/listProformaProducts.php?order_id=$orderId",
          wantJsonParse: true);
      if (response?.statusCode != 200) {
        Constants.customErrorSnack(context, response?.message.toString() ?? "");
        return null;
      }
      return ApiResult.success(
          data: ProductsByOrderForInv.fromJson(response!.data));
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e)!);
    }
  }

  Future<ApiResult<bool>> getAndSetLocationInBg(LatLng latLng) async {
    try {
      var response = await _apiClient?.postReq(
        "/UpdateLocationOfUsers",
        data: {
          "branch_id": user.user?.data?.branchId.toString(),
          "user_id": user.user?.data?.userId.toString(),
          "login_type": user.user?.data?.loginType.toString(),
          "user_code": user.user?.data?.userCode.toString(),
          "latitude": latLng.latitude,
          "longitude": latLng.longitude,
        },

      );
      print("Latitude:${latLng.latitude}");
      print("Longitude:${latLng.longitude}");

      if (response?.statusCode != 200) {
        print(response?.message);
        return ApiResult.success(data: false);
      }
      print(response?.message);
      return ApiResult.success(
          data: (response?.message == "Location Update Successfully")
              ? true
              : false);
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e)!);
    }
  }

  Future<ApiResult<Directions>?> getDirections(BuildContext context,
      LatLng origin, LatLng destination) async {
    try {
      final response = await _dio?.get(
        "https://maps.googleapis.com/maps/api/directions/json?",
        queryParameters: {
          'origin': '${origin.latitude},${origin.longitude}',
          'destination': '${destination.latitude},${destination.longitude}',
          'key': "AIzaSyAFkvJ5vPzUed6bCEBWo6UC11RnthpwVdo",
        },
      );
      if (response?.statusCode != 200) {
        Constants.customErrorSnack(
            context, response?.statusMessage.toString() ?? "");
        return null;
      }
      return ApiResult.success(data: Directions.fromMap(response?.data));
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e)!);
    }
  }

  Future<ApiResult<CompanyDsfSaleDetailModel>?> CompanyDsfSaleDetail(
      BuildContext context, String start_date, String end_date,
      String company_id, String supervisor_code,
      String supervisorbranch) async {
    try {
      var response = await _apiClient?.postReq(
        "/DsfSaleReport",
        data: {
          "user_id": user.user?.data?.userId.toString(),
          "login_type": user.user?.data?.loginType.toString(),
          "user_code": user.user?.data?.userCode.toString(),
          "start_date": start_date,
          "end_date": end_date,
          "supervisor_code": supervisor_code,
          "supervisor_branch": supervisorbranch,
          "branch_id": user.user?.data?.branchId.toString(),
          "company_id": company_id,
        },

      );
      print({"user_id": user.user?.data?.userId.toString(),
        "login_type": user.user?.data?.loginType.toString(),
        "user_code": user.user?.data?.userCode.toString(),
        "start_date": start_date,
        "end_date": end_date,
        "supervisor_code": supervisor_code,
        "supervisor_branch": supervisorbranch,
        "branch_id": user.user?.data?.branchId.toString(),
        "company_id": company_id,});
      if (response?.statusCode != 200) {
        Constants.customErrorSnack(context, response?.message.toString() ?? "");
        return null;
      }
      return ApiResult.success(
          data: CompanyDsfSaleDetailModel.fromJson(response!.data)
      );
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e)!);
    }
  }

  Future<ApiResult<SalesReportModel>?> salesreportDsf(BuildContext context,
      String start_date, String end_date, String supervisor_code,
      String branch) async {
    try {
      var response = await _apiClient?.postReq(
        "/DsfSaleReport",
        data: {
          "user_id": user.user?.data?.userId.toString(),
          "login_type": user.user?.data?.loginType.toString(),
          "user_code": user.user?.data?.userCode.toString(),
          "start_date": start_date,
          "end_date": end_date,
          "supervisor_code": supervisor_code,
          "supervisor_branch": branch,
          "branch_id": user.user?.data?.branchId.toString(),
        },
      );
      if (response?.statusCode != 200) {
        Constants.customErrorSnack(context, response?.message.toString() ?? "");
        return null;
      }
      return ApiResult.success(data: SalesReportModel.fromJson(response!.data));
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e)!);
    }
  }

  Future<ApiResult<CompanySalesReportModel>?> companysalesreport(
      BuildContext context, String start_date, String end_date,
      String supervisor_code, supervisor_branch) async {
    try {
      var response = await _apiClient?.postReq(
        "/CompanySaleReport",
        data: {
          "user_id": user.user?.data?.userId.toString(),
          "login_type": user.user?.data?.loginType.toString(),
          "user_code": user.user?.data?.userCode.toString(),
          "start_date": start_date,
          "end_date": end_date,
          "supervisor_code": supervisor_code,
          "supervisor_branch": supervisor_branch,
          "branch_id": user.user?.data?.branchId.toString(),
        },

      );
      print('api startdate: $start_date');
      print('api enddate: $end_date');
      if (response?.statusCode != 200) {
        Constants.customErrorSnack(context, response?.message.toString() ?? "");
        return null;
      }
      return ApiResult.success(
          data: CompanySalesReportModel.fromJson(response!.data));
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e)!);
    }
  }

  Future<ApiResult<fmReportModel>?> fmsalesreport(BuildContext context,
      String start_date, String end_date, String zsm_id) async {
    try {
      var response = await _apiClient?.postReq(
        "/FMSaleReport",
        data: {
          "user_id": user.user?.data?.userId.toString(),
          "login_type": user.user?.data?.loginType.toString(),
          "user_code": user.user?.data?.userCode.toString(),
          "start_date": start_date,
          "end_date": end_date,
          "branch_id": user.user?.data?.branchId.toString(),
          "azsm_id": zsm_id
        },

      );
      print({
        "user_id": user.user?.data?.userId.toString(),
        "login_type": user.user?.data?.loginType.toString(),
        "user_code": user.user?.data?.userCode.toString(),
        "start_date": start_date,
        "end_date": end_date,
        "branch_id": user.user?.data?.branchId.toString(),
        "azsm_id": zsm_id
      },);
      if (response?.statusCode != 200) {
        Constants.customErrorSnack(context, response?.message.toString() ?? "");
        return null;
      }
      return ApiResult.success(data: fmReportModel.fromJson(response!.data));
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e)!);
    }
  }

  Future<ApiResult<SupervisorReportModel>?> supervisorsalesreport(
      BuildContext context, String start_date, String end_date,
      String fm_id) async {
    try {
      var response = await _apiClient?.postReq(
        "/SupervisorSaleReport",
        data: {
          "user_id": user.user?.data?.userId.toString(),
          "login_type": user.user?.data?.loginType.toString(),
          "user_code": user.user?.data?.userCode.toString(),
          "start_date": start_date,
          "end_date": end_date,
          "branch_id": user.user?.data?.branchId.toString(),
          "fse_id": fm_id
        },
      );
      print({
        "user_id": user.user?.data?.userId.toString(),
        "login_type": user.user?.data?.loginType.toString(),
        "user_code": user.user?.data?.userCode.toString(),
        "start_date": start_date,
        "end_date": end_date,
        "branch_id": user.user?.data?.branchId.toString(),
        "fse_id": fm_id
      },);
      if (response?.statusCode != 200) {
        Constants.customErrorSnack(context, response?.message.toString() ?? "");
        return null;
      }
      return ApiResult.success(
          data: SupervisorReportModel.fromJson(response!.data));
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e)!);
    }
  }

  Future<ApiResult<zm_dsf_report>?> zm_dsf(BuildContext context,
      String start_date, String end_date, String supervisor_id) async {
    try {
      var response = await _apiClient?.postReq(
        "/SupervisorDsfSaleReport",
        data: {
          "user_id": user.user?.data?.userId.toString(),
          "login_type": user.user?.data?.loginType.toString(),
          "user_code": user.user?.data?.userCode.toString(),
          "start_date": start_date,
          "end_date": end_date,
          "branch_id": user.user?.data?.branchId.toString(),
          "supervisor_id": supervisor_id
        },
      );
      print("zmSaleReport: $start_date, $end_date");
      if (response?.statusCode != 200) {
        Constants.customErrorSnack(context, response?.message.toString() ?? "");
        return null;
      }
      return ApiResult.success(data: zm_dsf_report.fromJson(response!.data));
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e)!);
    }
  }


  Future<ApiResult<DsfcompanycustomerModel>?> DsfCompanyCustomerDetail(
      BuildContext context, String start_date, String end_date, String dsf_id,
      String company_id) async {
    try {
      var response = await _apiClient?.postReq(
          "/DsfCompanyCustomerDetail",
          data: {
            "user_id": user.user?.data?.userId.toString(),
            "login_type": user.user?.data?.loginType.toString(),
            "user_code": user.user?.data?.userCode.toString(),
            "start_date": start_date,
            "end_date": end_date,
            "branch_id": user.user?.data?.branchId.toString(),
            "dsf_id": dsf_id,
            'company_id': company_id,
          }
      );
      print("start_date: $start_date");
      print("end_date: $end_date");
      print("dsf_id:$dsf_id");
      print("company_id: $company_id");


      if (response?.statusCode != 200) {
        Constants.customErrorSnack(context, response?.message.toString() ?? "");
        return null;
      }
      return ApiResult.success(
          data: DsfcompanycustomerModel.fromJson(response!.data));
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e)!);
    }
  }

  Future<ApiResult<Companydsfsaledetailmodel>?> Companydsfsaledetail(
      BuildContext context, String start_date, String end_date,
      String supervisor_code, supervisor_branch, company_id) async {
    try {
      var response = await _apiClient?.postReq(
        "/CompanyDsfSaleDetail",
        data: {
          "user_id": user.user?.data?.userId.toString(),
          "login_type": user.user?.data?.loginType.toString(),
          "user_code": user.user?.data?.userCode.toString(),
          "start_date": start_date,
          "end_date": end_date,
          "branch_id": user.user?.data?.branchId.toString(),
          "supervisor_code": supervisor_code,
          "supervisor_branch": supervisor_branch,
          "company_id": company_id
        },

      );

      if (response?.statusCode != 200) {
        Constants.customErrorSnack(context, response?.message.toString() ?? "");
        return null;
      }
      return ApiResult.success(
          data: Companydsfsaledetailmodel.fromJson(response!.data));
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e)!);
    }
  }

  Future<ApiResult<ZmCompanySalesReportModel>?> FmCompanydsfsaledetail(
      BuildContext context, String start_date, String end_date,
      String fm_id) async {
    try {
      var response = await _apiClient?.postReq(
        "/FMCompanySaleReport",
        data: {
          "user_id": user.user?.data?.userId.toString(),
          "login_type": user.user?.data?.loginType.toString(),
          "user_code": user.user?.data?.userCode.toString(),
          "start_date": start_date,
          "end_date": end_date,
          "branch_id": user.user?.data?.branchId.toString(),
          "fm_id": fm_id
        },


      );
      print({
        "user_id": user.user?.data?.userId.toString(),
        "login_type": user.user?.data?.loginType.toString(),
        "user_code": user.user?.data?.userCode.toString(),
        "start_date": start_date,
        "end_date": end_date,
        "branch_id": user.user?.data?.branchId.toString(),
        "fm_id": fm_id
      });
      if (response?.statusCode != 200) {
        Constants.customErrorSnack(context, response?.message.toString() ?? "");
        return null;
      }
      return ApiResult.success(
          data: ZmCompanySalesReportModel.fromJson(response!.data));
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e)!);
    }
  }

  Future<ApiResult<DsfcompanyModel>?> DsfCompanyDetail(BuildContext context,
      String start_date, String end_date, String dsf_id) async {
    try {
      var response = await _apiClient?.postReq(
        "/DsfCompanyDetail",
        data: {
          "user_id": user.user?.data?.userId.toString(),
          "login_type": user.user?.data?.loginType.toString(),
          "user_code": user.user?.data?.userCode.toString(),
          "start_date": start_date,
          "end_date": end_date,
          "dsf_id": dsf_id,
          "branch_id": user.user?.data?.branchId.toString(),

        },
      );
      if (response?.statusCode != 200) {
        Constants.customErrorSnack(context, response?.message.toString() ?? "");
        return null;
      }
      return ApiResult.success(data: DsfcompanyModel.fromJson(response!.data));
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e)!);
    }
  }

  Future<ApiResult<Gmsalemodel>?> gmsalereport(BuildContext context,
      String s_month, String s_year) async {
    try {
      var response = await _apiClient?.postReq(
        "/GMSaleReport",
        data: {
          "user_id": user.user?.data?.userId.toString(),
          "login_type": user.user?.data?.loginType.toString(),
          "user_code": user.user?.data?.userCode.toString(),
          "start_date": s_month,
          "end_date": s_year,
          "branch_id": user.user?.data?.branchId.toString(),

        },

      );
      print({
        "user_id": user.user?.data?.userId.toString(),
        "login_type": user.user?.data?.loginType.toString(),
        "user_code": user.user?.data?.userCode.toString(),
        "start_date": s_month,
        "end_date": s_year,
        "branch_id": user.user?.data?.branchId.toString(),

      },);

      if (response?.statusCode != 200) {
        Constants.customErrorSnack(context, response?.message.toString() ?? "");
        return null;
      }
      return ApiResult.success(data: Gmsalemodel.fromJson(response!.data));
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e)!);
    }
  }


  Future<ApiResult<ssmsalemodel>?> ssmsalereport(BuildContext context,
      String s_month, String s_year, String general_manager_id) async {
    try {
      var response = await _apiClient?.postReq(
        "/SSMSaleReport",
        data: {
          "user_id": user.user?.data?.userId.toString(),
          "login_type": user.user?.data?.loginType.toString(),
          "user_code": user.user?.data?.userCode.toString(),
          "start_date": s_month,
          "end_date": s_year,
          "branch_id": user.user?.data?.branchId.toString(),
          "general_manager_id": general_manager_id
        },

      );
      print({
        "user_id": user.user?.data?.userId.toString(),
        "login_type": user.user?.data?.loginType.toString(),
        "user_code": user.user?.data?.userCode.toString(),
        "s_month": s_month,
        "s_year": s_year,
        "branch_id": user.user?.data?.branchId.toString(),

      },);

      if (response?.statusCode != 200) {
        Constants.customErrorSnack(context, response?.message.toString() ?? "");
        return null;
      }
      return ApiResult.success(data: ssmsalemodel.fromJson(response!.data));
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e)!);
    }
  }

  Future<ApiResult<rsmsalemodel>?> rsmsalereport(BuildContext context,
      String s_month, String s_year, String general_manager_id) async {
    try {
      var response = await _apiClient?.postReq(
        "/RSMSaleReport",
        data: {
          "user_id": user.user?.data?.userId.toString(),
          "login_type": user.user?.data?.loginType.toString(),
          "user_code": user.user?.data?.userCode.toString(),
          "start_date": s_month,
          "end_date": s_year,
          "branch_id": user.user?.data?.branchId.toString(),
          "sales_manager_id": general_manager_id
        },

      );
      print({
        "user_id": user.user?.data?.userId.toString(),
        "login_type": user.user?.data?.loginType.toString(),
        "user_code": user.user?.data?.userCode.toString(),
        "s_month": s_month,
        "s_year": s_year,
        "branch_id": user.user?.data?.branchId.toString(),
        "sales_manager_id": general_manager_id
      },);

      if (response?.statusCode != 200) {
        Constants.customErrorSnack(context, response?.message.toString() ?? "");
        return null;
      }
      return ApiResult.success(data: rsmsalemodel.fromJson(response!.data));
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e)!);
    }
  }


  Future<ApiResult<zsmsalemodel>?> zsmsalereport(BuildContext context,
      String s_month, String s_year, String general_manager_id) async {
    try {
      var response = await _apiClient?.postReq(
        "/ZSMSaleReport",
        data: {
          "user_id": user.user?.data?.userId.toString(),
          "login_type": user.user?.data?.loginType.toString(),
          "user_code": user.user?.data?.userCode.toString(),
          "start_date": s_month,
          "end_date": s_year,
          "branch_id": user.user?.data?.branchId.toString(),
          "regional_sales_manager_id": general_manager_id
        },

      );
      print({
        "user_id": user.user?.data?.userId.toString(),
        "login_type": user.user?.data?.loginType.toString(),
        "user_code": user.user?.data?.userCode.toString(),
        "s_month": s_month,
        "s_year": s_year,
        "branch_id": user.user?.data?.branchId.toString(),
        "regional_sales_manager_id": general_manager_id
      },);

      if (response?.statusCode != 200) {
        Constants.customErrorSnack(context, response?.message.toString() ?? "");
        return null;
      }
      return ApiResult.success(data: zsmsalemodel.fromJson(response!.data));
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e)!);
    }
  }


  Future<ApiResult<azsmsalemodel>?> azsmsalereport(BuildContext context,
      String s_month, String s_year, String zonal_manager_id) async {
    try {
      var response = await _apiClient?.postReq(
        "/AZSMSaleReport",
        data: {
          "user_id": user.user?.data?.userId.toString(),
          "login_type": user.user?.data?.loginType.toString(),
          "user_code": user.user?.data?.userCode.toString(),
          "start_date": s_month,
          "end_date": s_year,
          "branch_id": user.user?.data?.branchId.toString(),
          "zonal_manager_id": zonal_manager_id
        },

      );
      print({
        "user_id": user.user?.data?.userId.toString(),
        "login_type": user.user?.data?.loginType.toString(),
        "user_code": user.user?.data?.userCode.toString(),
        "s_month": s_month,
        "s_year": s_year,
        "branch_id": user.user?.data?.branchId.toString(),
        "zonal_manager_id": zonal_manager_id
      },);

      if (response?.statusCode != 200) {
        Constants.customErrorSnack(context, response?.message.toString() ?? "");
        return null;
      }
      return ApiResult.success(data: azsmsalemodel.fromJson(response!.data));
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e)!);
    }
  }


  Future<ApiResult<fsesalemodel>?> fsereport(BuildContext context,
      String s_month, String s_year, String fm_id) async {
    try {
      var response = await _apiClient?.postReq(
        "/FSESaleReport",
        data: {
          "user_id": user.user?.data?.userId.toString(),
          "login_type": user.user?.data?.loginType.toString(),
          "user_code": user.user?.data?.userCode.toString(),
          "start_date": s_month,
          "end_date": s_year,
          "branch_id": user.user?.data?.branchId.toString(),
          "fm_id": fm_id,

        },

      );
      print({
        "user_id": user.user?.data?.userId.toString(),
        "login_type": user.user?.data?.loginType.toString(),
        "user_code": user.user?.data?.userCode.toString(),
        "s_month": s_month,
        "s_year": s_year,
        "branch_id": user.user?.data?.branchId.toString(),
        "fm_id": fm_id
      },);

      if (response?.statusCode != 200) {
        Constants.customErrorSnack(context, response?.message.toString() ?? "");
        return null;
      }
      return ApiResult.success(data: fsesalemodel.fromJson(response!.data));
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e)!);
    }
  }


  Future<ApiResult<smsalemodel>?> smsalereport(BuildContext context,
      String s_month, String s_year, String general_manager_id) async {
    try {
      var response = await _apiClient?.postReq(
        "/SMSaleReport",
        data: {
          "user_id": user.user?.data?.userId.toString(),
          "login_type": user.user?.data?.loginType.toString(),
          "user_code": user.user?.data?.userCode.toString(),
          "start_date": s_month,
          "end_date": s_year,
          "branch_id": user.user?.data?.branchId.toString(),
          "senior_sales_manager_id": general_manager_id
        },

      );
      print({
        "user_id": user.user?.data?.userId.toString(),
        "login_type": user.user?.data?.loginType.toString(),
        "user_code": user.user?.data?.userCode.toString(),
        "s_month": s_month,
        "s_year": s_year,
        "branch_id": user.user?.data?.branchId.toString(),

      },);

      if (response?.statusCode != 200) {
        Constants.customErrorSnack(context, response?.message.toString() ?? "");
        return null;
      }
      return ApiResult.success(data: smsalemodel.fromJson(response!.data));
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e)!);
    }
  }

  Future<ApiResult<GmModel>?> gmreport(BuildContext context, String s_month,
      String s_year) async {
    try {
      var response = await _apiClient?.postReq(
        "/GMCustomerReport",
        data: {
          "user_id": user.user?.data?.userId.toString(),
          "login_type": user.user?.data?.loginType.toString(),
          "user_code": user.user?.data?.userCode.toString(),
          "s_month": s_month,
          "s_year": s_year,
          "branch_id": user.user?.data?.branchId.toString(),

        },

      );
      print({
        "user_id": user.user?.data?.userId.toString(),
        "login_type": user.user?.data?.loginType.toString(),
        "user_code": user.user?.data?.userCode.toString(),
        "s_month": s_month,
        "s_year": s_year,
        "branch_id": user.user?.data?.branchId.toString(),

      },);

      if (response?.statusCode != 200) {
        Constants.customErrorSnack(context, response?.message.toString() ?? "");
        return null;
      }
      return ApiResult.success(data: GmModel.fromJson(response!.data));
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e)!);
    }
  }

  Future<ApiResult<SsmModel>?> ssm(BuildContext context, String s_month,
      String s_year, String general_manager_id) async {
    try {
      var response = await _apiClient?.postReq(
        "/SSMCustomerReport",
        data: {
          "user_id": user.user?.data?.userId.toString(),
          "login_type": user.user?.data?.loginType.toString(),
          "user_code": user.user?.data?.userCode.toString(),
          "s_month": s_month,
          "s_year": s_year,
          "branch_id": user.user?.data?.branchId.toString(),
          "general_manager_id": general_manager_id
        },
      );
      print({"user_id": user.user?.data?.userId.toString(),
        "login_type": user.user?.data?.loginType.toString(),
        "user_code": user.user?.data?.userCode.toString(),
        "s_month": s_month,
        "s_year": s_year,
        "branch_id": user.user?.data?.branchId.toString(),
        "general_manager_id": general_manager_id});
      if (response?.statusCode != 200) {
        Constants.customErrorSnack(context, response?.message.toString() ?? "");
        return null;
      }
      return ApiResult.success(data: SsmModel.fromJson(response!.data));
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e)!);
    }
  }

  Future<ApiResult<SmModel>?> sm(BuildContext context, String s_month,
      String s_year, String general_manager_id) async {
    try {
      var response = await _apiClient?.postReq(
        "/SMCustomerReport",
        data: {
          "user_id": user.user?.data?.userId.toString(),
          "login_type": user.user?.data?.loginType.toString(),
          "user_code": user.user?.data?.userCode.toString(),
          "s_month": s_month,
          "s_year": s_year,
          "branch_id": user.user?.data?.branchId.toString(),
          "senior_sales_manager_id": general_manager_id
        },

      );
      print(response?.statusCode);
      print({
        "user_id": user.user?.data?.userId.toString(),
        "login_type": user.user?.data?.loginType.toString(),
        "user_code": user.user?.data?.userCode.toString(),
        "s_month": s_month,
        "s_year": s_year,
        "branch_id": user.user?.data?.branchId.toString(),
        "senior_sales_manager_id": general_manager_id
      },);
      if (response?.statusCode != 200) {
        Constants.customErrorSnack(context, response?.message.toString() ?? "");
        return null;
      }

      return ApiResult.success(data: SmModel.fromJson(response!.data));
    } catch (e) {
      print("error");
      print({
        "user_id": user.user?.data?.userId.toString(),
        "login_type": user.user?.data?.loginType.toString(),
        "user_code": user.user?.data?.userCode.toString(),
        "s_month": s_month,
        "s_year": s_year,
        "branch_id": user.user?.data?.branchId.toString(),
        "senior_sales_manager_id": general_manager_id
      },);
      return ApiResult.failure(error: NetworkExceptions.getDioException(e)!);
    }
  }


  Future<ApiResult<RsmModel>?> rsm(BuildContext context, String s_month,
      String s_year, String general_manager_id) async {
    try {
      var response = await _apiClient?.postReq(
        "/RSMCustomerReport",
        data: {
          "user_id": user.user?.data?.userId.toString(),
          "login_type": user.user?.data?.loginType.toString(),
          "user_code": user.user?.data?.userCode.toString(),
          "s_month": s_month,
          "s_year": s_year,
          "branch_id": user.user?.data?.branchId.toString(),
          "sales_manager_id": general_manager_id
        },

      );

      if (response?.statusCode != 200) {
        Constants.customErrorSnack(context, response?.message.toString() ?? "");
        return null;
      }

      return ApiResult.success(data: RsmModel.fromJson(response!.data));
    } catch (e) {
      print({
        "user_id": user.user?.data?.userId.toString(),
        "login_type": user.user?.data?.loginType.toString(),
        "user_code": user.user?.data?.userCode.toString(),
        "s_month": s_month,
        "s_year": s_year,
        "branch_id": user.user?.data?.branchId.toString(),
        "sales_manager_id": general_manager_id
      },);
      return ApiResult.failure(error: NetworkExceptions.getDioException(e)!);
    }
  }


  Future<ApiResult<zsmModel>?> zsm(BuildContext context, String s_month,
      String s_year, String general_manager_id) async {
    try {
      var response = await _apiClient?.postReq(
        "/ZSMCustomerReport",
        data: {
          "user_id": user.user?.data?.userId.toString(),
          "login_type": user.user?.data?.loginType.toString(),
          "user_code": user.user?.data?.userCode.toString(),
          "s_month": s_month,
          "s_year": s_year,
          "branch_id": user.user?.data?.branchId.toString(),
          "regional_manager_id": general_manager_id
        },

      );
      print({
        "user_id": user.user?.data?.userId.toString(),
        "login_type": user.user?.data?.loginType.toString(),
        "user_code": user.user?.data?.userCode.toString(),
        "s_month": s_month,
        "s_year": s_year,
        "branch_id": user.user?.data?.branchId.toString(),
        "regional_manager_id": general_manager_id
      },);
      if (response?.statusCode != 200) {
        Constants.customErrorSnack(context, response?.message.toString() ?? "");
        return null;
      }
      return ApiResult.success(data: zsmModel.fromJson(response!.data));
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e)!);
    }
  }

  Future<ApiResult<azsmresponse>?> azsmcust(BuildContext context,
      String s_month, String s_year, String zonal_manager_id) async {
    try {
      var response = await _apiClient?.postReq(
        "/AZSMCustomerReport",
        data: {
          "user_id": user.user?.data?.userId.toString(),
          "login_type": user.user?.data?.loginType.toString(),
          "user_code": user.user?.data?.userCode.toString(),
          "s_month": s_month,
          "s_year": s_year,
          "branch_id": user.user?.data?.branchId.toString(),
          "zonal_manager_id": zonal_manager_id
        },

      );
      print({
        "user_id": user.user?.data?.userId.toString(),
        "login_type": user.user?.data?.loginType.toString(),
        "user_code": user.user?.data?.userCode.toString(),
        "s_month": s_month,
        "s_year": s_year,
        "branch_id": user.user?.data?.branchId.toString(),
        "zonal_manager_id": zonal_manager_id
      },);
      if (response?.statusCode != 200) {
        Constants.customErrorSnack(context, response?.message.toString() ?? "");
        return null;
      }
      return ApiResult.success(data: azsmresponse.fromJson(response!.data));
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e)!);
    }
  }





  Future<ApiResult<fse>?> fsecust(BuildContext context,
      String s_month, String s_year, String zonal_manager_id) async {
    try {
      var response = await _apiClient?.postReq(
        "/FSECustomerReport",
        data: {
          "user_id": user.user?.data?.userId.toString(),
          "login_type": user.user?.data?.loginType.toString(),
          "user_code": user.user?.data?.userCode.toString(),
          "s_month": s_month,
          "s_year": s_year,
          "branch_id": user.user?.data?.branchId.toString(),
          "fm_id": zonal_manager_id
        },

      );
      print({
        "user_id": user.user?.data?.userId.toString(),
        "login_type": user.user?.data?.loginType.toString(),
        "user_code": user.user?.data?.userCode.toString(),
        "s_month": s_month,
        "s_year": s_year,
        "branch_id": user.user?.data?.branchId.toString(),
        "fm_id": zonal_manager_id
      },);
      if (response?.statusCode != 200) {
        Constants.customErrorSnack(context, response?.message.toString() ?? "");
        return null;
      }
      return ApiResult.success(data: fse.fromJson(response!.data));
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e)!);
    }
  }


  Future<ApiResult<SupervisorlistModel>?> supervisorList(BuildContext context,
      String fm_id) async {
    try {
      var response = await _apiClient?.postReq(
        "/DsfSupervisorList",
        data: {
          "user_id": user.user?.data?.userId.toString(),
          "login_type": user.user?.data?.loginType.toString(),
          "user_code": user.user?.data?.userCode.toString(),
          "branch_id": user.user?.data?.branchId.toString(),
          "fm_id": fm_id
          //"branch_id": user.user?.data?.branchId.toString(),

        },

      );
      print("user_id: ${user.user?.data?.userId.toString()}");
      print("login_type: ${user.user?.data?.loginType.toString()}");
      print("user_code: ${user.user?.data?.userCode.toString()}");
      print("branch_id ${user.user?.data?.branchId.toString()}");
      print("fm_id: ${fm_id}");

      print(response);
      if (response?.statusCode != 200) {
        Constants.customErrorSnack(context, response?.message.toString() ?? "");
        return null;
      }
      return ApiResult.success(
          data: SupervisorlistModel.fromJson(response!.data));
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e)!);
    }
  }

  Future<ApiResult<Companyreport>?> companyreport(
      BuildContext context, String s_month,String s_year,String zsm_id) async {
    try {
      var response = await _apiClient?.postReq(
        "/FMCustomerReport",
        data: {
          "user_id": user.user?.data?.userId.toString(),
          "login_type": user.user?.data?.loginType.toString(),
          "user_code": user.user?.data?.userCode.toString(),
          "branch_id": user.user?.data?.branchId.toString(),
          "s_month":s_month,
           "s_year":s_year,
          "azsm_id":zsm_id
          //"branch_id": user.user?.data?.branchId.toString(),
        },

      );

      print({
        "user_id": user.user?.data?.userId.toString(),
        "login_type": user.user?.data?.loginType.toString(),
        "user_code": user.user?.data?.userCode.toString(),
        "branch_id": user.user?.data?.branchId.toString(),
        "s_month":s_month,
        "s_year":s_year,
        "azsm_id":zsm_id
        //"branch_id": user.user?.data?.branchId.toString(),
      },);
      if (response?.statusCode != 200) {
        Constants.customErrorSnack(context, response?.message.toString() ?? "");
        return null;
      }



      return ApiResult.success(data: Companyreport.fromJson(response!.data));


    }

    catch (e) {

      return ApiResult.failure(error: NetworkExceptions.getDioException(e)!);
    }
  }


  Future<ApiResult<geo_coordinates_model>?> geo_coordinate(
      BuildContext context) async {
    try {
      var response = await _apiClient?.postReq(
        "/BoosterTaggingRequest",
        data: {
          "user_id": user.user?.data?.userId.toString(),
          "login_type": user.user?.data?.loginType.toString(),
          "user_code": user.user?.data?.userCode.toString(),
          "branch_id": user.user?.data?.branchId.toString(),
          //"branch_id": user.user?.data?.branchId.toString(),
        },

      );
      print("user_id: ${user.user?.data?.userId.toString()}");
      print("login_type: ${user.user?.data?.loginType.toString()}");
      print("user_code: ${user.user?.data?.userCode.toString()}");
      print("branch_id ${user.user?.data?.branchId.toString()}");
      print(response);
      if (response?.statusCode != 200) {
        Constants.customErrorSnack(context, response?.message.toString() ?? "");
        return null;
      }
      print(response?.data);

      return ApiResult.success(data: geo_coordinates_model.fromJson(response!.data));


    }

    catch (e) {
      print("1");
      return ApiResult.failure(error: NetworkExceptions.getDioException(e)!);
    }
  }

  Future<ApiResult<dsf_customer_report_model>?> dsf_details(
      BuildContext context, String s_month,String s_year,String supervisor_id) async {
    try {
      var response = await _apiClient?.postReq(
        "/DsfCustomerReport",
        data: {
          "user_id": user.user?.data?.userId.toString(),
          "login_type": user.user?.data?.loginType.toString(),
          "user_code": user.user?.data?.userCode.toString(),
          "s_month":s_month,
          "s_year":s_year,
          "branch_id": user.user?.data?.branchId.toString(),
          "supervisor_id":supervisor_id
        },

      );
      print("user_id: ${user.user?.data?.userId.toString()}");
      print("login_type: ${user.user?.data?.loginType.toString()}");
      print("user_code: ${user.user?.data?.userCode.toString()}");
      print("s_month: $s_month");
      print( "s_year:$s_year");
      print("branch_id ${user.user?.data?.branchId.toString()}");
      print( "supervisor_id:$supervisor_id");


      if (response?.statusCode != 200) {
        Constants.customErrorSnack(context, response?.message.toString() ?? "");
        return null;
      }
      print(response?.data);

      return ApiResult.success(data: dsf_customer_report_model.fromJson(response!.data));
    }

    catch (e) {
      print("1");
      return ApiResult.failure(error: NetworkExceptions.getDioException(e)!);
    }
  }

  Future<ApiResult<total_customer_report>?> tc_details(
      BuildContext context, String s_month,String s_year,String dsf_id) async {
    try {
      var response = await _apiClient?.postReq(
        "/DsfCustomerDetail",
        data: {
          "user_id": user.user?.data?.userId.toString(),
          "login_type": user.user?.data?.loginType.toString(),
          "user_code": user.user?.data?.userCode.toString(),
          "s_month":s_month,
          "s_year":s_year,
          "branch_id": user.user?.data?.branchId.toString(),
          "dsf_id":dsf_id
        },

      );
      print("user_id: ${user.user?.data?.userId.toString()}");
      print("login_type: ${user.user?.data?.loginType.toString()}");
      print("user_code: ${user.user?.data?.userCode.toString()}");
      print("s_month: $s_month");
      print( "s_year:$s_year");
      print("branch_id ${user.user?.data?.branchId.toString()}");
      print( "dsf_id:$dsf_id");


      if (response?.statusCode != 200) {
        Constants.customErrorSnack(context, response?.message.toString() ?? "");
        return null;
      }
      print(response?.data);

      return ApiResult.success(data: total_customer_report.fromJson(response!.data));
    }

    catch (e) {
      print("1");
      return ApiResult.failure(error: NetworkExceptions.getDioException(e)!);
    }
  }




  Future<ApiResult<total_uc_report>?> uc_details(
      BuildContext context, String s_month,String s_year,String dsf_id) async {
    try {
      var response = await _apiClient?.postReq(
        "/DsfUCDetail",
        data: {
          "user_id": user.user?.data?.userId.toString(),
          "login_type": user.user?.data?.loginType.toString(),
          "user_code": user.user?.data?.userCode.toString(),
          "s_month":s_month,
          "s_year":s_year,
          "branch_id": user.user?.data?.branchId.toString(),
          "dsf_id":dsf_id
        },

      );
      print("user_id: ${user.user?.data?.userId.toString()}");
      print("login_type: ${user.user?.data?.loginType.toString()}");
      print("user_code: ${user.user?.data?.userCode.toString()}");
      print("s_month: $s_month");
      print( "s_year:$s_year");
      print("branch_id ${user.user?.data?.branchId.toString()}");
      print( "dsf_id:$dsf_id");


      if (response?.statusCode != 200) {
        Constants.customErrorSnack(context, response?.message.toString() ?? "");
        return null;
      }
      print(response?.data);

      return ApiResult.success(data: total_uc_report.fromJson(response!.data));
    }

    catch (e) {
      print("1");
      return ApiResult.failure(error: NetworkExceptions.getDioException(e)!);
    }
  }


















  Future<ApiResult<Request_details_model>?> request_details(
      BuildContext context, String req_date,String customer_code,String dsf_code,String branch_code,) async {
    try {
      var response = await _apiClient?.postReq(
        "/BoosterRequestDetail",
        data: {
          "user_id": user.user?.data?.userId.toString(),
          "login_type": user.user?.data?.loginType.toString(),
          "user_code": user.user?.data?.userCode.toString(),
          "branch_id": user.user?.data?.branchId.toString(),
         "req_date":req_date,
          "customer_code":customer_code,
          "dsf_code":dsf_code,
          "branch_code":branch_code

        },

      );
      print("user_id: ${user.user?.data?.userId.toString()}");
      print("login_type: ${user.user?.data?.loginType.toString()}");
      print("user_code: ${user.user?.data?.userCode.toString()}");
      print("branch_id ${user.user?.data?.branchId.toString()}");
      print("req_date: $req_date");
   print( "customer_code:$customer_code");
   print( "dsf_code:$dsf_code");
   print( "branch_code:$branch_code");

      if (response?.statusCode != 200) {
        Constants.customErrorSnack(context, response?.message.toString() ?? "");
        return null;
      }
      print(response?.data);

      return ApiResult.success(data: Request_details_model.fromJson(response!.data));
    }

    catch (e) {
      print("1");
      return ApiResult.failure(error: NetworkExceptions.getDioException(e)!);
    }
  }


  Future<ApiResult<String>?> request_details_status(
      BuildContext context, String req_date, String customer_code,
      String dsf_code, String branch_code, String request_status,
      String customer_name, String request_id) async {
    try {

      var response = await _apiClient?.postReq(
        "/RequestDetailStatusChange",
        data: {
          "user_id": user.user?.data?.userId.toString(),
          "login_type": user.user?.data?.loginType.toString(),
          "user_code": user.user?.data?.userCode.toString(),
          "branch_id": user.user?.data?.branchId.toString(),
          "req_date": req_date,
          "customer_code": customer_code,
          "dsf_code": dsf_code,
          "branch_code": branch_code,
          "request_status": request_status,
          "customer_name": customer_name,
          "request_id": request_id,
        },
      );

      // Print statements for debugging
      print("user_id: ${user.user?.data?.userId.toString()}");
      // ... (other print statements)

      if (response?.statusCode != 200) {
        Constants.customErrorSnack(context, response?.message.toString() ?? "");
        return null;
      }
      print("response: ${response?.data}");
      if (response?.data['status'] == '200') {
        print("1");
        if (request_status == "Approved") {
          print("Approved");
        } else if (request_status == "Reject") {
          print("Reject");
          print("2");
          Constants.customSuccessSnack(context, "Request is Reject");
        }

      } else {
        print("3");
        Constants.customErrorSnack(context, "Status update failed");
        return null;
      }
    } catch (e) {
      print("Error: $e");
      print("4");
      return ApiResult.failure(error: NetworkExceptions.getDioException(e)!);
    }
  }
  Future<ApiResult<VersionModel>?> version(
      BuildContext context, String token) async {
    try {
      var response = await _apiClient?.postReq(
        "/UpdateToken",
        data: {
          "user_id": user.user?.data?.userId.toString(),
          "login_type": user.user?.data?.loginType.toString(),
          "user_code": user.user?.data?.userCode.toString(),
          "branch_id": user.user?.data?.branchId.toString(),
          "fcm_token":token,
        },
      );

      if (response?.statusCode != 200) {
        Constants.customErrorSnack(context, response?.message.toString() ?? "");
        return null;
      }
      return ApiResult.success(data: VersionModel.fromJson(response!.data));

    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e)!);
    }
  }




  Future<ApiResult<supervisor_customer_report>?> supervisor_customer(
      BuildContext context, String s_month,String s_year,String field_manager_id,) async {
    print("SupervisorCustomerReport");
    print("user_id: ${user.user?.data?.userId.toString()}");
    print("login_type: ${user.user?.data?.loginType.toString()}");
    print("user_code: ${user.user?.data?.userCode.toString()}");
    print( "s_month: $s_month");
    print( "s_year:$s_year");
    print("branch_id ${user.user?.data?.branchId.toString()}");
    print("field_manager_id:$field_manager_id");
    try {
      var response = await _apiClient?.postReq(
        "/SupervisorCustomerReport",

        data: {
          "user_id": user.user?.data?.userId.toString(),
          "login_type": user.user?.data?.loginType.toString(),
          "user_code": user.user?.data?.userCode.toString(),
          "s_month":s_month,
          "s_year":s_year,
          "branch_id": user.user?.data?.branchId.toString(),
          "field_manager_id":field_manager_id
        },

      );
      print("SupervisorCustomerReport");
      print("user_id: ${user.user?.data?.userId.toString()}");
      print("login_type: ${user.user?.data?.loginType.toString()}");
      print("user_code: ${user.user?.data?.userCode.toString()}");
      print( "s_month: $s_month");
      print( "s_year:$s_year");
      print("branch_id ${user.user?.data?.branchId.toString()}");
      print("field_manager_id:$field_manager_id");

      if (response?.statusCode != 200) {
        Constants.customErrorSnack(context, response?.message.toString() ?? "");
        return null;
      }
      print(response?.data);

      return ApiResult.success(data: supervisor_customer_report.fromJson(response!.data));
    }

    catch (e) {
      print("1");
      return ApiResult.failure(error: NetworkExceptions.getDioException(e)!);
    }
  }








}
