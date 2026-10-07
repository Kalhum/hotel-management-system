// To parse this JSON data, do
//
//     final historyModel = historyModelFromJson(jsonString);

import 'dart:convert';

HistoryModel historyModelFromJson(String str) => HistoryModel.fromJson(json.decode(str));

String historyModelToJson(HistoryModel data) => json.encode(data.toJson());

class HistoryModel {
    String? bookingId;
    String? roomNumber;
    DateTime? checkInDate;
    DateTime? checkOutDate;
    String? totalAmount;
    Review? review;

    HistoryModel({
        this.bookingId,
        this.roomNumber,
        this.checkInDate,
        this.checkOutDate,
        this.totalAmount,
        this.review,
    });

    factory HistoryModel.fromJson(Map<String, dynamic> json) => HistoryModel(
        bookingId: json["bookingId"],
        roomNumber: json["roomNumber"],
        checkInDate: json["checkInDate"] == null ? null : DateTime.parse(json["checkInDate"]),
        checkOutDate: json["checkOutDate"] == null ? null : DateTime.parse(json["checkOutDate"]),
        totalAmount: json["totalAmount"],
        review: json["review"] == null ? null : Review.fromJson(json["review"]),
    );

    Map<String, dynamic> toJson() => {
        "bookingId": bookingId,
        "roomNumber": roomNumber,
        "checkInDate": checkInDate == null ? null : "${checkInDate!.year.toString().padLeft(4, '0')}-${checkInDate!.month.toString().padLeft(2, '0')}-${checkInDate!.day.toString().padLeft(2, '0')}",
        "checkOutDate": checkOutDate == null ? null : "${checkOutDate!.year.toString().padLeft(4, '0')}-${checkOutDate!.month.toString().padLeft(2, '0')}-${checkOutDate!.day.toString().padLeft(2, '0')}",
        "totalAmount": totalAmount,
        "review": review?.toJson(),
    };
}

class Review {
    int? rating;
    String? comment;
    DateTime? reviewedAt;

    Review({
        this.rating,
        this.comment,
        this.reviewedAt,
    });

    factory Review.fromJson(Map<String, dynamic> json) => Review(
        rating: json["rating"],
        comment: json["comment"],
        reviewedAt: json["reviewedAt"] == null ? null : DateTime.parse(json["reviewedAt"]),
    );

    Map<String, dynamic> toJson() => {
        "rating": rating,
        "comment": comment,
        "reviewedAt": reviewedAt?.toIso8601String(),
    };
}
