import 'package:flutter/cupertino.dart';
import 'package:premier/src/models/geo_coordinates/geo_coordinates.dart';
import 'package:stacked/stacked.dart';

import '../../base/utils/Constants.dart';
import '../../models/supervisor/supervisor_order_model.dart';
import '../../services/local/base/auth_view_model.dart';
import '../../services/remote/base/api_view_model.dart';

class Geo_coordinateds_view_model extends ReactiveViewModel
    with AuthViewModel, ApiViewModel {
  TextEditingController searchController = TextEditingController();
  List<geo_coordinates_data> geo_data = [];
  List<geo_coordinates_data> all_geo_data = [];
  String searchQuery = "";
  init(BuildContext context) async {
    await getdata(context);
    notifyListeners();
  }
  search() {
    if (searchQuery.isEmpty) {
      // If the search query is empty, reset the list to the original data
      geo_data = List.from(all_geo_data);
    } else {
      // If there is a search query, filter the list based on the criteria
      geo_data = all_geo_data.where(
            (element) =>
        (element.dsf_code?.toLowerCase().contains(
          searchQuery.toLowerCase(),
        ) ??
            false) ||
            (element.dsf_name?.toLowerCase().contains(searchQuery) ?? false) ||
            (element.customer_code?.toLowerCase().contains(
              searchQuery.toLowerCase(),
            ) ??
                false) ||
            (element.customer_name?.toLowerCase().contains(searchQuery) ?? false),
      ).toList();
    }

    notifyListeners();
  }


  getdata(BuildContext context) async {
    var newsResponse = await runBusyFuture(apiService.geo_coordinate(context));
    newsResponse?.when(success: (data) async {
      if ((data.data?.length ?? 0) > 0) {
        geo_data = data.data?.toList() ?? [];
        all_geo_data = List.from(geo_data);
      } else {
        Constants.customWarningSnack(context, "Data not found");
      }
    }, failure: (error) {
      Constants.customErrorSnack(context, error.toString());
    });
  }






}