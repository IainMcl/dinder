import 'package:cloud_firestore/cloud_firestore.dart';

class DietaryRequirements {
  bool? vegetarian;
  bool? vegan;
  bool? glutenFree;
  bool? dairyFree;
  bool? nutFree;
  bool? shellfishFree;
  bool? eggFree;
  bool? fishFree;
  bool? soyFree;
  bool? porkFree;
  bool? beefFree;
  bool? halal;
  bool? pescatarian;
  bool? kosher;

  DietaryRequirements({
    this.vegetarian,
    this.vegan,
    this.glutenFree,
    this.dairyFree,
    this.nutFree,
    this.shellfishFree,
    this.eggFree,
    this.fishFree,
    this.soyFree,
    this.porkFree,
    this.beefFree,
    this.halal,
    this.pescatarian,
    this.kosher,
  });

  factory DietaryRequirements.fromJson(Map<String, dynamic> json) {
    return DietaryRequirements(
      vegetarian: json['vegetarian'],
      vegan: json['vegan'],
      glutenFree: json['glutenFree'],
      dairyFree: json['dairyFree'],
      nutFree: json['nutFree'],
      shellfishFree: json['shellfishFree'],
      eggFree: json['eggFree'],
      fishFree: json['fishFree'],
      soyFree: json['soyFree'],
      porkFree: json['porkFree'],
      beefFree: json['beefFree'],
      halal: json['halal'],
      pescatarian: json['pescatarian'],
      kosher: json['kosher'],
    );
  }

  factory DietaryRequirements.fromDocument(DocumentSnapshot? doc) {
    if (doc == null) {
      return DietaryRequirements();
    }
    return DietaryRequirements(
      vegetarian: doc.get("vegetarian"),
      vegan: doc.get("vegan"),
      glutenFree: doc.get("glutenFree"),
      dairyFree: doc.get("dairyFree"),
      nutFree: doc.get("nutFree"),
      shellfishFree: doc.get("shellfishFree"),
      eggFree: doc.get("eggFree"),
      fishFree: doc.get("fishFree"),
      soyFree: doc.get("soyFree"),
      porkFree: doc.get("porkFree"),
      beefFree: doc.get("beefFree"),
      halal: doc.get("halal"),
      pescatarian: doc.get("pescatarian"),
      kosher: doc.get("kosher"),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "vegetarian": vegetarian,
      "vegan": vegan,
      "glutenFree": glutenFree,
      "dairyFree": dairyFree,
      "nutFree": nutFree,
      "shellfishFree": shellfishFree,
      "eggFree": eggFree,
      "fishFree": fishFree,
      "soyFree": soyFree,
      "porkFree": porkFree,
      "beefFree": beefFree,
      "halal": halal,
      "pescatarian": pescatarian,
      "kosher": kosher,
    };
  }
}
