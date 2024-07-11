

import 'package:food_saver/res/enums.dart';

class UtilityFunctions {
  static String getWeekDayName(int weekDay) {
    switch (weekDay) {
      case 1:
        return "Monday";
      case 2:
        return "Tuesday";
      case 3:
        return "Wednesday";
      case 4:
        return "Thursday";
      case 5:
        return "Friday";
      case 6:
        return "Saturday";
      case 7:
        return "Sunday";
      default:
        return "Invalid Weekday Number";
    }
  }

  static String getCollectionName(String userRole) {
    if (userRole == UserRoles.Student.name) {
      return "Students";
    } else {
      return "Teachers";
    }
  }
}
