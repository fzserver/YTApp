import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class Events extends StatefulWidget {
  @override
  _EventsState createState() => _EventsState();
}

class _EventsState extends State<Events> {
  @override
  Widget build(BuildContext context) => Center(
        child: Text(
          'Upcoming Events',
          style: TextStyle(
              color: Color.fromRGBO(17, 28, 59, 1.0),
              fontWeight: FontWeight.bold,
              fontSize: 18.0),
        ),
      );
}
