import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:premier/src/base/utils/utils.dart';
import 'package:premier/src/configs/app_setup.router.dart';
import 'package:premier/src/models/supervisor/supervisor_order_model.dart';
import 'package:premier/src/services/local/navigation_service.dart';
import 'package:premier/src/services/remote/api_service.dart';
import 'package:premier/src/shared/DSF/dsf_app_screen.dart';
import 'package:premier/src/shared/input_field.dart';
import 'package:premier/src/shared/spacing.dart';
import 'package:premier/src/styles/app_colors.dart';
import 'package:premier/src/styles/text_theme.dart';
import 'package:premier/src/views/supervisor/supervisor_dashboard/supervisor_dashboard_view_model.dart';
import 'package:stacked/stacked.dart';
import 'package:url_launcher/url_launcher.dart';
import 'panding_order_view_model.dart';

class PendingOrderView extends StatefulWidget {
  final NewCardData data;
  final String? branchId;

  const PendingOrderView({Key? key, required this.data, this.branchId})
      : super(key: key);

  @override
  State<PendingOrderView> createState() => _PendingOrderViewState();
}

class _PendingOrderViewState extends State<PendingOrderView> {
  @override


  Widget build(BuildContext context) {

    return ViewModelBuilder<PendingOrderViewModel>.reactive(
      builder: (context, model, child) => SupervisorAppScreen(

        title: widget.data.name,
        body:

        model.isLoading==true?
        Center(
          child: Container(
            child: SizedBox(
              height: 40,
              width: 40,
              child: CircularProgressIndicator(color: AppColors.primary,),
            ),
          ),
        ):Stack(
          children: [

            SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.fromLTRB(20, 0, 20, 10),
                child: Column(
                  children: [
                    VerticalSpacing(10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SecondInputField(
                          label: 'From Date',
                          hint: 'Select From Date',
                          controller: model.fromDate,
                          inputType: TextInputType.datetime,
                          width: context.screenSize().width * 0.4,
                          onTap: () async {
                            DateTime? pickedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2022),
                                lastDate: DateTime(2100));

                            if (pickedDate != null) {
                              model.toDateFormat = pickedDate;
                              String formattedDate =
                                  DateFormat('yyyy-MM-dd').format(pickedDate);
                              model.fromDate.text = formattedDate;
                              model.getData(context, branchId: "${widget.branchId}");
                            } else {}
                          },
                          message: 'Please select from Date',
                          prefixIcon: Icon(
                            Icons.calendar_month,
                            color: AppColors.primary,
                            size: 24,
                          ),
                        ),
                        SecondInputField(
                          label: 'To Date',
                          hint: 'Select To Date',
                          controller: model.toDate,
                          inputType: TextInputType.datetime,
                          width: context.screenSize().width * 0.4,
                          onTap: () async {
                            DateTime? pickedDate = await showDatePicker(
                                context: context,
                                initialDate: model.toDateFormat,
                                firstDate: DateTime(2022),
                                lastDate: DateTime(2100));

                            if (pickedDate != null) {
                              String formattedDate =
                                  DateFormat('yyyy-MM-dd').format(pickedDate);
                              model.toDate.text = formattedDate;
                              model.getData(context, branchId: "${widget.branchId}");
                            } else {}
                          },
                          message: 'Please select to date',
                          prefixIcon: Icon(
                            Icons.calendar_month,
                            color: AppColors.primary,
                            size: 24,
                          ),
                        ),
                      ],
                    ),
                    VerticalSpacing(10),
                    SearchField(
                      label: "",
                      hint: 'Enter Order Number or Brick Name',
                      controller: model.searchController,
                      onSearch: (val) {
                        model.search();
                      },
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.primary),
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    VerticalSpacing(10),
                    (model.isBusy)
                        ? Center(
                            child: CircularProgressIndicator(
                              color: AppColors.primary,
                            ),
                          )
                        : (model.ordersData.length > 0)
                            ? ListView.builder(
                                itemCount: model.ordersData.length,
                                shrinkWrap: true,
                                physics: BouncingScrollPhysics(),
                                padding: EdgeInsets.zero,
                                itemBuilder: (context, index) {
                                  SupervisorOrderModelData _data =
                                      model.ordersData[index];
                                  return PendingOrderCard(
                                    model: model,
                                    data: _data,
                                    index: index,
                                    onTap: () {
                                      NavService.orderDetail(
                                          arguments: OrderDetailViewArguments(
                                              data: _data));
                                    },
                                  );
                                },
                              )
                            : Text(
                                "Data Not Found",
                                style: TextStyling.mediumBold.copyWith(
                                    color: AppColors.grey,
                                    fontStyle: FontStyle.italic),
                              ),
                    VerticalSpacing(40),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.primary,
                ),
                height: 50,
                width: context.screenSize().width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      "Orders: ${model.ordersData.length}",
                      style: TextStyling.mediumBold
                          .copyWith(color: AppColors.white),
                    ),
                    Text(
                      "Amount: Rs.${(model.ordersData.length > 0) ? model.ordersData.map((e) => int.parse(e.orderAmount.toString())).reduce((a, b) => a + b) : 0}",
                      style: TextStyling.mediumBold
                          .copyWith(color: AppColors.white),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
      viewModelBuilder: () => PendingOrderViewModel(widget.data, widget.branchId),
      onModelReady: (model) => model.init(context),
    );
  }
}

showPendingConfirmation(
    BuildContext ctx, PendingOrderViewModel model, String id) {
  showDialog(
      context: ctx,
      barrierDismissible: false,
      barrierColor: AppColors.primary.withOpacity(0.2),
      builder: (context) {
        return Center(
          child: Material(
            elevation: 5,
            borderRadius: BorderRadius.circular(10),
            child: Container(
              decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                        color: AppColors.primary.withOpacity(0.2),
                        offset: Offset(0, 0),
                        blurRadius: 30)
                  ]),
              height: 150,
              width: context.screenSize().width * 0.8,
              padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Icon(
                    Icons.done_outline,
                    color: AppColors.primary,
                  ),
                  Text(
                    "Are you Sure to Confirm or Cancel this Order?",
                    style: TextStyling.mediumRegular
                        .copyWith(color: AppColors.primary),
                    textAlign: TextAlign.center,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        splashColor: Colors.transparent,
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.yellow,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          height: 40,
                          width: context.screenSize().width * 0.23,
                          child: Center(
                              child: Text(
                            "Close",
                            style: TextStyling.mediumBold
                                .copyWith(color: AppColors.white),
                          )),
                        ),
                      ),
                      InkWell(
                        splashColor: Colors.transparent,
                        onTap: () {
                          Navigator.pop(context);
                          showCancelReason(ctx, model, id);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.red,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          height: 40,
                          width: context.screenSize().width * 0.23,
                          child: Center(
                              child: Text(
                            "Cancel",
                            style: TextStyling.mediumBold
                                .copyWith(color: AppColors.white),
                          )),
                        ),
                      ),
                      InkWell (
                        splashColor: Colors.transparent,
                        onTap: () {

                          model.orderConfirmation(ctx, id);
                          Navigator.pop(context);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.secondary,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          height: 40,
                          width: context.screenSize().width * 0.23,
                          child: Center(
                              child: Text(
                            "Confirm",
                            style: TextStyling.mediumBold
                                .copyWith(color: AppColors.white),
                          )),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      });
}

showCancelReason(BuildContext ctx, PendingOrderViewModel model, String id) {
  showDialog(
      context: ctx,
      barrierDismissible: false,
      barrierColor: AppColors.primary.withOpacity(0.2),
      builder: (context) {
        return StatefulBuilder(builder: (_, setState) {
          return Center(
            child: Material(
              elevation: 5,
              borderRadius: BorderRadius.circular(10),
              child: Container(
                decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                          color: AppColors.primary.withOpacity(0.2),
                          offset: Offset(0, 0),
                          blurRadius: 30)
                    ]),
                height: context.screenSize().height * 0.5,
                width: context.screenSize().width * 0.8,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    VerticalSpacing(10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Select Reason",
                          style: TextStyling.largeBold.copyWith(
                              color: AppColors.primary,
                              decoration: TextDecoration.underline),
                        ),
                      ],
                    ),
                    VerticalSpacing(10),
                    Expanded(
                      child: ListView.builder(
                          itemCount: model.reasons.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                setState(() {
                                  model.selectedReasons = model.reasons[index];
                                  model.notifyListeners();
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    color: (model.selectedReasons ==
                                            model.reasons[index])
                                        ? AppColors.primary
                                        : AppColors.white),
                                padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                                child: Text(
                                  model.reasons[index].reason.toString(),
                                  style: TextStyling.mediumBold.copyWith(
                                      color: (model.selectedReasons ==
                                              model.reasons[index])
                                          ? AppColors.white
                                          : AppColors.primary),
                                ),
                              ),
                            );
                          }),
                    ),
                    VerticalSpacing(10),
                    InkWell(
                      splashColor: Colors.transparent,
                      onTap: () {
                        if (model.selectedReasons != null) {
                          model.orderCancellation(ctx, id);
                          Navigator.pop(context);
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.red,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        height: 40,
                        width: context.screenSize().width * 0.4,
                        child: Center(
                            child: Text(
                          "Cancel Order",
                          style: TextStyling.mediumBold
                              .copyWith(color: AppColors.white),
                        )),
                      ),
                    ),
                    VerticalSpacing(10),
                  ],
                ),
              ),
            ),
          );
        });
      }
      );
}

showAddRemarks(BuildContext ctx, PendingOrderViewModel model, String id) {
  showDialog(
      context: ctx,
      barrierDismissible: false,
      barrierColor: AppColors.primary.withOpacity(0.2),
      builder: (context) {
        return StatefulBuilder(builder: (_, setState) {
          return Center(
            child: Material(
              elevation: 5,
              borderRadius: BorderRadius.circular(10),
              child: Container(
                decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                          color: AppColors.primary.withOpacity(0.2),
                          offset: Offset(0, 0),
                          blurRadius: 30)
                    ]),
                width: context.screenSize().width * 0.8,
                padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    VerticalSpacing(10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Add Remarks",
                          style: TextStyling.largeBold.copyWith(
                              color: AppColors.primary,
                              decoration: TextDecoration.underline),
                        ),
                      ],
                    ),
                    VerticalSpacing(10),
                    TextFormField(
                      controller: model.remarks,
                      maxLines: 10,
                      minLines: 10,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          filled: true,
                          fillColor: AppColors.lightGrey.withOpacity(0.2),
                          hintText: "Enter Remarks",
                          hintStyle: TextStyling.mediumRegular
                              .copyWith(color: AppColors.darkGrey)),
                    ),
                    VerticalSpacing(10),
                    InkWell(
                      splashColor: Colors.transparent,
                      onTap: () {
                        model.addRemarks(ctx, id);
                        model.remarks.clear();
                        Navigator.pop(context);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        height: 40,
                        width: context.screenSize().width * 0.4,
                        child: Center(
                            child: Text(
                          "Add",
                          style: TextStyling.mediumBold
                              .copyWith(color: AppColors.white),
                        )),
                      ),
                    ),
                    VerticalSpacing(10),
                  ],
                ),
              ),
            ),
          );
        });
      });
}

class PendingOrderCard extends StatefulWidget {
  final SupervisorOrderModelData data;
  final PendingOrderViewModel model;
  final int index;
  final Function onTap;

  const PendingOrderCard(
      {Key? key,
      required this.model,
      required this.data,
      required this.index,
      required this.onTap})
      : super(key: key);

  @override
  State<PendingOrderCard> createState() => _PendingOrderCardState();
}

class _PendingOrderCardState extends State<PendingOrderCard> {
  @override
  Widget build(BuildContext context) {
   // DateTime selectedDate = DateTime.now();
    ApiService api=ApiService();
    return GestureDetector(
      onTap: () {
        widget.onTap();
      },
      child:
      Card(
        color: AppColors.white,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.primary.withOpacity(0.8)),
            borderRadius: BorderRadius.circular(10),
          ),
          width: context.screenSize().width,
          padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Id: ${widget.data.orderId.toString()}",
                    style: TextStyling.smallBold.copyWith(color: AppColors.red),
                  ),
                  Text(
                    widget.data.orderDate?.replaceRange(10, 22, "").toString() ?? "",
                    style: TextStyling.mediumBold
                        .copyWith(color: AppColors.primary),
                  ),
                ],
              ),
              VerticalSpacing(10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: context.screenSize().width * 0.5,
                    child: Text(widget.data.customerName.toString(),
                        style: TextStyling.mediumBold
                            .copyWith(color: AppColors.primary)),
                  ),
                  Text("Rs.${widget.data.orderAmount.toString()}/-",
                      style: TextStyling.mediumBold
                          .copyWith(color: AppColors.green)),
                ],
              ),
              VerticalSpacing(10),
              RichText(
                text: TextSpan(
                    text: "Area: ",
                    style: TextStyling.smallRegular
                        .copyWith(color: AppColors.darkGrey),
                    children: [
                      TextSpan(
                        text: widget.data.brickName.toString(),
                        style: TextStyling.smallBold
                            .copyWith(color: AppColors.primary),
                      )
                    ]),
              ),
              VerticalSpacing(10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RichText(
                    text: TextSpan(
                        text: "Delivery On: ",
                        style: TextStyling.smallRegular
                            .copyWith(color: AppColors.darkGrey),
                        children: [
                          TextSpan(
                            text: widget.data.deliveryDate.toString(),
                            style: TextStyling.smallBold
                                .copyWith(color: AppColors.primary),
                          ),
                          TextSpan(
                            text: " (${widget.data.deliveryDay.toString()})",
                            style: TextStyling.smallBold
                                .copyWith(color: AppColors.primary),
                          ),
                        ]),
                  ),
                  // SecondInputField(
                  //   label: 'From Date',
                  //   hint: 'Select From Date',
                  //   controller: model.fromDate,
                  //   inputType: TextInputType.datetime,
                  //   width: context.screenSize().width * 0.4,
                  //   onTap: () async {
                  //     DateTime? pickedDate = await showDatePicker(
                  //         context: context,
                  //         initialDate: DateTime.now(),
                  //         firstDate: DateTime(2022),
                  //         lastDate: DateTime(2100));
                  //
                  //     if (pickedDate != null) {
                  //       model.toDateFormat = pickedDate;
                  //       String formattedDate =
                  //       DateFormat('yyyy-MM-dd').format(pickedDate);
                  //       model.fromDate.text = formattedDate;
                  //       model.getData(context, branchId: "${branchId}");
                  //     } else {}
                  //   },
                  //   message: 'Please select from Date',
                  //   prefixIcon: Icon(
                  //     Icons.calendar_month,
                  //     color: AppColors.primary,
                  //     size: 24,
                  //   ),
                  // )
                  if(widget.data.orderStatus=='3')
                    ElevatedButton(onPressed: () async {

                      DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2022),
                          lastDate: DateTime(2100));

                      if (pickedDate != null) {
                        widget.model.toDateFormat = pickedDate;
                        String formattedDate =
                        DateFormat('yyyy-MM-dd').format(pickedDate);
                        widget.model.fromDate.text = formattedDate;
                        print(formattedDate);
                        api.datechange(context, widget.data.orderId.toString(),
                            formattedDate);
                      } else {}
                      // api.datechange(context, "8", "2024-01-22");
                    },
                        style: ElevatedButton.styleFrom(
                          primary: AppColors.primary, // Change this to your desired color
                        ),
                        child: Text("Date Forward", style: TextStyle(color: Colors.white),)

                    ),
                  if(widget.data.orderStatus=='4')
                    ElevatedButton(onPressed: () async {
                      DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2022),
                          lastDate: DateTime(2100));

                      if (pickedDate != null) {
                        widget.model.toDateFormat = pickedDate;
                        String formattedDate =
                        DateFormat('yyyy-MM-dd').format(pickedDate);
                        widget.model.fromDate.text = formattedDate;
                        print(formattedDate);
                        api.datechange(context, widget.data.orderId.toString(),
                            formattedDate);
                      } else {

                      }
                    },
                        style: ElevatedButton.styleFrom(
                          primary: AppColors.primary, // Change this to your desired color
                        ),
                        child: Text("Date Forward", style: TextStyle(color: Colors.white),)
                    )
                  ]),
              VerticalSpacing(10),
              if (widget.data.orderStatus == "1")

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [

                    InkWell(
                      onTap: () async {

                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.parse(widget.data.deliveryDate.toString()),
                          firstDate: DateTime.now(),
                          lastDate:(DateTime.now()).add(new Duration(days: 6)));
                       // String date = DateFormat("yyyy-MM-dd").format(pickedDate!);
                       //  print('selected: ${selectedDate}');
                       //  print('picked: ${pickedDate}');

                        if (pickedDate != null) {
                  setState(() {
                    // selectedDate=pickedDate ;
                // print('selected: ${selectedDate}');
                // print('picked: ${pickedDate}');
                  });
                  String date = DateFormat("yyyy-MM-dd").format(pickedDate!);
                  widget.model.assignDeliveryDate(context, widget.data.orderId.toString(), date.toString());
                  widget.model.getData(context ,branchId: widget.model.branchId);
                  // PendingOrderViewModel view=PendingOrderViewModel(,''),
                      // view.getData(context);
                        }
                      },
                      child: Container(
                          decoration: BoxDecoration(
                              color: AppColors.white, shape: BoxShape.circle),
                          height: 48,
                          width: 48,
                          child: Center(
                              child: Icon(
                            Icons.date_range,
                            color: AppColors.primary,
                          ))),
                    ),
                    InkWell(
                      onTap: () async  {
                        //DateTime selectedDates = DateTime.now();
                        //print(selectedDate);
                        DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.parse(widget.data.deliveryDate.toString()),
                            firstDate: DateTime.now(),
                            lastDate: (DateTime.now()).add(new Duration(days: 6)));
                       // DateTime selectedDates = DateTime.now();
                        //print(selectedDates);
                        //print(pickedDate);

                        if (pickedDate != null) {
                          String date = DateFormat("yyyy-MM-dd").format(pickedDate);
                          widget.model.assignDeliveryDate(context, widget.data.orderId.toString(), date.toString());
                          showPendingConfirmation(context, widget.model, widget.data.orderId.toString());

                        }


                      },
                      child: Container(
                          decoration: BoxDecoration(
                              color: AppColors.white, shape: BoxShape.circle),
                          height: 48,
                          width: 48,
                          child: Center(
                              child: Icon(
                            Icons.done_outline,
                            color: AppColors.primary,
                          ))),
                    ),
                  ],
                ),
              if (widget.data.orderStatus == "3")
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CustomDropDown(
                      value: "",
                      width: context.screenSize().width * 0.6,
                      items: widget.model.salesman.map((items) {
                        return items.salesmanName.toString();
                      }).toList(),
                      disabledItemFn: (val) {
                        int l = (widget.model.salesman
                            .where((element) => element.salesmanName == val)
                            .length);
                        return (l > 0) ? false : true;
                      },
                      onChanged: (String? newValue) {
                        widget.model.selectedIndex[widget.index] = widget.model.salesman.indexWhere(
                            (element) => element.salesmanName == newValue);
                        widget.model.notifyListeners();
                      },
                    ),
                    InkWell(
                      onTap: () {
                        widget.model.assignSalesMan(
                            context,
                            widget.data.orderId.toString(),
                            widget.model.salesman[widget.model.selectedIndex[widget.index]]
                                .salesmanName
                                .toString(),
                            widget.model
                                .salesman[widget.model.selectedIndex[widget.index]].salesmanId
                                .toString());
                      },
                      child: Center(
                          child: Icon(
                        Icons.done_outline,
                        color: AppColors.primary,
                        size: 24,
                      )),
                    ),
                    HorizontalSpacing(0),
                  ],
                ),
              if (widget.data.orderStatus == "4")
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      widget.data.salesmanName?.trim().toString() ?? "",
                      style: TextStyling.mediumBold
                          .copyWith(color: AppColors.primary),
                    ),
                    Text(
                      "(${widget.data.salesmanCode.toString()})",
                      style:
                          TextStyling.mediumBold.copyWith(color: AppColors.red),
                    ),
                    Spacer(),
                    InkWell(
                      onTap: () async {
                        var callAndroid = Uri.parse(
                            "tel://${widget.data.salesmanMobile.toString()}");
                        if (await canLaunchUrl(callAndroid)) {
                          await launchUrl(callAndroid);
                        }
                      },
                      child: Container(
                          decoration: BoxDecoration(
                              color: AppColors.white, shape: BoxShape.circle),
                          height: 48,
                          width: 48,
                          child: Center(
                              child: Icon(
                            Icons.call,
                            color: AppColors.primary,
                          ))),
                    )
                  ],
                ),
              if (widget.data.remarks == 1 && widget.data.orderStatus == "5")
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                      splashColor: Colors.transparent,
                      onTap: () {
                        widget.model.remarks.text = widget.data.remarksText.toString();
                        showAddRemarks(context, widget.model, widget.data.orderId.toString());
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.green,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        height: 30,
                        width: context.screenSize().width * 0.4,
                        child: Center(
                            child: Text(
                          "Add Remarks",
                          style: TextStyling.smallBold
                              .copyWith(color: AppColors.white),
                        )),
                      ),
                    ),
                  ],
                )
            ],
          ),
        ),
      ),
    );
  }
}


