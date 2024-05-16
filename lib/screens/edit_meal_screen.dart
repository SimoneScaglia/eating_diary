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
  late MealTypes selectedValue;
  List<String> options = [];
  List<String> _searchResults = [];
  TextEditingController _controller = TextEditingController();
  List<String> mealItems = [];

  @override
  void initState() {
    super.initState();
    selectedValue = widget.mealData.mealQty;
    mealItems = widget.mealData.mealContent.split('\n');
    _controller.text = widget.mealData.mealContent;
    _controller.addListener(_onTextChanged);
  }

  Future<void> _fetchOptions(String query) async {
    if (query.isEmpty) {
      setState(() {
        _searchResults.clear();
      });
      return;
    }

    List<Map<String, dynamic>> response = await DiaryData().getMealContentByMealType(Utils.db, widget.mealData.mealType);
    setState(() {
      _searchResults = response
          .map((content) => content['mealContent'] as String)
          .where((content) => content.toLowerCase().startsWith(query.toLowerCase()))
          .toList();
    });
  }

  void _onTextChanged() {
    List<String> items = _controller.text.split('\n');
    String currentItem = items.isNotEmpty ? items.last : '';
    _fetchOptions(currentItem);
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
              (mealItems.isEmpty) ? 'Inserisci il pasto' : 'Modifica il pasto',
              style: const TextStyle(color: Color(0xff3E4A55), fontSize: 25.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                hintText: 'Inserisci il pasto',
                hintStyle: TextStyle(color: Colors.blueGrey),
                border: OutlineInputBorder(),
              ),
              style: const TextStyle(color: Color(0xff3E4A55)),
              maxLines: null,
              keyboardType: TextInputType.multiline,
              onChanged: (text) {
                setState(() {
                  mealItems = text.split('\n');
                });
                _onTextChanged(); // Fetch options whenever the text changes
              },
            ),
            const SizedBox(height: 8.0),
            Expanded(
              child: ListView.builder(
                itemCount: _searchResults.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 4.0),
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      side: BorderSide(color: Colors.blueGrey, width: 1.0),
                    ),
                    child: ListTile(
                      title: Text(_searchResults[index]),
                      onTap: () {
                        setState(() {
                          List<String> items = _controller.text.split('\n');
                          items[items.length - 1] = _searchResults[index];
                          _controller.text = items.join('\n');
                          _controller.selection = TextSelection.fromPosition(
                              TextPosition(offset: _controller.text.length));
                          _searchResults.clear();
                        });
                      },
                    ),
                  );
                },
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
                // Handle each meal item separately
                for (String mealItem in mealItems) {
                  if (mealItem.trim().isNotEmpty) {
                    await DiaryData().insertOrUpdateMeal(
                        Utils.db, widget.mealData.id, widget.mealData.mealType.name, mealItem, selectedValue);
                  }
                }
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
