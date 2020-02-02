import 'package:dio/dio.dart';
import 'jsonFix.dart';

class BgmWeb {
  String client_id = "(●'◡'●)";
  String client_secret = "(●'◡'●)";
  String access_token = '';
  String refresh_token = '';
  String user_uid = '';

  BgmJsonFix bgmjsonfix = new BgmJsonFix();

  bool islogin = false;

  List jsonDataList = new List();

  BgmWeb();

  Dio req = new Dio();

  void _getCalendar() async {
    try {
      Response jsonRespond = await req.get('https://api.bgm.tv/calendar');
      jsonDataList.addAll(jsonRespond.data);
    } catch (e) {
      print(e);
    }
  }

  bool isLogin() {
    return this.islogin;
  }

  Future<List> getCalendar(int weekday) async {
    try {
      if (jsonDataList.length == 0) {
        Response jsonRespond = await req.get('https://api.bgm.tv/calendar');
        jsonDataList.addAll(jsonRespond.data);
      }
      jsonDataList = bgmjsonfix.CalendarFix(jsonDataList, weekday);
      return await jsonDataList[weekday - 1]['items'];
    } catch (e) {
      print(e);
    }
  }

  Future<Map> getDetail(int id) async {
    try {
      Response<Map> jsonRespond =
          await req.get('https://api.bgm.tv/subject/$id?responseGroup=large');

      jsonRespond.data = bgmjsonfix.DetailFix(jsonRespond.data);
      return await jsonRespond.data;
    } catch (e) {
      print(e);
    }
  }

  Future<String> getAvatarUrl() async {
    try {
      Response<Map> res = await req.get('https://api.bgm.tv/user/$user_uid');
      return res.data['avatar']['large'];
    } catch (e) {
      print(e);
    }
  }

  Future<bool> getToken(String code) async {
    //获取token成功之后会设置已登录flag
    try {
      FormData postData = FormData.fromMap({
        'grant_type': 'authorization_code',
        'code': code,
        'client_id': client_id,
        'client_secret': client_secret,
        'redirect_uri': 'https://garnote.top'
      });
      Response<Map> jsonRespond =
          await req.post('https://bgm.tv/oauth/access_token', data: postData);
      if (jsonRespond.statusCode == 200) {
        access_token = jsonRespond.data['access_token'];
        refresh_token = jsonRespond.data['refresh_token'];
        user_uid = jsonRespond.data['user_id'].toString();
        this.islogin = true;
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e);
    }
  }

  Future<bool> refreshToken() async {
    FormData postData = FormData.fromMap({
      'grant_type': 'refresh_token',
      'refresh_token': refresh_token,
      'client_id': client_id,
      'client_secret': client_secret
    });
    try {
      Response jsonRespond =
          await req.post('https://bgm.tv/oauth/access_token', data: postData);
      if (jsonRespond.statusCode == 200) {
        access_token = jsonRespond.data['access_token'];
        refresh_token = jsonRespond.data['refresh_token'];
        this.islogin = true;
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<List> getMyCollections(String type) async {
    try {
      Response<List> res = await req.get(
          'https://api.bgm.tv/user/$user_uid/collections/anime?app_id=$client_id&max_results=25');
      if (res.statusCode == 200) {
        res.data = bgmjsonfix.MyCollectionsFix(res.data);
        for (var item in res.data[0]['collects']) {
          if (item['status']['name'] == type) {
            return await item['list'];
          }
        }
      }
      return await res.data;
    } catch (e) {
      print(e);
    }
  }

  String getStaff(List list) {
    String rStr = '';
    String tmpStr = '';
    if (list == null) return '咱不知道。';
    for (Map item in list) {
      for (var job in item['jobs']) {
        tmpStr = job + '、';
      }
      rStr = rStr + tmpStr.substring(0, tmpStr.length - 1) + ' : ';
      rStr = rStr + item['name'] + '\n';
      tmpStr = '';
    }
    return rStr;
  }

  Future<bool> updateSection(String id, String status) async {
    try {
      Response res = await req.get(
          'https://api.bgm.tv/ep/$id/status/$status?app_id=$client_id&access_token=$access_token');
      if (res.statusCode == 200) {
        return true;
      }
      return false;
    } catch (e) {
      print(e);
    }
  }

  Future<bool> updateCollection(String subject_id, String status) async {
    try {
      FormData postData = FormData.fromMap({
        'status': status,
      });
      Response jsonRespond = await req.post(
          'https://api.bgm.tv/collection/$subject_id/update?status=$status&privacy=0&app_id=$client_id&access_token=$access_token',
          data: postData);
      print(jsonRespond.data);
      if (jsonRespond.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e);
    }
  }
}
