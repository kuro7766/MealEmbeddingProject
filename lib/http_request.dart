import 'dart:convert';

import 'package:http/http.dart' as http;

typedef Response<T> = void Function(T json);

Future<T> simpleHttpRequest<T>(url, {Response<T> callback}) async {
  var r = await http.get(Uri.parse(url));
  print(T.toString());
  // if(T.toString()=='dynamic'){
  //   print('warning : you are using dynamic HttpRequest!');
  //   print(r.body);
  // }
  // T j = JsonConvert.fromJsonAsT(jsonDecode(r.body));
  dynamic j;
  try {
    j = (jsonDecode(r.body));
  } catch (e) {
    j = r.body;
  }

  callback?.call(j);

  return j;
}
