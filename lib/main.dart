import 'package:flutter/material.dart';
import 'package:flutter_raspbian_web/menu/view.dart';
import 'package:flutter_raspbian_web/urls.dart';
import 'package:get/get.dart';

import 'menu/logic.dart';
import 'menu/state.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: Constants.urlTitle,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MainPage(),
    );
  }
}

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MenuPage();
  }
}
