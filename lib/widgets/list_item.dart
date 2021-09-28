import 'package:flutter/material.dart';

import 'my_custom_form.dart';

////////////////////////////////////////////////////////////////////////////////
//                 List Item Stuff for editing list item                      //
////////////////////////////////////////////////////////////////////////////////

// class ListItem extends ConsumerStatefulWidget {
class ListItem extends StatefulWidget
{
  late int index;
  TextEditingController controller = TextEditingController();

  String? firstName;
  String? lastName;
  String? email;
  String? unid;
  late bool isEditMode;

  Function? callbackHomepage;
  Function? triggerText;


  ListItem(String? firstName, String? lastName, String? email, String? unid,
      Function? callback, Function? triggerText, TextEditingController controller)
  {
    this.firstName = firstName??"";
    this.lastName = lastName??"";
    this.email = email??"";
    this.unid = unid??"";
    isEditMode = true;
    this.callbackHomepage = callback;
    this.triggerText = triggerText;
    this.controller = controller;
  }

  @override
  _ListItemState createState() => _ListItemState();
}

class _ListItemState extends State<ListItem>
{
  bool _isEnabled = false;

  void callbackListItemState()
  {
    print("Running setState in ListItemState");
    setState(() { /*_isEnabled = false;*/ });
  }

  @override
  Widget build(BuildContext context)
  {
    if (_isEnabled)
    {
      return ListTile
      (
        title: MyCustomForm
        (
          widget.firstName,
          widget.lastName,
          widget.email,
          widget.unid,
          widget.callbackHomepage,
          widget.triggerText,
          callbackListItemState,
          widget.controller
        ),
        trailing: GestureDetector(
          child: const Icon(
            Icons.edit,
            color: Colors.black,
          ),
          onTap: () {
            setState(() {
              _isEnabled = !_isEnabled;
            });
          },
        ),
      );
    }
    else
    {
      return ListTile
      (
        subtitle: Text('${widget.firstName} ${widget.lastName}'),

        // The icon button which will notify list item to change
        trailing: GestureDetector(
          child: const Icon(
            Icons.edit,
            color: Colors.black,
          ),
          onTap: () {
            setState(()
            {
              _isEnabled = !_isEnabled;
            });
          },
        ),
      );
    }
  }
}
