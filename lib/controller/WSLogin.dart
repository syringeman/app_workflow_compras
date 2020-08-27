import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

Future<Post> WSLogin(String usuario, String senha) async {
  final response = await http.post(
    Uri.encodeFull(
        'http://10.1.7.144:6165/rest/api/ztms/v1/RTERESTPO/APPLOGIN/$usuario/$senha'),
    headers: {
      "Content-Type": "application/json",
      "Authorization": "Basic YXBpOmFwaTEyMzQ1Ng==",
    },
  );

  if (response.statusCode == 200 || response.statusCode == 201) {
    // If the call to the server was successful, parse the JSON.
    return Post(body: json.decode(response.body));
  } else {
    // If that call was not successful, throw an error.
    throw Exception('Falhou ao carregar o post');
  }
}

class Post {
  final Map<String, dynamic> body;

  Post({this.body});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      body: json['body'],
    );
  }
}
