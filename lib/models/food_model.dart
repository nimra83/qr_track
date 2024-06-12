import 'dart:ffi';

class FoodModel {
  String? foodName;
  String? details;
  String? expiryDate;
  String? foodQuantity;
  double? locationLat;
  double? locationLng;
  String? locationName;

  FoodModel(
      {this.foodName,
        this.details,
        this.expiryDate,
        this.foodQuantity,
        this.locationLat,
        this.locationLng,
        this.locationName,});

  FoodModel.fromJson(Map<String, dynamic> json) {
    foodName = json['foodName'];
    details = json['details'];
    expiryDate = json['expiryDate'];
    foodQuantity = json['foodQuantity'];
    locationLat = json['locationLat'];
    locationLng = json['locationLng'];
    locationName = json['locationName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['foodName'] = foodName;
    data['details'] = details;
    data['expiryDate'] = expiryDate;
    data['foodQuantity'] = foodQuantity;
    data['locationName'] = locationName;
    data['locationLat'] = locationLat;
    data['locationLng'] = locationLng;
    return data;
  }
}
