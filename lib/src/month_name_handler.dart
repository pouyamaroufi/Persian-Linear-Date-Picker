extension StringExt on int {
  String getMonthName(bool isJalali) {
    if (isJalali) {
      return jalaliMonthName;
    } else {
      return gregorianMonthName;
    }
  }

  String get jalaliMonthName {
    switch (this) {
      case 1:
        return "فروردین";

      case 2:
        return "اردیبهشت";

      case 3:
        return "خرداد";

      case 4:
        return "تیر";

      case 5:
        return "مرداد";

      case 6:
        return "شهریور";

      case 7:
        return "مهر";

      case 8:
        return "آبان";

      case 9:
        return "آذر";

      case 10:
        return "دی";

      case 11:
        return "بهمن";

      case 12:
        return "اسفند";

      default:
        return '$this';
    }
  }

  String get gregorianMonthName {
    switch (this) {
      case 1:
        return "Jan";

      case 2:
        return "Feb";

      case 3:
        return "March";

      case 4:
        return "April";

      case 5:
        return "May";

      case 6:
        return "June";

      case 7:
        return "July";

      case 8:
        return "August";

      case 9:
        return "Sep";

      case 10:
        return "Oct";

      case 11:
        return "Nov";
      case 12:
        return "Dec";
      default:
        return '$this';
    }
  }
}
