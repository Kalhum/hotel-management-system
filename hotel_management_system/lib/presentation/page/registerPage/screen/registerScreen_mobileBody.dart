// register_screen.dart
import 'package:flutter/material.dart';
import 'package:hotel_management_system/util/widget/core/form_enum.dart';
import 'package:provider/provider.dart';

import '../../../../util/widget/components/button/button.dart';
import '../../../../util/widget/core/constants.dart';
import '../provider/register_screen_provider.dart';

class RegisterScreenMobileBody extends StatelessWidget {
  const RegisterScreenMobileBody({super.key});

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
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
                const Text('สมัครสมาชิกสำเร็จ',
                    style: TextStyle(
                        fontSize: Constants.fontSizeTitle,
                        fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text('กลับไปหน้าเข้าสู่ระบบครับ',
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
                      Navigator.of(context).pop();
                      Navigator.of(context).pushReplacementNamed("/login");
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
      backgroundColor: const Color(0xFFF7F5F6),
      body: SafeArea(
        child: Column(
          children: [
            // --- Nav Bar ---
            Container(
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
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: screenWidth * 0.2,
                      alignment: Alignment.center,
                      height: 50,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(
                            Radius.circular(Constants.borderRadius)),
                        color: Constants.secondaryColor,
                      ),
                      child: const Text('กลับ',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: Constants.fontSizeLabel)),
                    ),
                  ),
                ],
              ),
            ),

            // --- Content Body ---
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 28, 20, 32),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 480),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(22),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFFE9E4E7)),
                        boxShadow: [
                          BoxShadow(
                            color: Constants.primaryColor.withOpacity(0.06),
                            blurRadius: 24,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Center(
                            child: Image.asset(
                              'assets/images/HotelLogo.jpg',
                              height: 58,
                              fit: BoxFit.contain,
                            ),
                          ),
                          const SizedBox(height: 18),
                          const Text(
                            'สมัครสมาชิก',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xFF29242A),
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            'กรอกข้อมูลเพื่อสร้างบัญชีผู้เข้าพัก',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xFF777078),
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 18),
                          Consumer<RegisterScreenProvider>(
                            builder: (context, provider, _) {
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                provider.handleRegisterResult(
                                  context,
                                  () => _showSuccessDialog(context),
                                );
                              });

                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  createInputField(InputFieldType.username,
                                      controller: provider.usernameController),
                                  createInputField(InputFieldType.email,
                                      controller: provider.emailController),
                                  createInputField(InputFieldType.phoneNumber,
                                      controller:
                                          provider.phoneNumberController),
                                  createInputField(InputFieldType.address,
                                      controller: provider.addressController),
                                  createInputField(
                                    InputFieldType.password,
                                    controller: provider.passwordController,
                                    obscureText: provider.obscurePassword,
                                    onTogglePasswordVisibility:
                                        provider.togglePasswordVisibility,
                                  ),
                                  createInputField(
                                    InputFieldType.confirmPassword,
                                    controller:
                                        provider.confirmPasswordController,
                                    obscureText:
                                        provider.obscureConfirmPassword,
                                    onTogglePasswordVisibility: provider
                                        .toggleConfirmPasswordVisibility,
                                  ),
                                  const SizedBox(height: 20),
                                  provider.isLoading
                                      ? const SizedBox(
                                          height: 48,
                                          child: Center(
                                            child: CircularProgressIndicator(),
                                          ),
                                        )
                                      : Button(
                                          text: 'สมัครสมาชิก',
                                          onTap: () => provider.register(),
                                          color: Constants.primaryColor,
                                          btnSize: double.infinity,
                                          btnHigh: 52,
                                        ),
                                ],
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
