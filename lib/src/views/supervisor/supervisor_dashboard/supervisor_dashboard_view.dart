import 'package:flutter/material.dart';
import 'package:premier/src/base/utils/Constants.dart';
import 'package:premier/src/base/utils/utils.dart';
import 'package:premier/src/configs/app_setup.router.dart';
import 'package:premier/src/services/local/navigation_service.dart';
import 'package:premier/src/shared/DSF/dsf_app_screen.dart';
import 'package:premier/src/shared/input_field.dart';
import 'package:premier/src/shared/spacing.dart';
import 'package:premier/src/styles/app_colors.dart';
import 'package:premier/src/styles/text_theme.dart';
import 'package:stacked/stacked.dart';
import 'supervisor_dashboard_view_model.dart';

class SupervisorDashboardView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SupervisorDashboardViewModel>.reactive(
      builder: (context, model, child) => SupervisorAppScreen(
        title: "Supervisor Dashboard",
        body: (model.isBusy)
            ? Center(
                child: CircularProgressIndicator(
                  color: AppColors.primary,
                ),
              )
            : RefreshIndicator(
                onRefresh: () {
                  return Future.delayed(Duration.zero, () {
                    model.init(context);
                  });
                },
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      VerticalSpacing(10),
                      if (model.authService.user?.data?.Issupervisor == "1")
                        CustomDropDown(
                          value: (model.selectedBranch == -1)
                              ? null
                              : model.allBranches[model.selectedBranch]
                                      .branchName ??
                                  "",
                          width: context.screenSize().width * 0.6,
                          items: model.allBranches.map((items) {
                            return items.branchName.toString();
                          }).toList(),
                          onChanged: (String? newValue) {
                            model.selectedBranch = model.allBranches.indexWhere(
                                (element) => element.branchName == newValue);
                            model.getData(context,
                                branchId: model
                                    .allBranches[model.selectedBranch].branchId
                                    .toString());
                            model.notifyListeners();
                          },
                        ),
                      if (model.authService.user?.data?.Issupervisor == "1")
                        VerticalSpacing(10),
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withOpacity(0.1),
                              offset: Offset(0, 0),
                              blurRadius: 5,
                            )
                          ],
                        ),
                        width: context.screenSize().width - 40,
                        height: 100,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              model.data?.totalOrders.toString() ?? "0",
                              style: TextStyling.extraLargeBold.copyWith(
                                  color: AppColors.white, fontSize: 36),
                              textAlign: TextAlign.center,
                            ),
                            VerticalSpacing(),
                            Text(
                              "Total Orders",
                              style: TextStyling.largeBold
                                  .copyWith(color: AppColors.white),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                      GridView.builder(
                        shrinkWrap: true,
                        itemCount: model.cardData.length,
                        padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                        physics: NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 5,
                            mainAxisSpacing: 5,
                            childAspectRatio: 1),
                        itemBuilder: (BuildContext context, int index) {
                          NewCardData _data = model.cardData[index];
                          return InkWell(
                            splashColor: Colors.transparent,
                            onTap: () {
                              if (model.authService.user?.data?.Issupervisor ==
                                  "1") {
                                if (model.selectedBranch != -1) {

                                  NavService.pendingOrder(
                                      arguments: PendingOrderViewArguments(
                                    data: _data,
                                    branchId: model.allBranches[model.selectedBranch].branchId.toString(),
                                  )
                                  );
                                } else {
                                  Constants.customWarningSnack(
                                      context,
                                      "Please Select atLeast 1 Branch from DropDown List"
                                  );
                                }
                              } else {

                                NavService.pendingOrder(
                                    arguments:
                                        PendingOrderViewArguments(data: _data)
                                );
                              }
                            },
                            child: Card(
                              color: _data.color.withOpacity(0.8),
                              child: Stack(
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: context.screenSize().width,
                                        height: 1,
                                      ),
                                      Text(
                                        _data.value,
                                        style: TextStyling.extraLargeBold
                                            .copyWith(color: AppColors.white),
                                        textAlign: TextAlign.center,
                                      ),
                                      VerticalSpacing(),
                                      Text(
                                        _data.name,
                                        style: TextStyling.mediumBold
                                            .copyWith(color: AppColors.white),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                  Positioned(
                                      bottom: 5,
                                      right: 5,
                                      child: Icon(
                                        Icons.forward_outlined,
                                        color: AppColors.white,
                                      )),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                      InkWell(
                        onTap: () {
                          NavService.allSupervisorMap();
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.secondary.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary.withOpacity(0.1),
                                offset: Offset(0, 0),
                                blurRadius: 5,
                              )
                            ],
                          ),
                          width: context.screenSize().width * 0.6,
                          height: 40,
                          child: Center(
                              child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Track SalesMan",
                                style: TextStyling.mediumBold
                                    .copyWith(color: AppColors.white),
                                textAlign: TextAlign.center,
                              ),
                              HorizontalSpacing(),
                              Icon(
                                Icons.location_on_outlined,
                                color: AppColors.white,
                              ),
                            ],
                          )),
                        ),
                      ),
                      VerticalSpacing(20),
                    ],
                  ),
                ),
              ),
      ),
      viewModelBuilder: () => SupervisorDashboardViewModel(),
      onModelReady: (model) => model.init(context),
    );
  }
}
