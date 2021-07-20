import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_raspbian_web/http_builder.dart';
import 'package:flutter_raspbian_web/http_request.dart';
import 'package:flutter_raspbian_web/menu/state.dart';
import 'package:flutter_raspbian_web/urls.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'logic.dart';

class MenuItem extends StatelessWidget {
  final name;
  final url;

  final MenuLogic logic = Get.put(MenuLogic());
  final MenuState state = Get.find<MenuLogic>().state;
  final count = 0.obs;

  MenuItem({this.name = 'icecreame', this.url = Constants.testImageUrl});

  void refreshData() {
    simpleHttpRequest(Constants.typedParamUrl('cookingcount', {'food': name}),
        callback: (j) {
      var c = j['count(*)'];
      count.value = c;
    });
  }

  @override
  Widget build(BuildContext context) {
    refreshData();
    return GestureDetector(
      onTap: () {
        showCupertinoDialog(
            context: context,
            builder: (c) {
              return CupertinoAlertDialog(
                  title: Text(Constants.sureTip),
                  actions: [
                    CupertinoDialogAction(
                      child: Text('是'),
                      onPressed: () {
                        Navigator.pop(context);
                        showCupertinoDialog(
                            context: context,
                            barrierDismissible: true,
                            builder: (c) {
                              return HttpBuilder(
                                  url: Constants.typedParamUrl(
                                      'getcode', {'food': name}),
                                  builder: (context, snapshot) {
                                    return CupertinoAlertDialog(
                                      title: Text(
                                          '请妥善保存凭据(手机拍照保存)\n订单号:${snapshot["serialNumber"]}'),
                                      content: Column(
                                        children: [
                                          Container(
                                            width: 200,
                                            height: 200,
                                            child: QrImage(
                                              data: snapshot['qrCode'],
                                              version: QrVersions.auto,
                                              size: 200.0,
                                            ),
                                          ),
                                          // Image.network('https://media.giphy.com/media/O5ac76MtFGPHG/giphy.gif'),
                                        ],
                                      ),
                                    );
                                  });
                            }).then((value) => refreshData());
                      },
                    ),
                    CupertinoDialogAction(
                      child: Text('否'),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ]);
            });
      },
      child: SizedBox(
        width: 200,
        child: Container(
          padding: EdgeInsets.only(left: 50, bottom: 50),
          child: Stack(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.network(
                        // 'https://media.giphy.com/media/O5ac76MtFGPHG/giphy.gif'
                        url),
                    Text(name),
                    Obx(() {
                      return Text(
                        '排队数 ${count.value}',
                        style: TextStyle(color: Colors.redAccent),
                      );
                    }),
                    ElevatedButton(
                        onPressed: () {
                          simpleHttpRequest(
                              Constants.typedParamUrl(
                                  'fetchbyname', {'food': name}),
                              callback: (xl) {
                            if (xl.length == 0) {
                              Get.snackbar('提示', '当前菜品没有任何订单',
                                  snackPosition: SnackPosition.BOTTOM);
                              return;
                            }
                            var x = xl[0];
                            // if (x.runtimeType.toString() == 'List<dynamic>') {
                            //   Get.snackbar('提示', '当前菜品没有任何订单',
                            //       snackPosition: SnackPosition.BOTTOM);
                            //   return;
                            // }
                            print(x);

                            state.camQuery = true;
                            state.waitingQr = x['uid'];
                            state.waitingFood = x['food'];
                            state.waitingId = x['id'];
                            showCupertinoDialog(
                                context: context,
                                barrierDismissible: true,
                                builder: (c) {
                                  // print(x.runtimeType);
                                  return CupertinoAlertDialog(
                                    title:
                                        Text('请 ${x["id"]} 号用户扫码取\n${x["food"]}'
                                            // '二维码应该是${state.waitingQr}'
                                            ),
                                    content: Column(
                                      children: [
                                        Stack(
                                          children: [
                                            ConstrainedBox(
                                              constraints: BoxConstraints(
                                                minHeight: 200
                                              ),
                                              child: Column(
                                                children: [
                                                  SizedBox(height: 10,),
                                                  SizedBox(height: 40,width: 40,child: CircularProgressIndicator(),),
                                                  SizedBox(height: 10,),
                                                  Obx(() {
                                                    print('refff');
                                                    state.imgRefresher.value;
                                                    return Image.network(
                                                      Constants.camUrl,
                                                    );
                                                  }),
                                                ],
                                              ),
                                            ),
                                            // Align(alignment: Alignment.center,child: CircularProgressIndicator()),
                                          ],
                                        )
                                      ],
                                    ),
                                  );
                                }).then((value) {
                              refreshData();
                              state.camQuery = false;
                            });
                          });
                        },
                        child: Text('取餐'))

                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
