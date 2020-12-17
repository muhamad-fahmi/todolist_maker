import 'package:flutter/material.dart';

class EventDetail extends StatelessWidget {
  final List itemHolder;
  final int index;
  EventDetail({this.itemHolder, this.index});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Detail Event"),
      ),
      body: Container(
        child: ListView(
          children: [
            Card(
              elevation: 5,
              shadowColor: Colors.grey[200].withOpacity(.4),
              margin: EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 0.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(Icons.alarm),
                        Text(itemHolder.toString())
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
