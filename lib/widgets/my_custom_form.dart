import 'package:flutter/material.dart';

import '../services/das_services.dart';

class MyCustomForm extends StatefulWidget {
  //const MyCustomForm({Key? key}) : super(key: key);
  late String? firstName;
  late String? lastName;
  late String? email;
  late String? unid;
  TextEditingController controller = TextEditingController();

  Function? callbackHomepage;
  Function? callbackListItem;
  Function? triggerText;

  MyCustomForm(
      String? firstName,
      String? lastName,
      String? email,
      String? unid,
      Function? callbackHomepage,
      Function? triggerText,
      Function? callbackListItem,
      TextEditingController controller) {
    this.firstName = firstName;
    this.lastName = lastName;
    this.email = email;
    this.unid = unid;
    this.callbackHomepage = callbackHomepage;
    this.triggerText = triggerText;
    this.callbackListItem = callbackListItem;
    this.controller = controller;
  }

  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}

// Create a corresponding State class.
// This class holds data related to the form.
class MyCustomFormState extends State<MyCustomForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a GlobalKey<FormState>,
  // not a GlobalKey<MyCustomFormState>.

  void callbackMyCustomFormState() {
    print("Running setState in MyCustomFormState");
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.

    final _formKey = GlobalKey<FormState>();

    TextEditingController _firstNameController =
        TextEditingController(text: widget.firstName);
    TextEditingController _lastnameController =
        TextEditingController(text: widget.lastName);
    TextEditingController _emailController =
        TextEditingController(text: widget.email);

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "UNID->  " + (widget.unid ?? ''),
            style: const TextStyle(
                fontWeight: FontWeight.bold, height: 5, fontSize: 10),
          ),
          TextFormField(
            // can't use initial value and controller at same time.
            // initialValue: widget.firstName,
            controller: _firstNameController,
            decoration: const InputDecoration(
                labelText: 'First Name',
                labelStyle: TextStyle(
                  color: Colors.blue,
                )),
            // The validator receives the text that the user has entered.
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
          ),
          TextFormField(
            //initialValue: widget.lastName,
            controller: _lastnameController,
            decoration: const InputDecoration(
                labelText: 'Second Name',
                labelStyle: TextStyle(
                  color: Colors.blue,
                )),
            // The validator receives the text that the user has entered.
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
          ),
          TextFormField(
            //initialValue: widget.email,
            controller: _emailController,
            decoration: const InputDecoration(
                labelText: 'Email',
                labelStyle: TextStyle(
                  color: Colors.blue,
                )),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: ElevatedButton(
              onPressed: () async {
                // Validate returns true if the form is valid, or false otherwise.
                if (_formKey.currentState!.validate()) {
                  // If the form is valid, display a snackbar. In the real world,
                  // you'd often call a server or save the information in a database.
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Processing Data')),
                  );

                  print("before documents update");
                  await updateDocument(
                      _firstNameController.text,
                      _lastnameController.text,
                      _emailController.text,
                      widget.unid ?? '');
                  print("After documents update");

                  print("before triggering callbacks");
                  //callbackMyCustomFormState();
                  await widget.callbackHomepage!();
                  //widget.callbackListItem!();
                  widget.triggerText!(widget.controller.text);
                  print("After triggering callbacks");
                }
              },
              child: const Text('Submit'),
            ),
          ),
        ],
      ),
    );
  }
}
