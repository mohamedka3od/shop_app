import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void navigateTo(context, widget) => Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => widget,
    ));
//////////////////////////////////////////////////
void navigateAndFinish(context, widget) => Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => widget,
      ),
      (Route<dynamic> route) => false,
    );
//////////////////////////////////////////////////
Widget defaultFormField({
  required TextEditingController controller,
  required TextInputType type,
  required FormFieldValidator validate,
  required String label,
  required IconData prefix,
  bool isPassword = false,
  Function(String)? onSubmit,
  IconData? suffix,
  Function? suffixPressed,
  Function()? onTap,
}) =>
    TextFormField(
      controller: controller,
      keyboardType: type,
      obscureText: isPassword,
      onFieldSubmitted: onSubmit,
      onTap: onTap,
      validator: validate,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        labelText: label,
        prefixIcon: Icon(
          prefix,
        ),
        suffixIcon: suffix != null
            ? IconButton(
                onPressed: () => suffixPressed!(),
                icon: Icon(
                  suffix,
                ),
              )
            : null,
      ),
    );
////////////////////////////////////////////////////

Widget defaultButton({
  double width = double.infinity,
  Color background = Colors.blue,
  bool isUpperCase = true,
  double radius = 0.3,
  required Function()? function,
  required String text,
})=>
Container(
  width: width,
  height: 50.0,
  child: MaterialButton(
    onPressed: function,
    child: Text(
        isUpperCase ? text.toUpperCase() : text,
        style: const TextStyle(
          color: Colors.white,
        ),
    ),
  ),
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(radius),
    color: background,
  ),
);
//////////////////////////////////////////////////

Widget defaultTextButton ({
  required Function()? function,
  required String text,
})=>
TextButton(
    onPressed: function,
    child: Text(text.toUpperCase())
);
///////////////////////////////////////////////////

void showToast({
  required String text,
  required ToastStates state,
})=>Fluttertoast.showToast(
    msg: text ,
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 5,
    backgroundColor: chooseToastColor(state),
    textColor: Colors.white,
    fontSize: 16.0
  );
//enum
enum ToastStates {SUCESS,ERROR,WARNING}
Color chooseToastColor(ToastStates state){
  Color color;
  switch (state)
  {
    case ToastStates.SUCESS:
      color= Colors.green;
      break;
    case ToastStates.ERROR:
      color= Colors.red;
      break;
    case ToastStates.WARNING:
      color= Colors.amber;
      break;
  }
  return color;
}
