import 'package:premier/src/services/local/base/auth_view_model.dart';
import 'package:premier/src/services/remote/base/api_view_model.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class DsfDetailTableViewModel extends ReactiveViewModel with ApiViewModel, AuthViewModel {
  final BuildContext context;

  DsfDetailTableViewModel(this.context);

}
