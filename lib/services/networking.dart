import 'package:http/http.dart' as http;
import 'dart:convert';

Future getData(String url) async {
  try {
    String data = await http.read(Uri.parse(url));
    return jsonDecode(data) ;
  } catch (e) {
    print(e);
  }
}
