import 'dart:math';

import 'package:flutter/material.dart';


class MyFunctions {

 
  String monthify(int month) {
    var mt = "January";
    if (month == 1) {
      mt = "January";
    } else if (month == 2) {
      mt = "February";
    } else if (month == 3) {
      mt = "March";
    } else if (month == 4) {
      mt = "April";
    } else if (month == 5) {
      mt = "May";
    } else if (month == 6) {
      mt = "June";
    } else if (month == 7) {
      mt = "July";
    } else if (month == 8) {
      mt = "August";
    } else if (month == 9) {
      mt = "September";
    } else if (month == 10) {
      mt = "October";
    } else if (month == 11) {
      mt = "November";
    } else if (month == 12) {
      mt = "December";
    }
    return mt;
  }

  String humanDate(int day, int month, int year) {
    return (day.toString() + ", " + monthify(month) + " " + year.toString());
  }

  String strRandom(int length) {
    const _chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    Random _rnd = Random();
    return String.fromCharCodes(Iterable.generate(
        length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
  }

  Color parseColor(String color) {
    String hex = color.replaceAll("#", "");
    if (hex.isEmpty) hex = "ffffff";
    if (hex.length == 3) {
      hex =
          '${hex.substring(0, 1)}${hex.substring(0, 1)}${hex.substring(1, 2)}${hex.substring(1, 2)}${hex.substring(2, 3)}${hex.substring(2, 3)}';
    }
    Color col = Color(int.parse(hex, radix: 16)).withOpacity(1.0);
    return col;
  }
}
