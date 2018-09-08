import 'package:flutter/material.dart';
import 'dart:async';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
          title: ("貸し借りメモタイトル"),
          home: InputForm(),
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
