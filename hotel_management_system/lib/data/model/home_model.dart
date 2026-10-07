// To parse this JSON data, do
//
//     final homeModel = homeModelFromJson(jsonString);
import 'dart:convert';

HomeModel homeModelFromJson(String str) => HomeModel.fromJson(json.decode(str));
String homeModelToJson(HomeModel data) => json.encode(data.toJson());

class HomeModel {
  String? roomId;
  String? roomType;
  String? name;
  String? description;
  String? pricePerNight;
  String? building;
  String? bedType;
  int? capacity;
  List<String>?
      imageUrls; // เปลี่ยนจาก imageUrl (String?) เป็น imageUrls (List<String>?)
  DateTime? createdAt;

  HomeModel({
    this.roomId,
    this.roomType,
    this.name,
    this.description,
    this.pricePerNight,
    this.building,
    this.bedType,
    this.capacity,
    this.imageUrls,
    this.createdAt,
  });

  factory HomeModel.fromJson(Map<String, dynamic> json) => HomeModel(
        roomId: json["roomId"],
        roomType: json["roomType"],
        name: json["name"],
        description: json["description"],
        pricePerNight: json["pricePerNight"]?.toString(),
        building: json["building"]?.toString() ?? '1',
        bedType: json["bedType"]?.toString() ?? 'เตียงเดี่ยว',
        capacity: json["capacity"] != null
            ? int.tryParse(json["capacity"].toString()) ?? 2
            : 2,
        imageUrls: json["imageUrls"] != null
            ? List<String>.from(json["imageUrls"])
            : <String>[],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
      );

  Map<String, dynamic> toJson() => {
        "roomId": roomId,
        "roomType": roomType,
        "name": name,
        "description": description,
        "pricePerNight": pricePerNight,
        "building": building,
        "bedType": bedType,
        "capacity": capacity,
        "imageUrls": imageUrls,
        "createdAt": createdAt?.toIso8601String(),
      };
}
