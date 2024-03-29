import 'dart:async';
import 'dart:convert' show json;

import 'package:flutter/material.dart';

import "package:http/http.dart" as http;

import 'package:virus_tracker/locationPage/locationForm.dart';
import 'package:url_launcher/url_launcher.dart';

import 'globals.dart' as globals;
import 'all_translations.dart';

import 'package:virus_tracker/locationPage/locationList.dart';
import 'package:virus_tracker/thsrPage/thsrList.dart';
import 'package:virus_tracker/trPage/trList.dart';
import 'package:virus_tracker/metroPage/taipeiMetro/taipeiMetroList.dart';
import 'package:virus_tracker/metroPage/kaohsiungMetro/kaohsiungMetroList.dart';
import 'package:virus_tracker/metroPage/metroRegionPage.dart';
import 'package:virus_tracker/busPage/busList.dart';
import 'package:virus_tracker/taxiPage/taxiList.dart';
import 'package:virus_tracker/completeListPage.dart';
import 'package:virus_tracker/settingPage.dart';

class HomePage extends StatefulWidget {
  @override
  State createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String language = globals.language;

  @override
  void initState() {
    super.initState();
    Timer.periodic(Duration(milliseconds: 100), (timer) {
      if (!mounted) return;
      if (language != globals.language) {
        setState(() {
          allTranslations.setNewLanguage(globals.language);
          language = globals.language;
        });
      }
    });
  }

  // var buttonColor = Color.fromRGBO(0, 0xCC, 0xFF, 1);
  // var backgroundColor = Color.fromRGBO(0, 0x51, 0x64, 1);
  // var appbarColor = Color.fromRGBO(0, 0xFF, 0xCC, 1);

  // var buttonColor = Color.fromRGBO(0x00, 0xFF, 0xCC, 1);
  // var backgroundColor = Color.fromRGBO(0x00, 0x51, 0x64, 1);
  // var appbarColor = Color.fromRGBO(0x07, 0x61, 0x5B, 1);

  final pages = [
    LocationList(),
    THSRList(),
    TRList(),
    TaipeiMetroList(),
    BusList()
  ];
  //UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Stack(
              // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Column(children: <Widget>[
                  SizedBox(height: 7),
                  Center(
                    child: Text(allTranslations.text('Together'),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 30.0,
                          // fontFamily: 'Arial'
                        )),
                  ),
                ]),
                Align(
                    alignment: Alignment.centerRight,
                    child: PopupMenuButton<String>(
                      onSelected: (val) async {
                        if (val == 'feedback') {
                          var url =
                              'mailto:togethertraveldiary@gmail.com?subject=${allTranslations.text('Feedback')}&body=';
                          if (await canLaunch(url)) {
                            await launch(url);
                          } else {
                            throw 'Could not launch $url';
                          }
                        } else if (val == 'completeList') {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  CompleteListPage()));
                        } else if (val == 'setting') {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  SettingPage()));
                        } else if (val == 'privacy') {
                          const url =
                              'https://together-travel-lo-0.flycricket.io/privacy.html';
                          if (await canLaunch(url)) {
                            await launch(url);
                          } else {
                            throw 'Could not launch $url';
                          }
                        } else if (val == 'facebook') {
                          const url =
                              'https://www.facebook.com/%E4%B8%80%E8%B5%B7-%E5%BF%AB%E9%80%9F%E7%99%BB%E8%A8%98%E4%BA%A4%E9%80%9A%E9%81%8B%E8%BC%B8%E8%BB%8C%E8%B7%A1-104122821309810/?modal=admin_todo_tour';
                          if (await canLaunch(url)) {
                            await launch(url);
                          } else {
                            throw 'Could not launch $url';
                          }
                        } else if (val == 'instagram') {
                          const url =
                              'https://instagram.com/togethertraveldiary?igshid=1arpr6c6frc53';
                          if (await canLaunch(url)) {
                            await launch(url);
                          } else {
                            throw 'Could not launch $url';
                          }
                        }
                      },
                      itemBuilder: (BuildContext context) =>
                          <PopupMenuEntry<String>>[
                        PopupMenuItem<String>(
                          value: 'completeList',
                          child: Text(allTranslations.text('Complete List')),
                        ),
                        PopupMenuItem<String>(
                          value: 'setting',
                          child: Text(allTranslations.text('Setting')),
                        ),
                        PopupMenuItem<String>(
                          value: 'feedback',
                          child: Text(allTranslations.text('Feedback')),
                        ),
                        PopupMenuItem<String>(
                          value: 'privacy',
                          child: Text(allTranslations.text('Privacy Policy')),
                        ),
                        // PopupMenuItem<String>(
                        //   value: 'tutorial',
                        //   child: Text(allTranslations.text('Tutorial')),
                        // ),
                        PopupMenuItem<String>(
                          value: 'facebook',
                          child: Row(children: <Widget>[
                            Image(
                                image: AssetImage('assets/fb_${globals.theme}.png'),
                                height: 20.0),
                            Padding(
                                padding: const EdgeInsets.only(left: 15),
                                child: Text('Facebook',
                                    style: TextStyle(
                                        color: (Theme.of(context).brightness ==
                                                Brightness.dark)
                                            ? Theme.of(context).indicatorColor
                                            : Theme.of(context).primaryColor))),
                          ]),
                        ),
                        PopupMenuItem<String>(
                          value: 'instagram',
                          child: Row(children: <Widget>[
                            Image(
                                image: AssetImage('assets/IG_${globals.theme}.png'),
                                height: 20.0),
                            Padding(
                                padding: const EdgeInsets.only(left: 15),
                                child: Text('Instagram',
                                    style: TextStyle(
                                        color: (Theme.of(context).brightness ==
                                                Brightness.dark)
                                            ? Theme.of(context).accentColor
                                            : Theme.of(context).primaryColor))),
                          ]),
                        ),
                      ],
                    )),
              ]),
        ),
        // backgroundColor: backgroundColor,
        body: Container(
            child: ListView(
          children: <Widget>[
            SizedBox(
              height: 20,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.all(20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      _selectButton(
                          allTranslations.text('Location'),
                          Icons.location_on,
                          LocationList(),
                          Theme.of(context).indicatorColor),
                      _selectButton(
                          allTranslations.text('Metro'),
                          Icons.directions_subway,
                          MetroRegionPage(),
                          Theme.of(context).accentColor),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      _selectButton(allTranslations.text('Taiwan Railways'),
                          Icons.train, TRList(), Theme.of(context).accentColor),
                      _selectButton(
                          allTranslations.text('Bus'),
                          Icons.directions_bus,
                          BusList(),
                          Theme.of(context).accentColor),
                    ],
                  ),
                ),
                Container(
                    margin: const EdgeInsets.all(20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        _selectButton(
                            allTranslations.text('THSR'),
                            Icons.directions_railway,
                            THSRList(),
                            Theme.of(context).accentColor),
                        _selectButton(
                            allTranslations.text('Taxi'),
                            Icons.local_taxi,
                            TaxiList(),
                            Theme.of(context).accentColor),
                      ],
                    ))
              ],
            ),
          ],
        )));
  }

  Widget _selectButton(
      String title, IconData icon, Widget navTo, Color icon_color) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.4,
      height: MediaQuery.of(context).size.width * 0.4,
      child: RaisedButton(
          color: Theme.of(context).scaffoldBackgroundColor,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Icon(icon,
                  size: MediaQuery.of(context).size.width * 0.15,
                  color: icon_color),
              Text(title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      // color: Theme.of(context).accentColor,
                      // fontWeight: FontWeight.bold,
                      fontSize: 16.0)),
            ],
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
            side: BorderSide(color: Theme.of(context).dividerColor, width: 3),
          ),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (BuildContext context) => navTo));
          }),
    );
  }
}
