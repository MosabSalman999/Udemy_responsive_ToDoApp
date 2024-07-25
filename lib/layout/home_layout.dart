// ignore_for_file: prefer_const_constructors, avoid_print

import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:udemy_flutter/modules/archived_tasks/archived_tasks_screen.dart';
import 'package:udemy_flutter/modules/done_tasks/done_tasks_screen.dart';
import 'package:udemy_flutter/modules/new_tasks/new_tasks_screen.dart';
import 'package:udemy_flutter/shared/components/components.dart';

class HomeLayout extends StatefulWidget {
  const HomeLayout({super.key});

  @override
  State<HomeLayout> createState() => _HomeLayoutState();
}

// 1. create database
// 2. create tables
// 3. open database
// 4. insert to database
// 5. get from database
// 6. update in database
// 7. delete from database

class _HomeLayoutState extends State<HomeLayout> {
  int currentIndex = 0;
  late Database database;
  var scaffoldKey = GlobalKey<ScaffoldState>();
  bool isBottomSheetShown = false;
  IconData fabIcon = Icons.edit;
  var titleController = TextEditingController();
  var timeController = TextEditingController();

  List<Widget> screens = [
    NewTasksScreen(),
    DoneTasksScreen(),
    ArchivedTasksScreen(),
  ];
  List<String> titles = [
    'New Tasks',
    'Done Tasks',
    'Archived Tasks',
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    createDatabase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text(
          titles[currentIndex],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (isBottomSheetShown) {
            Navigator.pop(context);
            isBottomSheetShown = false;
            setState(() {
              fabIcon = Icons.edit;
            });
          } else {
            scaffoldKey.currentState?.showBottomSheet(
              (context) => Container(
                color: Colors.grey[300],
                padding: EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    defaultFormField(
                      controller: titleController,
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'title must not be empty';
                        }
                        return null;
                      },
                      labelText: 'Task Title',
                      prefixIcon: Icons.title,
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    defaultFormField(
                      controller: timeController,
                      keyboardType: TextInputType.datetime,
                      onTab: () {
                        print('timing tapped');
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'time must not be empty';
                        }
                        return null;
                      },
                      labelText: 'Time Title',
                      prefixIcon: Icons.date_range,
                    ),
                  ],
                ),
              ),
            );
            isBottomSheetShown = true;
            setState(() {
              fabIcon = Icons.add;
            });
          }
        },
        child: Icon(
          fabIcon,
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        currentIndex: currentIndex,
        onTap: (value) {
          setState(() {
            currentIndex = value;
          });
        },
        // ignore: prefer_const_literals_to_create_immutables
        items: [
          BottomNavigationBarItem(
            label: "Tasks",
            icon: Icon(
              Icons.menu,
            ),
          ),
          BottomNavigationBarItem(
            label: "Done",
            icon: Icon(
              Icons.check,
            ),
          ),
          BottomNavigationBarItem(
            label: "Archived",
            icon: Icon(
              Icons.archive,
            ),
          )
        ],
      ),
      body: screens[currentIndex],
    );
  }

  Future<String> getName() async {
    return "Ahmed Ali";
  }

  void createDatabase() async {
    // ignore: unused_local_variable
    database = await openDatabase(
      'todo.db',
      version: 1,
      onCreate: (database, version) {
// id integer
// title String
// date String
// time String
// status String

        print('Database created');
        database
            .execute(
                'CREATE TABLE TASKS (id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT , status TEXT)')
            .then(
          (value) {
            print('table created');
          },
        );
      },
      onOpen: (database) {
        print('Database opened');
      },
    );
  }

  void insertToDatabase() {
    database.transaction((txn) {
      txn
          .rawInsert(
              'INSERT INTO TASKS(title , date , time ,status) VALUES("first task","02222","891","new")')
          .then(
        (value) {
          print('$value inserted successfully');
        },
      ).catchError((error) {
        print('Error When Inserting New Record ${error.toString()}');
      });
      throw ();
    });
  }
}
