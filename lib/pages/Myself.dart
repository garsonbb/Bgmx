import 'package:bgmx/bgmapi/globeBgm.dart';
import 'package:flutter/material.dart';
import 'Login.dart';

class ProgressListTab extends StatefulWidget {
  ProgressListTab({Key key}) : super(key: key);

  _ProgressListTabState createState() => _ProgressListTabState();
}

class _ProgressListTabState extends State<ProgressListTab>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _tabController = new TabController(vsync: this, length: 5);
  }

  @override
  Widget build(BuildContext context) {
    String avrUrl = 'http://lain.bgm.tv/pic/user/s/icon.jpg';
    getAvr() async {
      if (bgmweb.islogin == true) {
        avrUrl = await bgmweb.getAvatarUrl();
      } else {
        avrUrl = 'http://lain.bgm.tv/pic/user/s/icon.jpg';
      }
    }

    getAvr();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "我的進度",
        ),
        actions: <Widget>[
          IconButton(
            icon: CircleAvatar(
                //头像
                backgroundImage: NetworkImage(avrUrl),
                radius: 14),
            onPressed: () {},
          )
        ],
        bottom: TabBar(
          isScrollable: true,
          indicatorSize: TabBarIndicatorSize.label,
          controller: _tabController,
          //labelStyle: TextStyle(fontSize: 16),
          tabs: <Widget>[
            Tab(
              text: '在看',
            ),
            Tab(
              text: '看过',
            ),
            Tab(
              text: '想看',
            ),
            Tab(
              text: '搁置',
            ),
            Tab(
              text: '抛弃',
            ),
          ],
        ),
      ),
      body: TabBarView(controller: _tabController, children: <Widget>[
        MyList(target: '在看'),
        MyList(target: '看过'),
        MyList(target: '想看'),
        MyList(target: '搁置'),
        MyList(target: '抛弃'),
      ]),
    );
  }
}

class MyList extends StatefulWidget {
  String target;
  MyList({Key key, this.target}) : super(key: key);

  _MyListState createState() => _MyListState(target);
}

class _MyListState extends State<MyList> {
  String target;
  bool islogin = false;
  List listData;

  _MyListState(this.target);

  getData() async {
    //这一页，是每划一次，都会向服务器请求一次数据。
    List tmpListData = await bgmweb.getMyCollections(target);
    if (tmpListData == null) return;
    if (!mounted) return;
    setState(() {
      islogin = bgmweb.isLogin();
      listData = tmpListData;
    });
  }

  @override
  void initState() {
    super.initState();
    islogin = bgmweb.isLogin();
    if (islogin == true) {
      getData();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (islogin == false) {
      return Container(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "先登录再食用",
                style: TextStyle(fontSize: 20),
              ),
              RaisedButton(
                child: Text("点我登陆"),
                onPressed: () {
                  Navigator.push(context,
                          MaterialPageRoute(builder: (context) => LoginPage()))
                      .then((val) {
                    getData();
                    if (bgmweb.islogin == true) {
                      Scaffold.of(context).showSnackBar(SnackBar(
                        content: Text('Reloading'),
                      ));
                    }
                  });
                },
              )
            ],
          ),
        ),
      );
    } else {
      List<Widget> cardsList = new List();
      if (listData == null)
        return new Center(
          child: new CircularProgressIndicator(),
        );
      for (var i = 0; i < listData.length; i++) {
        cardsList.add(
          Container(
            decoration: new BoxDecoration(
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey[350],
                      //offset: new Offset(0, 0),
                      blurRadius: 10.0)
                ],
                color: Colors.white,
                borderRadius: new BorderRadius.circular(12)),
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
                        listData[i]['subject']['name_cn'] == null
                            ? listData[i]['subject']['name']
                            : listData[i]['subject']['name_cn'],
                        style: TextStyle(fontSize: 18),
                        overflow: TextOverflow.ellipsis,
                      ),
                    )),
                    // Container(
                    //   padding: EdgeInsets.only(left: 0),
                    //   child: ClipRRect(
                    //     borderRadius: BorderRadius.circular(50),
                    //     child: Container(
                    //       color: Colors.pink[100],
                    //       width: 40,
                    //       height: 30,
                    //       child: Center(
                    //           child: Text('xx'
                    //               /*listData[i]['rating']['score'].toString()*/)),
                    //     ),
                    //   ),
                    // ),
                    Container(
                      width: 55,
                      child: FlatButton(
                          textTheme: ButtonTextTheme.accent,
                          child: Icon(Icons.keyboard_arrow_right),
                          shape: CircleBorder(),
                          onPressed: () {
                            // String ptitle = listData[i]['name_cn'];
                            // String ppic = (listData[i]['images'] == null)
                            //     ? '127.0.0.1'
                            //     : listData[i]['images']['large'];
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
      //列表展示
    }
  }
}
