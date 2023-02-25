class Ingredient {
  String name;
  int quantity;
  String? unit;

  Ingredient({required this.name, required this.quantity, this.unit});

  factory Ingredient.fromJson(Map<String, dynamic> json) {
    return Ingredient(
      name: json['name'],
      quantity: json['quantity'],
      unit: json['unit'],
    );
  }

  static Ingredient fromMap(element) {
    return Ingredient(
      name: element['name'],
      quantity: element['quantity'],
      unit: element['unit'],
    );
  }
}
