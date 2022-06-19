import 'package:http/http.dart' as http;

class Networking {
  Future getExchangeRate({String currency, String coin}) async {
    http.Response response = await http.get(Uri.parse(
        "https://rest.coinapi.io/v1/exchangerate/$coin/$currency?apikey=C49DEB1D-6272-40FC-B41D-506B30078A91"));
    if (response.statusCode == 200) {
      //print(response.body);
    } else {
      print(response.statusCode);
    }
    return response.body;
  }
}
