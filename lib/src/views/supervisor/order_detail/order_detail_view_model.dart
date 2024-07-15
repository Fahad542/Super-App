import 'package:flutter/material.dart';
import 'package:premier/src/base/invoice_api/pdf_api.dart';
import 'package:premier/src/base/invoice_api/pdf_invoice_api.dart';
import 'package:premier/src/base/utils/Constants.dart';
import 'package:premier/src/models/supervisor/invoice/customer.dart';
import 'package:premier/src/models/supervisor/invoice/invoice.dart';
import 'package:premier/src/models/supervisor/products_by_order.dart';
import 'package:premier/src/models/supervisor/products_by_order_for_inv.dart';
import 'package:premier/src/models/supervisor/supervisor_order_model.dart';
import 'package:premier/src/services/local/base/auth_view_model.dart';
import 'package:premier/src/services/remote/base/api_view_model.dart';
import 'package:premier/src/styles/app_colors.dart';
import 'package:premier/src/styles/text_theme.dart';
import 'package:stacked/stacked.dart';

class OrderDetailViewModel extends ReactiveViewModel
    with AuthViewModel, ApiViewModel {
  final SupervisorOrderModelData data;
  OrderDetailViewModel(this.data);

  List<ProductsByOrderData> products = [];
  List<TableRow> orgItemTableData = [];
  List<TableRow> perItemTableData = [];
  List<TableRow> delItemTableData = [];
  init(BuildContext context) async {
    setBusy(true);
    orgItemTableData.clear();
    delItemTableData.clear();
    perItemTableData.clear();
    orgItemTableData.add(TableRow(
        decoration: BoxDecoration(
          color: AppColors.primary,
        ),
        children: [
          Text(
            "Product ID",
            style: TextStyling.mediumBold.copyWith(
              color: AppColors.white,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
          Text(
            "Name",
            style: TextStyling.mediumBold.copyWith(
              color: AppColors.white,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
          Text(
            "Price",
            style: TextStyling.mediumBold.copyWith(
              color: AppColors.white,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
          Text(
            "Qty",
            style: TextStyling.mediumBold.copyWith(
              color: AppColors.white,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
          Text(
            "S.Total",
            style: TextStyling.mediumBold.copyWith(
              color: AppColors.white,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
        ]));
    if (data.orderStatus == "3" || data.orderStatus == "4")
      perItemTableData.add(TableRow(
          decoration: BoxDecoration(
            color: AppColors.primary,
          ),
          children: [
            Text(
              "Product ID",
              style: TextStyling.mediumBold.copyWith(
                color: AppColors.white,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              "Name",
              style: TextStyling.mediumBold.copyWith(
                color: AppColors.white,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              "Price",
              style: TextStyling.mediumBold.copyWith(
                color: AppColors.white,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              "Qty",
              style: TextStyling.mediumBold.copyWith(
                color: AppColors.white,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              "S.Total",
              style: TextStyling.mediumBold.copyWith(
                color: AppColors.white,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              "",
              style: TextStyling.mediumBold.copyWith(
                color: AppColors.white,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
          ]));
    if (data.orderStatus == "5")
      delItemTableData.add(TableRow(
          decoration: BoxDecoration(
            color: AppColors.primary,
          ),
          children: [
            Text(
              "Product ID",
              style: TextStyling.mediumBold.copyWith(
                color: AppColors.white,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              "Name",
              style: TextStyling.mediumBold.copyWith(
                color: AppColors.white,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              "Price",
              style: TextStyling.mediumBold.copyWith(
                color: AppColors.white,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              "Qty",
              style: TextStyling.mediumBold.copyWith(
                color: AppColors.white,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              "S.Total",
              style: TextStyling.mediumBold.copyWith(
                color: AppColors.white,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              "",
              style: TextStyling.mediumBold.copyWith(
                color: AppColors.white,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
          ]));
    if (data.orderStatus == "3" ||
        data.orderStatus == "4" ||
        data.orderStatus == "5") await getProductsByOrderDataForInv(context);
    await getData(context);
    setBusy(false);
  }

  Future<void> getData(BuildContext context) async {
    setBusy(true);
    var response = await apiService.getProductsByOrderData(
        context, data.orderId.toString());
    if (response != null) {
      response.when(success: (_d) async {
        if ((_d.data?.length ?? 0) > 0) {
          _d.data?.forEach((element) {
            bool discountAddded = false;
            if (data.orderStatus == "3" ||
                data.orderStatus == "4" ||
                data.orderStatus == "5") if (_data.first.supplyid != "null") {
              print(
                  "Product id:${_data.where((ee) => ee.productId == element.productId).first.cmpDis.toString()}");
              discountAddded = (double.parse(_data
                          .where((ee) => ee.productId == element.productId)
                          .first
                          .cmpDis
                          .toString()) !=
                      0) ||
                  (double.parse(_data
                          .where((ee) => ee.productId == element.productId)
                          .first
                          .paDis
                          .toString()) !=
                      0);
            } else {
              discountAddded;
            }
            products.add(element);
            orgItemTableData.add(TableRow(children: [
              Padding(
                padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                child: Text(
                  element.product_code.toString() ?? "",
                  style: TextStyling.mediumBold.copyWith(
                    color: AppColors.primary,
                    fontSize: 12,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              Padding(
                padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                child: Text(
                  element.productName.toString() ?? "",
                  style: TextStyling.mediumBold.copyWith(
                    color: AppColors.primary,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                child: Text(
                  double.parse(element.productPrice.toString() ?? "")
                      .round()
                      .toString(),
                  style: TextStyling.mediumBold.copyWith(
                    color: AppColors.primary,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                child: Text(
                  element.orderQty.toString(),
                  style: TextStyling.mediumBold.copyWith(
                    color: AppColors.primary,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                child: Text(
                  "${(double.parse(element.orderQty.toString()) * double.parse(element.productPrice.toString())).round().toString()}",
                  style: TextStyling.mediumBold.copyWith(
                    color: AppColors.primary,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ]));
            if (data.orderStatus == "3" || data.orderStatus == "4")
              perItemTableData.add(TableRow(children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                  child:

                  Text(
                    element.product_code.toString() ,
                    style: TextStyling.mediumBold.copyWith(
                      color: AppColors.primary,
                      fontSize: 12,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                  child: Text(
                    element.productName.toString() ?? "",
                    style: TextStyling.mediumBold.copyWith(
                      color: AppColors.primary,
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                  child: Text(
                    double.parse(element.productPrice.toString())
                        .round()
                        .toString(),
                    style: TextStyling.mediumBold.copyWith(
                      color: AppColors.primary,
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                  child: Text(
                    element.proformaQty != null
                        ? element.proformaPrice.toString()
                        : "0",
                    style: TextStyling.mediumBold.copyWith(
                      color: AppColors.primary,
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                  child: Text(
                    (element.proformaQty != null)
                        ? double.parse(element.proformaQty.toString())
                            .round()
                            .toString()
                        : "0",
                    style: TextStyling.mediumBold.copyWith(
                      color: AppColors.primary,
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                  child: (element.proformaPrice == null)
                      ? Icon(
                          Icons.cancel,
                          color: AppColors.red,
                        )
                      : (element.orderQty != element.proformaPrice)
                          ? Icon(
                              Icons.cut_outlined,
                              color: Colors.deepOrange,
                            )
                          : discountAddded
                              ? Icon(
                                  Icons.local_offer,
                                  color: Colors.red,
                                )
                              : Icon(
                                  Icons.done_outline,
                                  color: Colors.transparent,
                                ),
                ),
              ]));
            if (data.orderStatus == "5")
              delItemTableData.add(TableRow(children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                  child:

                  Text(
                    element.product_code.toString() ?? "",
                    style: TextStyling.mediumBold.copyWith(
                      color: AppColors.primary,
                      fontSize: 12,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                  child:

                  Text(
                    element.productName.toString() ?? "",
                    style: TextStyling.mediumBold.copyWith(
                      color: AppColors.primary,
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                  child: Text(
                    double.parse(element.productPrice.toString())
                        .round()
                        .toString(),
                    style: TextStyling.mediumBold.copyWith(
                      color: AppColors.primary,
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                  child: Text(
                    element.deliveredPrice != null
                        ? element.deliveredQty.toString()
                        : "0",
                    style: TextStyling.mediumBold.copyWith(
                      color: AppColors.primary,
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                  child: Text(
                    (element.deliveredPrice != null)
                        ? double.parse(element.deliveredPrice.toString())
                            .round()
                            .toString()
                        : "0",
                    style: TextStyling.mediumBold.copyWith(
                      color: AppColors.primary,
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                  child: (element.deliveredPrice == null)
                      ? Icon(
                          Icons.cancel,
                          color: AppColors.red,
                        )
                      : (element.orderQty != element.deliveredQty)
                          ? Icon(
                              Icons.cut_outlined,
                              color: Colors.deepOrange,
                            )
                          : (discountAddded)
                              ? Icon(
                                  Icons.local_offer,
                                  color: Colors.red,
                                )
                              : Icon(
                                  Icons.done_outline,
                                  color: Colors.transparent,
                                ),
                ),
              ]));
          });
          setBusy(false);
          notifyListeners();
        }
      }, failure: (error) {
        Constants.customErrorSnack(context, error.toString());
        setBusy(false);
      });
    } else {
      setBusy(false);
    }
  }

  List<ProductsByOrderForInvData> _data = [];
  List<InvoiceItem> items = [];
  Future<void> getProductsByOrderDataForInv(BuildContext context) async {
    bool isFinal = (data.orderStatus == "5") ? true : false;
    var response = await apiService.getProductsByOrderDataForInv(
        context, isFinal, data.orderId.toString());
    response?.when(success: (_d) async {
      if ((_d.data?.length ?? 0) > 0) {
        items.clear();
        _data.clear();
        _d.data?.forEach((element) {
          _data.add(element);
          double _tpinQ = (double.parse(element.tp.toString()) *
              double.parse(element.orderQty.toString()));
          double _discunt = (double.parse(element.cmpDis.toString()) +
              double.parse(element.paDis.toString()));
          double _gst = (double.parse(element.gst1.toString()) +
              double.parse(element.gst2.toString()));
          double net = (((_tpinQ - _discunt) + _gst) +
              double.parse(element.advTax.toString()));
          items.add(InvoiceItem(
              proname: element.productName.toString(),
              tp: element.tp.toString(),
              qty: int.parse(element.orderQty.toString()),
              dis1: double.parse(element.cmpDis.toString()).round().toString(),
              dis2: double.parse(element.paDis.toString()).round().toString(),
              gst1: double.parse(element.gst1.toString()).round().toString(),
              gst2: double.parse(element.gst2.toString()).round().toString(),
              advtax:
                  double.parse(element.advTax.toString()).round().toString(),
              netamount: element.productPrice.toString()));
        });
        notifyListeners();
      }
    }, failure: (error) {
      Constants.customErrorSnack(context, error.toString());
    });
  }

  generateInvoice(BuildContext context) async {
    final invoice = Invoice(
      customer: Customer(
        name: data.customerName.toString(),
        address: data.address.toString(),
        contact: data.contact.toString(),
      ),
      info: InvoiceInfo(
          orderNo: data.orderId.toString(),
          orderDate: data.orderDate.toString(),
          deliveryDate: data.deliveryDate.toString(),
          specialNote: data.specialNote.toString(),
          salesmanName: data.salesmanName.toString()),
      items: items,
    );
    final pdfFile = await PdfInvoiceApi.generate(invoice);
    // final pdfFile = await PdfInvoiceApi.generate(invoice, "${data.orderId}",
    //     "${data.orderStatus}", "${data.orderDate}", "${data.customerName}");
    PdfApi.openFile(pdfFile);
  }
}
