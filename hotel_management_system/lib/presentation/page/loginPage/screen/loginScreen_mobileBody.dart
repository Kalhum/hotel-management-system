// login_screen.dart
import 'package:flutter/material.dart';
import 'package:hotel_management_system/util/widget/components/button/button.dart';
// import 'package:hotel_management_system/util/widget/components/button/buttonAuth.dart';
import 'package:hotel_management_system/util/widget/core/constants.dart';
import 'package:hotel_management_system/util/widget/core/form_enum.dart';

import 'package:hotel_management_system/presentation/page/loginPage/login_page_route.dart';
import 'package:provider/provider.dart';

import '../../../../util/function/login_flow.dart';

class LoginScreenMobileBody extends StatelessWidget {
  const LoginScreenMobileBody({super.key});

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.check_circle_outline,
                    color: Colors.green, size: 64),
                const SizedBox(height: 16),
                const Text('เข้าสู่ระบบสำเร็จ',
                    style: TextStyle(
                        fontSize: Constants.fontSizeTitle,
                        fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text('ยินดีต้อนรับเข้าสู่ระบบครับ',
                    style: TextStyle(
                        fontSize: Constants.fontSizeBody,
                        color: Colors.grey[700]),
                    textAlign: TextAlign.center),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Constants.secondaryColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onPressed: () {
                      Navigator.of(dialogContext).pop();
                      continueAfterLogin(
                        context,
                        defaultRoute: '/promotion_page',
                      );
                    },
                    child: const Text('ตกลง',
                        style: TextStyle(
                            fontSize: Constants.fontSizeBody,
                            color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Constants.bgcolor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(Constants.padding),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/images/HotelLogo.jpg',
                        width: screenWidth * 0.9),
                  ],
                ),
                const SizedBox(height: 20),

                // --- Input Fields ---
                Consumer<LoginScreenProvider>(
                  builder: (context, provider, child) => Column(
                    children: [
                      createInputField(InputFieldType.username,
                          controller: provider.usernameController),
                      const SizedBox(height: 12),
                      createInputField(InputFieldType.password,
                          controller: provider.passwordController,
                          obscureText: provider.obscurePassword,
                          onTogglePasswordVisibility: provider.togglePasswordVisibility),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // --- Login Button ---
                Consumer<LoginScreenProvider>(
                  builder: (context, provider, _) {
                    // เรียก provider ให้จัดการ status เอง ส่ง context และ dialog callback เข้าไป
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      provider.handleLoginResult(
                          context, () => _showSuccessDialog(context));
                    });

                    return provider.isLoading
                        ? const CircularProgressIndicator()
                        : Button(
                            text: "เข้าสู่ระบบ",
                            onTap: () => provider.login(),
                            color: Constants.secondaryColor,
                            btnSize: 300,
                          );
                  },
                ),

                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('ยังไม่มีบัญชีผู้ใช้?',
                        style: TextStyle(
                            fontSize: Constants.fontSizeLabel,
                            color: Colors.grey[700])),
                    GestureDetector(
                      onTap: () => Navigator.pushNamed(context, "/register"),
                      child: const Text(' สมัครสมาชิก',
                          style: TextStyle(
                              fontSize: Constants.fontSizeLabel,
                              color: Colors.blue,
                              fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),

                const SizedBox(height: 20),
                // Text('หรือเข้าสู่ระบบด้วย',
                //     style: TextStyle(
                //         fontSize: Constants.fontSizeLabel,
                //         color: Colors.grey[600]),
                //     textAlign: TextAlign.center),
                // const SizedBox(height: 20),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     ButtonAuth(
                //         onTap: () => context
                //             .read<LoginScreenProvider>()
                //             .loginWithGoogle(),
                //         ImagePath: "assets/images/authLogo/Google_Logo.png"),
                //     const SizedBox(width: 20),
                //     ButtonAuth(
                //         onTap: () => context
                //             .read<LoginScreenProvider>()
                //             .loginWithFacebook(),
                //         ImagePath: "assets/images/authLogo/FacebookLogo.png"),
                //   ],
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
