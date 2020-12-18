import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' show json;
import 'package:toast/toast.dart';

class EventDetail extends StatefulWidget {
  final String index;
  EventDetail({this.index});

  @override
  _EventDetailState createState() => _EventDetailState();
}

class _EventDetailState extends State<EventDetail> {
  Future<List> getDetail() async {
    final String date = widget.index.substring(0, 10);
    final String time = widget.index.substring(12, 20);
    final response = await http.get(
        "http://192.168.1.8:3000/guru/kepsek/kalender/" + date + "/" + time);
    var res = json.decode(response.body);
    return res;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Detail Event"),
      ),
      body: FutureBuilder(
        future: getDetail(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasError) print(snapshot.error);
          return snapshot.hasData
              ? ItemList(
                  list: snapshot.data,
                )
              : Center(
                  child: CircularProgressIndicator(),
                );
        },
      ),
    );
  }
}

String capitalize(String s) => s[0].toUpperCase() + s.substring(1);

class ItemList extends StatefulWidget {
  final List list;
  ItemList({this.list});

  @override
  _ItemListState createState() => _ItemListState();
}

class _ItemListState extends State<ItemList> {
  void _deleteData(id) async {
    final response =
        await http.delete("http://192.168.1.8:3000/guru/kepsek/kalender/" + id);
    var res = json.decode(response.body);
    if (response.statusCode == 200) {
      print("success");
      Toast.show("One event deleted!", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      Navigator.of(context).pop();
      return res;
    } else {
      print('gagal');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.list == null ? 0 : widget.list.length,
      itemBuilder: (context, index) {
        return Container(
            child: Card(
          elevation: 5,
          shadowColor: Colors.grey[200].withOpacity(.4),
          margin: EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 0.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  capitalize(widget.list[index]['title']),
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                ),
                Padding(padding: EdgeInsets.only(top: 15.0)),
                Divider(color: Colors.black),
                Padding(padding: EdgeInsets.only(top: 20.0)),
                Row(
                  children: [
                    Icon(Icons.event),
                    Padding(padding: EdgeInsets.only(right: 15.0)),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Date"),
                        Text(widget.list[index]['date']),
                      ],
                    )
                  ],
                ),
                Padding(padding: EdgeInsets.only(top: 20.0)),
                Row(
                  children: [
                    Icon(Icons.alarm),
                    Padding(padding: EdgeInsets.only(right: 15.0)),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Time"),
                        Text(widget.list[index]['time']),
                      ],
                    )
                  ],
                ),
                Padding(padding: EdgeInsets.only(top: 20.0)),
                Row(
                  children: [
                    Icon(Icons.list_alt),
                    Padding(padding: EdgeInsets.only(right: 15.0)),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Description"),
                        Text(capitalize(widget.list[index]['description'])),
                      ],
                    )
                  ],
                ),
                Padding(padding: EdgeInsets.only(top: 20.0)),
                Row(
                  children: [
                    Icon(Icons.supervised_user_circle_rounded),
                    Padding(padding: EdgeInsets.only(right: 15.0)),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Priority"),
                        Text(capitalize(widget.list[index]['priority'])),
                      ],
                    )
                  ],
                ),
                Padding(padding: EdgeInsets.only(top: 30.0)),
                Row(
                  children: [
                    Expanded(
                      child: RaisedButton(
                        color: Colors.red,
                        onPressed: () {
                          _deleteData(widget.list[index]['_id']);
                        },
                        child: Text(
                          "Delete",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    Padding(padding: EdgeInsets.all(5.0)),
                    Expanded(
                      child: RaisedButton(
                        color: Colors.yellow,
                        onPressed: () {},
                        child: Text("Update"),
                      ),
                    ),
                    Padding(padding: EdgeInsets.all(5.0)),
                    Expanded(
                      child: RaisedButton(
                        color: Colors.green,
                        onPressed: () {},
                        child: Text("Add Task"),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ));
      },
    );
  }
}
