import 'package:http/http.dart';

class NetworkHelper {
  String mApi;

  NetworkHelper({this.mApi});

  Future<Response> getData() async {
    Response response = await get(mApi);

    if (response.statusCode == 200) {
      return response;
    } else {
      print(response.statusCode);
    }
  }
}
