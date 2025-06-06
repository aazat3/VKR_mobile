import 'package:flutter_application_1/Models/CategoryModel/CategoryModel.dart';

class ProductModel {
  final int id;
  final int categoryID;
  final String name;
  final int sourceTypeId;
  final int? addedByUserId;
  final double? energyKcal;
  final double? waterPercent;
  final double? proteinPercent;
  final double? fatPercent;
  final double? carbohydratesPercent;
  final double? saturatedFaPercent;
  final double? cholesterolMg;
  final double? monodisaccharidesPercent;
  final double? starchPercent;
  final double? fiberPercent;
  final double? organicAcidsPercent;
  final double? ashPercent;
  final double? sodiumMg;
  final double? potassiumMg;
  final double? calciumMg;
  final double? magnesiumMg;
  final double? phosphorusMg;
  final double? ironMg;
  final double? retinolUg;
  final double? betaCaroteneUg;
  final double? retinolEqUg;
  final double? tocopherolEqMg;
  final double? thiamineMg;
  final double? riboflavinMg;
  final double? niacinMg;
  final double? niacinEqMg;
  final double? ascorbicAcidMg;
  final double? polyunsaturatedFaPercent;
  final double? ethanolPercent;
  final CategoryModel? category;
  // final MealModel? mealModel;

  ProductModel({
    required this.id,
    required this.categoryID,
    required this.name,
    required this.sourceTypeId,
    this.addedByUserId,
    this.energyKcal,
    this.waterPercent,
    this.proteinPercent,
    this.fatPercent,
    this.carbohydratesPercent,
    this.saturatedFaPercent,
    this.cholesterolMg,
    this.monodisaccharidesPercent,
    this.starchPercent,
    this.fiberPercent,
    this.organicAcidsPercent,
    this.ashPercent,
    this.sodiumMg,
    this.potassiumMg,
    this.calciumMg,
    this.magnesiumMg,
    this.phosphorusMg,
    this.ironMg,
    this.retinolUg,
    this.betaCaroteneUg,
    this.retinolEqUg,
    this.tocopherolEqMg,
    this.thiamineMg,
    this.riboflavinMg,
    this.niacinMg,
    this.niacinEqMg,
    this.ascorbicAcidMg,
    this.polyunsaturatedFaPercent,
    this.ethanolPercent,
    this.category,
    // this.mealModel,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    double? parseAndDivide(dynamic value) {
      if (value == null) return null;
      final numValue = (value as num).toDouble();
      return numValue / 100;
    }

    return ProductModel(
      id: json['id'],
      categoryID: json['categoryID'],
      name: json['name'],
      sourceTypeId: json['source_type_id'] ?? 1,
      addedByUserId: json['added_by_user_id'],
      energyKcal: parseAndDivide(json['energy_kcal']),
      waterPercent: parseAndDivide(json['water_percent']),
      proteinPercent: parseAndDivide(json['protein_percent']),
      fatPercent: parseAndDivide(json['fat_percent']),
      carbohydratesPercent: parseAndDivide(json['carbohydrates_percent']),
      saturatedFaPercent: parseAndDivide(json['saturatedfa_percent']),
      cholesterolMg: parseAndDivide(json['cholesterol_mg']),
      monodisaccharidesPercent: parseAndDivide(
        json['monodisaccharides_percen'],
      ),
      starchPercent: parseAndDivide(json['starch_percent']),
      fiberPercent: parseAndDivide(json['fiber_percent']),
      organicAcidsPercent: parseAndDivide(json['organicacids_percent']),
      ashPercent: parseAndDivide(json['ash_percent']),
      sodiumMg: parseAndDivide(json['sodium_mg']),
      potassiumMg: parseAndDivide(json['potassium_mg']),
      calciumMg: parseAndDivide(json['calcium_mg']),
      magnesiumMg: parseAndDivide(json['magnesium_mg']),
      phosphorusMg: parseAndDivide(json['phosphorus_mg']),
      ironMg: parseAndDivide(json['iron_mg']),
      retinolUg: parseAndDivide(json['retinol_ug']),
      betaCaroteneUg: parseAndDivide(json['betacarotene_ug']),
      retinolEqUg: parseAndDivide(json['retinoleq_ug']),
      tocopherolEqMg: parseAndDivide(json['tocopheroleq_mg']),
      thiamineMg: parseAndDivide(json['thiamine_mg']),
      riboflavinMg: parseAndDivide(json['riboflavin_mg']),
      niacinMg: parseAndDivide(json['niacin_mg']),
      niacinEqMg: parseAndDivide(json['niacineq_mg']),
      ascorbicAcidMg: parseAndDivide(json['ascorbicacid_mg']),
      polyunsaturatedFaPercent: parseAndDivide(
        json['polyunsaturatedfa_percent'],
      ),
      ethanolPercent: parseAndDivide(json['ethanol_percent']),
      category:
          json['category'] != null
              ? CategoryModel.fromJson(json['category'])
              : null,
    );
  }

  double? parseAndDivideToJSON(dynamic value) {
    if (value == null) return null;
    final numValue = (value as num).toDouble();
    return numValue * 100;
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'categoryID': categoryID,
    'name': name,
    'source_type_id': sourceTypeId,
    'added_by_user_id': addedByUserId,
    'energy_kcal': parseAndDivideToJSON(energyKcal),
    'water_percent': parseAndDivideToJSON(waterPercent),
    'protein_percent': parseAndDivideToJSON(proteinPercent),
    'fat_percent': parseAndDivideToJSON(fatPercent),
    'carbohydrates_percent': parseAndDivideToJSON(carbohydratesPercent),
    'saturatedfa_percent': parseAndDivideToJSON(saturatedFaPercent),
    'cholesterol_mg': parseAndDivideToJSON(cholesterolMg),
    'monodisaccharides_percen': parseAndDivideToJSON(monodisaccharidesPercent),
    'starch_percent': parseAndDivideToJSON(starchPercent),
    'fiber_percent': parseAndDivideToJSON(fiberPercent),
    'organicacids_percent': parseAndDivideToJSON(organicAcidsPercent),
    'ash_percent': parseAndDivideToJSON(ashPercent),
    'sodium_mg': parseAndDivideToJSON(sodiumMg),
    'potassium_mg': parseAndDivideToJSON(potassiumMg),
    'calcium_mg': parseAndDivideToJSON(calciumMg),
    'magnesium_mg': parseAndDivideToJSON(magnesiumMg),
    'phosphorus_mg': parseAndDivideToJSON(phosphorusMg),
    'iron_mg': parseAndDivideToJSON(ironMg),
    'retinol_ug': parseAndDivideToJSON(retinolUg),
    'betacarotene_ug': parseAndDivideToJSON(betaCaroteneUg),
    'retinoleq_ug': parseAndDivideToJSON(retinolEqUg),
    'tocopheroleq_mg': parseAndDivideToJSON(tocopherolEqMg),
    'thiamine_mg': parseAndDivideToJSON(thiamineMg),
    'riboflavin_mg': parseAndDivideToJSON(riboflavinMg),
    'niacin_mg': parseAndDivideToJSON(niacinMg),
    'niacineq_mg': parseAndDivideToJSON(niacinEqMg),
    'ascorbicacid_mg': parseAndDivideToJSON(ascorbicAcidMg),
    'polyunsaturatedfa_percent': parseAndDivideToJSON(polyunsaturatedFaPercent),
    'ethanol_percent': parseAndDivideToJSON(ethanolPercent),
    'category': category,
  };
}
