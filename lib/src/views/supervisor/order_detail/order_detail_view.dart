import 'package:flutter/material.dart';
import 'package:premier/src/base/utils/utils.dart';
import 'package:premier/src/shared/DSF/dsf_app_screen.dart';
import 'package:premier/src/shared/spacing.dart';
import 'package:premier/src/styles/app_colors.dart';
import 'package:premier/src/styles/text_theme.dart';
import 'package:stacked/stacked.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../models/supervisor/supervisor_order_model.dart';
import 'order_detail_view_model.dart';

class OrderDetailView extends StatelessWidget {
  final SupervisorOrderModelData data;

  const OrderDetailView({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<OrderDetailViewModel>.reactive(
      builder: (context, model, child) => SupervisorAppScreen(
        title: "Order Id: ${data.orderId}",
        body: (model.isBusy)
            ? Center(
                child: CircularProgressIndicator(
                  color: AppColors.primary,
                ),
              )
            : Stack(
                children: [
                  Container(
                    height: context.screenSize().height,
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(
                        0,
                        0,
                        0,
                        (data.orderStatus == "3" ||
                                data.orderStatus == "4" ||
                                data.orderStatus == "5")
                            ? 130
                            : 100),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          VerticalSpacing(10),
                          Container(
                            decoration: BoxDecoration(color: AppColors.primary),
                            padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Detail",
                                  style: TextStyling.largeBold
                                      .copyWith(color: AppColors.white),
                                ),
                              ],
                            ),
                          ),
                          VerticalSpacing(10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              SizedBox(
                                width: context.screenSize().width * 0.4,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Supply Id:",
                                      style: TextStyling.mediumRegular
                                          .copyWith(color: AppColors.secondary),
                                    ),
                                    VerticalSpacing(),
                                    Text(
                                      "Customer Name:",
                                      style: TextStyling.mediumRegular
                                          .copyWith(color: AppColors.secondary),
                                    ),
                                    VerticalSpacing(),
                                    Text(
                                      "Brick Code:",
                                      style: TextStyling.mediumRegular
                                          .copyWith(color: AppColors.secondary),
                                    ),
                                    VerticalSpacing(),
                                    Text(
                                      "Brick Name:",
                                      style: TextStyling.mediumRegular
                                          .copyWith(color: AppColors.secondary),
                                    ),
                                    VerticalSpacing(),
                                    Text(
                                      "Phone no:",
                                      style: TextStyling.mediumRegular
                                          .copyWith(color: AppColors.secondary),
                                    ),
                                    VerticalSpacing(),
                                    Text(
                                      "Order Status:",
                                      style: TextStyling.mediumRegular
                                          .copyWith(color: AppColors.secondary),
                                    ),
                                    VerticalSpacing(),
                                    Text(
                                      "Order Date:",
                                      style: TextStyling.mediumRegular
                                          .copyWith(color: AppColors.secondary),
                                    ),
                                    VerticalSpacing(),
                                    Text(
                                      "Delivery Date:",
                                      style: TextStyling.mediumRegular
                                          .copyWith(color: AppColors.secondary),
                                    ),
                                    Text(
                                      "Branch id:",
                                      style: TextStyling.mediumRegular
                                          .copyWith(color: AppColors.secondary),
                                    ),
                                    Text(
                                      "Customer code:",
                                      style: TextStyling.mediumRegular
                                          .copyWith(color: AppColors.secondary),
                                    ),
                                    VerticalSpacing(),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: context.screenSize().width * 0.5,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      model.data.supplyid.toString(),
                                      style: TextStyling.mediumBold
                                          .copyWith(color: AppColors.primary),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    VerticalSpacing(),
                                    Text(
                                      model.data.customerName.toString(),
                                      style: TextStyling.mediumBold
                                          .copyWith(color: AppColors.primary),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    VerticalSpacing(),
                                    Text(
                                      model.data.brickCode.toString(),
                                      style: TextStyling.mediumBold
                                          .copyWith(color: AppColors.primary),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    VerticalSpacing(),
                                    Text(
                                      model.data.brickName.toString(),
                                      style: TextStyling.mediumBold
                                          .copyWith(color: AppColors.primary),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    VerticalSpacing(),
                                    Text(
                                      model.data.contact.toString(),
                                      style: TextStyling.mediumBold
                                          .copyWith(color: AppColors.primary),
                                      overflow: TextOverflow.ellipsis,
                                    ),

                                    VerticalSpacing(),
                                    Text(
                                      model.data.orderStatus.toString() == "1"
                                          ? "Pending"
                                          : model.data.orderStatus.toString() ==
                                                  "2"
                                              ? "Transfer"
                                              : model.data.orderStatus
                                                          .toString() ==
                                                      "3"
                                                  ? "Confirmed"
                                                  : model.data.orderStatus
                                                              .toString() ==
                                                          "4"
                                                      ? "Dispatch"
                                                      : model.data.orderStatus
                                                                  .toString() ==
                                                              "7"
                                                          ? "Cancelled"
                                                          : "Delivered",
                                      style: TextStyling.mediumBold
                                          .copyWith(color: AppColors.primary),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    VerticalSpacing(),
                                    Text(

                                      model.data.orderDate.toString() ?? "",
                                      style: TextStyling.mediumBold
                                          .copyWith(color: AppColors.primary),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    VerticalSpacing(),
                                    Text(
                                      model.data.deliveryDate.toString(),
                                      style: TextStyling.mediumBold
                                          .copyWith(color: AppColors.primary),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    VerticalSpacing(),
                                    Text(
                                      model.data.branch_id.toString(),
                                      style: TextStyling.mediumBold
                                          .copyWith(color: AppColors.primary),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      model.data.customer_code.toString(),
                                      style: TextStyling.mediumBold
                                          .copyWith(color: AppColors.primary),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          VerticalSpacing(10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Text(
                                  model.data.address.toString(),
                                  textAlign: TextAlign.center,
                                  style: TextStyling.mediumBold
                                      .copyWith(color: AppColors.primary),
                                ),
                              ),
                            ],
                          ),
                          VerticalSpacing(10),
                          Container(
                            decoration: BoxDecoration(color: AppColors.primary),
                            padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Summery",
                                  style: TextStyling.largeBold
                                      .copyWith(color: AppColors.white),
                                ),
                              ],
                            ),
                          ),
                          VerticalSpacing(10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.local_offer,
                                    color: Colors.red,
                                  ),
                                  HorizontalSpacing(5),
                                  Text(
                                    "Discount",
                                    style: TextStyling.smallRegular
                                        .copyWith(color: Colors.indigo),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Icon(
                                    Icons.cut_outlined,
                                    color: Colors.deepOrange,
                                  ),
                                  HorizontalSpacing(5),
                                  Text(
                                    "Cutting",
                                    style: TextStyling.smallRegular
                                        .copyWith(color: Colors.deepOrange),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Icon(
                                    Icons.cancel,
                                    color: AppColors.red,
                                  ),
                                  HorizontalSpacing(5),
                                  Text(
                                    "Not Available",
                                    style: TextStyling.smallRegular
                                        .copyWith(color: Colors.deepOrange),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          VerticalSpacing(10),
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              children: [
                                Container(
                                    decoration:
                                        BoxDecoration(color: AppColors.primary),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Orignal Order",
                                          style: TextStyling.mediumBold
                                              .copyWith(color: AppColors.white),
                                        ),
                                      ],
                                    )),
                                Table(
                                  columnWidths: {
                                    0: FlexColumnWidth(1),
                                    1: FlexColumnWidth(2),
                                    2: FlexColumnWidth(1),
                                    3: FlexColumnWidth(1),
                                  },
                                  border:
                                      TableBorder.all(color: AppColors.primary),
                                  children: model.orgItemTableData,
                                ),
                              ],
                            ),
                          ),
                          VerticalSpacing(10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              SizedBox(
                                width: context.screenSize().width / 2,
                                child: RichText(
                                  text: TextSpan(
                                    text: "Total:   ",
                                    style: TextStyling.mediumRegular.copyWith(
                                      color: AppColors.black,
                                      fontSize: 12,
                                    ),
                                    children: [
                                      TextSpan(
                                          text:
                                              "Rs.${model.products.map((e) => double.parse(e.totalPrice.toString())).reduce((a, b) => a + b).round().toString()}/-",
                                          style:
                                              TextStyling.mediumBold.copyWith(
                                            color: AppColors.primary,
                                            fontSize: 16,
                                          )),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                          if (data.orderStatus == "3" ||
                              data.orderStatus == "4")
                            Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(10, 50, 10, 10),
                              child: Column(
                                children: [
                                  Container(
                                      decoration: BoxDecoration(
                                          color: AppColors.primary),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Proforma Order",
                                            style: TextStyling.mediumBold
                                                .copyWith(
                                                    color: AppColors.white),
                                          ),
                                        ],
                                      )),
                                  Table(
                                    columnWidths: {
                                      0: FlexColumnWidth(1),
                                      1: FlexColumnWidth(2),
                                      2: FlexColumnWidth(1),
                                      3: FlexColumnWidth(1),
                                      4: FlexColumnWidth(1),
                                    },
                                    border: TableBorder.all(
                                        color: AppColors.primary),
                                    children: model.perItemTableData,
                                  ),
                                ],
                              ),
                            ),
                          if (data.orderStatus == "3" ||
                              data.orderStatus == "4")
                            VerticalSpacing(10),
                          if (data.orderStatus == "3" ||
                              data.orderStatus == "4")
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                SizedBox(
                                  width: context.screenSize().width / 2,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      RichText(
                                        text: TextSpan(
                                          text: "Total:   ",
                                          style: TextStyling.mediumRegular
                                              .copyWith(
                                            color: AppColors.black,
                                            fontSize: 12,
                                          ),
                                          children: [
                                            TextSpan(
                                                text:
                                                    "Rs.${model.products.map((e) {
                                                          if (e.proformaQty !=
                                                              null) {
                                                            return double.parse(e
                                                                .proformaQty
                                                                .toString());
                                                          } else {
                                                            return 0.0;
                                                          }
                                                        }).reduce((a, b) => a + b).round().toString()}/-",
                                                style: TextStyling.mediumBold
                                                    .copyWith(
                                                  color: AppColors.primary,
                                                  fontSize: 16,
                                                )),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          if (data.orderStatus == "5")
                            Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(10, 50, 10, 10),
                              child: Column(
                                children: [
                                  Container(
                                      decoration: BoxDecoration(
                                          color: AppColors.primary),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Delivered Order",
                                            style: TextStyling.mediumBold
                                                .copyWith(
                                                    color: AppColors.white),
                                          ),
                                        ],
                                      )),
                                  Table(
                                    columnWidths: {
                                      0: FlexColumnWidth(1),
                                      1: FlexColumnWidth(2),
                                      2: FlexColumnWidth(1),
                                      3: FlexColumnWidth(1),
                                      4: FlexColumnWidth(1),
                                    },
                                    border: TableBorder.all(
                                        color: AppColors.primary),
                                    children: model.delItemTableData,
                                  ),
                                ],
                              ),
                            ),
                          if (data.orderStatus == "5") VerticalSpacing(10),
                          if (data.orderStatus == "5")
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                SizedBox(
                                  width: context.screenSize().width / 2,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      RichText(
                                        text: TextSpan(
                                          text: "Total:   ",
                                          style: TextStyling.mediumRegular
                                              .copyWith(
                                            color: AppColors.black,
                                            fontSize: 12,
                                          ),
                                          children: [
                                            TextSpan(
                                                text:
                                                    "Rs.${model.products.map((e) {
                                                          if (e.deliveredPrice !=
                                                              null) {
                                                            return double.parse(e
                                                                .deliveredPrice
                                                                .toString());
                                                          } else {
                                                            return 0.0;
                                                          }
                                                        }).reduce((a, b) => a + b).round().toString()}/-",
                                                style: TextStyling.mediumBold
                                                    .copyWith(
                                                  color: AppColors.primary,
                                                  fontSize: 16,
                                                )),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 10,
                    left: 10,
                    right: 10,
                    child: Column(
                      children: [
                        if (data.orderStatus == "3" ||
                            data.orderStatus == "4" ||
                            data.orderStatus == "5")
                          InkWell(
                            splashColor: Colors.transparent,
                            onTap: () async {
                              if (model.items.length > 0)
                                model.generateInvoice(context);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: AppColors.green,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              height: 40,
                              width: context.screenSize().width * 0.4,
                              child: Center(
                                  child: Text(
                                "Download Invoice",
                                style: TextStyling.mediumBold
                                    .copyWith(color: AppColors.white),
                              )),
                            ),
                          ),
                        if (data.orderStatus == "3" ||
                            data.orderStatus == "4" ||
                            data.orderStatus == "5")
                          VerticalSpacing(5),
                        RichText(
                            text: TextSpan(
                                text: "Contact to ",
                                style: TextStyling.mediumRegular
                                    .copyWith(color: AppColors.secondary),
                                children: [
                              TextSpan(
                                text: model.data.customerName
                                    ?.toUpperCase()
                                    .toString(),
                                style: TextStyling.mediumBold
                                    .copyWith(color: AppColors.primary),
                              )
                            ])),
                        VerticalSpacing(5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            InkWell(
                              splashColor: Colors.transparent,
                              onTap: () async {
                                var callAndroid = Uri.parse(
                                    "tel://${model.data.contact.toString()}");
                                if (await canLaunchUrl(callAndroid)) {
                                  await launchUrl(callAndroid);
                                }
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
                                  "Call",
                                  style: TextStyling.mediumBold
                                      .copyWith(color: AppColors.white),
                                )),
                              ),
                            ),
                            InkWell(
                              splashColor: Colors.transparent,
                              onTap: () async {
                                var whatsappAndroid = Uri.parse(
                                    "whatsapp://send?phone=92${model.data.contact?.replaceRange(0, 1, "").toString()}&text=salam");
                                if (await canLaunchUrl(whatsappAndroid)) {
                                  await launchUrl(whatsappAndroid);
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          "WhatsApp is not installed on the device"),
                                    ),
                                  );
                                }
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: AppColors.green,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                height: 40,
                                width: context.screenSize().width * 0.4,
                                child: Center(
                                    child: Text(
                                  "WhatsApp",
                                  style: TextStyling.mediumBold
                                      .copyWith(color: AppColors.white),
                                )),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
      ),
      viewModelBuilder: () => OrderDetailViewModel(data),
      onModelReady: (model) => model.init(context),
    );
  }
}
