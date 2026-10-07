import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../domain/entitise/cart_item_entitise.dart';
import '../model/model.dart';
import '../provider/cart_provider.dart';
import '../provider/user_provider.dart';

Future<bool> ensureLoggedIn(
  BuildContext context, {
  required String redirectRoute,
  Object? redirectArguments,
  CartItemEntitise? cartItemToAdd,
}) async {
  if (context.read<UserProvider>().isLogin) return true;

  final shouldLogin = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: const Text('กรุณาเข้าสู่ระบบ'),
      content: const Text('กรุณาเข้าสู่ระบบก่อนทำรายการนี้'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(dialogContext, false),
          child: const Text('ยกเลิก'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(dialogContext, true),
          child: const Text('เข้าสู่ระบบ'),
        ),
      ],
    ),
  );

  if (shouldLogin == true && context.mounted) {
    Navigator.pushNamed(
      context,
      '/login',
      arguments: LoginPageArguments(
        redirectRoute: redirectRoute,
        redirectArguments: redirectArguments,
        cartItemToAdd: cartItemToAdd,
      ),
    );
  }
  return false;
}

Future<void> continueAfterLogin(
  BuildContext context, {
  required String defaultRoute,
}) async {
  final routeArguments = ModalRoute.of(context)?.settings.arguments;
  final loginArguments =
      routeArguments is LoginPageArguments ? routeArguments : null;

  if (loginArguments?.cartItemToAdd case final item?) {
    try {
      await context.read<CartProvider>().addItem(item);
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('ไม่สามารถเพิ่มลงตะกร้าได้')),
        );
      }
      return;
    }
  }

  if (!context.mounted) return;
  final redirectRoute = loginArguments?.redirectRoute;
  if (redirectRoute == null) {
    Navigator.pushNamedAndRemoveUntil(
      context,
      defaultRoute,
      (route) => route.isFirst,
    );
    return;
  }

  Navigator.pushReplacementNamed(
    context,
    redirectRoute,
    arguments: loginArguments?.redirectArguments,
  );
}
