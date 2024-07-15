import 'package:flutter/material.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:package_info/package_info.dart';
import 'package:premier/src/app/app_view.dart';
import 'package:premier/src/configs/app_setup.locator.dart';
import 'package:premier/src/services/local/auth_service.dart';
import 'package:premier/src/services/local/background_serv.dart';
import 'package:premier/src/services/local/flavor_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  AuthService.prefs = await SharedPreferences.getInstance();
  BackgroundServ.init();

  // getting package
  final package = await PackageInfo.fromPlatform();

  setupLocator();

  // app flavor init
  FlavorService.init(package);

  runApp(AppView());
}


////////////////////
// class update extends StatefulWidget {
//   const update({Key? key}) : super(key: key);
//
//   @override
//   State<update> createState() => _updateState();
//
// }
//
// class _updateState extends State<update> {
//   Future<void> checkForUpdate() async {
//     print('checking for Update');
//     InAppUpdate.checkForUpdate().then((info) {
//       setState(() {
//         if (info.updateAvailability == UpdateAvailability.updateAvailable) {
//           print('update available');
//           update();
//         }
//       });
//     }).catchError((e) {
//       print(e.toString());
//     });
//   }
//
//   void update() async {
//     print('Updating');
//     await InAppUpdate.startFlexibleUpdate();
//     InAppUpdate.completeFlexibleUpdate().then((_) {}).catchError((e) {
//       print(e.toString());
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return const Placeholder();
//   }
// }
