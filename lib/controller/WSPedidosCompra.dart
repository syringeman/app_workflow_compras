import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'Post.dart';

Future<Post> WSPedidosCompra(String tipo) async {
  final response = await http.get(
    Uri.encodeFull(
        'http://10.1.7.144:6165/rest/api/ztms/v1/RTERESTPO/PCDUMMY/000018/$tipo'),
    headers: {
      "Content-Type": "application/json",
      "Authorization": "Basic YXBpOmFwaTEyMzQ1Ng==",
    },
  );

  if (response.statusCode == 200) {
    // If the call to the server was successful, parse the JSON.
    return Post(body: json.decode(response.body));
  } else {
    // If that call was not successful, throw an error.
    throw Exception('Falhou ao carregar o post');
  }
}
