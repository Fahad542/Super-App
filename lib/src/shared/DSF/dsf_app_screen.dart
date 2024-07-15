import 'package:flutter/material.dart';
import 'package:premier/src/shared/top_app_bar.dart';
import 'package:premier/src/views/dsf/dsf_menu/dsf_menu_view.dart';
import 'package:premier/src/views/supervisor/supervisor_menu/supervisor_menu_view.dart';

class DSFaAppScreen extends StatelessWidget {
  final String title;
  final Widget body;

  const DSFaAppScreen({Key? key, required this.body, required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        drawer: DSFMenuView(),
        appBar: MainAppBar(
          title: title,
        ),
        body: body,
      ),
    );
  }
}
class SupervisorAppScreen extends StatelessWidget {
  final String title;
  final Widget body;

  const SupervisorAppScreen({Key? key, required this.body, required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        drawer: SupervisorMenuView(),
        appBar: MainAppBar(
          title: title,
        ),
        body: body,
      ),
    );
  }
}
