import 'package:flutter/material.dart';
import 'package:pill_app/screens/add_pill2.dart';
import 'package:pill_app/state.dart';
import 'package:provider/provider.dart';
import 'screens/home_page.dart';
import 'screens/add_pill.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => AppModel()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pill app',
      theme: ThemeData(
          fontFamily: "SF Pro Display",
          primarySwatch: Colors.blue,
          scaffoldBackgroundColor: Colors.white),
      initialRoute: "/",
      routes: {
        "/": (context) => const HomePage(),
        "/add_pill": (context) => const AddPillPage(),
        "/add_pill2": (context) => const AddPillPage2(), 
      },
    );
  }
}

