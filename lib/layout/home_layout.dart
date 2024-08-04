// ignore_for_file: prefer_const_constructors, avoid_print, unused_local_variable

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:udemy_flutter/modules/archived_tasks/archived_tasks_screen.dart';
import 'package:udemy_flutter/modules/done_tasks/done_tasks_screen.dart';
import 'package:udemy_flutter/modules/new_tasks/new_tasks_screen.dart';
import 'package:udemy_flutter/shared/components/components.dart';
import 'package:udemy_flutter/shared/components/constants.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:udemy_flutter/shared/cubit/cubit.dart';
import 'package:udemy_flutter/shared/cubit/states.dart';

// ignore: must_be_immutable, use_key_in_widget_constructors
class HomeLayout extends StatelessWidget {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {
          if (state is AppInsertDatabaseState) {
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          AppCubit cubit = AppCubit.get(context);
          return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              title: Text(
                AppCubit.get(context).titles[cubit.currentIndex],
              ),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                if (cubit.isBottomSheetShown) {
                  if (formKey.currentState!.validate()) {
                    cubit.insertToDatabase(
                        title: titleController.text,
                        time: timeController.text,
                        date: dateController.text);
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
                    cubit.changeBottomSheetShown(
                        isShow: false, icon: Icons.edit);
                  });
                  cubit.changeBottomSheetShown(isShow: true, icon: Icons.add);
                }
              },
              child: Icon(
                cubit.fabIcon,
              ),
            ),
            bottomNavigationBar: BottomNavigationBar(
              backgroundColor: Colors.white,
              type: BottomNavigationBarType.fixed,
              currentIndex: cubit.currentIndex,
              onTap: (onValue) {
                AppCubit.get(context).changeIndex(onValue);
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
              condition: state is! AppGetDatabaseLoadingState,
              builder: (context) => cubit.screens[cubit.currentIndex],
              fallback: (context) => Center(child: CircularProgressIndicator()),
            ),
          );
        },
      ),
    );
  }

  Future<String> getName() async {
    return "Ahmed Ali";
  }
}





// // 1. create database
// 2. create tables
// 3. open database
// 4. insert to database
// 5. get from database
// 6. update in database
// 7. delete from database

