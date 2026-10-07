// data/model/extra_bed_type_model.dart
//
// รับได้ทั้งชื่อ key แบบ camelCase (เหมือน HomeModel) และ snake_case (ตามคอลัมน์ในตาราง)
// และรับ price ได้ทั้งแบบตัวเลขและ String (MySQL DECIMAL มักถูกส่งมาเป็น String)
class ExtraBedTypeModel {
  int? id;
  String? name;
  String? description;
  String? price;
  int? maxChildAge;

  ExtraBedTypeModel({
    this.id,
    this.name,
    this.description,
    this.price,
    this.maxChildAge,
  });

  factory ExtraBedTypeModel.fromJson(Map<String, dynamic> json) =>
      ExtraBedTypeModel(
        id: int.tryParse('${json["id"]}'),
        name: json["name"]?.toString(),
        description: json["description"]?.toString(),
        price: json["price"]?.toString(),
        maxChildAge:
            int.tryParse('${json["maxChildAge"] ?? json["max_child_age"]}'),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "price": price,
        "maxChildAge": maxChildAge,
      };
}