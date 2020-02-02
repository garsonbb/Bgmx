import 'package:bgmx/pages/Tabs.dart' as prefix0;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bgmx/bgmapi/globeBgm.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  bool lock = false;
  @override
  Widget build(BuildContext context) {
    checkLogin() async {
      if (lock == false) {
        lock = true;
        SharedPreferences prefs = await SharedPreferences.getInstance();
        bool isLogin = prefs.getBool('isLogin');
        if (isLogin == true) {
          bgmweb.access_token = prefs.getString('access_token');
          bgmweb.refresh_token = prefs.getString('refresh_token');
          bgmweb.user_uid = prefs.getString('user_uid');
          bgmweb.islogin = false;
          bool status = await bgmweb.refreshToken();
          if (status == false) {
            prefs.setBool('isLogin', false);
            prefs.setString('access_token', '0');
            prefs.setString('refresh_token', '0');
            prefs.setString('user_uid', '0');
            Fluttertoast.showToast(msg: "登录信息失效了(。_。)！");
          } else {
            prefs.setBool('isLogin', true);
            prefs.setString('access_token', bgmweb.access_token);
            prefs.setString('refresh_token', bgmweb.refresh_token);
            prefs.setString('user_uid', bgmweb.user_uid);
          }
        }
      }
    }

    checkLogin();

    return MaterialApp(
      title: 'BgmX',
      home: prefix0.ButtonBar(),
      theme: ThemeData(primarySwatch: Colors.pink),
    );
  }
}
