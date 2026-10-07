class AnnouncementEntitise {
  final int id;
  final String title;
  final String content;
  final String imageUrl;
  final int displayOrder;
  final bool isActive;

  const AnnouncementEntitise({
    required this.id,
    required this.title,
    required this.content,
    required this.imageUrl,
    required this.displayOrder,
    required this.isActive,
  });
}
