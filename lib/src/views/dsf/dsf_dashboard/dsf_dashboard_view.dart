import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:premier/src/base/utils/constants.dart';
import 'package:premier/src/base/utils/utils.dart';
import 'package:premier/src/configs/app_setup.router.dart';
import 'package:premier/src/models/DSF/get_all_dsf_model.dart';
import 'package:premier/src/services/local/navigation_service.dart';
import 'package:premier/src/shared/DSF/company_table_data.dart';
import 'package:premier/src/shared/DSF/dsf_app_screen.dart';
import 'package:premier/src/shared/DSF/pie_chart.dart';
import 'package:premier/src/shared/input_field.dart';
import 'package:premier/src/shared/spacing.dart';
import 'package:premier/src/styles/app_colors.dart';
import 'package:premier/src/styles/text_theme.dart';
import 'package:stacked/stacked.dart';
import 'dsf_dashboard_view_model.dart';

class DSFView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<DSFViewModel>.reactive(
      builder: (context, model, child) => DSFaAppScreen(
        title: "DSF Dashboard",
        body: (model.isBusy)
            ? Center(
                child: CircularProgressIndicator(
                color: AppColors.primary,
              ))
            : Column(
                children: [
                  VerticalSpacing(10),
                  if (model.authService.user?.data?.Issupervisor == "1")
                    CustomDropDown(
                      value: (model.selectedDsf == -1)
                          ? null
                          : model.allDsf[model.selectedDsf].dsfName ?? "",
                      width: context.screenSize().width * 0.6,
                      items: model.allDsf.map((items) {
                        return items.dsfName.toString();
                      }).toList(),
                      onChanged: (String? newValue) async {
                        model.selectedDsf = model.allDsf.indexWhere(
                            (element) => element.dsfName == newValue);
                        AllDsfModelData _data = model.allDsf[model.selectedDsf];
                        model.getCancelCustomerData(context, "", "",
                            id: _data.dsfId,
                            type: _data.userType,
                            code: _data.dsfCode);
                        model.getExecutedCustomerData(context, "", "",
                            id: _data.dsfId,
                            type: _data.userType,
                            code: _data.dsfCode);
                        model.getPendingCustomerData(context, "", "",
                            id: _data.dsfId,
                            type: _data.userType,
                            code: _data.dsfCode);
                        model.setBusy(true);
                        await model.getData(context, "", "",
                            id: _data.dsfId,
                            type: _data.userType,
                            code: _data.dsfCode);
                        model.setBusy(false);
                        model.notifyListeners();
                      },
                    ),
                  if (model.authService.user?.data?.Issupervisor == "1")
                    VerticalSpacing(10),
                  InkWell(
                    splashColor: Colors.transparent,
                    onTap: () {
                      if (model.authService.user?.data?.Issupervisor == "1") {
                        if (model.selectedDsf != -1) {
                          NavService.dSFBookingDetail(
                              arguments: DSFBookingDetailViewArguments(
                                  data: model.allDsf[model.selectedDsf]));
                        } else {
                          Constants.customWarningSnack(context,
                              "Please Select atLeast 1 DSF from DropDown List");
                        }
                      } else {
                        NavService.dSFBookingDetail();
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(color: AppColors.primary),
                      padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Total Booking amount",
                                style: TextStyling.mediumBold
                                    .copyWith(color: AppColors.white),
                              ),
                              Text(
                                "Date: ${DateFormat("yyyy-MM-dd").format(DateTime.now())}",
                                style: TextStyling.mediumBold
                                    .copyWith(color: AppColors.white),
                              ),
                            ],
                          ),
                          VerticalSpacing(10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Rs.${model.dashboardData.todayBooking.toString()}",
                                style: TextStyling.largeBold
                                    .copyWith(color: AppColors.white),
                              ),
                              Icon(
                                Icons.next_plan_outlined,
                                color: AppColors.white,
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    height: (model.authService.user?.data?.Issupervisor == "1")
                        ? context.screenSize().height - 280
                        : context.screenSize().height - 210,
                    padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          VerticalSpacing(10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              MainInputField(
                                label: "From Date",
                                hint: "Select Date",
                                controller: model.fromDate,
                                error: "please select from date",
                                width: context.screenSize().width * 0.4,
                                inputType: TextInputType.datetime,
                                readOnly: true,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: (model.fromDate.text == "")
                                          ? AppColors.secondary
                                          : AppColors.primary),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                onTap: () {
                                  showDatePicker(
                                    context: context,
                                    initialDate: DateTime.parse(
                                        "${model.fromDate.text}"),
                                    firstDate: DateTime(2023, 2, 1),
                                    lastDate: DateTime(2050, 1, 31),
                                  ).then((value) {
                                    if (value != null) {
                                      if (model.toDateFormat?.isBefore(value) ??
                                          false) {
                                        model.toDateFormat = null;
                                        model.toDate.text = "";
                                      }
                                      model.fromDateFormat = value;
                                      String date = DateFormat("yyyy-MM-dd")
                                          .format(value);
                                      model.fromDate.text = date.toString();
                                      if (model.toDateFormat != null) {
                                        model.update(context,
                                            "${model.fromDate.text}", "");
                                      }
                                      model.notifyListeners();
                                    } else {
                                      model.toDateFormat = null;
                                      model.toDate.text = "";
                                      model.fromDateFormat = null;
                                      model.fromDate.text = "";
                                      model.update(context,
                                          "${model.fromDate.text}", "");
                                    }
                                  });
                                },
                              ),
                              MainInputField(
                                label: "To Date",
                                hint: "Select Date",
                                controller: model.toDate,
                                error: "please select to date",
                                width: context.screenSize().width * 0.4,
                                inputType: TextInputType.datetime,
                                readOnly: true,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: (model.toDate.text == "")
                                          ? AppColors.secondary
                                          : AppColors.primary),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                onTap: () {
                                  if (model.fromDateFormat != null) {
                                    showDatePicker(
                                      context: context,
                                      initialDate: model.toDateFormat ??
                                          model.fromDateFormat!,
                                      firstDate: model.fromDateFormat!,
                                      lastDate: DateTime(2050, 1, 31),
                                    ).then((value) {
                                      if (value != null) {
                                        model.toDateFormat = value;
                                        String date = DateFormat("yyyy-MM-dd")
                                            .format(value);
                                        model.toDate.text = date.toString();
                                        model.update(
                                            context,
                                            "${model.fromDate.text}",
                                            "${model.toDate.text}");
                                        model.notifyListeners();
                                      } else {
                                        model.toDateFormat = null;
                                        model.toDate.text = "";
                                      }
                                    });
                                  } else {
                                    Constants.customWarningSnack(context,
                                        'please select "From Date" before "To Date" selection');
                                  }
                                },
                              ),
                            ],
                          ),
                          VerticalSpacing(10),
                          PieCharNew(
                            dataMap: model.dataMap,
                          ),
                          VerticalSpacing(10),
                          GridView.builder(
                            shrinkWrap: true,
                            itemCount: model.statisticData.length,
                            padding: EdgeInsets.zero,
                            physics: BouncingScrollPhysics(),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 10,
                                    mainAxisSpacing: 10,
                                    childAspectRatio: 1.8),
                            itemBuilder: (BuildContext context, int index) {
                              return InkWell(
                                splashColor: Colors.transparent,
                                onTap: () {
                                  if (model.authService.user?.data
                                          ?.Issupervisor ==
                                      "1") {
                                    if (model.selectedDsf != -1) {
                                      if (model.isBusy == false) {
                                        if (index < 2) {
                                          NavService.dsfDetailTable(
                                              arguments:
                                                  DsfDetailTableViewArguments(
                                                      title:
                                                          "Executed Customers",
                                                      heading:
                                                          model.executedHeading,
                                                      data: model.executedData,
                                                      totalInv: model
                                                          .executedInvTotal,
                                                      totalAmount: model
                                                          .executedAmountTotal));
                                        } else if (index < 4) {
                                          NavService.dsfDetailTable(
                                              arguments:
                                                  DsfDetailTableViewArguments(
                                                      title:
                                                          "Cancelled Customers",
                                                      heading:
                                                          model.canceledHeading,
                                                      data: model.canceledData,
                                                      totalInv: model
                                                          .canceledInvTotal,
                                                      totalAmount: model
                                                          .canceledAmountTotal));
                                        } else {
                                          NavService.dsfDetailTable(
                                              arguments:
                                                  DsfDetailTableViewArguments(
                                                      title:
                                                          "Pending Customers",
                                                      heading:
                                                          model.pendingHeading,
                                                      data: model.pendingData,
                                                      totalInv:
                                                          model.pendingInvTotal,
                                                      totalAmount: model
                                                          .pendingAmountTotal));
                                        }
                                      }
                                    } else {
                                      Constants.customWarningSnack(context,
                                          "Please Select atLeast 1 DSF from DropDown List");
                                    }
                                  } else {
                                    if (model.isBusy == false) {
                                      if (index < 2) {
                                        NavService.dsfDetailTable(
                                            arguments:
                                                DsfDetailTableViewArguments(
                                                    title: "Executed Customers",
                                                    heading:
                                                        model.executedHeading,
                                                    data: model.executedData,
                                                    totalInv:
                                                        model.executedInvTotal,
                                                    totalAmount: model
                                                        .executedAmountTotal));
                                      } else if (index < 4) {
                                        NavService.dsfDetailTable(
                                            arguments:
                                                DsfDetailTableViewArguments(
                                                    title:
                                                        "Cancelled Customers",
                                                    heading:
                                                        model.canceledHeading,
                                                    data: model.canceledData,
                                                    totalInv:
                                                        model.canceledInvTotal,
                                                    totalAmount: model
                                                        .canceledAmountTotal));
                                      } else {
                                        NavService.dsfDetailTable(
                                            arguments:
                                                DsfDetailTableViewArguments(
                                                    title: "Pending Customers",
                                                    heading:
                                                        model.pendingHeading,
                                                    data: model.pendingData,
                                                    totalInv:
                                                        model.pendingInvTotal,
                                                    totalAmount: model
                                                        .pendingAmountTotal));
                                      }
                                    }
                                  }
                                },
                                child: Card(
                                  color: (index < 2)
                                      ? AppColors.primary.withOpacity(0.1)
                                      : (index < 4)
                                          ? AppColors.red.withOpacity(0.1)
                                          : AppColors.boxdsf.withOpacity(0.1),
                                  shadowColor: (index < 2)
                                      ? AppColors.primary.withOpacity(0.1)
                                      : (index < 4)
                                          ? AppColors.red.withOpacity(0.1)
                                          : AppColors.boxdsf.withOpacity(0.1),
                                  elevation: 5,
                                  child: Padding(
                                    padding:
                                        EdgeInsets.fromLTRB(10, 10, 10, 10),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        FittedBox(
                                            child: Text(
                                          model.statisticData[index].title,
                                          style: TextStyling.mediumBold
                                              .copyWith(
                                                  color: AppColors.primary),
                                        )),
                                        FittedBox(
                                            child: Text(
                                          model.statisticData[index].value,
                                          style: TextStyling.mediumRegular
                                              .copyWith(
                                                  color: AppColors.primary),
                                        )),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                          VerticalSpacing(10),
                          CompanyDataTable(
                            heading: model.heading,
                            data: model.companyData,
                            onTap: (int value) {},
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                flex: 3,
                                child: Text(
                                  "Grand Total:",
                                  style: TextStyling.largeBold
                                      .copyWith(color: AppColors.primary),
                                  textAlign: TextAlign.start,
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Text(
                                  "",
                                  style: TextStyling.mediumBold
                                      .copyWith(color: AppColors.primary),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: Text(
                                  "Rs.${model.dashboardData.companyAmountTotal.toString()}/-",
                                  style: TextStyling.mediumBold
                                      .copyWith(color: AppColors.primary),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            decoration: BoxDecoration(
                              border: Border.symmetric(
                                horizontal: BorderSide(
                                    color: AppColors.secondary, width: 2),
                              ),
                            ),
                            height: 8,
                            margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
      ),
      viewModelBuilder: () => DSFViewModel(),
      onModelReady: (model) => model.init(context),
    );
  }
}
