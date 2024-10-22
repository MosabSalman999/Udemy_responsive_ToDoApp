// ignore_for_file: unused_import

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:udemy_flutter/layout/home_layout.dart';
import 'package:udemy_flutter/modules/counter/counter.dart';
import 'package:udemy_flutter/shared/bloc_observer.dart';
import 'modules/bmi/bmi.dart';
import 'modules/login/login_screen.dart';

void main() {
  Bloc.observer = MyBlocObserver();

  runApp(const MyApp());
}

// Stateless
// Stateful
// class MyApp

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // constructor
  // build

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeLayout(),
    );
  }
}
