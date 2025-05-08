import 'package:flutter_application_1/Models/CategoryModel/CategoryModel.dart';

class ProductModel {
  final int id;
  final int categoryID;
  final String name;
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
    double? toDouble(dynamic value) =>
        value != null ? (value as num).toDouble() : null;

    return ProductModel(
      id: json['id'],
      categoryID: json['categoryID'],
      name: json['name'],
      energyKcal: toDouble(json['energy_kcal']),
      waterPercent: toDouble(json['water_percent']),
      proteinPercent: toDouble(json['protein_percent']),
      fatPercent: toDouble(json['fat_percent']),
      carbohydratesPercent: toDouble(json['carbohydrates_percent']),
      saturatedFaPercent: toDouble(json['saturatedfa_percent']),
      cholesterolMg: toDouble(json['cholesterol_mg']),
      monodisaccharidesPercent: toDouble(json['monodisaccharides_percen']),
      starchPercent: toDouble(json['starch_percent']),
      fiberPercent: toDouble(json['fiber_percent']),
      organicAcidsPercent: toDouble(json['organicacids_percent']),
      ashPercent: toDouble(json['ash_percent']),
      sodiumMg: toDouble(json['sodium_mg']),
      potassiumMg: toDouble(json['potassium_mg']),
      calciumMg: toDouble(json['calcium_mg']),
      magnesiumMg: toDouble(json['magnesium_mg']),
      phosphorusMg: toDouble(json['phosphorus_mg']),
      ironMg: toDouble(json['iron_mg']),
      retinolUg: toDouble(json['retinol_ug']),
      betaCaroteneUg: toDouble(json['betacarotene_ug']),
      retinolEqUg: toDouble(json['retinoleq_ug']),
      tocopherolEqMg: toDouble(json['tocopheroleq_mg']),
      thiamineMg: toDouble(json['thiamine_mg']),
      riboflavinMg: toDouble(json['riboflavin_mg']),
      niacinMg: toDouble(json['niacin_mg']),
      niacinEqMg: toDouble(json['niacineq_mg']),
      ascorbicAcidMg: toDouble(json['ascorbicacid_mg']),
      polyunsaturatedFaPercent: toDouble(json['polyunsaturatedfa_percent']),
      ethanolPercent: toDouble(json['ethanol_percent']),
      category: json['category'] != null ? CategoryModel.fromJson(json['category']) : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'categoryID': categoryID,
        'name': name,
        'energy_kcal': energyKcal,
        'water_percent': waterPercent,
        'protein_percent': proteinPercent,
        'fat_percent': fatPercent,
        'carbohydrates_percent': carbohydratesPercent,
        'saturatedfa_percent': saturatedFaPercent,
        'cholesterol_mg': cholesterolMg,
        'monodisaccharides_percen': monodisaccharidesPercent,
        'starch_percent': starchPercent,
        'fiber_percent': fiberPercent,
        'organicacids_percent': organicAcidsPercent,
        'ash_percent': ashPercent,
        'sodium_mg': sodiumMg,
        'potassium_mg': potassiumMg,
        'calcium_mg': calciumMg,
        'magnesium_mg': magnesiumMg,
        'phosphorus_mg': phosphorusMg,
        'iron_mg': ironMg,
        'retinol_ug': retinolUg,
        'betacarotene_ug': betaCaroteneUg,
        'retinoleq_ug': retinolEqUg,
        'tocopheroleq_mg': tocopherolEqMg,
        'thiamine_mg': thiamineMg,
        'riboflavin_mg': riboflavinMg,
        'niacin_mg': niacinMg,
        'niacineq_mg': niacinEqMg,
        'ascorbicacid_mg': ascorbicAcidMg,
        'polyunsaturatedfa_percent': polyunsaturatedFaPercent,
        'ethanol_percent': ethanolPercent,
        'category' : category,

      };
}