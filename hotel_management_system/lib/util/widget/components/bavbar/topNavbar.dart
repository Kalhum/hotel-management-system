import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hotel_management_system/util/provider/user_provider.dart';
import 'package:hotel_management_system/util/widget/core/constants.dart';

class Topnavbar extends StatelessWidget {
  final double widthFactor;
  final bool showBackButton;

  const Topnavbar({
    super.key,
    required this.widthFactor,
    this.showBackButton = true,
  });

  @override
  Widget build(BuildContext context) {
    final isLogin = context.read<UserProvider>().isLogin;
    double screenWidth = MediaQuery.of(context).size.width;
    return Container(
      padding: const EdgeInsets.all(Constants.padding),
      decoration: BoxDecoration(
        color: Constants.primaryColor,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(Constants.borderRadius),
          bottomRight: Radius.circular(Constants.borderRadius),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (showBackButton)
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                width: screenWidth * widthFactor,
                alignment: Alignment.center,
                height: 50,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(Constants.borderRadius),
                  ),
                  color: Constants.secondaryColor,
                ),
                child: const Icon(
                  Icons.arrow_back_ios_new,
                  color: Constants.white,
                  size: 30,
                ),
              ),
            )
          else
            SizedBox(width: screenWidth * widthFactor),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(width: 10),
              GestureDetector(
                onTap: () {
                  if (isLogin) {
                    Navigator.pushNamed(context, '/profile');
                  } else {
                    Navigator.pushNamed(context, '/login');
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Constants.white.withOpacity(0.3),
                  ),
                  alignment: Alignment.center,
                  child: const Icon(Icons.person,
                      color: Constants.white, size: 40),
                ),
              ),
              const SizedBox(width: 10),
            ],
          ),
        ],
      ),
    );
  }
}
