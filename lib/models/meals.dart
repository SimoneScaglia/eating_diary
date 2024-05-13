enum Meals{
  breakfast,
  amSnack,
  lunch,
  pmSnack,
  dinner,
}

extension MealNames on Meals {
  String getname() {
    switch (this) {
      case Meals.breakfast:
        return 'Colazione';
      case Meals.amSnack:
        return 'Spuntino mattutino';
      case Meals.lunch:
        return 'Pranzo';
      case Meals.pmSnack:
        return 'Spuntino pomeridiano';
      case Meals.dinner:
        return 'Cena';
      default:
        return '';
    }
  }
}