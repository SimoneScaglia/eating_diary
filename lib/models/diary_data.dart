import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'meal_types.dart';
import 'meals.dart';

class DiaryData {
  Future<Database> OpenDatabase() async {
    return openDatabase(
      join(await getDatabasesPath(), 'eating_diary_database.db'),
      onCreate: (db, version) async {
        await db.execute(
          'CREATE TABLE meal(id INTEGER PRIMARY KEY AUTOINCREMENT,'
          'mealType TEXT,'
          'mealContent TEXT,'
          'mealQty TEXT);',
        );
        await db.execute(
          'CREATE TABLE day(id INTEGER PRIMARY KEY AUTOINCREMENT,'
          'date DATE NOT NULL,'
          'breakfastId INTEGER DEFAULT -1,'
          'amSnackId INTEGER DEFAULT -1,'
          'lunchId INTEGER DEFAULT -1, '
          'pmSnackId INTEGER DEFAULT -1,'
          'dinnerId INTEGER DEFAULT -1,'
          'physicalActivity TEXT);',
        );
      },
      version: 2,
    );
  }

  Future<Map<Meals, dynamic>?> getMealsData(Database db, DateTime _date) async {
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final String date = formatter.format(_date);
    Map<Meals, dynamic> meals = {};
    await db.transaction((txn) async {
      List<Map<String, dynamic>> dayEntry = await txn.query('day', where: 'date = ?', whereArgs: [date]);
      var mealId;
      if (dayEntry.isEmpty) {
        await txn.insert('day', {'date': date});
        var dayId = Sqflite.firstIntValue(await txn.rawQuery('SELECT last_insert_rowid();'));
        for (Meals mealType in Meals.values) {
          await txn.insert('meal', {'mealType': mealType.name, 'mealContent': "", 'mealQty': "balanced"});
          mealId = Sqflite.firstIntValue(await txn.rawQuery('SELECT last_insert_rowid();'));
          await txn.update('day', {'${mealType.name}Id': mealId}, where: 'id = $dayId');
          meals[mealType] = await txn.query('meal', where: 'id = ?', whereArgs: [mealId]);
        }
      } else {
        for (Meals mealType in Meals.values) {
          meals[mealType] = await txn.query('meal', where: 'id = ?', whereArgs: [dayEntry[0]['${mealType.name}Id']]);
        }
      }
    });
    return meals;
  }

  Future<void> insertOrUpdateMeal(
      Database db, int mealId, String mealType, String mealContent, MealTypes mealQty) async {
    await db.transaction((txn) async {
      final Map<String, dynamic> mealData = {
        'mealType': mealType,
        'mealContent': mealContent,
        'mealQty': mealQty.name
      };
      await txn.update('meal', mealData, where: 'id = ?', whereArgs: [mealId]);
    });
  }

  Future<void> updatePhysicalActivity(Database db, int dayId, String physActDesc) async {
    await db.transaction((txn) async {
      final Map<String, dynamic> dayData = {
        'physicalActivity': physActDesc
      };
      await txn.update('day', dayData, where: 'id = ?', whereArgs: [dayId]);
    });
  }

  Future<List<Map<String, dynamic>>> getDayIdByDate(Database db, DateTime _date) async {
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final String date = formatter.format(_date);
    List<Map<String, dynamic>> day = [];
    await db.transaction((txn) async {
      day = await txn.query('day', where: 'date = ?', whereArgs: [date]);
    });
    return day;
  }
}
