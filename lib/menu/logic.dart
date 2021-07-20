import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_raspbian_web/http_request.dart';
import 'package:flutter_raspbian_web/urls.dart';
import 'package:get/get.dart';

import 'state.dart';

class MenuLogic extends GetxController {
  final state = MenuState();

  MenuLogic() {
    Timer.periodic(Duration(seconds: 1), (t) {
      if (!state.camQuery) return;
      simpleHttpRequest(Constants.typedParamUrl('camtext', {}), callback: (j) {
        print(state.waitingQr);
        state.imgRefresher.value += 1;
        if (j == state.waitingQr) {
          // if('$j'=='0'){
          simpleHttpRequest(
              Constants.typedParamUrl('finishone', {'id': state.waitingId}),
              callback: (j) {
            Navigator.of(Get.overlayContext).pop();
            Get.snackbar(
                '提示信息', '${state.waitingId} 号用户取餐 ${state.waitingFood} 成功',
                snackPosition: SnackPosition.BOTTOM);
            state.camQuery = false;
          });
        }
        print(j);
      });
    });
  }
}
