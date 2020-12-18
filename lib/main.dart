import 'package:calender_table/add.dart';
import 'package:calender_table/detail.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'To Do list Maker',
      home: MyHomePage(title: 'ToDoList'),
    );
  }
}

String capitalize(String s) => s[0].toUpperCase() + s.substring(1);

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  String url;

  Future<void> refresh() async {
    setState(() {
      url = "http://192.168.1.8:3000/guru/kepsek/kalender";
    });
    return true;
  }

  List _selectedEvents;
  Map<DateTime, List> _events;
  CalendarController _calendarController;
  AnimationController _animationController;

  Future<List<EventModel>> getAllEvent() async {
    try {
      final response =
          await http.get("http://192.168.1.8:3000/guru/kepsek/kalender");

      String responseContohnya = '''
          {
              "status": "ok",
              "message": "Found!",
              "data": [
                        {
                      "status": false,
                      "_id": "5e04a27692928701258b9b06",
                      "group_id": "5df8aaae2f85481f6e31db59",
                      "date": "2020-12-30",
                      "time": "10:12",
                      "title": "new task",
                      "priority": "5",
                      "description": "just a description",
                      "tasks": [],
                      "created_date": "2019-12-26T12:07:18.301Z",
                      "__v": 0
                  },
                  {
                      "status": false,
                      "_id": "5e04a2769292870125845534535",
                      "group_id": "5df8aaae2f85481f6e31db59",
                      "date": "2020-12-30",
                      "time": "12:40",
                      "title": "makan bersamas",
                      "priority": "5",
                      "description": "just a description",
                      "tasks": [],
                      "created_date": "2020-12-26T12:07:18.301Z",
                      "__v": 0
                  },
                  {
                      "status": false,
                      "_id": "5e04a234243444354525845535",
                      "group_id": "5df8aaae2f85481f6e31db59",
                      "date": "2020-12-30",
                      "time": "15:00",
                      "title": "makan bersama",
                      "priority": "5",
                      "description": "just a description",
                      "tasks": [],
                      "created_date": "2020-12-26T12:08:24.301Z",
                      "__v": 0
                  },
                  {
                      "status": false,
                      "_id": "5e04a234243444354525845535",
                      "group_id": "5df8aaae2f85481f6e31db59",
                      "date": "2020-12-31",
                      "time": "20:20",
                      "title": "makan bersama",
                      "priority": "5",
                      "description": "just a description",
                      "tasks": [],
                      "created_date": "2020-12-26T12:08:24.301Z",
                      "__v": 0
                  },
                  {
                      "status": false,
                      "_id": "5e04a234243444354525845535",
                      "group_id": "5df8aaae2f85481f6e31db59",
                      "date": "2020-12-31",
                      "time": "21:40",
                      "title": "makan bersama",
                      "priority": "5",
                      "description": "just a description",
                      "tasks": [],
                      "created_date": "2020-12-26T12:08:24.301Z",
                      "__v": 0
                  }
              ]
          }
    ''';

      final Map<String, dynamic> responseJson = json.decode(response.body);
      if (responseJson["status"] == "ok") {
        List eventList = responseJson['data'];
        final result = eventList
            .map<EventModel>((json) => EventModel.fromJson(json))
            .toList();
        return result;
      } else {
        //throw CustomError(responseJson['message']);
      }
    } catch (e) {
      return Future.error(e.toString());
    }
    return [];
  }

  Future<Map<DateTime, List>> getTask() async {
    Map<DateTime, List> mapFetch = {};
    List<EventModel> event = await getAllEvent();
    for (int i = 0; i < event.length; i++) {
      var date =
          DateTime(event[i].date.year, event[i].date.month, event[i].date.day);
      var original = mapFetch[date];
      if (original == null) {
        print("null");
        mapFetch[date] = [
          event[i].date.toString().substring(0, 10) +
              " (" +
              event[i].time +
              ")" +
              "\n" +
              capitalize(event[i].title)
        ];
      } else {
        print(event[i].date);
        mapFetch[date] = List.from(original)
          ..addAll([
            event[i].date.toString().substring(0, 10) +
                " (" +
                event[i].time +
                ")" +
                "\n" +
                capitalize(event[i].title)
          ]);
      }
    }

    return mapFetch;
  }

  void _onDaySelected(DateTime day, List events) {
    print('CALLBACK: _onDaySelected');
    setState(() {
      _selectedEvents = events;
    });
  }

  @override
  void initState() {
    _selectedEvents = [];
    _calendarController = CalendarController();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _animationController.forward();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getTask().then((val) => setState(() {
            _events = val;
          }));
      print(' ${_events.toString()} ');
    });
    super.initState();
    url = "http://192.168.1.8:3000/guru/kepsek/kalender";
  }

  @override
  void dispose() {
    _calendarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.event_available),
        title: Text(widget.title),
      ),
      body: RefreshIndicator(
        onRefresh: refresh,
        key: _refreshIndicatorKey,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _buildTableCalendarWithBuilders(),
              const SizedBox(height: 8.0),
              const SizedBox(height: 8.0),
              Expanded(child: _buildEventList()),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (contaxt) => AddDate(),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildTableCalendarWithBuilders() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Card(
        elevation: 5,
        shadowColor: Colors.grey[200].withOpacity(.4),
        margin: EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 0.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: TableCalendar(
          calendarController: _calendarController,
          events: _events,
          initialCalendarFormat: CalendarFormat.month,
          formatAnimation: FormatAnimation.slide,
          startingDayOfWeek: StartingDayOfWeek.sunday,
          availableGestures: AvailableGestures.all,
          availableCalendarFormats: const {
            CalendarFormat.month: '',
            CalendarFormat.week: '',
          },
          calendarStyle: CalendarStyle(
            outsideDaysVisible: false,
            weekendStyle: TextStyle().copyWith(color: Colors.blue[800]),
            holidayStyle: TextStyle().copyWith(color: Colors.blue[800]),
          ),
          daysOfWeekStyle: DaysOfWeekStyle(
            weekendStyle: TextStyle().copyWith(color: Colors.blue[600]),
          ),
          headerStyle: HeaderStyle(
            centerHeaderTitle: true,
            formatButtonVisible: false,
          ),
          builders: CalendarBuilders(
            selectedDayBuilder: (context, date, _) {
              return FadeTransition(
                opacity:
                    Tween(begin: 0.0, end: 1.0).animate(_animationController),
                child: Container(
                  margin: const EdgeInsets.all(4.0),
                  padding: const EdgeInsets.only(top: 5.0, left: 6.0),
                  color: Colors.deepOrange[300],
                  width: 100,
                  height: 100,
                  child: Text(
                    '${date.day}',
                    style: TextStyle().copyWith(fontSize: 16.0),
                  ),
                ),
              );
            },
            todayDayBuilder: (context, date, _) {
              return Container(
                margin: const EdgeInsets.all(4.0),
                padding: const EdgeInsets.only(top: 5.0, left: 6.0),
                color: Colors.amber[400],
                width: 100,
                height: 100,
                child: Text(
                  '${date.day}',
                  style: TextStyle().copyWith(fontSize: 16.0),
                ),
              );
            },
            markersBuilder: (context, date, events, holidays) {
              final children = <Widget>[];

              if (events.isNotEmpty) {
                children.add(
                  Positioned(
                    right: 1,
                    bottom: 1,
                    child: _buildEventsMarker(date, events),
                  ),
                );
              }

              if (holidays.isNotEmpty) {
                children.add(
                  Positioned(
                    right: -2,
                    top: -2,
                    child: _buildHolidaysMarker(),
                  ),
                );
              }

              return children;
            },
          ),
          onDaySelected: (day, events, holidays) {
            _onDaySelected(day, events);
            _animationController.forward(from: 0.0);
          },
          onVisibleDaysChanged: _onVisibleDaysChanged,
        ),
      ),
    );
  }

  void _onVisibleDaysChanged(
      DateTime first, DateTime last, CalendarFormat format) {
    print('CALLBACK: _onVisibleDaysChanged');
  }

  Widget _buildEventsMarker(DateTime date, List events) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: _calendarController.isSelected(date)
            ? Colors.brown[500]
            : _calendarController.isToday(date)
                ? Colors.brown[300]
                : Colors.blue[400],
      ),
      width: 16.0,
      height: 16.0,
      child: Center(
        child: Text(
          '${events.length}',
          style: TextStyle().copyWith(
            color: Colors.white,
            fontSize: 12.0,
          ),
        ),
      ),
    );
  }

  Widget _buildHolidaysMarker() {
    return Icon(
      Icons.add_box,
      size: 20.0,
      color: Colors.blueGrey[800],
    );
  }

  Widget _buildEventList() {
    return ListView(
      children: _selectedEvents
          .map(
            (event) => Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Card(
                elevation: 5,
                shadowColor: Colors.grey[200].withOpacity(.4),
                margin: EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 0.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Container(
                  child: ListTile(
                    leading: Icon(Icons.alarm),
                    title: Text(event.toString()),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => EventDetail(
                            index: event,
                          ),
                        ),
                      );
                      //print(event);
                    },
                  ),
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}

class EventModel {
  bool status;
  String id;
  String groupId;
  DateTime date;
  String time;
  String title;
  String priority;
  String description;
  List<dynamic> tasks;
  DateTime createdDate;
  int v;

  EventModel({
    this.status,
    this.id,
    this.groupId,
    this.date,
    this.time,
    this.title,
    this.priority,
    this.description,
    this.tasks,
    this.createdDate,
    this.v,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) => EventModel(
        status: json["status"],
        id: json["_id"],
        groupId: json["group_id"],
        date: DateTime.parse(json["date"]),
        time: json["time"],
        title: json["title"],
        priority: json["priority"],
        description: json["description"],
        tasks: List<dynamic>.from(json["tasks"].map((x) => x)),
        createdDate: DateTime.parse(json["created_date"]),
        v: json["__v"],
      );
}
