import '../../domain/entitise/cart_item_entitise.dart';

class RoomDetailArguments {
  final String roomId;
  final String roomType;
  final DateTime? checkIn;
  final DateTime? checkOut;

  RoomDetailArguments({
    required this.roomId,
    required this.roomType,
    this.checkIn,
    this.checkOut,
  });
}

class RoomConditionCheckArguments {
  final String roomId;
  final String bookingId;

  RoomConditionCheckArguments({
    required this.roomId,
    required this.bookingId,
  });
}

class HomeFilterArgs {
  final DateTime checkIn;
  final DateTime checkOut;

  const HomeFilterArgs({
    required this.checkIn,
    required this.checkOut,
  });
}

class LoginPageArguments {
  final String redirectRoute;
  final Object? redirectArguments;
  final CartItemEntitise? cartItemToAdd;

  LoginPageArguments({
    required this.redirectRoute,
    this.redirectArguments,
    this.cartItemToAdd,
  });
}


// class ListScreenArguments {
//   final bool? checkInStatus;
//   final bool? ckeckOutStatus;
//   final bool? statusConCheck;

//   ListScreenArguments({
//     this.checkInStatus,
//     this.ckeckOutStatus,
//     this.statusConCheck,
//   });
// }
