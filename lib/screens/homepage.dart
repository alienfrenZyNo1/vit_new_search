import 'package:flutter/material.dart';
import 'package:vitalijus_search_app/models/user_details.dart';
import 'package:vitalijus_search_app/widgets/list_item.dart';

import '../services/das_services.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
{
  TextEditingController controller = TextEditingController();

  late Future<List<dynamic>> _userDetails;
  @override
  void initState()
  {
    super.initState();

    _userDetails = getUserDetails();
  }

  Future<void> _pullRefresh() async
  {
    List<dynamic> freshFutureDocuments = await getUserDetails();


    setState(() {
      _userDetails = Future.value(freshFutureDocuments);
    });
  }

  void callbackHomepage()
  {
    print("Running setState in Homepage");
    setState(() {  _pullRefresh(); });
  }

  final List<UserDetails> _searchResult = [];
  var userSnapshot = [];

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _pullRefresh,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Home'),
          elevation: 0.0,
        ),
        body: Column(
          children: <Widget>[
            Container(
              color: Theme.of(context).primaryColor,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  child: ListTile(
                    leading: const Icon(Icons.search),
                    title: TextField(
                      controller: controller,
                      decoration: const InputDecoration
                      (
                          hintText: 'Search', border: InputBorder.none
                      ),
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
            FutureBuilder(
              future: _userDetails,
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot)
              {
                if (snapshot.hasData)
                {
                  userSnapshot = snapshot.data;
                  return Expanded(
                    child:
                        _searchResult.isNotEmpty || controller.text.isNotEmpty
                            ? ListView.builder(
                                itemCount: _searchResult.length,
                                itemBuilder: (context, i) {
                                  var currentUser = _searchResult[i];
                                  return Card
                                  (
                                    child: ListItem
                                    (
                                      currentUser.firstName,
                                      currentUser.lastName,
                                      currentUser.email,
                                      currentUser.unid,
                                      callbackHomepage,
                                      onSearchTextChanged,
                                        controller
                                    ),
                                    margin: const EdgeInsets.all(0.0),
                                  );
                                },
                              )
                            : ListView.builder
                            (
                                itemCount: snapshot.data.length,
                                itemBuilder: (context, i)
                                {
                                  var currentUser = snapshot.data[i];
                                  return Card
                                  (
                                    child: ListItem
                                    (
                                      currentUser.firstName,
                                      currentUser.lastName,
                                      currentUser.email,
                                      currentUser.unid,
                                      callbackHomepage,
                                      onSearchTextChanged,
                                        controller
                                    ),
                                    margin: const EdgeInsets.all(0.0),
                                  );
                                },
                              ),
                  );
                }

                if (snapshot.hasError) {
                  return const Center(
                      child: Icon(
                    Icons.error,
                    color: Colors.red,
                    size: 82.0,
                  ));
                }

                return Expanded(
                  child: Center(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: const <Widget>[
                      CircularProgressIndicator(),
                      SizedBox(
                        height: 20.0,
                      ),
                      Text("Loading at the moment, please hold the line.")
                    ],
                  )),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  onSearchTextChanged(String text) async
  {

    _searchResult.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }

    _pullRefresh();

    for (var userDetail in userSnapshot)
    {
      if (userDetail.firstName.toLowerCase().contains(text.toLowerCase()) ||
          userDetail.lastName.toLowerCase().contains(text.toLowerCase())) {
        _searchResult.add(userDetail);
      }
    }
    setState(() {});
  }
}
