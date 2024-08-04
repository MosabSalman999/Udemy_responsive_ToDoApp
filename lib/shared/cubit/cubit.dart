import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:udemy_flutter/modules/archived_tasks/archived_tasks_screen.dart';
import 'package:udemy_flutter/modules/done_tasks/done_tasks_screen.dart';
import 'package:udemy_flutter/modules/new_tasks/new_tasks_screen.dart';
import 'package:udemy_flutter/shared/cubit/states.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;
  late Database database;

  List<Map> tasks = [];
  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archiveTasks = [];

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

  void changeIndex(int index) {
    currentIndex = index;
    emit(AppChangeBottomNavBarState());
  }

  void createDatabase() {
    // ignore: duplicate_ignore
    // ignore: unused_local_variable
    openDatabase(
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
        getDataFromDatabase(database);
        print('Database opened');
      },
    ).then((onValue) {
      database = onValue;
      emit(AppCreateDatabaseState());
    });
    ;
  }

  insertToDatabase({
    required String title,
    required String time,
    required String date,
  }) async {
    return database.transaction((txn) => txn
            .rawInsert(
                'INSERT INTO TASKS(title , date , time ,status) VALUES("$title","$date","$time","new")')
            .then((onValue) {
          //  print('$onValue inserted successfully');
          emit(AppInsertDatabaseState());

          getDataFromDatabase(database);
        }).catchError((error) {
          print('Error When Inserting New Record ${error.toString()}');
        }));
  }

  void getDataFromDatabase(database) {
    newTasks = [];
    doneTasks = [];
    archiveTasks = [];

    emit(AppGetDatabaseLoadingState());

    database.rawQuery('SELECT * FROM TASKS').then((onValue) {
      tasks = onValue;
      print(tasks);

      tasks.forEach((Element) {
        if (Element['status'] == 'new') {
          newTasks.add(Element);
        } else if (Element['status'] == 'done') {
          doneTasks.add(Element);
        } else
          archiveTasks.add(Element);
      });

      emit(AppGetDatabaseState());

      //   ctrl + k + c << comment
    });
    ;
  }

  void updateData({
    required String status,
    required int id,
  }) {
    database.rawUpdate(
      'UPDATE tasks SET status = ? WHERE id = ?',
      ['$status', id],
    ).then((onValue) {
      getDataFromDatabase(database);
      emit(AppUpdateDatabaseState());
    });
  }

  void deleteDatabase({
    required int id,
  }) async {
    database.rawDelete(
      'DELETE FROM tasks WHERE id = ?',
      [id],
    ).then((onValue) {
      getDataFromDatabase(database);
      emit(AppDeleteDatabaseState());
    });
  }

  bool isBottomSheetShown = false;
  IconData fabIcon = Icons.edit;

  void changeBottomSheetShown({
    required bool isShow,
    required IconData icon,
  }) {
    isBottomSheetShown = isShow;
    fabIcon = icon;
    emit(AppChangeBottomNavBarState());
  }
}
