import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:vitalijus_search_app/models/user_details.dart';
import 'package:vitalijus_search_app/widgets/list_item.dart';
import 'package:http/http.dart' as http;

import '../services/das_services.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController controller = TextEditingController();

  List<UserDetails> _userDetails = [];
  final List<UserDetails> _searchResult = [];
  bool loading = true;

  @override
  initState() {
    super.initState();
    getUserDetails();
  }

  Future<void> callbackHomepage() async {
    print("Running setState in Homepage");
    await getUserDetails();
  }

  @override
  Widget build(BuildContext context) {
    Widget child;

    if (loading) {
      child = CircularProgressIndicator();
    } else if (_searchResult.isNotEmpty || controller.text.isNotEmpty) {
      child = ListView.builder(
        itemCount: _searchResult.length,
        itemBuilder: (context, i) {
          var currentUser = _searchResult[i];
          return Card(
            child: ListItem(
                currentUser.firstName,
                currentUser.lastName,
                currentUser.email,
                currentUser.unid,
                callbackHomepage,
                onSearchTextChanged,
                controller),
            margin: const EdgeInsets.all(0.0),
          );
        },
      );
    } else {
      child = ListView.builder(
        itemCount: _userDetails.length,
        itemBuilder: (context, i) {
          var currentUser = _userDetails[i];
          return Card(
            child: ListItem(
                currentUser.firstName,
                currentUser.lastName,
                currentUser.email,
                currentUser.unid,
                callbackHomepage,
                onSearchTextChanged,
                controller),
            margin: const EdgeInsets.all(0.0),
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        elevation: 0.0,
      ),
      body: Column(children: <Widget>[
        Container(
          color: Theme.of(context).primaryColor,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              child: ListTile(
                leading: const Icon(Icons.search),
                title: TextField(
                  controller: controller,
                  decoration: const InputDecoration(
                      hintText: 'Search', border: InputBorder.none),
                  onChanged: onSearchTextChanged,
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.cancel),
                  onPressed: () {
                    controller.clear();
                    onSearchTextChanged('');
                  },
                ),
              ),
            ),
          ),
        ),
        Expanded(child: child)
      ]),
    );
  }

  onSearchTextChanged(String text) async {
    print("onSearchTextChanged start");
    _searchResult.clear();

    if (text.isEmpty) {
      setState(() {});
      return;
    }
    for (var userDetail in _userDetails) {
      if (userDetail.firstName.toLowerCase().contains(text.toLowerCase()) ||
          userDetail.lastName.toLowerCase().contains(text.toLowerCase())) {
        _searchResult.add(userDetail);
      }
    }
    setState(() {});
    print("onSearchTextChanged end");
  }

  Future<List<UserDetails>> getUserDetails() async {
    setState(() {
      loading = true;
    });
    print("loading = true");

    const String url =
        'https://dp5.dominopeople.ie/visualizer/vitalijusvisualizer.nsf/api/data/collections/unid/fedbeb2447022ffa8025860100352a70?count=2000';
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
      List<UserDetails> listModel = [];
      for (Map<String, dynamic> i in data) {
        listModel.add(UserDetails.fromJson(i));
      }
      print("Done getUsersDetails: " + response.statusCode.toString());
      _userDetails = listModel.reversed.toList();

      setState(() {
        loading = false;
      });
      print("loading = false");

      return listModel.reversed.toList();
    } else {
      throw Exception("Something gone wrong, ${response.statusCode}");
    }
  }
}
