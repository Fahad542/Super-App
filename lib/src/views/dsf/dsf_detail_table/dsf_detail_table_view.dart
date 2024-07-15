import 'package:flutter/material.dart';
import 'package:premier/src/shared/DSF/company_table_data.dart';
import 'package:premier/src/shared/DSF/dsf_app_screen.dart';
import 'package:premier/src/styles/app_colors.dart';
import 'package:premier/src/styles/text_theme.dart';
import 'package:premier/src/views/dsf/dsf_detail_table/dsf_detail_table_view_model.dart';
import 'package:stacked/stacked.dart';

class DsfDetailTableView extends StatelessWidget {

  final String title;
  final CompanyTableData heading;
  final List<CompanyTableData> data;
  final String totalInv, totalAmount;
  const DsfDetailTableView({Key? key, required this.title, required this.heading, required this.data, required this.totalInv, required this.totalAmount}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<DsfDetailTableViewModel>.reactive(
      builder: (context, model, child) {
        return DSFaAppScreen(
          title: title,
          body: Padding(
            padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: (model.isBusy) ? Center(child: CircularProgressIndicator(color: AppColors.primary,)) : SingleChildScrollView(
              child: Column(
                children: [
                  CompanyDataTable(heading: heading, data: data, onTap: (int value) {},),
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
                          totalInv,
                          style: TextStyling.mediumBold.copyWith(
                              color: AppColors.primary),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Text(
                          "Rs.$totalAmount/-",
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
      viewModelBuilder: () => DsfDetailTableViewModel(context),
    );
  }
}
