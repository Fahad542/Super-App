
import 'package:premier/src/models/supervisor/invoice/customer.dart';
import 'package:premier/src/models/supervisor/invoice/supplier.dart';

class Invoice {
  final InvoiceInfo info;
  final Customer customer;
  final List<InvoiceItem> items;

  const Invoice({
    required this.info,
   required this.customer,
     required this.items,
  });
}

class InvoiceInfo {
  final String orderNo;
  final String orderDate;
  final String deliveryDate;
  final String specialNote;
  final String salesmanName;

  InvoiceInfo(
      {required this.orderNo,
      required this.orderDate,
      required this.deliveryDate,
      required this.specialNote,
      required this.salesmanName});
}

class InvoiceItem {
  final String proname;
  final String tp;
  final int qty;
  final String dis1;
  final String dis2;
  final String gst1;
  final String gst2;
  final String advtax;
  final String netamount;

  const InvoiceItem({
     required this.advtax,
    required this.dis1,
    required this.dis2,
    required this.gst1,
    required this.gst2,
    required this.netamount,
    required this.proname,
    required this.qty,
    required this.tp
  });
}
