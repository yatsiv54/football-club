import 'package:drift/drift.dart';

class Matches extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get opponent => text()();
  TextColumn get place => text()();
  DateTimeColumn get date => dateTime()();
  BoolColumn get completed => boolean().withDefault(const Constant(false))();
  TextColumn get score => text().withDefault(const Constant(''))();
  TextColumn get notes => text()();
}

class Trainings extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text()();
  TextColumn get notes => text().withDefault(const Constant(''))();
  DateTimeColumn get date => dateTime()();
  IntColumn get durationMinutes => integer()();
}

class Players extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get position => text()();
  IntColumn get jerseyNumber => integer().nullable()();
  DateTimeColumn get dob => dateTime().nullable()();
  TextColumn get phoneNumber => text().withDefault(const Constant(''))();
  TextColumn get email => text().withDefault(const Constant(''))();
  TextColumn get note => text().withDefault(const Constant(''))();
}

class Diaries extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text()();
  IntColumn get mood => integer()();
  TextColumn get notes => text().withDefault(const Constant(''))();
  DateTimeColumn get date => dateTime().nullable()();
}

class Objectives extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text()();
  IntColumn get status => integer()(); 
  IntColumn get category => integer()(); 
  TextColumn get description => text().withDefault(const Constant(''))();
  DateTimeColumn get deadline => dateTime().nullable()();
  IntColumn get goalType => integer()(); 
  TextColumn get stepsJson => text().withDefault(const Constant(''))();
}
