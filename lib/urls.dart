import 'dart:collection';

class Constants {
  static var base = 'http://127.0.0.1:8080/apis';

  static var urlTitle = '订单系统';
  static var appTitle = '伍颖、殷运松的餐饮系统';
  static var sureTip = '确认下单？';

  static get camUrl =>
      base +
      '?type=img&path=data/cam.jpg&t=${DateTime.now().millisecondsSinceEpoch}';
  static const testImageUrl =
      'https://media.giphy.com/media/O5ac76MtFGPHG/giphy.gif';

  static String typedParamUrl(String type, dynamic otherParams) {
    List<String> params = ['type=$type'];
    otherParams.forEach((key, value) {
      params.add('$key=$value');
    });
    var paramString = params.join('&');
    return "$base?$paramString";
  }
}
