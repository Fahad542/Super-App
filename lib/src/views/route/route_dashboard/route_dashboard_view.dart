import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:premier/generated/assets.dart';
import 'package:premier/src/base/utils/constants.dart';
import 'package:premier/src/base/utils/utils.dart';
import 'package:premier/src/configs/app_setup.router.dart';
import 'package:premier/src/models/ROUTES/all_salesman_model.dart';
import 'package:premier/src/services/local/navigation_service.dart';
import 'package:premier/src/shared/DSF/dsf_app_screen.dart';
import 'package:premier/src/shared/buttons.dart';
import 'package:premier/src/shared/input_field.dart';
import 'package:premier/src/shared/spacing.dart';
import 'package:premier/src/styles/app_colors.dart';
import 'package:premier/src/styles/text_theme.dart';
import 'package:stacked/stacked.dart';

import 'route_dashboard_view_model.dart';

class RouteView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<RouteViewModel>.reactive(
      builder: (context, model, child) => DSFaAppScreen(
        title: "Route Dashboard",
        body: (model.isBusy)
            ? Center(
                child: CircularProgressIndicator(
                  color: AppColors.primary,
                ),
              )
            : SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  children: [
                    VerticalSpacing(10),
                    if (model.authService.user?.data?.Issupervisor == "1")
                      CustomDropDown(
                        value: (model.selectedSalesman == -1)
                            ? null
                            : model.allSalesMan[model.selectedSalesman]
                                    .salesmanName ??
                                "",
                        width: context.screenSize().width * 0.6,
                        items: model.allSalesMan.map((items) {
                          return items.salesmanName.toString();
                        }).toList(),
                        onChanged: (String? newValue) async {
                          model.selectedSalesman = model.allSalesMan.indexWhere(
                              (element) => element.salesmanName == newValue);
                          AllSalesManModelData _data =
                              model.allSalesMan[model.selectedSalesman];
                          await model.getDSFOrders(context,
                              code: _data.salesmanCode.toString());
                        },
                      ),
                    if (model.authService.user?.data?.Issupervisor == "1")
                      VerticalSpacing(10),
                    Container(
                      decoration: BoxDecoration(color: AppColors.primary),
                      padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              RichText(
                                text: TextSpan(
                                  text: "Shops: ",
                                  style: TextStyling.mediumBold
                                      .copyWith(color: AppColors.white),
                                  children: [
                                    TextSpan(
                                      text: model.shops,
                                      style: TextStyling.mediumBold
                                          .copyWith(color: AppColors.white),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                "Date: ${DateFormat("dd/MM/yyyy").format(DateTime.now())}",
                                style: TextStyling.mediumBold
                                    .copyWith(color: AppColors.white),
                              ),
                            ],
                          ),
                          VerticalSpacing(10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              RichText(
                                text: TextSpan(
                                  text: "Total Amount: ",
                                  style: TextStyling.mediumBold
                                      .copyWith(color: AppColors.white),
                                  children: [
                                    TextSpan(
                                      text: "Rs.${model.amount}",
                                      style: TextStyling.mediumBold
                                          .copyWith(color: AppColors.white),
                                    ),
                                  ],
                                ),
                              ),
                              InkWell(
                                  onTap: () {
                                    if (model.data.length > 0) {
                                      NavService.allRouteMap(
                                          arguments: AllRouteMapViewArguments(
                                              routesData: model.data));
                                    } else {
                                      Constants.customWarningSnack(
                                          context, "you cant have data");
                                    }
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: AppColors.white,
                                        borderRadius: BorderRadius.circular(5)),
                                    padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                                    child: Text(
                                      "View All Store",
                                      style: TextStyling.smallBold
                                          .copyWith(color: AppColors.primary),
                                    ),
                                  ))
                            ],
                          ),
                        ],
                      ),
                    ),
                    VerticalSpacing(10),
                    Text(
                      "Summery",
                      style: TextStyling.largeBold
                          .copyWith(color: AppColors.primary),
                    ),
                    VerticalSpacing(10),
                    Container(
                      height:
                          (model.authService.user?.data?.Issupervisor == "1")
                              ? context.screenSize().height - 320
                              : context.screenSize().height - 250,
                      child: ListView.builder(
                        itemCount: model.data.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          RoutesData _data = model.data[index];
                          return Container(
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              boxShadow: AppColors.primaryBoxShadow,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            margin: EdgeInsets.fromLTRB(20, 5, 20, 10),
                            padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                            child: Column(
                              children: [
                                InkWell(
                                  onTap: () {
                                    NavService.routeMap(
                                        arguments: RouteMapViewArguments(
                                            routesData: _data));
                                  },
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              _data.name,
                                              style: TextStyling.mediumBold
                                                  .copyWith(
                                                      color: AppColors.primary,
                                                      decoration: TextDecoration
                                                          .underline),
                                            ),
                                          ),
                                          Container(
                                              decoration: BoxDecoration(
                                                color: AppColors.primary,
                                                shape: BoxShape.circle,
                                              ),
                                              height: 20,
                                              width: 20,
                                              child: Center(
                                                child: Text(
                                                  _data.seq.toString(),
                                                  style: TextStyling.smallBold
                                                      .copyWith(
                                                          color:
                                                              AppColors.white),
                                                ),
                                              )),
                                        ],
                                      ),
                                      VerticalSpacing(5),
                                      Text(
                                        _data.address,
                                        style: TextStyling.smallRegular
                                            .copyWith(color: AppColors.primary),
                                      ),
                                      VerticalSpacing(10),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          RichText(
                                            text: TextSpan(
                                              text: "Amount: ",
                                              style: TextStyling.mediumBold
                                                  .copyWith(
                                                      color:
                                                          AppColors.secondary),
                                              children: [
                                                TextSpan(
                                                  text: "Rs.${_data.amount}",
                                                  style: TextStyling.mediumBold
                                                      .copyWith(
                                                          color: AppColors
                                                              .primary),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Spacer(),
                                          Text(
                                            "View Map",
                                            style: TextStyling.mediumRegular
                                                .copyWith(
                                                    color: AppColors.secondary),
                                          ),
                                          Icon(
                                            Icons.location_on_outlined,
                                            size: 24,
                                            color: AppColors.secondary,
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                VerticalSpacing(10),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        model.launchWhatsapp(
                                            context, _data.mobile);
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: AppColors.green,
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            border: Border.all(
                                                color: Colors.green)),
                                        height: 40,
                                        width: context.screenSize().width * 0.4,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Image.asset(
                                              Assets.imagesWhatsappLogo,
                                              color: AppColors.white,
                                              height: 30,
                                              width: 30,
                                            ),
                                            HorizontalSpacing(10),
                                            Text(
                                              "WhatsApp",
                                              style: TextStyling.smallBold
                                                  .copyWith(
                                                      color: AppColors.white),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        model.launchCall(context, _data.mobile);
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: Colors.indigoAccent,
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            border: Border.all(
                                                color: Colors.indigo)),
                                        height: 40,
                                        width: context.screenSize().width * 0.4,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.phone,
                                              color: AppColors.white,
                                            ),
                                            HorizontalSpacing(10),
                                            Text(
                                              "Call",
                                              style: TextStyling.mediumBold
                                                  .copyWith(
                                                      color: AppColors.white),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
      ),
      viewModelBuilder: () => RouteViewModel(),
      onModelReady: (model) => model.init(context),
    );
  }
}
