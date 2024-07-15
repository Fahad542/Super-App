import 'package:flutter/material.dart';
import 'package:premier/generated/assets.dart';
import 'package:premier/src/base/utils/utils.dart';
import 'package:premier/src/shared/buttons.dart';
import 'package:premier/src/shared/input_field.dart';
import 'package:premier/src/shared/spacing.dart';
import 'package:premier/src/styles/app_colors.dart';
import 'package:stacked/stacked.dart';
import 'login_view_model.dart';

class LoginView extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return ViewModelBuilder<LoginViewModel>.reactive(
      builder: (context, model, child) => Scaffold(
        extendBodyBehindAppBar: true,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                  height: context.screenSize().height - 100,
                  child: Form(
                    child: Builder(builder: (ctx) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Spacer(),
                          Image.asset(
                            Assets.imagesLoginill,
                            width: context.screenSize().width * 0.8,
                          ),
                          Spacer(),
                          Container(

                              child: Image.asset(Assets.premier)),
                          VerticalSpacing(20),
                          MainInputField(
                              label: "UserName",
                              hint: "Enter UserName",
                              controller: model.username,
                              error: "enter username"),
                          VerticalSpacing(20),
                          MainInputField(
                              label: "Password",
                              hint: "Enter Password",
                              controller: model.password,
                              error: "enter password",
                              isPassword: (model.isShowPassword) ? false : true,
                              suffixIcon: InkWell(
                                  splashColor: Colors.transparent,
                                  onTap: () {
                                    model.isShowPassword =
                                        !model.isShowPassword;
                                    model.notifyListeners();
                                  },
                                  child: Icon(
                                    Icons.remove_red_eye_outlined,
                                    size: 20,
                                    color: AppColors.primary,
                                  ))),
                          VerticalSpacing(30),
                          MainButton(
                              text: "Login",
                              isBusy: model.isBusy,
                              onTap: () {
                                model.onLogin(ctx);
                              }),
                          Spacer(),
                          Spacer(),
                        ],
                      );
                    }),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      viewModelBuilder: () => LoginViewModel(),
      onModelReady: (model) => model.init(),
    );
  }
}
