import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../models/user_details.dart';

Future<http.Response> updateDocument(
    String firstName, String lastName, String emailAddress, String unid) {
  String username = 'Joe Public';
  const password = 'Whatever';
  final credentials = '$username:$password';
  final stringToBase64 = utf8.fuse(base64);
  final encodedCredentials = stringToBase64.encode(credentials);

  return http.put(
    Uri.parse(
        'https://dp5.dominopeople.ie/visualizer/vitalijusvisualizer.nsf/api/data/documents/unid/$unid'),
    headers: {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.authorizationHeader: 'Basic $encodedCredentials',
    },
    body: jsonEncode(<String, String>{
      'last_name': lastName,
      'first_name': firstName,
      'email': emailAddress,
    }),
  );
}

////////////////////////////////////////////////////////////////////////////////
//                               I/O STUFF                                    //
////////////////////////////////////////////////////////////////////////////////

const String url =
    'https://dp5.dominopeople.ie/visualizer/vitalijusvisualizer.nsf/api/data/collections/unid/fedbeb2447022ffa8025860100352a70?count=2000';

// Get json result and convert it to model. Then add
Future<List> getUserDetails() async
{
  const username = 'Joe Public';
  const password = 'Whatever';
  const credentials = '$username:$password';
  final stringToBase64 = utf8.fuse(base64);
  final encodedCredentials = stringToBase64.encode(credentials);

  http.Response response = await http.get(
    Uri.parse(url),
    headers: {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.authorizationHeader: 'Basic $encodedCredentials',
    },
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    var listModel = [];
    for (Map<String, dynamic> i in data) {
      listModel.add(UserDetails.fromJson(i));
    }

    return listModel.reversed.toList();
  } else {
    throw Exception("Something gone wrong, ${response.statusCode}");
  }
}
