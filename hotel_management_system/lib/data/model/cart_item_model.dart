import '../../domain/entitise/cart_item_entitise.dart';
import '../../domain/entitise/extra_bed_entitise.dart';
import '../../util/function/image_url.dart';
import '../../presentation/page/homePage/companents/typeRoom_enum.dart';

class CartItemModel {
  final int id;
  final String roomId;
  final RoomType roomType;
  final String? imageUrl;
  final DateTime checkIn;
  final DateTime checkOut;
  final int adultCount;
  final int childCount;
  final ExtraBedTypeEntitise? extraBedType;
  final int extraBedQuantity;
  final double pricePerNight;
  final double roomPrice;
  final double extraBedPrice;

  CartItemModel({
    required this.id,
    required this.roomId,
    required this.roomType,
    this.imageUrl,
    required this.checkIn,
    required this.checkOut,
    required this.adultCount,
    required this.childCount,
    this.extraBedType,
    required this.extraBedQuantity,
    required this.pricePerNight,
    required this.roomPrice,
    required this.extraBedPrice,
  });

  factory CartItemModel.fromEntity(CartItemEntitise entity) => CartItemModel(
        id: entity.id,
        roomId: entity.roomId,
        roomType: entity.roomType,
        imageUrl: entity.imageUrl,
        checkIn: entity.checkIn,
        checkOut: entity.checkOut,
        adultCount: entity.adultCount,
        childCount: entity.childCount,
        extraBedType: entity.extraBedType,
        extraBedQuantity: entity.extraBedQuantity,
        pricePerNight: entity.pricePerNight,
        roomPrice: entity.roomPrice,
        extraBedPrice: entity.extraBedPrice,
      );

  Map<String, dynamic> toCartRequestJson() => {
        'roomId': roomId,
        'checkIn': _formatDate(checkIn),
        'checkOut': _formatDate(checkOut),
        'adultCount': adultCount,
        'childCount': childCount,
        'extraBedTypeId': extraBedType?.id,
        'extraBedQuantity': extraBedQuantity,
      };

  String _formatDate(DateTime date) =>
      '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    final roomType = json['room_type']?.toString() == 'house'
        ? RoomType.house
        : RoomType.rooms;
    final pricePerNight =
        double.tryParse('${json['price_per_night'] ?? 0}') ?? 0;
    return CartItemModel(
      id: int.parse('${json['id']}'),
      roomId: '${json['room_id']}',
      roomType: roomType,
      imageUrl: ImageUrlHelper.toFullImageUrl(json['image_url']?.toString()),
      checkIn: DateTime.parse('${json['check_in']}').toLocal(),
      checkOut: DateTime.parse('${json['check_out']}').toLocal(),
      adultCount: int.tryParse('${json['adult_count'] ?? 1}') ?? 1,
      childCount: int.tryParse('${json['child_count'] ?? 0}') ?? 0,
      extraBedType: json['extra_bed_type_id'] == null
          ? null
          : ExtraBedTypeEntitise(
              id: int.parse('${json['extra_bed_type_id']}'),
              name: '${json['extra_bed_name'] ?? ''}',
              description: '${json['extra_bed_description'] ?? ''}',
              price:
                  double.tryParse('${json['extra_bed_unit_price'] ?? 0}') ?? 0,
              maxChildAge:
                  int.tryParse('${json['extra_bed_max_child_age'] ?? 0}') ?? 0,
            ),
      extraBedQuantity: int.tryParse('${json['extra_bed_quantity'] ?? 0}') ?? 0,
      pricePerNight: pricePerNight,
      roomPrice: double.tryParse('${json['room_price'] ?? 0}') ?? 0,
      extraBedPrice: double.tryParse('${json['extra_bed_price'] ?? 0}') ?? 0,
    );
  }

  CartItemEntitise toEntity({int? id}) => CartItemEntitise(
        id: id ?? this.id,
        roomId: roomId,
        roomType: roomType,
        imageUrl: imageUrl,
        checkIn: checkIn,
        checkOut: checkOut,
        adultCount: adultCount,
        childCount: childCount,
        extraBedType: extraBedType,
        extraBedQuantity: extraBedQuantity,
        pricePerNight: pricePerNight,
      );
}
