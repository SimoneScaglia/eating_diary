enum MealTypes{
  restriction,
  balanced,
  bingeEating,
}

extension MealNames on MealTypes {
  String getname() {
    switch (this) {
      case MealTypes.restriction:
        return 'Restrizione';
      case MealTypes.balanced:
        return 'Giusto';
      case MealTypes.bingeEating:
        return 'Abbuffata';
      default:
        return '';
    }
  }
}