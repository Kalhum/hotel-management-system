import 'package:flutter/material.dart';
import 'package:hotel_management_system/data/data_source/remote_data_source/announcement_remote.dart';
import 'package:hotel_management_system/data/data_source/remote_data_source/furniture_remote.dart';
import 'package:hotel_management_system/data/data_source/remote_data_source/home_remote.dart';
import 'package:hotel_management_system/data/data_source/remote_data_source/houseKeeper_remote.dart';
import 'package:hotel_management_system/data/data_source/remote_data_source/list_remote.dart';
import 'package:hotel_management_system/data/data_source/remote_data_source/promotion_remote.dart';
import 'package:hotel_management_system/data/data_source/remote_data_source/register_remote.dart';
import 'package:hotel_management_system/data/repositorise/furniture_repositorise.dart';
import 'package:hotel_management_system/data/repositorise/announcement_repositorise.dart';
import 'package:hotel_management_system/data/repositorise/home_repositorise.dart';
import 'package:hotel_management_system/data/repositorise/houseKeeper_repositorise.dart';
import 'package:hotel_management_system/data/repositorise/list_repositorise.dart';
import 'package:hotel_management_system/data/repositorise/promotion_repositorise.dart';
import 'package:hotel_management_system/data/repositorise/register_repositorise.dart';
import 'package:hotel_management_system/domain/use_case/furniture_usecase.dart';
import 'package:hotel_management_system/domain/use_case/announcement_usecase.dart';
import 'package:hotel_management_system/domain/use_case/extra_bed_usecase.dart';
import 'package:hotel_management_system/domain/use_case/history_usecase.dart';
import 'package:hotel_management_system/domain/use_case/home_usecase.dart';
import 'package:hotel_management_system/domain/use_case/list_usecase.dart';
import 'package:hotel_management_system/domain/use_case/promotion_usecase.dart';
import 'package:hotel_management_system/presentation/page/HousekeeperRoomCheckPage/provider/HousekeeperRoomCheck_Screen_provider.dart';
import 'package:hotel_management_system/presentation/page/HousekeeperRoomCheckPage/screen/HousekeeperRoomCheck_Screen.dart';
import 'package:hotel_management_system/presentation/page/RoomConditionCheckPage/provider/room_condition_check_screen_provider.dart';
import 'package:hotel_management_system/presentation/page/RoomConditionCheckPage/screen/room_condition_check_screen.dart';
import 'package:hotel_management_system/presentation/page/historyPage/provider/histoty_screen_provider.dart';
import 'package:hotel_management_system/presentation/page/homePage/provider/home_screen_provider.dart';
import 'package:hotel_management_system/presentation/page/listPage/provider/list_screen_provider.dart';
import 'package:hotel_management_system/presentation/page/listPage/screen/list_screen.dart';
import 'package:hotel_management_system/presentation/page/page_route.dart';
import 'package:hotel_management_system/presentation/page/promotionDetailPage/provider/promotionDetail_provider.dart';
import 'package:hotel_management_system/presentation/page/promotionDetailPage/screen/promotion_detail_screen.dart';
import 'package:hotel_management_system/presentation/page/announcementDetailPage/screen/announcement_detail_screen.dart';
import 'package:hotel_management_system/presentation/page/promotionPage/provider/promotion_provider.dart';
import 'package:hotel_management_system/presentation/page/promotionPage/provider/announcement_provider.dart';
import 'package:hotel_management_system/presentation/page/promotionPage/screen/promotion_screen.dart';
import 'package:hotel_management_system/presentation/page/registerPage/provider/register_screen_provider.dart';
import 'package:hotel_management_system/presentation/page/registerPage/screen/register_screen.dart';
import 'package:hotel_management_system/presentation/page/roomDetailPage/provider/room_detail_screen_provider.dart';
import 'package:hotel_management_system/presentation/page/CartPage/screen/cart_screen.dart';

import 'package:hotel_management_system/util/provider/user_provider.dart';
import 'package:provider/provider.dart';

import '../../data/data_source/remote_data_source/booking_form_remote.dart';
import '../../data/data_source/remote_data_source/check_in_remote.dart';
import '../../data/data_source/remote_data_source/extra_bed_remote.dart';
import '../../data/data_source/remote_data_source/history_remote.dart';
import '../../data/data_source/remote_data_source/login_remote.dart';
import '../../data/data_source/remote_data_source/user_profile_remote.dart';
import '../../data/repositorise/booking_form_repositorise.dart';
import '../../data/data_source/remote_data_source/payment_remote.dart';
import '../../data/repositorise/payment_repositorise.dart';
import '../../domain/use_case/payment_usecase.dart';
import '../../data/repositorise/check_in_repositorise.dart';
import '../../data/repositorise/extra_bed_repositorise.dart';
import '../../data/repositorise/history_repository.dart';
import '../../data/repositorise/login_repositorise.dart';
import '../../data/repositorise/user_profile_respositorise.dart';
import '../../domain/use_case/booking_form_usecase.dart';
import '../../domain/use_case/check_in_usecase.dart';
import '../../domain/use_case/houseKeeper_usecase.dart';
import '../../domain/use_case/login_usecase.dart';
import '../../domain/use_case/register_usecase.dart';
import '../../domain/use_case/user_profile_usecase.dart';

import '../../presentation/page/historyPage/screen/history_screen.dart';
import '../../presentation/page/homePage/screen/home_screen.dart';
import '../../presentation/page/roomDetailPage/screen/room_detail_screen.dart';

// import dio client เข้ามาเพื่อ แนบ token ไปทุก req
import '../../presentation/page/userProfileScreen/provider/user_profile_provider.dart';
import '../../presentation/page/userProfileScreen/screen/user_profile_screen.dart';
import '../widget/core/network/dio_client.dart';

RouteFactory onGenerateRoute = (settings) {
  switch (settings.name) {
    case "/login":
      return MaterialPageRoute(
          builder: (context) => ChangeNotifierProvider(
                create: (_) => LoginScreenProvider(
                  context.read<UserProvider>(),
                  LoginUseCase(
                    LoginRepositoryImpl(
                      LoginRemoteDataSourceImpl(DioClient.dio),
                    ),
                  ),
                ),
                child: const LoginScreen(),
              ),
          settings: settings);
    case "/register":
      return MaterialPageRoute(
          builder: (context) => ChangeNotifierProvider(
                create: (_) => RegisterScreenProvider(
                    usecase: RegisterUsecase(
                        repositorise: RegisterRepositoriseImpl(
                            remoteDataSource: RegisterRemoteDataSourceImpl(
                                dio: DioClient.dio)))),
                child: const RegisterScreen(),
              ),
          settings: settings);
    case "/home":
      return MaterialPageRoute(
          builder: (context) => ChangeNotifierProvider(
                create: (_) => HomeScreenProvider(HomeUsecase(
                    HomeRepositoryImpl(
                        HomeRemoteDataSourceImpl(DioClient.dio)))),
                child: const HomeScreen(),
              ),
          settings: settings);

    case '/room_detail':
      return MaterialPageRoute(
        builder: (context) => ChangeNotifierProvider(
          create: (_) => RoomDetailScreenProvider(
            HomeUsecase(
              HomeRepositoryImpl(
                HomeRemoteDataSourceImpl(DioClient.dio),
              ),
            ),
            ExtraBedUsecase(
              ExtraBedRepositoryImpl(
                ExtraBedRemoteDataSourceImpl(DioClient.dio),
              ),
            ),
          ),
          child: const RoomDetailScreen(),
        ),
        settings: settings,
      );
    case "/booking_form":
      return MaterialPageRoute(
          builder: (context) => ChangeNotifierProvider(
                create: (_) => BookingFormScreenProvider(
                    BookingFormUsecase(BookingFormRepositoriseImpl(
                        BookingFormRemoteDataSourceImpl(DioClient.dio),
                        HomeRemoteDataSourceImpl(DioClient.dio))),
                    PaymentUsecase(PaymentRepositoriseImpl(
                        PaymentRemoteDataSourceImpl(DioClient.dio)))),
                child: const BookingFormScreen(),
              ),
          // รายการห้องพักอ่านจาก CartProvider (global) ไม่ต้องส่ง arguments
          settings: settings);
    case "/cart":
      return MaterialPageRoute(
          builder: (context) => const CartScreen(), settings: settings);
    case "/room_condition_check":
      return MaterialPageRoute(
          builder: (context) => ChangeNotifierProvider(
                create: (_) => RoomConditionCheckScreenProvider(
                    FurnitureUsecase(FurnitureRepositoriseImpl(
                        furnitureRemoteDataSourceImpl()))),
                child: RoomConditionCheckScreen(),
              ),
          settings: settings);
    case "/history":
      return MaterialPageRoute(
          builder: (context) => ChangeNotifierProvider(
                create: (_) => HistoryScreenProvider(BookingHistoryUseCase(
                    repository: BookingHistoryRepositoryImpl(
                        remoteDataSource: BookingHistoryRemoteDataSourceImpl(
                            DioClient.dio)))),
                child: const HistoryScreen(),
              ),
          settings: settings);
    case "/housekeeper":
      return MaterialPageRoute(
          builder: (context) => ChangeNotifierProvider(
                create: (_) => HousekeeperRoomCheckScreenProvider(
                    HousekeeperRoomUseCase(
                        repository: HousekeeperRoomRepositoryImpl(
                            remoteDataSource:
                                HousekeeperRoomRemoteDataSourceImpl()))),
                child: const HousekeeperRoomCheckScreen(),
              ),
          settings: settings);
    case "/list_page":
      return MaterialPageRoute(
          builder: (context) => ChangeNotifierProvider(
                create: (_) => ListScreenProvider(
                  ListUsecase(ListRepositoriseImpl(
                      ListRemoteDatasourceImpl(DioClient.dio))),
                  CheckInUsecase(CheckInRepositoriseImpl(
                      CheckInRemoteDataSourceImpl(DioClient.dio))),
                  BookingHistoryUseCase(
                      repository: BookingHistoryRepositoryImpl(
                          remoteDataSource: BookingHistoryRemoteDataSourceImpl(
                              DioClient.dio))),
                ),
                child: const ListScreen(),
              ),
          settings: settings);
    case "/promotion_page":
      return MaterialPageRoute(
          builder: (context) => MultiProvider(
                providers: [
                  ChangeNotifierProvider(
                    create: (_) => PromotionProvider(
                      PromotionUsecase(
                        PromotionRepositoriseImpl(
                          PromotionRemoteDataSourceImpl(DioClient.dio),
                        ),
                      ),
                    ),
                  ),
                  ChangeNotifierProvider(
                    create: (_) => AnnouncementProvider(
                      AnnouncementUseCase(
                        AnnouncementRepositoriseImpl(
                          AnnouncementRemoteDataSourceImpl(DioClient.dio),
                        ),
                      ),
                    ),
                  ),
                ],
                child: const PromotionScreen(),
              ),
          settings: settings);
    case "/promotion_detail_page":
      return MaterialPageRoute(
          builder: (context) => ChangeNotifierProvider(
                create: (_) => PromotiondetailProvide(PromotionUsecase(
                    PromotionRepositoriseImpl(
                        PromotionRemoteDataSourceImpl(DioClient.dio)))),
                child: PromotionDetailScreen(),
              ),
          settings: settings);
    case "/announcement_detail_page":
      return MaterialPageRoute(
        builder: (context) => const AnnouncementDetailScreen(),
        settings: settings,
      );
    case "/profile":
      return MaterialPageRoute(
          builder: (context) => ChangeNotifierProvider(
                create: (_) => ProfileScreenProvider(
                  UserProfileUseCase(
                    repository: UserProfileRepositoryImpl(
                      remoteDataSource: UserProfileRemoteDataSourceImpl(),
                    ),
                  ),
                ),
                child: const ProfileScreen(),
              ),
          settings: settings);
    default:
      return null;
  }
};
