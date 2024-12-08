// To parse this JSON data, do
//
//     final food = foodFromJson(jsonString);

import 'dart:convert';

List<Food> foodFromJson(String str) =>
    List<Food>.from(json.decode(str).map((x) => Food.fromJson(x)));

String foodToJson(List<Food> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Food {
  Model model;
  String pk;
  Fields fields;

  Food({
    required this.model,
    required this.pk,
    required this.fields,
  });

  factory Food.fromJson(Map<String, dynamic> json) => Food(
        model: modelValues.map[json["model"]]!,
        pk: json["pk"],
        fields: Fields.fromJson(json["fields"]),
      );

  Map<String, dynamic> toJson() => {
        "model": modelValues.reverse[model],
        "pk": pk,
        "fields": fields.toJson(),
      };
}

class Fields {
  String name;
  String price;
  String restaurant;
  String address;
  String contact;
  String openTime;
  String description;
  String image;
  int? user;

  Fields({
    required this.name,
    required this.price,
    required this.restaurant,
    required this.address,
    required this.contact,
    required this.openTime,
    required this.description,
    required this.image,
    required this.user,
  });

  factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        name: json["name"] ?? '',
        price: json["price"] ?? '',
        restaurant: json["restaurant"] ?? '',
        address: json["address"] ?? '',
        contact: json["contact"] ?? '',
        openTime: json["open_time"] ?? '',
        description: json["description"] ?? '',
        image: json["image"] ?? '',
        user: json["user"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "price": price,
        "restaurant": restaurant,
        "address": address,
        "contact": contact,
        "open_time": openTime,
        "description": description,
        "image": image,
        "user": user,
      };
}

enum Model { MAIN_FOOD }

final modelValues = EnumValues({"main.food": Model.MAIN_FOOD});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
