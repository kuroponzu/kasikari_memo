import 'package:flutter/material.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';


void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
          title: ("貸し借りメモ"),
          home: _List(),
    );
  }
}

class InputForm extends StatefulWidget {

  InputForm(this.docs);
  final DocumentSnapshot docs;

  @override
  _MyInputFormState createState() => new _MyInputFormState();
}

class _formData {
  String lendorrent;
  String user;
  String loan;
  DateTime date;
}

class _List extends StatefulWidget {
  @override
  _MyList createState() => new _MyList();
}




class _MyInputFormState extends State<InputForm> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  _formData _data = new _formData();
  String lendorrent = "rent";
  DateTime date = new DateTime.now();
  var change_Flg = 0;
  var lendorrent_Flg = 0;
  bool deleteFlg;


  void _setLendorRent(String value){
    setState(() {
      lendorrent = value;
    });
  }

  Future <Null> _selectTime(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: date,
        firstDate: new DateTime(2018),
        lastDate: new DateTime(2020)
    );

    if(picked != null && picked != date){
      setState(() {
        date = picked;
        change_Flg = 1;
        print(date);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var _mainReference;
    if (this.widget.docs != null) {
      if(lendorrent_Flg == 0 && widget.docs['lendorrent'].toString() == "lend"){
        lendorrent = "lend";
        lendorrent_Flg = 1;
      }
      _data.user = widget.docs['name'];
      _data.loan = widget.docs['loan'];
      if(change_Flg == 0) {
        date = widget.docs['date'];
      }
      _mainReference = Firestore.instance.collection('kasikari-memo').document(widget.docs.documentID);
      deleteFlg = true;
    } else {
      _data.lendorrent = "";
      _data.user = "";
      _data.loan = "";
      _mainReference = Firestore.instance.collection('kasikari-memo').document();
      deleteFlg = false;
    }

    Widget titleSection;
    titleSection = Scaffold(
      appBar: AppBar(
        title: const Text('かしかりめも'),
        actions: <Widget>[
          // action button
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              _data.lendorrent = lendorrent;
              _data.date = date;
              if (this._formKey.currentState.validate()) {
                _formKey.currentState.save();
                _mainReference.setData(
                    { 'lendorrent': _data.lendorrent, 'name': _data.user,
                      'loan': _data.loan, 'date': _data.date});
                Navigator.pop(context);
              }
            }
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: !deleteFlg? null:() {
              _mainReference.delete();
              Navigator.pop(context);
            },
          )
        ],
      ),
      body: new SafeArea(
        child:
        new Form(
          key: this._formKey,
          child: new ListView(
            padding: const EdgeInsets.all(20.0),
            children: <Widget>[

              RadioListTile(
                value: "rent",
                groupValue: lendorrent,
                title: new Text("借りた"),
                onChanged: (String value){
                  _setLendorRent(value);
                  print("借りたに設定しました");
                },
              ),

              RadioListTile(
                  value: "lend",
                  groupValue: lendorrent,
                  title: new Text("貸した"),
                  onChanged: (String value) {
                    _setLendorRent(value);
                    print("貸したに設定しました");
                  }
              ),
              new TextFormField(
                //controller: _myController,
                decoration: const InputDecoration(
                  icon: const Icon(Icons.person),
                  hintText: '相手の名前',
                  labelText: 'Name',
                ),
                onSaved: (String value) {
                  this._data.user = value;
                },
                validator: (value) {
                  if (value.isEmpty) {
                    return '名前は必須入力項目です';
                  }
                },
                initialValue: _data.user,
              ),

              new TextFormField(
                decoration: const InputDecoration(
                  icon: const Icon(Icons.business_center),
                  hintText: '借りたもの、貸したもの',
                  labelText: 'loan',
                ),
                onSaved: (String value) {
                  this._data.loan = value;
                },
                validator: (value) {
                  if (value.isEmpty) {
                    return '借りたもの、貸したものは必須入力項目です';
                  }
                },
                initialValue: _data.loan,
              ),

              new RaisedButton(
                  color: Colors.blue,
                  child: new RichText(
                      text: new TextSpan(
                          children: <TextSpan>[
                            new TextSpan(
                              text: '日付変更',
                              style: new TextStyle(color: Colors.white),
                            )
                          ]
                      )
                  ),
                  onPressed: (){_selectTime(context);}
              ),
              new Text("締め切り日：${date.toString()}"),
            ],
          ),
        ),
      ),
    );
    return titleSection;
  }
}

class _MyList extends State<_List> {

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("一覧"),
      ),
      body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: new StreamBuilder<QuerySnapshot>(
              stream: Firestore.instance.collection('kasikari-memo').snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) return const Text('Loading...');
                return new ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: snapshot.data.documents.length,
                  padding: const EdgeInsets.only(top: 10.0),
                  itemBuilder: (context, index) =>
                      _buildListItem(context, snapshot.data.documents[index]),
                );
              }
          ),
      ),
      floatingActionButton: new FloatingActionButton(
          child: new Icon(Icons.check),
          onPressed: () {
            print("新規作成ボタンを押しました");
            Navigator.push(
              context,
              MaterialPageRoute(
                  settings: const RouteSettings(name: "/new"),
                  builder: (BuildContext context) => new InputForm(null)
              ),
            );

          }),
    );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot document){
    var lendorrent = (document['lendorrent'] == "lend") ? "貸した":"借りた";
    var date = document['date'].toString();

    return new Card(
      child: new Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.android),
              title: Text("【" + lendorrent +"】"+ document['name']),
              subtitle: Text('期限：'+date.substring(0,16)+'\n'
                  "貸借り品："+document['loan']),
            ),
            new ButtonTheme.bar(
                child: new ButtonBar(
                  children: <Widget>[
                    new FlatButton(
                      child: const Text("へんしゅう"),
                      onPressed: ()
                        {
                          Navigator.push(
                          context,
                          MaterialPageRoute(
                            settings: const RouteSettings(name: "/new"),
                            builder: (BuildContext context) => new InputForm(document)
                          ),
                          );
                        },
                        ),
                  ],
                )
            ),
          ]
      ),
    );
  }
}