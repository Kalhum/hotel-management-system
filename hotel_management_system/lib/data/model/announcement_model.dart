import '../../domain/entitise/announcement_entitise.dart';
import '../../util/function/image_url.dart';

class AnnouncementModel {
  final int id;
  final String title;
  final String content;
  final String imageUrl;
  final int displayOrder;
  final bool isActive;

  const AnnouncementModel({
    required this.id,
    required this.title,
    required this.content,
    required this.imageUrl,
    required this.displayOrder,
    required this.isActive,
  });

  factory AnnouncementModel.fromJson(Map<String, dynamic> json) {
    final activeValue = json['isActive'] ?? json['is_active'];
    return AnnouncementModel(
      id: int.tryParse('${json['id']}') ?? 0,
      title: '${json['title'] ?? ''}',
      content:
          '${json['content'] ?? json['body'] ?? json['description'] ?? ''}',
      imageUrl: ImageUrlHelper.toFullImageUrl(
            (json['imageUrl'] ?? json['image_url'])?.toString(),
          ) ??
          '',
      displayOrder: int.tryParse(
              '${json['displayOrder'] ?? json['display_order'] ?? 0}') ??
          0,
      isActive: activeValue == true || activeValue == 1 || activeValue == '1',
    );
  }

  AnnouncementEntitise toEntity() => AnnouncementEntitise(
        id: id,
        title: title,
        content: content,
        imageUrl: imageUrl,
        displayOrder: displayOrder,
        isActive: isActive,
      );
}
