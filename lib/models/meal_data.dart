import 'package:my_app_1/models/meal_types.dart';
import 'package:my_app_1/models/meals.dart';

class MealData {
  final int id;
  final Meals mealType;
  final String mealContent;
  final MealTypes mealQty;

  MealData({
    this.id = -1,
    this.mealType = Meals.breakfast,
    this.mealContent = "",
    this.mealQty = MealTypes.balanced,
  });

  Map<String, Object?> toMap(){
    return {
      'id': id,
      'mealType': mealType,
      'mealContent': mealContent,
      'mealQty': mealQty
    };
  }

  @override
  String toString(){
    return 'MealData(id: $id, mealType: $mealType, mealContent: $mealContent, mealQty: $mealQty)';
  }
}
