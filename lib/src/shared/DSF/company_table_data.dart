import 'package:intl/intl.dart';
import 'package:premier/src/base/utils/Constants.dart';
import 'package:premier/src/base/utils/utils.dart';
import 'package:premier/src/shared/input_field.dart';
import 'package:premier/src/shared/spacing.dart';
import 'package:premier/src/styles/app_colors.dart';
import 'package:premier/src/styles/text_theme.dart';
import 'package:flutter/material.dart';

import '../../../generated/assets.dart';

class CompanyTableData {
  final String companyName;
   String? companyid;
  final String invCount;
  final String totalSales;
  String? dsfcompanyname;
 String? dsfid;
 String? ExecuteInv;
  String? booking;
 String? percent;

  CompanyTableData({required this.companyName, required this.invCount, required this.totalSales , this.dsfid, this.dsfcompanyname, this.ExecuteInv, this.booking, this.percent, this.companyid});
}
var totalSales;
class CompanyDataTable extends StatelessWidget {
  final CompanyTableData heading;
  final List<CompanyTableData> data;
  final ValueChanged<int> onTap;
  String? code;
  String? companyname;
  String? companyid;
   CompanyDataTable({
    Key? key,
    required this.heading,
    required this.data,
    required this.onTap,
    this.code
  }) : super(key: key);

  @override
  Widget build(BuildContext context)
  {
    String totalSales = heading.totalSales;
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Container(
        width: context.screenSize().width,
        decoration: BoxDecoration(
          color: AppColors.white,
          border: Border.all(color: AppColors.secondary, width: 2),
          borderRadius: BorderRadius.circular(8),
        ),
        margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(10, 15, 10, 10),
              child: Row(

                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 3,
                    child: Text(
                      heading.companyName,
                      style: TextStyling.mediumBold.copyWith(fontSize: 16, color: AppColors.primary),
                      textAlign: TextAlign.start,
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      heading.invCount,
                      style: TextStyling.mediumBold.copyWith(fontSize: 16, color: AppColors.primary),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                        totalSales.toString(),

                      style: TextStyling.mediumBold.copyWith(fontSize: 16, color: AppColors.primary),
                      textAlign: TextAlign.center,
                    ),

                  ),
                ],
              ),
            ),

            Padding(
              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: Divider(
                color: AppColors.darkGrey,
                thickness: 0.4,
              ),
            ),
            (data.length > 0)
                ? ListView.separated(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: data.length,
              itemBuilder: (context,index) {
                return InkWell(
                  onTap: () {
                    String name = data[index].companyName;
                    String dsfid = data[index].dsfid.toString();
                    String companyid =data[index].companyid.toString();
                    heading.dsfcompanyname = name;
                    heading.dsfid=dsfid;
                    int dsfCodeAsInt = int.parse(dsfid);
                    print(dsfCodeAsInt);
                    onTap(dsfCodeAsInt);
                    //String code = data[index].dsfid.toString();



                  },
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                    child: Column(children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              flex: 3,
                              child: Text(
                                data[index].companyName,
                                style: TextStyling.mediumRegular.copyWith(
                                    color: AppColors.primary),
                                textAlign: TextAlign.start,
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                data[index].invCount,
                                style: TextStyling.mediumRegular.copyWith(
                                    color: AppColors.primary),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                data[index].totalSales,
                                style: TextStyling.mediumRegular.copyWith(
                                    color: AppColors.primary),
                                textAlign: TextAlign.center,
                              ),
                            ),

                          ],
                        ),


                    ]),
                  ),
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: Divider(
                    color: AppColors.grey,
                    thickness: 0.4,
                  ),
                );
              },
            )
                : Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Data Not Available",
                style: TextStyling.mediumBold
                    .copyWith(color: AppColors.darkGrey),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/////////////////////////////////////////////////////////////////

class CompanySalesDetailsTableData {
  final String companyName;
  String? companyid;
  final String invCount;
  final String totalSales;
  String? dsfcompanyname;
  String? dsfid;


  CompanySalesDetailsTableData({required this.companyName, required this.invCount, required this.totalSales , this.dsfid, this.dsfcompanyname, this.companyid});
}

class CompanySaleData extends StatelessWidget {
  final CompanySalesDetailsTableData heading;
  final List<CompanySalesDetailsTableData> data;
  Function onTap;
  String? code;
  String? companyname;
  String? companyid;
  CompanySaleData({
    Key? key,
    required this.heading,
    required this.data,
    required this.onTap,
    this.code
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Container(
        width: context.screenSize().width,
        decoration: BoxDecoration(
          color: AppColors.white,
          border: Border.all(color: AppColors.secondary, width: 2),
          borderRadius: BorderRadius.circular(8),
        ),
        margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(10, 15, 10, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 3,
                    child: Text(
                      heading.companyName,
                      style: TextStyling.mediumBold.copyWith(fontSize: 16, color: AppColors.primary),
                      textAlign: TextAlign.start,
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      heading.invCount,
                      style: TextStyling.mediumBold.copyWith(fontSize: 16, color: AppColors.primary),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      heading.totalSales,
                      style: TextStyling.mediumBold.copyWith(fontSize: 16, color: AppColors.primary),
                      textAlign: TextAlign.center,
                    ),

                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: Divider(
                color: AppColors.darkGrey,
                thickness: 0.4,
              ),
            ),
            (data.length > 0)
                ? ListView.separated(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: data.length,
              itemBuilder: (context,index) {
                return InkWell(
                  onTap: () {
                    String companyid =data[index].companyid.toString();
                    String companyname =data[index].companyName.toString();
                    heading.companyid=companyid;
                    String sales =data[index].totalSales.toString();
                    int companyidAsInt = int.parse(companyid);
                    if(sales!='0.00'){
                    onTap(companyidAsInt,companyname,sales);}
                    else{
                      Constants.customErrorSnack(context, "Data Not Found");
                    }
                  },
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child: Column(children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            flex: 3,
                            child: Text(
                              data[index].companyName,
                              style: TextStyling.mediumRegular.copyWith(
                                  color: AppColors.primary),
                              textAlign: TextAlign.start,
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              data[index].invCount,
                              style: TextStyling.mediumRegular.copyWith(
                                  color: AppColors.primary),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              data[index].totalSales,
                              style: TextStyling.mediumRegular.copyWith(
                                  color: AppColors.primary),
                              textAlign: TextAlign.center,
                            ),
                          ),

                        ],
                      ),

                      // Row(
                      //   children: [
                      //     Spacer(),
                      //     Container(
                      //         height: 20,
                      //         width: 20,
                      //         child: Image.asset(Assets.click, color: AppColors.primary,)),
                      //   ],
                      // )
                    ]),
                  ),
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: Divider(
                    color: AppColors.grey,
                    thickness: 0.4,
                  ),
                );
              },
            )
                : Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Data Not Available",
                style: TextStyling.mediumBold
                    .copyWith(color: AppColors.darkGrey),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
///////////////////////////////////////////////
class hand {
  final String companyName;
  String? companyid;
  final String invCount;
  final String totalSales;
  int? uc;
  String? dsfcompanyname;
  String? dsfid;
  String? start;
  String? end;
String? brname;
bool? ischeck;
  String? branchsale;
  List<String>? name;
  List<String>? sale;

  hand({required this.companyName,this.ischeck, required this.invCount, this.brname, required this.totalSales , this.dsfid, this.dsfcompanyname, this.companyid, this.start, this.end, this.uc,  this.branchsale, this.name,  this.sale});
}


class branches {
  final String saleamount;
  final String branch_code;
  final String branch_name;


  branches({required this.saleamount, required this.branch_code, required this.branch_name });
}

class handdetails extends StatelessWidget {
  final hand heading;
  final List<hand> data;
   List<branches>? branchs;
  Function onTap;
  String? code;
  String? companyname;
  String? companyid;
  bool? brcheck;
  bool ischeck;


  handdetails({
    Key? key,
    required this.heading,
    required this.data,
    this.branchs,
    this.brcheck,
    required this.onTap,
   this.ischeck=false,


    this.code
  }) : super(key: key);

  @override
  Widget build(BuildContext context)
  {

    return
      Column(
          children: [

      Container(

        width: context.screenSize().width,
        decoration: BoxDecoration(
          color: AppColors.white,
          border: Border.all(color: AppColors.secondary, width: 2),
          borderRadius: BorderRadius.circular(8),
        ),
        margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
        child:
        Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(10, 15, 10, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 3,
                    child: Text(
                      heading.companyName,
                      style: TextStyling.mediumBold.copyWith(fontSize: 16, color: AppColors.primary),
                      textAlign: TextAlign.start,
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      heading.invCount,
                      style: TextStyling.mediumBold.copyWith(fontSize: 16, color: AppColors.primary),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      heading.totalSales,
                      style: TextStyling.mediumBold.copyWith(fontSize: 16, color: AppColors.primary),
                      textAlign: TextAlign.center,
                    ),

                  ),
                  Expanded(
                    child:
                    Text(
                      "",
                      style: TextStyling.mediumBold.copyWith(fontSize: 16, color: AppColors.primary),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: Divider(
                color: AppColors.darkGrey,
                thickness: 0.4,
              ),
            ),
            (data.length > 0)
                ?  ListView.builder(
             physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: data.length,
              itemBuilder: (context,index) {
                  return  InkWell(
                      onTap: () {
                        String companyid =data[index].companyid.toString();
                        String companyname =data[index].companyName.toString();
                        heading.companyid=companyid;
                        String sales =data[index].totalSales.toString();
                        int companyidAsInt = int.parse(companyid);

                        if(sales!='0.00'){
                          print(companyidAsInt);
                          onTap(companyidAsInt,companyname,sales);}

                        else{
                          Constants.customErrorSnack(context, "Data Not Found");
                        }


                        //onTap(dsfCodeAsInt);

                      },
                      child: Padding(
                        padding: EdgeInsets.all(8),
                        child: Column(children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                flex: 3,
                                child:Text.rich(
                                  TextSpan(
                                    children: [
                                      TextSpan(
                                        text: data[index].companyName,
                                        style: TextStyling.mediumRegular.copyWith(
                                            color: AppColors.primary),

                                      ),
                                      if(brcheck==true)
                                      TextSpan(
                                        text: ' (${data[index].brname})',
                                        style: TextStyle(
                                          fontSize: 12.0, // Smaller font size for brname
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Text(
                                  data[index].invCount,
                                  style: TextStyling.mediumRegular.copyWith(
                                      color: AppColors.primary),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Text(
                                    NumberFormat('#,##0', 'en_US').format(double.parse(data[index].totalSales.replaceAll(',', '')).round()),
                                  style: TextStyling.mediumRegular.copyWith(
                                      color: AppColors.primary),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Row(
                                  children: [

                                    Container(
                                        height: 20,
                                        width: 20,
                                        child: Image.asset(Assets.click, color: AppColors.primary,)),
                                  ],
                                ),
                              )
                            ],
                          ),
                          VerticalSpacing(10),
                          Visibility(
                            visible: ischeck==true,
                            child: Row(
                              mainAxisAlignment:MainAxisAlignment.spaceBetween,
                              children: [

                                Spacer(),
                            InkWell(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      contentPadding: EdgeInsets.symmetric(vertical: 24, horizontal: 16), // Adjust as needed
                                      title: Text(data[index].companyName, textAlign: TextAlign.center,),
                                      content: SizedBox(
                                        width: 300, // Set width here
                                        height: 400, // Set height here
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: <Widget>[
                                                Text("Branch Name/ID", style: TextStyle(fontWeight: FontWeight.bold),),
                                                Text("Sale", style: TextStyle(fontWeight: FontWeight.bold),),
                                                //Divider(color: AppColors.primary,)
                                              ],
                                            ),
                                            SizedBox(height: 8),
                                            Expanded(
                                              child: ListView.builder(
                                                shrinkWrap: true,
                                                itemCount: data[index].name!.length,
                                                itemBuilder: (context, branchindex) {
                                                  branchs!.sort((a, b) => b.saleamount.compareTo(a.saleamount));
                                                  return Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: <Widget>[

                                                        Text(data[index].name![branchindex]),
                                                        Text(data[index].sale![branchindex]),
                                                        //Text(branchs![index].saleamount),
                                                      ],
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),

                                          ],
                                        ),
                                      ),
                                    );

                                  },
                                );

                              },
                              child: Container(
                                padding: EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6),
                                  color: AppColors.primary,
                                ),
                                child: Text(
                                  "Branch wise details",
                                  style: TextStyle(color: Colors.white, fontSize: 10),
                                ),
                              ),
                            ),



                        Padding(
                            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                            child: Divider(
                              color: AppColors.grey,
                              thickness: 0.4,
                            ),
                        ),

                            ]),
                      ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                            child: Divider(
                              color: AppColors.darkGrey,
                              thickness: 0.4,
                            ),
                          ),

                      ])));
              },



                )
                : Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Data Not Available",
                style: TextStyling.mediumBold
                    .copyWith(color: AppColors.darkGrey),
              ),
            ),
          ],
        ),
      ),
            ]
      );
  }
}



class dsf {
  final String companyName;
 final String companyid;

  dsf({required this.companyName, required this.companyid});
}

class dsfdetails extends StatelessWidget {
  final dsf heading;
  final List<dsf> data;
  final Function onTap;

  dsfdetails({
    Key? key,
    required this.heading,
    required this.data,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return 
      SafeArea(
        child:
         SingleChildScrollView(
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: AppColors.primary,
                ),
                height: 50,
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      "Total Count: ${data.length}",
                      style: TextStyling.mediumBold.copyWith(color: AppColors.white),
                    ),
                  ],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: AppColors.white,
                  //border: Border.all(color: AppColors.secondary, width: 2),
                  borderRadius: BorderRadius.circular(8),
                ),
                margin: EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(10, 15, 10, 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            flex: 2,
                            child: Text(
                              "Count",
                              style: TextStyling.mediumBold.copyWith(fontSize: 16, color: AppColors.primary),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              heading.companyName,
                              style: TextStyling.mediumBold.copyWith(fontSize: 16, color: AppColors.primary),
                              textAlign: TextAlign.start,
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Text(
                              heading.companyid,
                              style: TextStyling.mediumBold.copyWith(fontSize: 16, color: AppColors.primary),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: Divider(
                        color: AppColors.darkGrey,
                        thickness: 0.4,
                      ),
                    ),
                  ],
                ),
              ),
            Container(
              height: 400,
                child:
                ListView.builder(
                    itemCount: data.length,
                    //shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return  InkWell(
                          onTap: () {},
                          child:
                          Padding(
                            padding: EdgeInsets.all(10),
                            child:
                            Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(width: 35),
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        "${index +1}",
                                        style: TextStyling.mediumRegular.copyWith(color: AppColors.primary),
                                        textAlign: TextAlign.start,
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        data[index].companyid,
                                        style: TextStyling.mediumRegular.copyWith(color: AppColors.primary),
                                        textAlign: TextAlign.start,
                                      ),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: Text(
                                        data[index].companyName,
                                        style: TextStyling.mediumRegular.copyWith(color: AppColors.primary),
                                        textAlign: TextAlign.start,
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                  child: Divider(
                                    color: AppColors.grey,
                                    thickness: 0.4,
                                  ),
                                ),
                              ],
                            ),
                          ),

                      );
                    },
                  ),


            )
            ],

          ),
        ),
      );
  }
}
















































class CompanySalesDetailsTableDatanohand {
  final String companyName;
  String? companyid;
  final String invCount;
  final String totalSales;
  String? dsfcompanyname;
  String? brname;
  String? dsfid;



  CompanySalesDetailsTableDatanohand({required this.companyName, this.brname,required this.invCount, required this.totalSales , this.dsfid, this.dsfcompanyname, this.companyid});
}

class CompanySaleDatanohand extends StatelessWidget {
  final CompanySalesDetailsTableDatanohand heading;
  final List<CompanySalesDetailsTableDatanohand> data;
  Function onTap;
  String? code;
  String? companyname;
  String? companyid;
  bool? brcheck;
  CompanySaleDatanohand({Key? key,
    required this.heading,
    this.brcheck,
    required this.data,
    required this.onTap,
    this.code
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Container(
        width: context.screenSize().width,
        decoration: BoxDecoration(
          color: AppColors.white,
          border: Border.all(color: AppColors.secondary, width: 2),
          borderRadius: BorderRadius.circular(8),
        ),
        margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(10, 15, 10, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 3,
                    child: Text(
                      heading.companyName,
                      style: TextStyling.mediumBold.copyWith(fontSize: 16, color: AppColors.primary),
                      textAlign: TextAlign.start,
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      heading.invCount,
                      style: TextStyling.mediumBold.copyWith(fontSize: 16, color: AppColors.primary),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      heading.totalSales,
                      style: TextStyling.mediumBold.copyWith(fontSize: 16, color: AppColors.primary),
                      textAlign: TextAlign.center,
                    ),

                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: Divider(
                color: AppColors.darkGrey,
                thickness: 0.4,
              ),
            ),
            (data.length > 0)
                ? ListView.separated(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: data.length,
              itemBuilder: (context,index) {
                return InkWell(
                  onTap: () {
                    String companyid =data[index].companyid.toString();
                    String companyname =data[index].companyName.toString();
                    heading.companyid=companyid;
                    String sales =data[index].totalSales.toString();
                    int companyidAsInt = int.parse(companyid);
                    if(sales!='0.00'){
                      onTap(companyidAsInt,companyname,sales);}
                    else{
                      Constants.customErrorSnack(context, "Data Not Found");
                    }


                    //onTap(dsfCodeAsInt);

                  },
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child: Column(children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            flex: 3,
                            child: Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: data[index].companyName,
                                    style: TextStyling.mediumRegular.copyWith(
                                        color: AppColors.primary),
                                  ),
                                  TextSpan(
                                    text: brcheck ==true ? " " :' (${data[index].brname})',
                                    style: TextStyle(
                                      fontSize: 12.0, // Smaller font size for brname
                                    ),
                                  ),
                                ],
                              ),
                            ),

                          ),

                          Expanded(
                            flex: 2,
                            child: Text(
                              data[index].invCount,
                              style: TextStyling.mediumRegular.copyWith(
                                  color: AppColors.primary),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                             // data[index].totalSales,
                              NumberFormat('#,##0', 'en_US').format(double.parse(data[index].totalSales.replaceAll(',', '')).round()),
                              style: TextStyling.mediumRegular.copyWith(
                                  color: AppColors.primary),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ]
                    ),
                  ),
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: Divider(
                    color: AppColors.grey,
                    thickness: 0.4,
                  ),
                );
              },
            )
                : Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Data Not Available",
                style: TextStyling.mediumBold
                    .copyWith(color: AppColors.darkGrey),
              ),
            ),
          ],
        ),
      ),
    );
  }
}



///////////////////////////////////////////////////
class CompanyTableDatahand {
  final String companyName;
  String? companyid;
  final String invCount;
  final String totalSales;
  String? dsfcompanyname;
  String? dsfid;
  String? ExecuteInv;
  String? booking;
  String? percent;

  CompanyTableDatahand({required this.companyName, required this.invCount, required this.totalSales , this.dsfid, this.dsfcompanyname, this.ExecuteInv, this.booking, this.percent, this.companyid});
}

class CompanyDataTablehand extends StatelessWidget {
  final CompanyTableDatahand heading;
  final List<CompanyTableDatahand> data;
  final ValueChanged<int> onTap;
  String? code;
  String? companyname;
  String? companyid;
  CompanyDataTablehand({
    Key? key,
    required this.heading,
    required this.data,
    required this.onTap,
    this.code
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return
      SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Container(
        width: context.screenSize().width,
        decoration: BoxDecoration(
          color: AppColors.white,
          border: Border.all(color: AppColors.secondary, width: 2),
          borderRadius: BorderRadius.circular(8),
        ),
        margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(10, 15, 10, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 3,
                    child: Text(
                      heading.companyName,
                      style: TextStyling.mediumBold.copyWith(fontSize: 16, color: AppColors.primary),
                      textAlign: TextAlign.start,
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      heading.invCount,
                      style: TextStyling.mediumBold.copyWith(fontSize: 16, color: AppColors.primary),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      heading.totalSales,
                      style: TextStyling.mediumBold.copyWith(fontSize: 16, color: AppColors.primary),
                      textAlign: TextAlign.center,
                    ),

                  ),
                ],
              ),
            ),

            Padding(
              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: Divider(
                color: AppColors.darkGrey,
                thickness: 0.4,
              ),
            ),
            (data.length > 0)
                ? ListView.separated(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: data.length,
              itemBuilder: (context,index) {
                return InkWell(
                  onTap: () {
                    String name = data[index].companyName;
                    String dsfid = data[index].dsfid.toString();

                    String companyid =data[index].companyid.toString();
                    heading.dsfcompanyname = name;
                    heading.dsfid=dsfid;
                    int dsfCodeAsInt = int.parse(dsfid);
                    onTap(dsfCodeAsInt);
                    //String code = data[index].dsfid.toString();



                  },
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                    child: Column(children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            flex: 3,
                            child: Text(
                              data[index].companyName,
                              style: TextStyling.mediumRegular.copyWith(
                                  color: AppColors.primary),
                              textAlign: TextAlign.start,
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              data[index].invCount,
                              style: TextStyling.mediumRegular.copyWith(
                                  color: AppColors.primary),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              NumberFormat('#,##0', 'en_US').format(double.parse(data[index].totalSales.replaceAll(',', '')).round()),
                              style: TextStyling.mediumRegular.copyWith(
                                  color: AppColors.primary),
                              textAlign: TextAlign.center,
                            ),
                          ),

                        ],
                      ),
                      Row(
                        children: [
                          Spacer(),
                          Container(
                              height: 20,
                              width: 20,
                              child: Image.asset(Assets.click, color: AppColors.primary,)),
                        ],
                      )

                    ]),
                  ),
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: Divider(
                    color: AppColors.grey,
                    thickness: 0.4,
                  ),
                );
              },
            )
                : Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Data Not Available",
                style: TextStyling.mediumBold
                    .copyWith(color: AppColors.darkGrey),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SupervisorData {
  final String SupervisorName;
  final String SupervisorId;
  final String SupervisorCode;
  final String branch;

  SupervisorData({required this.SupervisorName, required this.SupervisorId, required this.SupervisorCode, required this.branch });
}

class SupervisorDatadropdown extends StatefulWidget {
  final List<SupervisorData> data;
  Function  onTap;
  String sale='';
  String? code;
  String? selectedSupervisor;
  SupervisorDatadropdown({
    Key? key,

    required this.data,
    required this.onTap,
    required this.selectedSupervisor,
    this.code
  }) : super(key: key);

  @override
  State<SupervisorDatadropdown> createState() => _SupervisorDatadropdownState();
}

class _SupervisorDatadropdownState extends State<SupervisorDatadropdown> {
  String? selectedValue;
  String? a;
  //String? selectedSupervisor;

  @override
  void initState() {
    super.initState();


  }
  @override
  Widget build(BuildContext context) {
    List<String> dropdownItems = widget.data.map((item) {

      return "${item.branch} - ${item.SupervisorCode} - ${item.SupervisorName}";

    }).toList();

    return
      (widget.data.length > 0)
          ?
      SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Container(
        width: context.screenSize().width,

        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Your dropdown widget goes here
                  SizedBox(
                    width:300,
                      child: CustomDropDown(
                          value: widget.selectedSupervisor,
                          items: dropdownItems,
                          onChanged: (value) {
                            setState(() {
                              if (value != null) {
                                final parts = value.split(" - ");
                              final selectedId = parts[1];
                                final selectedName = parts[2];
                                final selectedbrach=parts[0];
                                //final selectedId = parts[1];
                                widget.onTap(selectedName, selectedId, selectedbrach );
                                print(selectedName);
                                print(selectedId);
                              }
                            });
                          //selectedValue=widget.selectedSupervisor;
                          }),
                    ),
                  ]
              ),
            ),
          ],
        ),
      ),
    ): Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          "Data Not Available",
          style: TextStyling.mediumBold
              .copyWith(color: AppColors.darkGrey),
        ),
      );

  }
}
///////////////////////////////
class CompanySales {
  final String companyName;
  final String BookingInv;
  final String ExecuteInv;
  final String ExecuteAmount;

  CompanySales({required this.companyName, required this.BookingInv, required this.ExecuteInv , required this.ExecuteAmount});
}

class CompanySalesData extends StatefulWidget {
  final CompanySales heading;
  final List<CompanyTableData> data;
  Function onTap;
  String? code;

  CompanySalesData({
    Key? key,
    required this.heading,
    required this.data,
    required this.onTap,
    this.code
  }) : super(key: key);

  @override
  State<CompanySalesData> createState() => _CompanySalesDataState();
}

class _CompanySalesDataState extends State<CompanySalesData> {


  @override
  Widget build(BuildContext context) {

    Size screenSize = MediaQuery.of(context).size;
    return Column(
        children:[
        Container(
        width: context.screenSize().width,
        decoration: BoxDecoration(
          color: AppColors.white,
          border: Border.all(color: AppColors.secondary, width: 2),
          borderRadius: BorderRadius.circular(8),
        ),
        margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Column(
          children: [
            Container(
              child: Padding(
                padding: EdgeInsets.fromLTRB(10, 15, 10, 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 3,
                      child: Text(
                        widget.heading.companyName,
                        style: TextStyling.mediumBold.copyWith(fontSize: 14, color: AppColors.primary),
                        textAlign: TextAlign.start,
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        widget.heading.BookingInv,
                        style: TextStyling.mediumBold.copyWith(fontSize: 14, color: AppColors.primary),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        widget.heading.ExecuteInv,
                        style: TextStyling.mediumBold.copyWith(fontSize: 14, color: AppColors.primary),
                        textAlign: TextAlign.center,
                      ),

                    ),

                    Expanded(
                      flex: 2,
                      child: Text(
                        widget.heading.ExecuteAmount,
                        style: TextStyling.mediumBold.copyWith(fontSize: 14, color: AppColors.primary),
                        textAlign: TextAlign.center,
                      ),

                    ),

                  ],
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: Divider(
                color: AppColors.darkGrey,
                thickness: 0.4,
              ),
            ),
            (widget.data.length > 0)
                ? Container(
              height: screenSize.height * 0.5,
                  child: ListView.builder(
              //physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: widget.data.length,
              itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {

                      String name = widget.data[index].companyName;

                      //heading. = name;
                      String? code = widget.data[index].companyid;
                      //String supervisorbrach=widget.data[index].
                      widget.onTap(code,name);

                      // print(index);
                      //print( data[index].companyName);
                      //data[index].invCount;
                    },
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                      child: Column(children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              flex: 3,
                              child: Text(
                                widget.data[index].companyName,
                                style: TextStyling.mediumRegular.copyWith(fontSize: 14,
                                    color: AppColors.primary),
                                textAlign: TextAlign.start,
                              ),
                            ),
                            //SizedBox(height: 20),

                            Expanded(
                              flex: 2,
                              child: Column(
                                children: [
                                  Text(
                                    widget.data[index].booking.toString(),
                                    style: TextStyling.mediumRegular.copyWith(
                                        fontSize: 14,
                                        color: AppColors.primary),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                widget.data[index].invCount,
                                style: TextStyling.mediumRegular.copyWith(
                                  //fontSize: 13,
                                    color: AppColors.primary),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                NumberFormat('#,##0', 'en_US').format(double.parse(widget.data[index].totalSales.replaceAll(',', '')).round()),

                                style: TextStyling.mediumRegular.copyWith(

                                    color: AppColors.primary),
                                textAlign: TextAlign.center,
                              ),
                            ),

                          ],
                        ),

                        Row(
                          children: [
                            Expanded(
                                flex:3,
                                child: Text("")),
                            Expanded(
                              flex:5,
                              child: SizedBox(
                                  height:7,
                                  width: 200,
                                  child: CustomLinearProgressIndicator(value:widget.data[index].percent.toString(), valueColor: Colors.green, borderRadius: BorderRadius.circular(10),)),
                            ),
                            SizedBox(width: 5,),
                            Text('${widget.data[index].percent.toString()}%',style: TextStyle(color: AppColors.primary
                                , fontWeight: FontWeight.w600,fontSize: 11),)
                          ],
                        ),
                        // Row(
                        //   //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //   children: [
                        //
                        //     Spacer(),
                        //     Text('${widget.data[index].percent.toString()}%',style: TextStyle(color: AppColors.primary
                        //         , fontWeight: FontWeight.w600,fontSize: 11),)
                        //   ],
                        // ),
                       // SizedBox(height: 8,),

                      ]),
                    ),
                  );
              },









                      //SizedBox(height: 30),
                      // Padding(
                      //   padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                      //   child: Divider(
                      //     color: AppColors.grey,
                      //     thickness: 0.4,
                      //   ),
                      // ),



            ),
                )
                : Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Data Not Available",
                style: TextStyling.mediumBold
                    .copyWith(color: AppColors.darkGrey),
              ),
            ),
          ],
        ),
      ),
            ] );
  }
}


//////

class CompanySalesTable {
  final String companyName;
  final String BookingInv;
  final String ExecuteInv;
  final String ExecuteAmount;

  CompanySalesTable({required this.companyName, required this.BookingInv, required this.ExecuteInv , required this.ExecuteAmount});
}
class CompanySalesDataTable extends StatefulWidget {
  final CompanySalesTable heading;
  final List<CompanyTableData> data;
  Function onTap;
  String? code;

  CompanySalesDataTable({
    Key? key,
    required this.heading,
    required this.data,
    required this.onTap,
    this.code
  }) : super(key: key);

  @override
  State<CompanySalesDataTable> createState() => _CompanySalesDataTableState();
}

class _CompanySalesDataTableState extends State<CompanySalesDataTable> {


  @override
  Widget build(BuildContext context) {


    return
      Container(
          width: context.screenSize().width,
          decoration: BoxDecoration(
            color: AppColors.white,
            border: Border.all(color: AppColors.secondary, width: 2),
            borderRadius: BorderRadius.circular(8),
          ),
         margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Column(
          children: [
        // Container(
        //   width: context.screenSize().width,
        //   decoration: BoxDecoration(
        //     color: AppColors.white,
        //     border: Border.all(color: AppColors.secondary, width: 2),
        //     borderRadius: BorderRadius.circular(8),
        //   ),
        //  margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
          Container(

            child:

              Padding(
                padding: EdgeInsets.fromLTRB(10, 15, 10, 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 3,
                      child: Text(
                        widget.heading.companyName,
                        style: TextStyling.mediumBold.copyWith(fontSize: 14, color: AppColors.primary),
                        textAlign: TextAlign.start,
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        widget.heading.BookingInv,
                        style: TextStyling.mediumBold.copyWith(fontSize: 14, color: AppColors.primary),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        widget.heading.ExecuteInv,
                        style: TextStyling.mediumBold.copyWith(fontSize: 14, color: AppColors.primary),
                        textAlign: TextAlign.center,
                      ),

                    ),

                    Expanded(
                      flex: 2,
                      child: Text(
                        widget.heading.ExecuteAmount,
                        style: TextStyling.mediumBold.copyWith(fontSize: 14, color: AppColors.primary),
                        textAlign: TextAlign.center,
                      ),

                    ),

                  ],
                ),
              ),),
              Divider(color: AppColors.lightGrey,),

              Container(
                height: 400,
                child:

              ListView.builder(
              //  physics: NeverScrollableScrollPhysics(),
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: widget.data.length,
                itemBuilder: (context, index) {
                  return
                  (widget.data.length > 0)
                  ?

                  SingleChildScrollView(
                    child: InkWell(
                      onTap: () {

                        String name = widget.data[index].companyName;

                        //heading. = name;
                        String? code = widget.data[index].companyid;
                        //String supervisorbrach=widget.data[index].
                        widget.onTap(code,name);

                        // print(index);
                        //print( data[index].companyName);
                        //data[index].invCount;
                      },
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                        child: Column(children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                flex: 3,
                                child: Text(
                                  widget.data[index].companyName,
                                  style: TextStyling.mediumRegular.copyWith(fontSize: 14,
                                      color: AppColors.primary),
                                  textAlign: TextAlign.start,
                                ),
                              ),
                              //SizedBox(height: 20),

                              Expanded(
                                flex: 2,
                                child: Column(
                                  children: [
                                    Text(
                                widget.data[index].booking.toString(),
                                      style: TextStyling.mediumRegular.copyWith(
                                        fontSize: 14,
                                          color: AppColors.primary),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Text(
                                  widget.data[index].invCount,
                                  style: TextStyling.mediumRegular.copyWith(
                                      //fontSize: 13,
                                      color: AppColors.primary),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Text(
                                  //widget.data[index].totalSales,
                                  NumberFormat('#,##0', 'en_US').format(double.parse(widget.data[index].totalSales.replaceAll(',', '')).round()),

                                  style: TextStyling.mediumRegular.copyWith(

                                      color: AppColors.primary),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                                    // SizedBox(height: 30),
                                    ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                  flex:3,
                                  child: Text("")),
                              Expanded(
                                flex:5,
                                child: SizedBox(
                                  height:7,
                                    width: 200,
                                    child: CustomLinearProgressIndicator(value:widget.data[index].percent.toString(), valueColor: Colors.green, borderRadius: BorderRadius.circular(10),)),
                              ),
                              SizedBox(width: 5,),
                              Text('${widget.data[index].percent.toString()}%',style: TextStyle(color: AppColors.primary
                                  , fontWeight: FontWeight.w600,fontSize: 11),),
                              SizedBox(width: 10),
                              Container(
                                  height: 20,
                                  width: 20,
                                  child: Image.asset(Assets.click, color: AppColors.primary,)),
                            ],
                          ),
                          // Row(
                          //   //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //   children: [
                          //
                          //   Spacer(),
                          //   Text('${widget.data[index].percent.toString()}%',style: TextStyle(color: AppColors.primary
                          //       , fontWeight: FontWeight.w600,fontSize: 11),)
                          // ],),
                          // SizedBox(height: 8,),
                          // Row(
                          //   children: [
                          //     Spacer(),
                          //     Container(
                          //         height: 20,
                          //         width: 20,
                          //         child: Image.asset(Assets.click, color: AppColors.primary,)),
                          //   ],
                          // ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                            child: Divider(
                              color: AppColors.grey,
                              thickness: 0.4,
                            ),
                          )
                        ]),
                      ),
                    ),
                  )   : Padding(
                      padding: const EdgeInsets.all(8.0),
                  child: Text(
                  "Data Not Available",
                  style: TextStyling.mediumBold
                      .copyWith(color: AppColors.darkGrey),
                  ));
                },
    )



                // separatorBuilder: (BuildContext context, int index) {
                //   return Column(
                //     children: [
                //
                //
                //
                //
                //
                //
                //
                //       //SizedBox(height: 30),
                //       Padding(
                //         padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                //         child: Divider(
                //           color: AppColors.grey,
                //           thickness: 0.4,
                //         ),
                //       ),
                //     ],
                //   );
                // },
              )
              //     : Padding(
              //   padding: const EdgeInsets.all(8.0),
              //   child: Text(
              //     "Data Not Available",
              //     style: TextStyling.mediumBold
              //         .copyWith(color: AppColors.darkGrey),
              //   ),
              // ),

    ],

    ),
      );
  }
}



class CustomLinearProgressIndicator extends StatelessWidget {
  final String value;
  final Color valueColor;

  final BorderRadius borderRadius;

  CustomLinearProgressIndicator(
      {
    required this.value,

    required this.valueColor,
    required this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    double valueAsDouble = double.parse(value);
    return ClipRRect(
      borderRadius: borderRadius,
      child:  LinearProgressIndicator(
          value: valueAsDouble / 100,
          backgroundColor: Colors.black.withOpacity(0.3),
          valueColor: AlwaysStoppedAnimation<Color>(valueColor),
        ),


    );
  }
}
