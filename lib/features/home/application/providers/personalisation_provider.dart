import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PersonalisationProvider extends ChangeNotifier {
  int dayFrequency = 0;
  DateTime _startTime = DateTime.now();
  DateTime _endTime = DateTime.now();
  Set<WeekDay> weekDaysFrequency = {};
  String alertTone = "";

  // int get dayFrequency => _modelState.frequency;
  // DateTime get startTime => _modelState.startTime;
  // DateTime get endTime => _modelState.endTime;
  // Set<WeekDay> get weekDaysFrequency => _modelState.repeatDays;
  // String get alertTone => _modelState.alertSound;

  String get startTime => DateFormat('hh:mm a').format(_startTime);
  String get endTime => DateFormat('hh:mm a').format(_endTime);

  void updateDayFrequencyUp() {
    if (dayFrequency >= 24) return;
    dayFrequency++;
    notifyListeners();
  }

  void updateDayFrequencyDown() {
    if (dayFrequency <= 1) return;
    dayFrequency--;
    notifyListeners();
  }

  void updateStartTime(DateTime time) {
    if (time == _startTime) return;
    _startTime = time;
    notifyListeners();
  }

  void updateEndTime(DateTime time) {
    if (time == _endTime) return;
    _endTime = time;
    notifyListeners();
  }

  void toggleRepeatDay(WeekDay weekday) {
    if (weekDaysFrequency.remove(weekday)) {
      notifyListeners();
    } else {
      weekDaysFrequency.add(weekday);
      notifyListeners();
    }
  }
}

class ReminderModel {
  final int frequency;
  final DateTime startTime;
  final DateTime endTime;
  final Set<WeekDay> repeatDays;
  final String alertSound;

  ReminderModel({
    required this.frequency,
    required this.startTime,
    required this.endTime,
    required this.repeatDays,
    required this.alertSound,
  });

  factory ReminderModel.defaultInit() {
    return ReminderModel(
      frequency: 4,
      startTime: DateTime.now(),
      endTime: DateTime.now(),
      alertSound: '',
      repeatDays: {},
    );
  }
}

enum WeekDay {
  monday(1),
  tuesday(2),
  wednesday(3),
  thursday(4),
  friday(5),
  saturday(6),
  sunday(7);

  final int id;
  const WeekDay(this.id);
}
