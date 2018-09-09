import 'package:flutter/material.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';


void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
          title: ("貸し借りメモタイトル"),
          home: _List(),
    );
  }
}

class InputForm extends StatefulWidget {
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
        print(date);
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    Widget titleSection;
    titleSection = Scaffold(
      appBar: AppBar(
        title: const Text('かしかりめも'),
        actions: <Widget>[
          // action button
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              print("保存ボタンを押しました");
              }
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: (){
              print("削除ボタンを押しました");
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
              ),

              new TextFormField(
                //controller: _myController2,
                decoration: const InputDecoration(
                  icon: const Icon(Icons.business_center),
                  hintText: '借りたもの、貸したもの',
                  labelText: 'loan',
                ),
              ),

              new Text("締め切り日：${date.toString()}"),
              new RaisedButton(
                  child: new Text("締め切り日変更"),
                  onPressed: (){_selectTime(context);}
              ),
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
          }),
    );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot document){
    return new Card(
      child: new Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.android),
              title: Text(document['name']),
              subtitle: Text(document['loan']),
            ),
            new ButtonTheme.bar(
                child: new ButtonBar(
                  children: <Widget>[
                    new FlatButton(
                      child: const Text("へんしゅう"),
                      onPressed: ()
                        {
                          print("編集ボタンを押しました");
                        }
                        ),
                  ],
                )
            ),
          ]
      ),
    );
  }
}