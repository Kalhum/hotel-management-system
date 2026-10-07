import 'package:flutter/material.dart';

import '../../../../util/widget/components/button/button.dart';
// import '../../../../util/widget/components/button/heart_button.dart';
import '../../../../util/widget/core/constants.dart';

class BoxshowPromotionCard extends StatelessWidget {
  const BoxshowPromotionCard({
    super.key,
    required this.title,
    required this.description,
    required this.bedsInfo,
    required this.price,
    this.badgeText = "Guest favorite",
    this.rating,
    this.reviewCount,
    this.imageUrl,
    this.isFavorite = false,
    this.priceSuffix = "ยอดรวมก่อนหักภาษี",
    this.onTap,
    this.onFavoriteChanged,
    this.onClaim,
    this.claimLabel = "รับคูปอง",
    this.badgeColor = Colors.white,
    this.cardHeight = 200,
    this.textColor,
  });

  final String title;
  final String description;
  final String bedsInfo;
  final String price;
  final String badgeText;
  final double? rating;
  final int? reviewCount;
  final String? imageUrl;
  final bool isFavorite;
  final String priceSuffix;
  final VoidCallback? onTap;
  final ValueChanged<bool>? onFavoriteChanged;
  final VoidCallback? onClaim;
  final String claimLabel;
  final Color? badgeColor, textColor;
  final double cardHeight;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            height: cardHeight,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(Constants.borderRadius),
              ),
              image: imageUrl != null
                  ? DecorationImage(
                      image: NetworkImage(imageUrl!),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: Padding(
              padding: const EdgeInsets.all(Constants.padding),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (badgeText.isNotEmpty)
                    Button(
                      text: badgeText,
                      onTap: () {},
                      color: badgeColor,
                      btnSize: 150,
                      btnHigh: 50,
                      btnPadding: 10,
                      textColor: textColor ?? Colors.white,
                    )
                  else
                    const SizedBox.shrink(),
                  // HeartButton(
                  //   initialValue: isFavorite,
                  //   size: 24,
                  //   inactiveColor: Colors.white,
                  //   // onChanged: onFavoriteChanged,
                  // ),
                ],
              ),
            ),
          ),

          // ===============================
          // Promotion Detail
          // ===============================
          Padding(
            padding: const EdgeInsets.only(
              top: 10,
              left: 4,
              right: 4,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ชื่อ + Rating
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    // if (rating != null)
                    //   Row(
                    //     children: [
                    //       const Icon(
                    //         Icons.star,
                    //         size: 16,
                    //       ),
                    //       const SizedBox(width: 4),
                    //       Text(
                    //         rating!.toStringAsFixed(2),
                    //         style: const TextStyle(
                    //           fontSize: 14,
                    //           fontWeight: FontWeight.w500,
                    //         ),
                    //       ),
                    //       if (reviewCount != null)
                    //         Text(
                    //           " ($reviewCount)",
                    //           style: const TextStyle(
                    //             fontSize: 14,
                    //             color: Colors.grey,
                    //           ),
                    //         ),
                    //     ],
                    //   ),
                  ],
                ),

                const SizedBox(height: 4),

                // รายละเอียด
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: 3),

                // จำนวนเตียง
                Text(
                  bedsInfo,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),

                const SizedBox(height: 8),

                // ราคา
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: price,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                      TextSpan(
                        text: " $priceSuffix",
                        style: const TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                if (onClaim != null) ...[
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: Button(
                      text: claimLabel,
                      onTap: onClaim!,
                      color: Constants.secondaryColor,
                      btnPadding: 10,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
