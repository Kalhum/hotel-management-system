import 'package:flutter/material.dart';

import '../widget/core/network/dio_client.dart';

class ImageUrlHelper {
  static String get _apiRoot {
    final baseUrl = DioClient.dio.options.baseUrl;

    if (baseUrl.endsWith('/api/')) {
      return baseUrl.substring(0, baseUrl.length - 5);
    }

    if (baseUrl.endsWith('/')) {
      return baseUrl.substring(0, baseUrl.length - 1);
    }

    return baseUrl;
  }

  static String? toFullImageUrl(String? path) {
    if (path == null || path.isEmpty) return null;

    // ถ้าเป็น URL เต็มอยู่แล้ว
    if (path.startsWith('http://') || path.startsWith('https://')) {
      return path;
    }

    String cleanPath = path;

    // รองรับ:
    // uploads/furniture/photo.jpg
    // furniture/photo.jpg
    if (cleanPath.startsWith('uploads/')) {
      cleanPath = cleanPath.substring('uploads/'.length);
    }

    final url = "$_apiRoot/api/uploads/$cleanPath";

    debugPrint("Image URL: $url");

    return url;
  }

  static List<String> toFullImageUrlList(List<String>? paths) {
    if (paths == null || paths.isEmpty) return [];

    return paths.map((p) => toFullImageUrl(p)).whereType<String>().toList();
  }
}


// import '../widget/core/network/dio_client.dart';

// class ImageUrlHelper {
//   static String get _apiRoot {
//     final baseUrl =
//         DioClient.dio.options.baseUrl; // "http://localhost:2000/api/"
//     if (baseUrl.endsWith('/api/')) {
//       return baseUrl.substring(0, baseUrl.length - 5);
//     }
//     if (baseUrl.endsWith('/')) {
//       return baseUrl.substring(0, baseUrl.length - 1);
//     }
//     return baseUrl;
//   }

//   static String? toFullImageUrl(String? path) {
//     if (path == null || path.isEmpty) return null;
//     if (path.startsWith('http')) return path;
//     return "$_apiRoot/api/uploads/$path";
//   }

//   static List<String> toFullImageUrlList(List<String>? paths) {
//     if (paths == null || paths.isEmpty) return [];
//     return paths.map((p) => toFullImageUrl(p)).whereType<String>().toList();
//   }
// }
