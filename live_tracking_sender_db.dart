import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; //SystemNavigator.pop();
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import '../menu_list_after_login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LiveTrackingSenderDb extends StatelessWidget {
  const LiveTrackingSenderDb({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromARGB(250, 50, 50, 250),
          foregroundColor: Colors.white,
          title: const Center(child: Text("LIVE SENDER")),
        ),
        body: HomePage(),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late SharedPreferences pref;
  late String username_pref_ = "";
  late String name_pref_ = "";

  LocationData? _locationData2;
  bool light0 = true;
  var userid1;
  var name1;

  Future<void> initial() async {
    pref = await SharedPreferences.getInstance();
    setState(() {
      username_pref_ = pref.getString('username_pref_').toString();
      name_pref_ = pref.getString('name_pref_').toString();
    });
  }

  //....................................................

  Future<void> _getCoordinateLocation() async {
    Location location = Location();
    final _locationData = await location.getLocation();
    print(_locationData);

    setState(() {
      _locationData2 = _locationData;
    });
  }

  //............................................................................................

  Future _insertUpdateCoordinateLocation() async {
    final url = Uri.parse(
        "https://mediumsitompul.com/googlemaps/insert_update_coordinate_location.php");
    var response = await http.post(url, body: {
      "lat": "${_locationData2?.latitude}",
      "lng": "${_locationData2?.longitude}",
      "username1": "${username_pref_.toString()}",
      "name1": "${name_pref_.toString()}",
    });
  }

  //...................................................
  int _n = 1;
  @override
  void initState() {
    Timer.periodic(Duration(seconds: 5), (Timer timer) {
      if (light0 == true) {
        print("OK");
        _getCoordinateLocation();
        _insertUpdateCoordinateLocation();
        _n++;
        print(_n);
      } else if (light0 == false) {
        print("NOK");
      }
    });
    // TODO: implement initState
    super.initState();
    initial();
  }
  //...................................................

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ElevatedButton(
              onPressed: _getCoordinateLocation,
              child: const Text("AUTO SEND EVERY 5 SEC")),
          const SizedBox(
            height: 20,
          ),

          Center(child: Text("Welcome ${name_pref_} / ${username_pref_}")),

          const SizedBox(
            height: 20,
          ),

          //>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("disable"),
                  Switch(
                    value: light0,
                    onChanged: (bool value) {
                      setState(() {
                        light0 = value;
                        print("light0");
                        print(light0);
                      });
                    },
                  ),
                  const Text("enable"),
                ],
              ),
            ],
          ),
          //>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

          _locationData2 != null
              ? Wrap(
                  children: [
                    Center(
                      child: Text(
                        "Your Latitude: ${_locationData2?.latitude}",
                        style: const TextStyle(fontSize: 20),
                      ),
                    ),
                    Center(
                      child: Text(
                        "Your Longitude: ${_locationData2?.longitude}",
                        style: const TextStyle(fontSize: 20),
                      ),
                    ),
                    Center(
                      child: Text(
                        "Sampling: ${_n}",
                        style: const TextStyle(
                            fontSize: 40,
                            fontStyle: FontStyle.italic,
                            color: Colors.red),
                      ),
                    ),
                  ],
                )
              : Container(),
        ],
      ),

      //...............................................................
      floatingActionButton: FloatingActionButton(
        onPressed: (() {
          showToastMessage("BACK TO MAIN MENU");
          // showToastMessage("EXIT APPS");
          // SystemNavigator.pop(); // recommended
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    const MenuListAfterLogin(), //What is that?
              ));
        }),
        tooltip: 'Reload data',
        foregroundColor: Colors.white,
        backgroundColor: Colors.red,
        child: const Icon(Icons.ac_unit),
      ),
      //...............................................................
    );
  }
}

//xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
//No Build Context
//showToastMessage("Show Toast Message on Flutter");
void showToastMessage(String message) {
  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      textColor: Colors.white,
      fontSize: 16.0);
}
//xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
