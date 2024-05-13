import 'package:flutter/material.dart';
import 'package:my_app_1/models/meal_data.dart';
import 'package:my_app_1/utils.dart';

import '../models/meal_types.dart';
import '../models/meals.dart';
import '../screens/edit_meal_screen.dart';

class Meal extends StatelessWidget {
  final int mealId;
  final String mealContent;
  final Meals mealType;
  final MealTypes mealQty;
  final Function reloadWidget;

  const Meal(
      {required this.mealId,
      required this.mealContent,
      required this.mealType,
      required this.mealQty,
      required this.reloadWidget});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: (mealQty != MealTypes.balanced) ? const Color(0xffE8C9B8) : const Color(0xffF9EBE1),
            border: Border.all(color: Colors.black),
            borderRadius: BorderRadius.circular(30.0),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      mealType.getname(),
                      style: const TextStyle(fontSize: 14.0),
                    ),
                    Text(
                      mealQty.getname(),
                      style: const TextStyle(fontSize: 14.0),
                    ),
                  ],
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: SingleChildScrollView(
                          child: Text(
                            Utils.getFormattedText(mealContent),
                            style: const TextStyle(fontSize: 18.0),
                            softWrap: true,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () async {
                          await showModalBottomSheet(
                            context: context,
                            builder: (context) => EditMealScreen(
                              mealData: MealData(
                                  id: mealId, mealContent: mealContent, mealQty: mealQty, mealType: mealType),
                            ),
                          );
                          reloadWidget();
                        },
                        icon: const Icon(Icons.edit),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
