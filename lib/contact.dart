import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Contact extends StatefulWidget {
  @override
  _ContactState createState() => _ContactState();
}

class _ContactState extends State<Contact> {

  final formKey = GlobalKey<FormState>();

  String _fname;
  String _email;
  String _phone;
  String _message;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Padding title(String title) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 2.0),
        child: Card(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  title,
                  style: TextStyle(
                      color: Colors.deepOrange,
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0),
                )
              ],
            ),
          ),
        ),
      );
    }

    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          // Card(),
          title('DAMDAMI TAKSAL'),
          Card(
            child: ListTile(
              isThreeLine: true,
              title: Text('Address',
                  style: TextStyle(
                      color: Colors.deepOrange, fontWeight: FontWeight.w400)),
              subtitle: Text(
                'Mehta Chowk, Amritsar – 143114, Punjab, INDIA',
                style: TextStyle(color: Colors.deepOrange),
              ),
            ),
          ),
          Card(
              child: ListTile(
                  title: Text(
                    'Phone',
                    style: TextStyle(
                        color: Colors.deepOrange, fontWeight: FontWeight.w400),
                  ),
                  subtitle: Text('+91 98780 30067',
                      style:
                          TextStyle(color: Color.fromRGBO(17, 28, 59, 1.0))))),
          Card(
              child: ListTile(
                  title: Text(
                    'Email',
                    style: TextStyle(
                        color: Colors.deepOrange, fontWeight: FontWeight.w400),
                  ),
                  subtitle: Text('info@damdamitaksal.net',
                      style:
                          TextStyle(color: Color.fromRGBO(17, 28, 59, 1.0))))),
          Card(
            child: Form(
              key: formKey,
              child: Column(
                children: <Widget>[
                  ListTile(
                    leading: Icon(Icons.person, color: Colors.deepOrange),
                    title: TextField(
                      decoration: InputDecoration(hintText: "Full Name"),
                      keyboardType: TextInputType.text,
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.email, color: Colors.deepOrange),
                    title: TextField(
                      decoration: InputDecoration(hintText: "Email"),
                      keyboardType: TextInputType.emailAddress,
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.phone, color: Colors.deepOrange),
                    title: TextField(
                      decoration: InputDecoration(hintText: "Phone"),
                      keyboardType: TextInputType.phone,
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.message, color: Colors.deepOrange),
                    title: TextField(
                      decoration: InputDecoration(hintText: "Message"),
                      maxLines: null,
                      keyboardType: TextInputType.text,
                    ),
                  ),
                  MaterialButton(
                    onPressed: () => {},
                    child: Text(
                      'Submit',
                      style: TextStyle(color: Color.fromRGBO(17, 28, 59, 1.0)),
                    ),
                    textColor: Color.fromRGBO(17, 28, 59, 1.0),
                    color: Colors.deepOrange,
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
