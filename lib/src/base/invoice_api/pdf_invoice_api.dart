import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets.dart';
import 'package:premier/src/base/invoice_api/pdf_api.dart';
import 'package:premier/src/models/supervisor/invoice/customer.dart';
import 'package:premier/src/models/supervisor/invoice/invoice.dart';

class PdfInvoiceApi {
  static Future<File> generate(Invoice invoice) async {
    final pdf = Document();
    final ByteData bytes = await rootBundle.load('assets/images/logomain2.png');
    final Uint8List byteList = bytes.buffer.asUint8List();

    pdf.addPage(MultiPage(
      pageFormat: PdfPageFormat.a4,
      build: (context) => [
        buildHeader(invoice, byteList),
        SizedBox(height: 3 * PdfPageFormat.cm),
        buildInvoice(invoice),
        Divider(),
        buildTotal(invoice),
      ],
      footer: (context) => buildFooter(invoice),
    ));

    return PdfApi.saveDocument(
        name: 'orderNo#${invoice.info.orderNo}.pdf', pdf: pdf);
  }

  static buildHeader(Invoice invoice, Uint8List byteList) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 1 * PdfPageFormat.cm),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            pw.Image(
                pw.MemoryImage(
                  byteList,
                ),
                height: 150,
                width: 150,
                fit: pw.BoxFit.fitWidth),
            buildInvoiceInfo(invoice.info),
          ],
        ),
        SizedBox(height: 1 * PdfPageFormat.cm),
        buildCustomerAddress(invoice.customer),
      ],
    );
  }

  static Widget buildCustomerAddress(Customer customer) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${customer.name}',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          Text('${customer.address}'),
        ],
      );

  static Widget buildInvoiceInfo(InvoiceInfo info) {
    var now = new DateTime.now();
    var formatter = new DateFormat('dd-MM-yyyy');
    String formattedDate = formatter.format(now);

    final titles = <String>[
      'Order No#:',
      'Invoice Date:',
      'Order Date:',
      'Delivery Date:',
    ];
    final data = <String>[
      info.orderNo,
      formattedDate,
      info.orderDate,
      info.deliveryDate
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(titles.length, (index) {
        final title = titles[index];
        final value = data[index];

        return buildText(title: title, value: value, width: 250);
      }),
    );
  }

  static Widget buildInvoice(Invoice invoice) {
    final headers = [
      'Product Name',
      'Tp',
      'Qty',
      'Dis1',
      'Dis2',
      'Gst1',
      'Gst2',
      'Adv Tax',
      'Net Amt'
    ];

    final data = invoice.items.map((item) {
      return [
        item.proname,
        '${item.tp} ',
        item.qty,
        '${item.dis1} ',
        '${item.dis2}',
        '${item.gst1}',
        '${item.gst2}',
        '${item.advtax} ',
        '${item.netamount}',
      ];
    }).toList();

    return Table.fromTextArray(
      headers: headers,
      data: data,
      border: TableBorder.all(color: PdfColors.grey300),
      headerStyle: TextStyle(fontWeight: FontWeight.bold),
      headerDecoration: BoxDecoration(color: PdfColors.grey300),
      cellHeight: 30,
      columnWidths: {
        0: FlexColumnWidth(4),
        // 1: FlexColumnWidth(1),
        // 2: FlexColumnWidth(1),
        // 3: FlexColumnWidth(1),
        // 4: FlexColumnWidth(1),
        // 5: FlexColumnWidth(1),
        // 6: FlexColumnWidth(1),
        // 7: FlexColumnWidth(2),
        //8: FlexColumnWidth(2),
      },
      cellAlignments: {
        0: Alignment.centerLeft,
        1: Alignment.centerLeft,
        2: Alignment.centerLeft,
        3: Alignment.centerRight,
        4: Alignment.centerRight,
        5: Alignment.centerRight,
        6: Alignment.centerRight,
        7: Alignment.centerRight,
        8: Alignment.centerRight,
      },
    );
  }

  static Widget buildTotal(Invoice invoice) {
    return Container(
      alignment: Alignment.centerRight,
      child: Row(
        children: [
          Spacer(flex: 6),
          Expanded(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Divider(),
                buildText(
                  title: 'Total amount',
                  titleStyle: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  value: invoice.items
                      .map((e) => double.parse(e.netamount))
                      .reduce((a, b) => a + b)
                      .round()
                      .toString(),
                  unite: true,
                ),
                SizedBox(height: 2 * PdfPageFormat.mm),
                Container(height: 1, color: PdfColors.grey400),
                SizedBox(height: 0.5 * PdfPageFormat.mm),
                Container(height: 1, color: PdfColors.grey400),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Widget buildFooter(Invoice invoice) => Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Divider(),
          SizedBox(height: 2 * PdfPageFormat.mm),
          buildSimpleText(
              title: 'Address:',
              value:
                  '1-A/15, Sector-15 Korangi Industrial Area Karachi, Pakistan.'),
          SizedBox(height: 1 * PdfPageFormat.mm),
          buildSimpleText(
              title: 'Phone No:', value: '34919932-341228348-34912823'),
          SizedBox(height: 1 * PdfPageFormat.mm),
          buildSimpleText(title: 'Email:', value: 'info@premiergroup.com.pk'),
        ],
      );

  static buildSimpleText({
    required String title,
    required String value,
  }) {
    final style = TextStyle(fontWeight: FontWeight.bold);

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: pw.CrossAxisAlignment.end,
      children: [
        Text(title, style: style),
        SizedBox(width: 2 * PdfPageFormat.mm),
        Text(value),
      ],
    );
  }

  static buildText({
    required String title,
    String? value,
    double width = double.infinity,
    TextStyle? titleStyle,
    bool unite = false,
  }) {
    final style = titleStyle ?? TextStyle(fontWeight: FontWeight.bold);

    return Container(
      width: width,
      child: Row(
        children: [
          Expanded(child: Text(title, style: style)),
          Text(value ?? "", style: unite ? style : null),
        ],
      ),
    );
  }
}
// import 'dart:io';
// import 'dart:typed_data';
//
// import 'package:flutter/services.dart';
// import 'package:intl/intl.dart';
// import 'package:pdf/pdf.dart';
// import 'package:pdf/widgets.dart' as pw;
// import 'package:pdf/widgets.dart';
// import 'package:premier/src/base/invoice_api/pdf_api.dart';
// import 'package:premier/src/models/supervisor/invoice/customer.dart';
// import 'package:premier/src/models/supervisor/invoice/invoice.dart';
//
// class PdfInvoiceApi {
//   static Future<File> generate(Invoice invoice, String orderno, String Status,
//       String invdate, String custcode) async {
//     final pdf = Document();
//     final ByteData bytes = await rootBundle.load('assets/images/logomain2.png');
//     final Uint8List byteList = bytes.buffer.asUint8List();
//
//     pdf.addPage(MultiPage(
//       pageFormat: PdfPageFormat.a4,
//       //header:(context) =>buildHeader(invoice,byteList,'${orderno}',Status,invdate),
//       build: (context) => [
//         buildHeader(
//             invoice, byteList, '${orderno}', Status, invdate, '${custcode}'),
//         buildCustomerAddress(invoice.customer),
//         SizedBox(height: 1 * PdfPageFormat.cm),
//         //buildTitle(invoice),
//
//         buildInvoice(invoice),
//         Divider(),
//         buildTotal(invoice),
//         // buildFooter(invoice),
//       ],
//       footer: (context) => buildFooter(invoice),
//     ));
//
//     return PdfApi.saveDocument(name: 'OrderNo#${orderno}', pdf: pdf);
//   }
//
//   static buildHeader(Invoice invoice, Uint8List byteList, String orderno,
//           String Statuss, String invdate, String custcode) =>
//       Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           SizedBox(height: 1 * PdfPageFormat.cm),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.start,
//             children: [
//               pw.Expanded(
//                 child: Container(
//                   alignment: Alignment.topLeft,
//                   child: pw.Image(
//                       pw.MemoryImage(
//                         byteList,
//                       ),
//                       height: 100,
//                       width: 150,
//                       fit: pw.BoxFit.fitHeight),
//                 ),
//               ),
//             ],
//           ),
//           SizedBox(height: 0.5 * PdfPageFormat.cm),
//           pw.Column(children: [
//             Row(
//               crossAxisAlignment: CrossAxisAlignment.end,
//               mainAxisAlignment: MainAxisAlignment.end,
//               children: [
//                 //buildCustomerAddress(invoice.customer),
//                 buildInvoiceInfo(
//                     invoice.info, '${orderno}', invdate, Statuss, custcode),
//               ],
//             ),
//           ])
//         ],
//       );
//
//   static Widget buildCustomerAddress(Customer customer) => Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             '${customer.name}',
//             style: TextStyle(
//                 fontWeight: FontWeight.bold,
//                 fontSize: 22,
//                 color: PdfColors.green700),
//           ),
//           pw.SizedBox(height: 5),
//           Text(
//             '${customer.address}',
//             style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
//           ),
//         ],
//       );
//
//   static Widget buildInvoiceInfo(InvoiceInfo info, String orderno,
//       String invdate, String Status, String custcode) {
//     var now = new DateTime.now();
//     var formatter = new DateFormat('dd-MM-yyyy');
//     String formattedDate = formatter.format(now);
//     //final paymentTerms = '${info.dueDate.difference(info.date).inDays} days';
//     final titles = <String>[
//       'Order No#:',
//       'Invoice Date:',
//       'Delivery Date:',
//     ];
//     final data = <String>[info.orderNo, info.orderDate, info.deliveryDate];
//
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: List.generate(titles.length, (index) {
//         final title = titles[index];
//         final value = data[index];
//
//         return buildText(title: title, value: value, width: 200);
//       }),
//     );
//   }
//
//   // static Widget buildSupplierAddress(Supplier supplier) => Column(
//   //       crossAxisAlignment: CrossAxisAlignment.start,
//   //       children: [
//   //         Text(supplier.name, style: TextStyle(fontWeight: FontWeight.bold)),
//   //         SizedBox(height: 1 * PdfPageFormat.mm),
//   //         Text(supplier.address),
//   //       ],
//   //     );
//
//   // static Widget buildTitle(Invoice invoice) => Column(
//   //       crossAxisAlignment: CrossAxisAlignment.start,
//   //       children: [
//   //         Text(
//   //           'INVOICE',
//   //           style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//   //         ),
//   //         SizedBox(height: 0.8 * PdfPageFormat.cm),
//   //         Text(invoice.info.description),
//   //         SizedBox(height: 0.8 * PdfPageFormat.cm),
//   //       ],
//   //     );
//
//   static Widget buildInvoice(Invoice invoice) {
//     final headers = [
//       'Product Name',
//       'Tp',
//       'Qty',
//       'Dis1',
//       'Dis2',
//       'Gst1',
//       'Gst2',
//       'Adv Tax',
//       'Net Amt'
//     ];
//
//     final data = invoice.items.map((item) {
//       final formatter = new NumberFormat("##,###,###");
//       return [
//         item.proname,
//         '${item.tp} ',
//         item.qty,
//         '${item.dis1} ',
//         '${item.dis2}',
//         '${item.gst1}',
//         '${item.gst2}',
//         '${item.advtax} ',
//         '${formatter.format(int.parse('${item.netamount}'))}',
//       ];
//     }).toList();
//
//     return Table.fromTextArray(
//       headers: headers,
//       data: data,
//       border: TableBorder.all(color: PdfColors.black),
//       headerStyle:
//           TextStyle(fontWeight: FontWeight.bold, color: PdfColors.white),
//       headerDecoration: BoxDecoration(color: PdfColors.green700),
//       cellHeight: 30,
//       columnWidths: {
//         0: FlexColumnWidth(4),
//         // 1: FlexColumnWidth(1),
//         // 2: FlexColumnWidth(1),
//         // 3: FlexColumnWidth(1),
//         // 4: FlexColumnWidth(1),
//         // 5: FlexColumnWidth(1),
//         // 6: FlexColumnWidth(1),
//         // 7: FlexColumnWidth(2),
//         //8: FlexColumnWidth(2),
//       },
//       cellAlignments: {
//         0: Alignment.center,
//         1: Alignment.center,
//         2: Alignment.center,
//         3: Alignment.center,
//         4: Alignment.center,
//         5: Alignment.center,
//         6: Alignment.center,
//         7: Alignment.center,
//         8: Alignment.center,
//       },
//     );
//   }
//
//   static Widget buildTotal(Invoice invoice) {
//     final formatter = new NumberFormat("##,###,###");
//     final netTotal = invoice.items
//         .map((item) => int.parse('${item.netamount}'))
//         .reduce((item1, item2) => item1 + item2);
//     print('Values: ${netTotal}');
//     // //final vatPercent = invoice.items.first.proname;
//
//     return Container(
//       alignment: Alignment.centerRight,
//       child: Row(
//         children: [
//           Spacer(flex: 6),
//           Expanded(
//             flex: 4,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 buildText(
//                   title: 'Total Amount',
//                   value:
//                       'Rs:${formatter.format(int.parse('${netTotal.toString()}'))}',
//                   unite: true,
//                 ),
//                 // buildText(
//                 //   title: 'Discounts',
//                 //  // value: Utils.formatPrice(vat),
//                 //   unite: true,
//                 // ),
//                 // Divider(),
//                 // buildText(
//                 //   title: 'Net Amount',
//                 //   titleStyle: TextStyle(
//                 //     fontSize: 14,
//                 //     fontWeight: FontWeight.bold,
//                 //   ),
//                 //  // value: Utils.formatPrice(total),
//                 //   unite: true,
//                 // ),
//                 // SizedBox(height: 2 * PdfPageFormat.mm),
//                 // Container(height: 1, color: PdfColors.grey400),
//                 // SizedBox(height: 0.5 * PdfPageFormat.mm),
//                 // Container(height: 1, color: PdfColors.grey400),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   static Widget buildFooter(Invoice invoice) => Column(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           Divider(),
//           SizedBox(height: 2 * PdfPageFormat.mm),
//           buildSimpleText(
//               title: 'Address:',
//               value:
//                   '1-A/15, Sector-15 Korangi Industrial Area Karachi, Pakistan.'),
//           SizedBox(height: 1 * PdfPageFormat.mm),
//           buildSimpleText(
//               title: 'Phone No:', value: '34919932-341228348-34912823'),
//           SizedBox(height: 1 * PdfPageFormat.mm),
//           buildSimpleText(title: 'Email:', value: 'info@premiergroup.com.pk'),
//         ],
//       );
//
//   static buildSimpleText({
//     String? title,
//     String? value,
//   }) {
//     final style = TextStyle(fontWeight: FontWeight.bold);
//
//     return Row(
//       mainAxisSize: MainAxisSize.min,
//       crossAxisAlignment: pw.CrossAxisAlignment.end,
//       children: [
//         Text(title!, style: style),
//         SizedBox(width: 2 * PdfPageFormat.mm),
//         Text(value!),
//       ],
//     );
//   }
//
//   static buildText({
//     String? title,
//     String? value,
//     double width = double.infinity,
//     TextStyle? titleStyle,
//     bool unite = false,
//   }) {
//     final style = titleStyle ??
//         TextStyle(
//           fontWeight: FontWeight.bold,
//           fontSize: 15,
//         );
//
//     return Container(
//       width: width,
//       child: Row(
//         children: [
//           Expanded(child: Text(title.toString(), style: style)),
//           Text(value.toString(), style: style),
//         ],
//       ),
//     );
//   }
// }
