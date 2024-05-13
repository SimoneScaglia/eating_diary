import 'package:flutter/material.dart';
import 'package:my_app_1/components/physical_activity.dart';
import 'package:my_app_1/models/meals.dart';
import 'package:my_app_1/models/diary_data.dart';
import 'package:my_app_1/utils.dart';

import '../components/meal.dart';
import '../models/meal_types.dart';
import '../models/meal_data.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const List<String> giorniSettimana = [
    "Lunedì",
    "Martedì",
    "Mercoledì",
    "Giovedì",
    "Venerdì",
    "Sabato",
    "Domenica",
  ];
  DateTime dateTime = DateTime.now();
  Map<Meals, MealData> mealsOfTheDay = {
    Meals.breakfast: MealData(mealType: Meals.breakfast),
    Meals.amSnack: MealData(mealType: Meals.breakfast),
    Meals.lunch: MealData(mealType: Meals.breakfast),
    Meals.pmSnack: MealData(mealType: Meals.breakfast),
    Meals.dinner: MealData(mealType: Meals.breakfast),
  };
  int dayId = -1;
  String physicalActivityDescription = "";

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  void _fetchData() async {
    Map<Meals, dynamic>? mealsOfTheDayFromDB = await DiaryData().getMealsData(Utils.db, dateTime);
    for (Meals mealType in Meals.values) {
      setState(() {
        mealsOfTheDay[mealType] = MealData(
          id: mealsOfTheDayFromDB?[mealType][0]['id'],
          mealType: mealType,
          mealContent: mealsOfTheDayFromDB?[mealType][0]['mealContent'],
          mealQty:
              MealTypes.values.firstWhere((element) => element.name == mealsOfTheDayFromDB?[mealType][0]['mealQty']),
        );
      });
    }
    List<Map<String, dynamic>> _dayId = await DiaryData().getDayIdByDate(Utils.db, dateTime);
    setState(() {
      dayId = _dayId[0]['id'];
      physicalActivityDescription = _dayId[0]['physicalActivity'] ?? "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F5F5),
      appBar: AppBar(
        title: const Text('Diario Alimentare'),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          Text(
            "${giorniSettimana[dateTime.weekday - 1]} ${Utils.getFormattedDate(dateTime)}",
            style: const TextStyle(fontSize: 18.0),
          ),
          Meal(
            mealId: mealsOfTheDay[Meals.breakfast]!.id,
            mealContent: mealsOfTheDay[Meals.breakfast]!.mealContent,
            mealType: mealsOfTheDay[Meals.breakfast]!.mealType,
            mealQty: mealsOfTheDay[Meals.breakfast]!.mealQty,
            reloadWidget: () => _fetchData(),
          ),
          Meal(
            mealId: mealsOfTheDay[Meals.amSnack]!.id,
            mealContent: mealsOfTheDay[Meals.amSnack]!.mealContent,
            mealType: mealsOfTheDay[Meals.amSnack]!.mealType,
            mealQty: mealsOfTheDay[Meals.amSnack]!.mealQty,
            reloadWidget: () => _fetchData(),
          ),
          Meal(
            mealId: mealsOfTheDay[Meals.lunch]!.id,
            mealContent: mealsOfTheDay[Meals.lunch]!.mealContent,
            mealType: mealsOfTheDay[Meals.lunch]!.mealType,
            mealQty: mealsOfTheDay[Meals.lunch]!.mealQty,
            reloadWidget: () => _fetchData(),
          ),
          Meal(
            mealId: mealsOfTheDay[Meals.pmSnack]!.id,
            mealContent: mealsOfTheDay[Meals.pmSnack]!.mealContent,
            mealType: mealsOfTheDay[Meals.pmSnack]!.mealType,
            mealQty: mealsOfTheDay[Meals.pmSnack]!.mealQty,
            reloadWidget: () => _fetchData(),
          ),
          Meal(
            mealId: mealsOfTheDay[Meals.dinner]!.id,
            mealContent: mealsOfTheDay[Meals.dinner]!.mealContent,
            mealType: mealsOfTheDay[Meals.dinner]!.mealType,
            mealQty: mealsOfTheDay[Meals.dinner]!.mealQty,
            reloadWidget: () => _fetchData(),
          ),
          PhysicalActivity(
            id: dayId,
            physicalActivityDescription: physicalActivityDescription,
            reloadWidget: () => _fetchData(),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Color(0xff3E4A55),
        backgroundColor: Colors.blueGrey.shade50,
        currentIndex: 1,
        items: [
          const BottomNavigationBarItem(icon: Icon(Icons.arrow_back_ios), label: 'Precedente'),
          BottomNavigationBarItem(icon: const Icon(Icons.home), label: Utils.getFormattedDate(dateTime)),
          const BottomNavigationBarItem(icon: Icon(Icons.arrow_forward_ios), label: 'Successivo'),
        ],
        onTap: (value) {
          if (value == 0) {
            setState(() {
              dateTime = dateTime.subtract(const Duration(days: 1));
            });
          }
          if (value == 1) {
            setState(() {
              dateTime = DateTime.now();
            });
          }
          if (value == 2) {
            setState(() {
              dateTime = dateTime.add(const Duration(days: 1));
            });
          }
          _fetchData();
        },
      ),
    );
  }
}
