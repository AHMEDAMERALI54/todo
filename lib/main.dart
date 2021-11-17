//بسم الله الرحمن الرحيم


import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:todo/shared/cubit/bloc_observer.dart';

import 'layOut/mainMenu/main_menu.dart';



void main() {
  Bloc.observer = MyBlocObserver();

  runApp(MainApp());
}
class MainApp extends StatelessWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false,
      home: MainMenu(),
    );
  }
}
