import 'package:flutter/material.dart';
import 'package:hotel_management_system/data/data_source/remote_data_source/cart_remote.dart';
import 'package:hotel_management_system/data/repositorise/cart_repositorise.dart';
import 'package:hotel_management_system/domain/use_case/cart_usecase.dart';
import 'package:hotel_management_system/presentation/page/splashPage/screen/splash_screen.dart';
import 'package:hotel_management_system/util/function/generate_routes.dart';
import 'package:hotel_management_system/util/function/app_route_observer.dart';
import 'package:hotel_management_system/util/provider/cart_provider.dart';
import 'package:hotel_management_system/util/provider/user_provider.dart';
import 'package:hotel_management_system/util/widget/core/network/dio_client.dart';
import 'package:provider/provider.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

CartProvider _createCartProvider() => CartProvider(
      CartUseCase(
        CartRepositoryImpl(
          CartRemoteDataSourceImpl(DioClient.dio),
        ),
      ),
    );

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
// ควรใส่แค่ provider กลาง หมายความว่าทุกหน้าสามารถเข้าถึง provider หน้าอื่นได้
// มันควรจะเป็น provider กลางเท่านั้น ที่จะอยู่ main
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProxyProvider<UserProvider, CartProvider>(
          create: (_) => _createCartProvider(),
          update: (_, userProvider, cartProvider) {
            final cart = cartProvider ?? _createCartProvider();
            cart.syncForUser(userProvider.user?.id);
            return cart;
          },
        ),
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          navigatorKey: navigatorKey,
          navigatorObservers: [appRouteObserver],
          home: SplashScreen(),
          theme: ThemeData(
            fontFamily: 'Prompt',
            useMaterial3: true,
          ),
          onGenerateRoute: onGenerateRoute),
    );
  }
}
