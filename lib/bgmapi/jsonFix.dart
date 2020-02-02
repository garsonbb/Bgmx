class BgmJsonFix {
  List CalendarFix(List jsonDataList, int weekday) {
    for (var i = 0; i < jsonDataList[weekday - 1]['items'].length; i++) {
      if (jsonDataList[weekday - 1]['items'][i]['rating'] == null) {
        Map<String, String> ffff = {'score': 'X.X'};
        jsonDataList[weekday - 1]['items'][i]['rating'] = ffff;
      }
      if (jsonDataList[weekday - 1]['items'][i]['name_cn'] == '')
        jsonDataList[weekday - 1]['items'][i]['name_cn'] =
            jsonDataList[weekday - 1]['items'][i]['name'];
    }
    return jsonDataList;
  }

  Map DetailFix(Map data) {
    if (data['rating'] == null) {
      Map<String, String> ffff = {'score': 'X', 'total': '0'};
      data['rating'] = ffff;
    }
    if (data['collection']['wish'] == null) data['collection']['wish'] = 0;
    if (data['collection']['collect'] == null)
      data['collection']['collect'] = 0;
    if (data['collection']['doing'] == null) data['collection']['doing'] = 0;
    if (data['collection']['on_hold'] == null)
      data['collection']['on_hold'] = 0;
    if (data['collection']['dropped'] == null)
      data['collection']['dropped'] = 0;

    if (data['name_cn'] == '') data['name_cn'] = data['name'];

    return data;
  }

  List MyCollectionsFix(List list) {
    //不在这里填充'name_cn',太麻烦,在UI那里选显示的名字就好了.
    Map insertMap = {};
    List types = ['在看', '看过', '想看', '搁置', '抛弃'];
    List reList = [];
    if (list == null) {
      for (var type in types) {
        reList.add(insertMap = {
          'status': {'name': '$type'},
          'list': [
            {
              'subject': {'name_cn': '空空如也~'}
            }
          ]
        });
      }
      return reList;
    } else {
      int flag = 1;
      for (var type in types) {
        flag = 1;
        for (var item in list[0]['collects']) {
          if (item['status']['name'] == type) {
            flag = 0;
          }
        }
        if (flag == 1) {
          insertMap = {
            'status': {'name': '$type'},
            'list': [
              {
                'subject': {'name_cn': '空空如也~'}
              }
            ]
          };
          list[0]['collects'].add(insertMap);
        }
      }
      return list;
    }
  }
}
