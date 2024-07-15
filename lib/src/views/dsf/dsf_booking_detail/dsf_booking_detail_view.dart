import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:premier/src/base/utils/utils.dart';
import 'package:premier/src/models/DSF/get_all_dsf_model.dart';
import 'package:premier/src/shared/DSF/company_table_data.dart';
import 'package:premier/src/shared/DSF/dsf_app_screen.dart';
import 'package:premier/src/shared/input_field.dart';
import 'package:premier/src/styles/app_colors.dart';
import 'package:premier/src/styles/text_theme.dart';
import 'package:premier/src/views/dsf/dsf_booking_detail/dsf_booking_detail_view_model.dart';
import 'package:stacked/stacked.dart';

class DSFBookingDetailView extends StatelessWidget {
  final AllDsfModelData? data;

  const DSFBookingDetailView({Key? key, this.data}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<DSFBookingDetailViewModel>.reactive(
      builder: (context, model, child) {
        return DSFaAppScreen(
          title: "Order Details",
          body: Padding(
            padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: (model.isBusy) ? Center(child: CircularProgressIndicator(color: AppColors.primary,)) : SingleChildScrollView(
              child: Column(
                children: [
                  MainInputField(
                    label: "Report Date",
                    hint: "Select Report Date",
                    controller: model.selectedDate,
                    error: "please select report date",
                    width: context.screenSize().width,
                    inputType: TextInputType.datetime,
                    readOnly: true,
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: AppColors.primary),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    onTap: () {
                      showDatePicker(
                        context: context,
                        initialDate: model.selectedDateFormat ?? DateTime.now(),
                        firstDate: DateTime(2023, 2, 1),
                        lastDate: DateTime(2050, 1, 31),
                      ).then((value) {
                        if (value != null) {
                          model.selectedDateFormat = value;
                          model.selectedDate.text = DateFormat("dd-MM-yyyy").format(value);
                          model.getDSFOrders(context);
                          model.notifyListeners();
                        } else {
                          model.selectedDateFormat = DateTime.now();
                          model.selectedDate.text = DateFormat("dd-MM-yyyy").format(DateTime.now());
                          model.getDSFOrders(context);
                          model.notifyListeners();
                        }
                      });
                    },
                  ),
                  CompanyDataTable(heading: model.heading, data: model.data, onTap: (int value) {},),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 3,
                        child: Text(
                          "Grand Total:",
                          style: TextStyling.largeBold.copyWith(
                              color: AppColors.primary),
                          textAlign: TextAlign.start,
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          model.totalInv,
                          style: TextStyling.mediumBold.copyWith(
                              color: AppColors.primary),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Text(
                          "Rs.${model.totalAmount}/-",
                          style: TextStyling.mediumBold.copyWith(
                              color: AppColors.primary),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.symmetric(
                        horizontal: BorderSide(color: AppColors.secondary, width: 2),
                      ),
                    ),
                    height: 8,
                    margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      viewModelBuilder: () => DSFBookingDetailViewModel(context, data),
      onModelReady: (model) => model.init(),
    );
  }
}
