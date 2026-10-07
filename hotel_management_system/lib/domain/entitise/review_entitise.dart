class ReviewEntity {
  int rating;
  String comment;
  DateTime? reviewedAt;

  ReviewEntity({
    this.rating = 0,
    this.comment = '',
    this.reviewedAt,
  });
}