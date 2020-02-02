import 'package:flutter/material.dart';
import 'package:bgmx/bgmapi/globeBgm.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    save(bool status) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (status == true) {
        prefs.setBool('isLogin', true);
        prefs.setString('access_token', bgmweb.access_token);
        prefs.setString('refresh_token', bgmweb.refresh_token);
        prefs.setString('user_uid', bgmweb.user_uid);
      } else {
        prefs.setBool('isLogin', false);
        prefs.setString('access_token', '0');
        prefs.setString('refresh_token', '0');
        prefs.setString('user_uid', '0');
      }
    }

    return Scaffold(
        appBar: AppBar(
          title: Text('登录'),
        ),
        body: Builder(builder: (BuildContext context) {
          return SafeArea(
            child: WebView(
              initialUrl:
                  'https://bgm.tv/oauth/authorize?response_type=code&client_id=${bgmweb.client_id}&state=23333333&redirect_uri=https://garnote.top',
              javascriptMode: JavascriptMode.unrestricted,
              navigationDelegate: (NavigationRequest req) {
                if (req.url.contains('garnote.top') == true) {
                  Future<bool> status = bgmweb.getToken(req.url.substring(
                      req.url.indexOf('=') + 1, req.url.lastIndexOf('&')));
                  status.whenComplete(() async {
                    if (await status == true) {
                      Scaffold.of(context).showSnackBar(SnackBar(
                        content: Text('登陆成功'),
                      ));
                      Future.delayed(const Duration(milliseconds: 2500),
                          () => Navigator.pop(context));
                    } else {
                      Scaffold.of(context).showSnackBar(SnackBar(
                        content: Text('登陆失败'),
                      ));
                      Future.delayed(const Duration(milliseconds: 3),
                          () => Navigator.pop(context));
                    }
                    save(await status);
                  });
                }
                return NavigationDecision.navigate;
              },
            ),
          );
        }));
  }
}
