import 'package:flutter/material.dart';
import 'package:flutter_raspbian_web/menu/menu_item.dart';
import 'package:flutter_raspbian_web/urls.dart';
import 'package:get/get.dart';

import '../meals.dart';
import 'logic.dart';
import 'state.dart';

class MenuPage extends StatelessWidget {
  final MenuLogic logic = Get.put(MenuLogic());
  final MenuState state = Get.find<MenuLogic>().state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(Constants.appTitle),
        ),
        body: ListView(
          children: [
            Wrap(
              children: List.generate(
                  19,
                  (index) => MenuItem(
                      name: meals[index * 2 + 1],
                      // url: 'http://kuroweb.cf/a/${index}.jpg'
                      url: Constants.typedParamUrl(
                          'img', {'path': 'data/pics/$index.jpg'})
                      // url: 'http://127.0.0.1:8080/apis?type=img',
                      // meals[index*2],
                      )),
            ),
          ],
        ));
  }
}
