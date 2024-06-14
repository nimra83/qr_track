import 'dart:ffi';
import 'dart:math';

class FoodModel {
  String? foodId;
  String? foodName;
  String? details;
  String? expiryDate;
  String? foodQuantity;
  double? locationLat;
  double? locationLng;
  String? locationName;
  String? addedBy;
  String? pickedBy;
  bool? picked;

  FoodModel({
    this.foodId,
    this.foodName,
    this.details,
    this.expiryDate,
    this.foodQuantity,
    this.locationLat,
    this.locationLng,
    this.locationName,
    this.addedBy,
    this.pickedBy,
    this.picked = false,
  });

  FoodModel.fromJson(Map<String, dynamic> json) {
    foodId = json['foodId'];
    foodName = json['foodName'];
    details = json['details'];
    expiryDate = json['expiryDate'];
    foodQuantity = json['foodQuantity'];
    locationLat = json['locationLat'];
    locationLng = json['locationLng'];
    locationName = json['locationName'];
    addedBy = json['addedBy'];
    pickedBy = json['pickedBy'];
    picked = json['picked'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['foodName'] = foodName;
    data['foodId'] = foodId;
    data['details'] = details;
    data['expiryDate'] = expiryDate;
    data['foodQuantity'] = foodQuantity;
    data['locationName'] = locationName;
    data['locationLat'] = locationLat;
    data['locationLng'] = locationLng;
    data['addedBy'] = addedBy;
    data['pickedBy'] = pickedBy;
    data['picked'] = picked;
    return data;
  }
}
