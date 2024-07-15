import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:premier/generated/assets.dart';
import 'package:premier/src/base/utils/Constants.dart';
import 'package:premier/src/base/utils/utils.dart';
import 'package:premier/src/services/local/navigation_service.dart';
import 'package:premier/src/shared/spacing.dart';
import 'package:premier/src/styles/app_colors.dart';
import 'package:premier/src/styles/text_theme.dart';
import 'package:premier/src/views/login/login_view.dart';

class AppView extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: AppColors.primary,
      statusBarIconBrightness: Brightness.light,
    ));
    return StreamBuilder(
        stream: Connectivity().onConnectivityChanged,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return MaterialApp(
              title: Constants.appTitle,
              debugShowCheckedModeBanner: false,
              onGenerateRoute: NavService.onGenerateRoute,
              navigatorKey: NavService.key,
              theme: ThemeData(
                  scaffoldBackgroundColor: Colors.white,
                  useMaterial3: true,
                  colorScheme: ColorScheme(brightness: Brightness.light, primary: AppColors.primary, onPrimary: AppColors.white, secondary: AppColors.secondary, onSecondary: AppColors.white, error: AppColors.red, onError: AppColors.white, background: AppColors.white, onBackground: AppColors.white, surface: AppColors.white, onSurface: AppColors.primary),
                  fontFamily: 'Poppins'),
              home: LoginView(),
              builder: (context, child) {
                return snapshot.data == ConnectivityResult.none
                    ? NoInternet()
                    : Stack(
                        children: [child!],
                      );
              },
            );
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          return Center(child: CircularProgressIndicator());
        });
  }
}

class NoInternet extends StatelessWidget {
  const NoInternet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: context.screenSize().width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              Assets.imagesConnectionLost,
              width: context.screenSize().width * 0.8,
              height: context.screenSize().width * 0.8,
            ),
            VerticalSpacing(15),
            Text(
              "No Internet Found",
              style:
                  TextStyling.largeRegular.copyWith(color: AppColors.primary),
            ),
          ],
        ),
      ),
    );
  }
}

