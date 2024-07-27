import 'package:flutter/material.dart';

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

Widget buildTaskItem(Map tasks) => Padding(
      padding: const EdgeInsets.all(20.0),
      child: const Row(
        children: [
          CircleAvatar(
            radius: 40.0,
            child: Text('tasks'),
          ),
          SizedBox(
            width: 20.0,
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'title',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'date',
                style: TextStyle(color: Colors.grey),
              )
            ],
          )
        ],
      ),
    );
