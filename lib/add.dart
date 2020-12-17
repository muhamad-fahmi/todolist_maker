import 'package:flutter/material.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:toast/toast.dart';
import 'dart:convert' show json;

class AddDate extends StatefulWidget {
  @override
  _AddDateState createState() => _AddDateState();
}

class _AddDateState extends State<AddDate> {
  TextEditingController eventdateController = TextEditingController();
  TextEditingController eventtimeController = TextEditingController();
  TextEditingController eventnameController = TextEditingController();
  TextEditingController eventdescController = TextEditingController();
  TextEditingController eventtaskController = TextEditingController();
  TextEditingController eventpriorityController = TextEditingController();

  Future<List> _addevent() async {
    String groupid = DateFormat("yyyyMM").format(DateTime.now()) + 'GROUPEVENT';
    final response =
        await http.post("http://192.168.1.2:3000/guru/kepsek/kalender", body: {
      "date": eventdateController.text,
      "group_id": groupid,
      "time": eventtimeController.text,
      "title": eventnameController.text,
      "description": eventdescController.text,
      "tasks": eventtaskController.text,
      "priority": eventpriorityController.text
    });
    var decode = json.decode(response.body);
    print(decode);
    return [];
  }

  final formatdate = DateFormat("yyyy-MM-dd");

  final formattime = DateFormat("HH:mm a");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Event"),
      ),
      body: Container(
        child: ListView(
          children: [
            Container(
              padding: EdgeInsets.all(40.0),
              child: Column(
                children: [
                  DateTimeField(
                    format: formatdate,
                    controller: eventdateController,
                    onShowPicker: (context, currentValue) {
                      return showDatePicker(
                          context: context,
                          firstDate: DateTime(1900),
                          initialDate: currentValue ?? DateTime.now(),
                          lastDate: DateTime(2100));
                    },
                    decoration: InputDecoration(
                        hintText: "Add Date",
                        icon: Icon(Icons.date_range_outlined),
                        labelText: "Event Date"),
                  ),
                  Padding(padding: EdgeInsets.only(top: 20.0)),
                  DateTimeField(
                    format: formattime,
                    controller: eventtimeController,
                    onShowPicker: (context, currentValue) async {
                      final time = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.fromDateTime(
                            currentValue ?? DateTime.now()),
                      );
                      return DateTimeField.convert(time);
                    },
                    decoration: InputDecoration(
                      hintText: "Add Time",
                      icon: Icon(Icons.lock_clock),
                      labelText: "Event Time",
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(top: 20.0)),
                  TextField(
                    controller: eventnameController,
                    decoration: InputDecoration(
                        hintText: "Enter Event Name",
                        icon: Icon(Icons.event_note),
                        labelText: "Event Name"),
                  ),
                  Padding(padding: EdgeInsets.only(top: 20.0)),
                  TextField(
                    controller: eventdescController,
                    decoration: InputDecoration(
                        hintText: "Enter Event Description",
                        icon: Icon(Icons.description),
                        labelText: "Event Description"),
                  ),
                  Padding(padding: EdgeInsets.only(top: 20.0)),
                  TextField(
                    controller: eventtaskController,
                    decoration: InputDecoration(
                        hintText: "Enter Task",
                        icon: Icon(Icons.list),
                        labelText: "Task"),
                  ),
                  Padding(padding: EdgeInsets.only(top: 20.0)),
                  TextField(
                    controller: eventpriorityController,
                    decoration: InputDecoration(
                        hintText: "Enter Priority",
                        icon: Icon(Icons.person),
                        labelText: "Event Priority"),
                  ),
                  Padding(padding: EdgeInsets.only(top: 30.0)),
                  RaisedButton(
                    onPressed: () {
                      _addevent();
                      Toast.show("Event added successful!", context,
                          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                      eventdateController.clear();
                      eventdescController.clear();
                      eventnameController.clear();
                      eventpriorityController.clear();
                      eventtaskController.clear();
                      eventtimeController.clear();
                    },
                    child: Text("Save"),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
