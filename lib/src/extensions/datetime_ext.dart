import 'package:intl/intl.dart';

extension RelativeDateTimeNullableExtension on DateTime? {
  String formatNullableTimeAgo() {
    try {
      if (this == null) {
        return "";
      }
      Duration difference = DateTime.now().difference(this!);

      if (difference.inSeconds < 60) {
        return difference.inSeconds == 1
            ? "1 sec ago"
            : "${difference.inSeconds} s ago";
      } else if (difference.inMinutes < 60) {
        return difference.inMinutes == 1
            ? "1 min ago"
            : "${difference.inMinutes} mins ago";
      } else if (difference.inHours < 24) {
        return difference.inHours == 1
            ? "1 hr ago"
            : "${difference.inHours} hrs ago";
      } else if (difference.inDays < 7) {
        return difference.inDays == 1
            ? "1 day ago"
            : "${difference.inDays} days ago";
      } else {
        return DateFormat(
          'MMM d, y',
        ).format(this!); // return date if older than a week
      }
    } catch (e) {
      return this?.toDateTimeString() ??
          ""; // fallback to a full date-time string
    }
  }
}

String getGreeting() {
  final hour = DateTime.now().hour;

  if (hour < 12) {
    return 'Good morning';
  } else if (hour < 17) {
    return 'Good afternoon';
  } else {
    return 'Good evening';
  }
}

extension RelativeDateTimeExtension on DateTime {
  String toRelativeTimeString() {
    Duration difference = DateTime.now().difference(this);
    // return DateFormat('E d\'th\', MMM h:mm a').format(this);
    if (difference.inSeconds < 1) {
      return "a sec ago";
    } else if (difference.inMinutes < 1) {
      return "a min ago";
    } else if (difference.inMinutes < 60) {
      return "${difference.inMinutes} mins ago";
    } else if (difference.inHours < 24) {
      return "${difference.inHours} hrs ago";
    } else if (difference.inDays < 7) {
      return "${difference.inDays} days ago";
    } else {
      return DateFormat('MMM d, yyyy').format(this);

      // Fallback to default format
      // return DateFormat('EEE M d, yyyy; hh:mm a').format(this);
    }
  }

  // String toDateTimeString() {
  //   try {
  //     final DateFormat formatter = DateFormat(
  //       'dd MMMM, yyyy. hh:mma',
  //     );

  //     String formattedDate = formatter.format(this);

  //     return formattedDate;
  //   } catch (e) {
  //     // print('Error formatting date time: $e');
  //     return toIso8601String();
  //   }
  // }
  String toDateTimeString() {
    try {
      // Since the datetime is already UTC, just convert to local
      DateTime localTime = toLocal();

      final DateFormat formatter = DateFormat('dd MMMM, yyyy. hh:mma');
      String formattedDate = formatter.format(localTime);
      return formattedDate;
    } catch (e) {
      // print('Error formatting date time: $e');
      return toLocal().toIso8601String();
    }
  }

  String toMonthString() {
    try {
      final DateFormat formatter = DateFormat('MMM d');

      String formattedDate = formatter.format(this);

      return formattedDate;
    } catch (e) {
      // print('Error formatting date time: $e');
      return toIso8601String();
    }
  }

  String toYearMonthString() {
    try {
      final DateFormat formatter = DateFormat('MMM d, yyyy');

      String formattedDate = formatter.format(this);

      return formattedDate;
    } catch (e) {
      // print('Error formatting date time: $e');
      return toIso8601String();
    }
  }

  String formatAsCustomDate() {
    try {
      final DateFormat formatter = DateFormat('yyyy-MM-dd');
      return formatter.format(this);
    } catch (e) {
      return toIso8601String();
    }
  }

  String formatTimeLeft() {
    try {
      Duration difference = this.difference(DateTime.now());
      if (difference.isNegative) {
        return "00 mins : 00 secs left";
      }
      int minutes = difference.inMinutes.remainder(60);
      int seconds = difference.inSeconds.remainder(60);

      // Use NumberFormat to format the minutes and seconds with leading zeros
      String minutesStr = NumberFormat("00").format(minutes);
      String secondsStr = NumberFormat("00").format(seconds);

      return "$minutesStr mins : $secondsStr secs left";
    } catch (e) {
      return toDateTimeString();
    }
  }

  String formatTimeAgo() {
    try {
      Duration difference = DateTime.now().difference(this);

      if (difference.inSeconds < 60) {
        return difference.inSeconds == 1
            ? "1 sec ago"
            : "${difference.inSeconds} seconds ago";
      } else if (difference.inMinutes < 60) {
        return difference.inMinutes == 1
            ? "1 minute ago"
            : "${difference.inMinutes} mins ago";
      } else if (difference.inHours < 24) {
        return difference.inHours == 1
            ? "1 hour ago"
            : "${difference.inHours} hrs ago";
      } else if (difference.inDays < 7) {
        return difference.inDays == 1
            ? "1 day ago"
            : "${difference.inDays} days ago";
      } else {
        return DateFormat(
          'MMM d, y',
        ).format(this); // return date if older than a week
      }
    } catch (e) {
      return toDateTimeString(); // fallback to a full date-time string
    }
  }

  String toTransFormat() {
    DateTime localDateTime = toLocal();
    final dateFormat = DateFormat('MMM d・HH:mm');
    return dateFormat.format(localDateTime);
  }
}
