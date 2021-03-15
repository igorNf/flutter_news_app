import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

TextEditingController controller = new TextEditingController();
class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    final String appTitle = "Свежайшие новости";

    return MaterialApp(
      title: appTitle,
      home: Scaffold(
        appBar: AppBar(
          title: Text(appTitle),
        ),
        body: MyCustomForm(),
      ),
    );
  }

}

// Define a custom Form widget.
class MyCustomForm extends StatefulWidget {
  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}

// Define a corresponding State class.
// This class holds data related to the form.
class MyCustomFormState extends State<MyCustomForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a `GlobalKey<FormState>`,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();



  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Form(
        key: _formKey,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              // Add TextFormFields and ElevatedButton here.
              TextFormField(validator: (value) {
                if(value.isEmpty) {
                  return "Введите строку для поиска";
                }
                return null;
              }, controller: controller,),
              ElevatedButton(onPressed: () {
                // Validate returns true if the form is valid, or false
                // otherwise.

                if (_formKey.currentState.validate()) {
                  // If the form is valid, display a Snackbar.
                  print("Value: ${controller.value.text}");
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text('Processing Data: ${controller.value.text}')));
                }
              } , child: Text("Искать"))
            ]
        )
    );
  }




}