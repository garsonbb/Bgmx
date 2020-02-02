import 'package:flutter/material.dart';
import 'package:bgmx/bgmapi/globeBgm.dart';

import 'Detail.dart';

class DailyListTab extends StatefulWidget {
  DailyListTab({Key key}) : super(key: key);

  _DailyListTabState createState() => _DailyListTabState();
}

class _DailyListTabState extends State<DailyListTab>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _tabController = new TabController(
        vsync: this, length: 7, initialIndex: DateTime.now().weekday - 1);
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "每日放送",
        ),
        bottom: TabBar(
          isScrollable: true,
          indicatorSize: TabBarIndicatorSize.label,
          controller: _tabController,
          //labelStyle: TextStyle(fontSize: 16),
          tabs: <Widget>[
            Tab(
              text: '一',
            ),
            Tab(
              text: '二',
            ),
            Tab(
              text: '三',
            ),
            Tab(
              text: '四',
            ),
            Tab(
              text: '五',
            ),
            Tab(
              text: '六',
            ),
            Tab(
              text: '七',
            ),
          ],
        ),
      ),
      body: TabBarView(controller: _tabController, children: <Widget>[
        DailyList(1),
        DailyList(2),
        DailyList(3),
        DailyList(4),
        DailyList(5),
        DailyList(6),
        DailyList(7),
      ]),
    );
  }
}

class DailyList extends StatefulWidget {
  final day;
  DailyList(this.day, {Key key}) : super(key: key);

  @override
  _DailyListState createState() => _DailyListState(day);
}

class _DailyListState extends State<DailyList> {
  final day;
  _DailyListState(this.day);
  List listData;

  getData() async {
    List tmpListData = await bgmweb.getCalendar(day);
    if (tmpListData == null) return;
    if (!mounted) return;
    setState(() {
      listData = tmpListData;
    });
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> cardsList = new List();
    if (listData == null)
      return new Center(
        child: new CircularProgressIndicator(),
      );
    for (var i = 0; i < listData.length; i++) {
      cardsList.add(
        Container(
          decoration: new BoxDecoration(boxShadow: [
            BoxShadow(
                color: Colors.grey[350],
                //offset: new Offset(0, 0),
                blurRadius: 10.0)
          ], color: Colors.white, borderRadius: new BorderRadius.circular(12)),
          padding: EdgeInsets.all(10.0),
          margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
          child: Column(
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                      child: Container(
                    padding: EdgeInsets.fromLTRB(20, 0, 5, 0),
                    child: Text(
                      listData[i]['name_cn'],
                      style: TextStyle(fontSize: 18),
                      overflow: TextOverflow.ellipsis,
                    ),
                  )),
                  Container(
                    padding: EdgeInsets.only(left: 0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Container(
                        color: Colors.pink[100],
                        width: 40,
                        height: 30,
                        child: Center(
                            child: Text(
                                listData[i]['rating']['score'].toString())),
                      ),
                    ),
                  ),
                  Container(
                    width: 55,
                    child: FlatButton(
                        textTheme: ButtonTextTheme.accent,
                        child: Icon(Icons.keyboard_arrow_right),
                        shape: CircleBorder(),
                        onPressed: () {
                          String ptitle = listData[i]['name_cn'];
                          String ppic = (listData[i]['images'] == null)
                              ? '127.0.0.1'
                              : listData[i]['images']['large'];
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DetailPage(
                                      title: ptitle,
                                      pic: ppic,
                                      id: listData[i]['id'])));
                        }),
                  )
                ],
              ),
            ],
          ),
        ),
      );
    }
    return ListView.builder(
      itemCount: listData.length,
      itemBuilder: (context, i) => cardsList[i],
    );
  }
}
