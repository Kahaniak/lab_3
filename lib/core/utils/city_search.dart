import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:lab_3/core/secrets/secret.dart';
import 'package:lab_3/core/secrets/secret_loader.dart';

Future<List> getCities(String query) async {

  // Secret secret = await SecretLoader(secretPath: "assets/json/config.json").load();
  // String key = secret.apiKey;
  // print('key : $key');

  var response = await http.get(
    "https://api.locationiq.com/v1/autocomplete.php?key=pk.bdde82faa37e2a702b5a5a8fb593f365&q=$query",
    headers: {
      HttpHeaders.acceptHeader: 'application/json',
    },
  );

  List allCities = json.decode(response.body);

  return allCities.length >= 10 ? allCities.getRange(0, 10).toList() : allCities.toList();
}
