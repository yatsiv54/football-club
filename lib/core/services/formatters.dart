import 'package:fortuna/features/objectives/data/objective_entity.dart';

String formatDate(DateTime dateTime, String separator) {
  const weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  const months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  final dayName = weekdays[(dateTime.weekday - 1) % weekdays.length];
  final monthName = months[(dateTime.month - 1) % months.length];

  String twoDigits(int n) => n.toString().padLeft(2, '0');
  final time = '${twoDigits(dateTime.hour)}:${twoDigits(dateTime.minute)}';

  return '$dayName, $monthName ${twoDigits(dateTime.day)} $separator $time';
}

String formatTime(DateTime time) {
  return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
}

String formatBirthdayDate(DateTime? date) {
  const months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];
  if (date != null) {
    final monthName = months[(date.month - 1) % months.length];
    return '${date.day} $monthName ${date.year}';
  } else {
    return 'No date';
  }
}

String formatBirthdayDate2(DateTime? date) {
  const months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];
  if (date != null) {
    final monthName = months[(date.month - 1) % months.length];
    return ' $monthName ${date.day}, ${date.year}';
  } else {
    return 'No date';
  }
}

String formatDateForTraining(DateTime dateTime, String separator) {
  const weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  const months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  final dayName = weekdays[(dateTime.weekday - 1) % weekdays.length];
  final monthName = months[(dateTime.month - 1) % months.length];

  String twoDigits(int n) => n.toString().padLeft(2, '0');
  final time = '${twoDigits(dateTime.hour)}:${twoDigits(dateTime.minute)}';

  return '$dayName, $monthName ${twoDigits(dateTime.day)} \n $time';
}

String formatScore(String input) {
  final trimmed = input.trim();
  final parts = trimmed.split(':');
  if (parts.length != 2) return input;
  final left = parts[0].trim();
  final right = parts[1].trim();
  return '$left - $right';
}

String formatScore2(String input) {
  final trimmed = input.trim();
  final parts = trimmed.split(':');
  if (parts.length != 2) return input;
  final left = parts[0].trim();
  final right = parts[1].trim();
  return '$left : $right';
}

String formatPhone(String input) {
  final digits = input.replaceAll(RegExp(r'\D'), '');
  if (digits.isEmpty) return '';

  final buffer = StringBuffer('+');

  int index = 0;

  if (digits.length > 3) {
    buffer.write(digits.substring(0, 3));
    index = 3;
  } else {
    buffer.write(digits);
    return buffer.toString();
  }

  while (index < digits.length) {
    buffer.write(' ');
    final end = (index + 3 < digits.length) ? index + 3 : digits.length;
    buffer.write(digits.substring(index, end));
    index = end;
  }

  return buffer.toString();
}

String formatDateDiary(DateTime dateTime) {
  const weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  const months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  final dayName = weekdays[(dateTime.weekday - 1) % 7];
  final monthName = months[(dateTime.month - 1) % 12];

  String twoDigits(int n) => n.toString().padLeft(2, '0');

  return '$dayName, $monthName ${twoDigits(dateTime.day)}';
}

String categoryText(ObjectiveCategory category) {
  switch (category) {
    case ObjectiveCategory.fitness:
      return 'Fitness';
    case ObjectiveCategory.training:
      return 'Training';
    case ObjectiveCategory.performance:
      return 'Performance';
    case ObjectiveCategory.recovery:
      return 'Recovery';
    case ObjectiveCategory.mindset:
      return 'Mindset';
    case ObjectiveCategory.teamwork:
      return 'Teamwork';
    case ObjectiveCategory.seasonGoal:
      return 'Season Goal';
  }
}
