// ignore_for_file: prefer_const_constructors, avoid_print, unused_local_variable

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:udemy_flutter/modules/archived_tasks/archived_tasks_screen.dart';
import 'package:udemy_flutter/modules/done_tasks/done_tasks_screen.dart';
import 'package:udemy_flutter/modules/new_tasks/new_tasks_screen.dart';
import 'package:udemy_flutter/shared/components/components.dart';
import 'package:udemy_flutter/shared/components/constants.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';

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
  var dateController = TextEditingController();
  var formKey = GlobalKey<FormState>();

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
            if (formKey.currentState!.validate()) {
              insertToDatabase(
                title: titleController.text,
                date: dateController.text,
                time: timeController.text,
              ).then((onValue) {
                // ignore: use_build_context_synchronously
                getDataFromDatabase(database).then((onValue) {
                  Navigator.pop(context);
                  setState(() {
                    isBottomSheetShown = false;
                    fabIcon = Icons.edit;

                    tasks = onValue;
                    print(tasks);
                  });
                });
              });
            }
          } else {
            scaffoldKey.currentState
                ?.showBottomSheet(
                  (context) => Container(
                    color: Colors.white,
                    padding: EdgeInsets.all(20.0),
                    child: Form(
                      key: formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          defaultFormField(
                            controller: titleController,
                            keyboardType: TextInputType.text,
                            validator: (onValue) {
                              if (onValue!.isEmpty) {
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
                            // isClickable: false,
                            onTab: () {
                              showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.now(),
                              ).then((onValue) {
                                // ignore: use_build_context_synchronously
                                timeController.text =
                                    onValue!.format(context).toString();
                                // ignore: use_build_context_synchronously
                                print(onValue.format(context));
                              });
                            },
                            validator: (onValue) {
                              if (onValue!.isEmpty) {
                                return 'time must not be empty';
                              }
                              return null;
                            },
                            labelText: 'Time Title',
                            prefixIcon: Icons.watch_later_sharp,
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          defaultFormField(
                            controller: dateController,
                            keyboardType: TextInputType.datetime,
                            //     isClickable: false,
                            onTab: () {
                              showDatePicker(
                                context: context,
                                firstDate: DateTime.now(),
                                lastDate: DateTime.parse('2024-12-01'),
                              ).then((onValue) {
                                dateController.text =
                                    DateFormat.yMMMd().format(onValue!);
                              });
                            },
                            validator: (onValue) {
                              if (onValue!.isEmpty) {
                                return 'date must not be empty';
                              }
                              return null;
                            },
                            labelText: 'Task Date',
                            prefixIcon: Icons.calendar_today,
                          ),
                        ],
                      ),
                    ),
                  ),
                  elevation: 20,
                )
                .closed
                .then((onValue) {
              isBottomSheetShown = false;
              setState(() {
                fabIcon = Icons.edit;
              });
            });
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
        onTap: (onValue) {
          setState(() {
            currentIndex = onValue;
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
      body: ConditionalBuilder(
        condition: tasks.isNotEmpty,
        builder: (context) => screens[currentIndex],
        fallback: (context) => Center(child: CircularProgressIndicator()),
      ),
    );
  }

  Future<String> getName() async {
    return "Ahmed Ali";
  }

  void createDatabase() async {
    // ignore: duplicate_ignore
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
                'CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT , status TEXT)')
            .then(
          (onValue) {
            print('table created');
          },
        ).catchError(
          (onError) {
            print("Error When Creating Table ${onError.toString()}");
          },
        );
      },
      onOpen: (database) {
        getDataFromDatabase(database).then((onValue) {
          setState(() {
            tasks = onValue;
            print(tasks[0]);

            // {id: 1, title: mosab, date: Jul 31, 2024, time: 6:33 AM, status: new}
          });
        });
        print('Database opened');
      },
    );
  }

  Future insertToDatabase({
    required String title,
    required String time,
    required String date,
  }) async {
    return await database.transaction((txn) => txn
            .rawInsert(
                'INSERT INTO TASKS(title , date , time ,status) VALUES("$title","$date","$time","new")')
            .then(
          (onValue) {
            print('$onValue inserted successfully');
          },
        ).catchError((error) {
          print('Error When Inserting New Record ${error.toString()}');
        }));
  }

  Future<List<Map>> getDataFromDatabase(database) async {
    return database.rawQuery('SELECT * FROM tasks');
  }
}
