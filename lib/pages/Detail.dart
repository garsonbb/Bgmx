import 'package:flutter/material.dart';
import 'package:bgmx/bgmapi/globeBgm.dart';
import 'package:bgmx/other/KTransparentImage.dart';

class DetailPage extends StatelessWidget {
  final String title;
  final String pic;
  final int id;

  DetailPage({Key key, this.title, this.pic, this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        floatingActionButton: FloatingActionButton.extended(
          label: Text('status'),
          icon: Icon(Icons.stars),
          onPressed: () {
            print('$id');
            myShowBottomSheet(context, title, '0', '$id', true);
          },
        ),
        body: new CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              title: Text(
                title,
                overflow: TextOverflow.ellipsis,
              ),
              floating: true,
              snap: true,
              pinned: true,
              expandedHeight: 300,
              flexibleSpace: FlexibleSpaceBar(
                background: FadeInImage.memoryNetwork(
                  placeholder: kTransparentImage,
                  image: this.pic,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SliverList(
                delegate: SliverChildListDelegate([Detail(id: this.id)])),
          ],
        ),
      ),
    );
  }
}

class Detail extends StatefulWidget {
  final int id;
  Detail({Key key, this.id}) : super(key: key);

  _DetailState createState() => _DetailState(this.id);
}

class _DetailState extends State<Detail> {
  String staffList;
  Map data;
  int id;
  _DetailState(this.id);

  List<Widget> epsButton() {
    List<Widget> returnList = [];
    if (data['eps'] == null) {
      returnList.add(ButtonTheme(
          minWidth: 50,
          height: 50,
          child: RaisedButton(
            child: Text(
              '暂时没有剧集信息',
              style: TextStyle(fontSize: 14, color: Colors.white),
            ),
            onPressed: () {},
          )));
      return returnList;
    }
    for (var item in data['eps']) {
      returnList.add(ButtonTheme(
          minWidth: 50,
          height: 50,
          child: RaisedButton(
            color: item['status'] != 'Air' ? Colors.grey : null,
            child: Text(
              item['sort'].toString(),
              style: TextStyle(fontSize: 12, color: Colors.white),
            ),
            onPressed: () {
              print('${item['id']}');
              myShowBottomSheet(context, item['sort'].toString(),
                  '${item['id']}', '0', false);
            },
          )));
    }
    return returnList;
  }

  void getData() async {
    Map tmpMap = await bgmweb.getDetail(id);
    if (!mounted) return;
    if (tmpMap == null) return;
    String tmpStaff = bgmweb.getStaff(tmpMap['staff']);
    setState(() {
      data = tmpMap;
      staffList = tmpStaff;
    });
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    if (data == null)
      return Padding(
          padding: EdgeInsets.only(top: 200),
          child: Center(
            child: CircularProgressIndicator(),
          ));

    List epsButtonList = epsButton();

    return Container(
      padding: EdgeInsets.all(28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(children: <Widget>[
            Icon(Icons.title),
            Container(
              padding: EdgeInsets.only(left: 10),
            ),
            Text('全名') //,style: TextStyle(fontSize: 18),),
          ]),
          Container(
            child: Text(
              data['name_cn'],
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            padding: EdgeInsets.fromLTRB(20, 5, 0, 20),
          ),
          Row(children: <Widget>[
            Icon(Icons.map),
            Container(
              padding: EdgeInsets.only(left: 10),
            ),
            Text('类别') //,style: TextStyle(fontSize: 18),),
          ]),
          Container(
            child: Text('TV动画'),
            padding: EdgeInsets.fromLTRB(20, 5, 0, 20),
          ),
          Row(
            children: <Widget>[
              Icon(Icons.details),
              Container(
                padding: EdgeInsets.only(left: 10),
              ),
              Text('概览')
            ],
          ),
          Container(
            child: Text(data['summary']),
            padding: EdgeInsets.fromLTRB(20, 5, 0, 20),
          ),
          Row(
            children: <Widget>[
              Icon(Icons.score),
              Container(
                padding: EdgeInsets.only(left: 10),
              ),
              Text('评分')
            ],
          ),
          Container(
            child: Text(
                '由${data['rating']['total']}位网友评为为${data['rating']['score']}分'),
            padding: EdgeInsets.fromLTRB(20, 5, 0, 20),
          ),
          Row(
            children: <Widget>[
              Icon(Icons.collections_bookmark),
              Container(
                padding: EdgeInsets.only(left: 10),
              ),
              Text('收藏人数')
            ],
          ),
          Container(
            child: Text(
                '有${data['collection']['wish']}位网友想看\n有${data['collection']['collect']}位网友看过\n有${data['collection']['doing']}位网友在看\n有${data['collection']['on_hold']}位网友搁置了\n有${data['collection']['dropped']}位网友抛弃了。'),
            padding: EdgeInsets.fromLTRB(20, 5, 0, 20),
          ),
          Row(
            children: <Widget>[
              Icon(Icons.collections_bookmark),
              Container(
                padding: EdgeInsets.only(left: 10),
              ),
              Text('制作人员')
            ],
          ),
          Container(
            child: Text(staffList),
            padding: EdgeInsets.fromLTRB(20, 5, 0, 20),
          ),
          Row(
            children: <Widget>[
              Icon(Icons.collections_bookmark),
              Container(
                padding: EdgeInsets.only(left: 10),
              ),
              Text('剧集')
            ],
          ),
          Container(
            height: (epsButtonList.length / 4 + 1) * 100 > 300
                ? 300
                : (epsButtonList.length / 4 + 1) * 100,
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4, mainAxisSpacing: 28, crossAxisSpacing: 28),
              itemCount: epsButtonList.length,
              itemBuilder: (context, i) => epsButtonList[i],
            ),
            padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
          ),
          Container(
            padding: EdgeInsets.only(bottom: 40),
          )
        ],
      ),
    );
  }
}

void myShowBottomSheet(context, title, section_id, subject_id, is_collection) {
  showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Stack(
          children: <Widget>[
            Container(
              height: 30.0,
              width: double.infinity,
              color: Colors.black54,
            ),
            Container(
                height: 310, //与下面Tag的位置的一样。
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25),
                    ))),
            MenuSheet(
                title: title,
                section_id: section_id,
                subject_id: subject_id,
                is_collection: is_collection),
          ],
        );
      });
}

class MenuSheet extends StatefulWidget {
  final String title;
  final String section_id;
  final String subject_id;
  final bool is_collection;

  MenuSheet(
      {Key key,
      this.title,
      this.section_id,
      this.subject_id,
      this.is_collection})
      : super(key: key);
  @override
  _MenuSheetState createState() =>
      _MenuSheetState(title, section_id, subject_id, is_collection);
}

class _MenuSheetState extends State<MenuSheet> {
  String title = 'title';
  String section_id;
  String subject_id;
  bool is_collection;
  _MenuSheetState(
      this.title, this.section_id, this.subject_id, this.is_collection);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 310, //Tag  352
      padding: EdgeInsets.only(top: 16),
      child: ButtonTheme(
        height: 45,
        minWidth: double.infinity,
        textTheme: ButtonTextTheme.primary,
        child: Column(
          children: <Widget>[
            Container(
                padding: EdgeInsets.fromLTRB(20, 0, 20, 10),
                child: Text(
                  this.title,
                  style: TextStyle(fontSize: 22),
                  overflow: TextOverflow.ellipsis,
                )),
            FlatButton(
              child: Text(
                '想看',
                style: TextStyle(fontSize: 16),
              ),
              onPressed: () {
                if (is_collection == false) {
                  print(this.section_id);
                  bgmweb.updateSection(this.section_id, 'queue');
                } else {
                  print(this.subject_id);
                  bgmweb.updateCollection(this.subject_id, 'queue');
                }
              },
            ),
            FlatButton(
              child: Text(
                '看过',
                style: TextStyle(fontSize: 16),
              ),
              onPressed: () {
                if (is_collection == false) {
                  print(this.section_id);
                  bgmweb.updateSection(this.section_id, 'watched');
                } else {
                  print(this.subject_id);
                  bgmweb.updateCollection(this.subject_id, 'watched');
                }
              },
            ),
            // FlatButton(
            //   child: Text(
            //     '在看',
            //     style: TextStyle(fontSize: 16),
            //   ),
            //   onPressed: () {},
            // ),
            // FlatButton(
            //   child: Text(
            //     '搁置',
            //     style: TextStyle(fontSize: 16),
            //   ),
            //   onPressed: () {},
            // ),
            FlatButton(
              child: Text(
                '抛弃',
                style: TextStyle(fontSize: 16),
              ),
              onPressed: () {
                if (is_collection == false) {
                  print(this.section_id);
                  bgmweb.updateSection(this.section_id, 'drop');
                } else {
                  print(this.subject_id);
                  bgmweb.updateCollection(this.subject_id, 'drop');
                }
              },
            ),
            FlatButton(
              child: Text(
                '移除记录',
                style: TextStyle(fontSize: 16),
              ),
              onPressed: () {
                if (is_collection == false) {
                  print(this.section_id);
                  bgmweb.updateSection(this.section_id, 'remove');
                } else {
                  print(this.subject_id);
                  bgmweb.updateCollection(this.subject_id, 'remove');
                }
              },
            ),
            FlatButton(
              child: Text(
                '寻找资源',
                style: TextStyle(fontSize: 16),
              ),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
