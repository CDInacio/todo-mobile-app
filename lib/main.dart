// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

// packages
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

// screens
import 'screens/tasks_overview_screen.dart';
import './screens/auth_screen.dart';
import './screens/add_task_screen.dart';

//providers
import './providers/auth.dart';
import './providers/tasks.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => Auth()),
          ChangeNotifierProxyProvider<Auth, Tasks>(
              update: (context, auth, prevTasks) =>
                  Tasks(auth.token, auth.userId, prevTasks == null ? [] : prevTasks.tasks),
              create: (_) => Tasks('', '', [])),
        ],
        child: Consumer<Auth>(
            builder: (context, authData, child) => MaterialApp(
                  localizationsDelegates: [
                    GlobalMaterialLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate
                  ],
                  supportedLocales: [const Locale('pt', 'BR')],
                  title: 'Flutter Demo',
                  theme: ThemeData(
                      primaryColor: Colors.lightBlue[800],
                      textTheme: GoogleFonts.openSansTextTheme()),
                  home: authData.isAuth ? PostsOverViewScreen() : AuthScreen(),
                  routes: {
                    AddTaskScreen.addTaskRouteName: (context) =>
                        AddTaskScreen(),
                  },
                )));
  }
}
