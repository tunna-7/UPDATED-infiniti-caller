import 'package:flutter/material.dart';

import './screens/home_screen.dart';
import './screens/contact_summary.dart';
import './screens/add_contact.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Phonebook',
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Color(0xFF1B1B1B),
        accentColor: Color(0xFF323232),
        buttonTheme: ButtonThemeData(
          buttonColor: Color(0xFFFC6E20), 
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
      routes: {
        AddContactScreen.routeName: (_) => AddContactScreen(),
        ContactSummary.routeName: (_) => ContactSummary(),
      },
    );
  }
}
