// ignore_for_file: unused_import

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:udemy_flutter/models/user/user_model.dart';
import 'package:udemy_flutter/shared/components/constants.dart';
import 'package:udemy_flutter/shared/cubit/cubit.dart';

Widget defaultButton({
  width = double.infinity,
  Color background = Colors.blue,
  bool isUpperCase = true,
  double radius = 10.0,
  @required Function? function,
  required String text,
}) =>
    Container(
      width: width,
      height: 50.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          radius,
        ),
        color: background,
      ),
      child: MaterialButton(
        onPressed: () {
          if (function != null) {
            function();
          }
        },
        child: Text(
          isUpperCase ? text.toUpperCase() : text,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );

Widget defaultFormField({
  required TextEditingController controller,
  required TextInputType keyboardType,
  void Function(String)? onFieldSubmitted,
  void Function(String)? onChanged,
  bool isPassword = false,
  required String? Function(String?) validator,
  required String labelText,
  required IconData prefixIcon,
  IconData? suffixIcon,
  Function? suffixPressed,
  void Function()? onTab,
  bool isClickable = true,
}) =>
    TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: isPassword,
      onFieldSubmitted: onFieldSubmitted,
      enabled: isClickable,
      onChanged: onChanged,
      onTap: onTab,
      validator: validator,
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: Icon(
          prefixIcon,
        ),
        suffixIcon: suffixIcon != null
            ? IconButton(
                onPressed: () {
                  if (suffixPressed != null) {
                    suffixPressed();
                  }
                },
                icon: Icon(
                  suffixIcon,
                ),
              )
            : null,
        border: const OutlineInputBorder(),
      ),
    );

Widget buildTaskItem(Map model, context) => Dismissible(
      key: Key(model['id'].toString()),
      onDismissed: (direction) {
        AppCubit.get(context).deleteDatabase(id: model['id']);
      },
      child: Padding(
        padding: EdgeInsets.all(20.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 40.0,
              child: Text(
                "${model['time']}",
              ),
            ),
            SizedBox(
              width: 20.0,
            ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${model['title']}',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${model['date']}',
                    style: TextStyle(color: Colors.grey),
                  )
                ],
              ),
            ),
            SizedBox(
              width: 20.0,
            ),
            IconButton(
                onPressed: () {
                  AppCubit.get(context).updateData(
                    status: 'done',
                    id: model['id'],
                  );
                },
                icon: Icon(
                  Icons.check_box,
                  color: const Color.fromARGB(255, 127, 153, 128),
                )),
            SizedBox(
              width: 1.0,
            ),
            IconButton(
                onPressed: () {
                  AppCubit.get(context).updateData(
                    status: 'archive',
                    id: model['id'],
                  );
                },
                icon: Icon(
                  Icons.archive,
                  color: Colors.purple,
                ))
          ],
        ),
      ),
    );

Widget tasksBuilder({
  required List<Map> tasks,
}) =>
    ConditionalBuilder(
        condition: tasks.isNotEmpty,
        fallback: (context) => const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.menu,
                    size: 100.0,
                    color: Colors.grey,
                  ),
                  Text(
                    'No Tasks Yet, Please Add Some Tasks',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  )
                ],
              ),
            ),
        builder: (context) => ListView.separated(
            itemBuilder: (context, index) =>
                buildTaskItem(tasks[index], context),
            separatorBuilder: (context, index) => Padding(
                  padding: const EdgeInsetsDirectional.only(
                    start: 20.0,
                  ),
                  child: Container(
                    width: double.infinity,
                    height: 1.0,
                    color: Colors.grey[300],
                  ),
                ),
            itemCount: tasks.length));
