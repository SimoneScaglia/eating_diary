import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_app_1/models/diary_data.dart';
import 'package:my_app_1/models/meal_data.dart';
import 'package:my_app_1/models/meal_types.dart';

import '../utils.dart';

class EditMealScreen extends StatefulWidget {
  final MealData mealData;

  const EditMealScreen({required this.mealData});

  @override
  State<EditMealScreen> createState() => _EditMealScreenState();
}

class _EditMealScreenState extends State<EditMealScreen> {
  late String mealContent;
  late MealTypes selectedValue;

  @override
  void initState() {
    super.initState();
    mealContent = widget.mealData.mealContent;
    selectedValue = widget.mealData.mealQty;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30.0),
        color: const Color(0xffF9EBE1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              (mealContent == "") ? 'Inserisci il pasto' : 'Modifica il pasto',
              style: const TextStyle(color: Color(0xff3E4A55), fontSize: 25.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16.0),
            SingleChildScrollView(
              scrollDirection: Axis.vertical,
              reverse: true,
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxHeight: 100.0,
                ),
                child: TextField(
                  autofocus: true,
                  maxLines: null,
                  controller: TextEditingController(text: mealContent),
                  decoration: const InputDecoration(
                    hintText: 'Inserisci il pasto',
                    hintStyle: TextStyle(color: Colors.blueGrey),
                    border: OutlineInputBorder(),
                  ),
                  style: const TextStyle(color: Color(0xff3E4A55)),
                  onChanged: (value) => mealContent = value,
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            SegmentedButton<MealTypes>(
              segments: <ButtonSegment<MealTypes>>[
                ButtonSegment<MealTypes>(
                    value: MealTypes.restriction,
                    label: Text(MealTypes.restriction.getname()),
                    icon: const Icon(Icons.arrow_drop_down)),
                ButtonSegment<MealTypes>(
                    value: MealTypes.balanced,
                    label: Text(MealTypes.balanced.getname()),
                    icon: const Icon(Icons.balance)),
                ButtonSegment<MealTypes>(
                    value: MealTypes.bingeEating,
                    label: Text(MealTypes.bingeEating.getname()),
                    icon: const Icon(Icons.arrow_drop_up)),
              ],
              selected: <MealTypes>{selectedValue},
              onSelectionChanged: (Set<MealTypes> newSelection) {
                setState(() {
                  selectedValue = newSelection.first;
                });
              },
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                await DiaryData().insertOrUpdateMeal(
                    Utils.db, widget.mealData.id, widget.mealData.mealType.name, mealContent, selectedValue);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xffE8C9B8),
                padding: const EdgeInsets.all(20.0),
              ),
              child: const Text(
                'Salva',
                style: TextStyle(color: Color(0xff3E4A55), fontSize: 20.0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
