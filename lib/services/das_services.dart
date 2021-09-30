import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../models/user_details.dart';


////////////////////////////////////////////////////////////////////////////////
//                               I/O STUFF                                    //
////////////////////////////////////////////////////////////////////////////////

Future<http.Response> updateDocument(String firstName, String lastName, String emailAddress, String unid) async
{
  String username = 'Joe Public';
  const password = 'Whatever';
  final credentials = '$username:$password';
  final stringToBase64 = utf8.fuse(base64);
  final encodedCredentials = stringToBase64.encode(credentials);

  http.Response response = await http.put
  (
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

  print("Done update, response status code: "+response.statusCode.toString());
  return response;
}