// presentation/page/ProfilePage/profile_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../util/provider/user_provider.dart';
import '../../../../util/widget/components/button/button.dart';
import '../../../../util/widget/core/constants.dart';
import '../provider/user_profile_provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isEditing = false;

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProfileScreenProvider>().loadProfile().then((_) {
        _syncControllersFromProfile();
      });
    });
  }

  void _syncControllersFromProfile() {
    final profile = context.read<ProfileScreenProvider>().profile;
    if (profile == null) return;
    _nameController.text = profile.name ?? '';
    _emailController.text = profile.email ?? '';
    _phoneController.text = profile.phone ?? '';
    _addressController.text = profile.address ?? '';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _confirmLogout(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text("ยืนยันออกจากระบบ"),
        content: const Text("คุณต้องการออกจากระบบใช่หรือไม่?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text("ยกเลิก"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child:
                const Text("ออกจากระบบ", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed != true) return;
    if (!context.mounted) return;

    await context.read<UserProvider>().logout();

    if (!context.mounted) return;
    Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
  }

  String _formatDate(String? isoDate) {
    if (isoDate == null || isoDate.isEmpty) return '-';
    try {
      final date = DateTime.parse(isoDate);
      return "${date.day.toString().padLeft(2, '0')}/"
          "${date.month.toString().padLeft(2, '0')}/"
          "${date.year}";
    } catch (e) {
      return isoDate; // ถ้า parse ไม่ออก โชว์ค่าดิบไปเลย ดีกว่า error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.inputFieldFillColor,
      appBar: AppBar(
        title: const Text(
          "โปรไฟล์",
          style: TextStyle(
            fontSize: Constants.fontSizeTitle,
            fontWeight: Constants.fontWeightBold,
          ),
        ),
        backgroundColor: Constants.white,
        foregroundColor: Constants.primaryColor,
        elevation: 0,
        centerTitle: true,
        actions: [
          Consumer<ProfileScreenProvider>(
            builder: (context, provider, _) {
              if (provider.isLoading) return const SizedBox.shrink();
              return IconButton(
                icon: Icon(_isEditing ? Icons.close : Icons.edit_outlined),
                onPressed: () {
                  setState(() {
                    if (_isEditing) {
                      // ยกเลิกแก้ไข → คืนค่าเดิม
                      _syncControllersFromProfile();
                    }
                    _isEditing = !_isEditing;
                  });
                },
              );
            },
          ),
        ],
      ),
      body: Consumer<ProfileScreenProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final profile = provider.profile;
          if (profile == null) {
            return Center(
              child: Text(
                provider.errorMessage.isEmpty
                    ? 'ไม่พบข้อมูลผู้ใช้'
                    : provider.errorMessage,
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ---------------------------------------------
                // Avatar + role badge
                // ---------------------------------------------
                Center(
                  child: Column(
                    children: [
                      Container(
                        width: 90,
                        height: 90,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Constants.primaryColor.withOpacity(0.15),
                        ),
                        child: Icon(
                          Icons.person,
                          size: 50,
                          color: Constants.primaryColor,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        profile.name ?? '-',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Constants.secondaryColor.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          profile.role ?? '-',
                          style: TextStyle(
                            fontSize: 12,
                            color: Constants.secondaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // ---------------------------------------------
                // ข้อมูลติดต่อ (แก้ไขได้)
                // ---------------------------------------------
                _sectionCard(
                  title: "ข้อมูลส่วนตัว",
                  children: [
                    _field(
                      label: "ชื่อ",
                      controller: _nameController,
                      editable: _isEditing,
                      icon: Icons.badge_outlined,
                    ),
                    const SizedBox(height: 12),
                    _field(
                      label: "อีเมล",
                      controller: _emailController,
                      editable: false, // แก้ไม่ได้เสมอ
                      icon: Icons.email_outlined,
                    ),
                    const SizedBox(height: 12),
                    _field(
                      label: "เบอร์โทร",
                      controller: _phoneController,
                      editable: _isEditing,
                      icon: Icons.phone_outlined,
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 12),
                    _field(
                      label: "ที่อยู่",
                      controller: _addressController,
                      editable: _isEditing,
                      icon: Icons.location_on_outlined,
                      maxLines: 2,
                    ),
                  ],
                ),

                if (profile.joinDate != null || profile.status != null) ...[
                  const SizedBox(height: 16),
                  _sectionCard(
                    title: "ข้อมูลระบบ",
                    children: [
                      _readOnlyRow("รหัส", profile.id ?? '-'),
                      if (profile.joinDate != null)
                        _readOnlyRow(
                            "วันที่เริ่มใช้งาน", _formatDate(profile.joinDate)),
                      if (profile.status != null)
                        _readOnlyRow("สถานะ", profile.status!),
                    ],
                  ),
                ],

                if (_isEditing) ...[
                  const SizedBox(height: 24),
                  Button(
                    text:
                        provider.isSaving ? "กำลังบันทึก..." : "บันทึกการแก้ไข",
                    color: Colors.green,
                    onTap: provider.isSaving
                        ? () {}
                        : () async {
                            final success = await provider.saveProfile(
                              name: _nameController.text,
                              phone: _phoneController.text,
                              address: _addressController.text,
                            );

                            if (!mounted) return;

                            if (success) {
                              setState(() => _isEditing = false);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("บันทึกโปรไฟล์สำเร็จ"),
                                  backgroundColor: Colors.green,
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    provider.errorMessage.isEmpty
                                        ? 'ไม่สามารถบันทึกได้'
                                        : provider.errorMessage,
                                  ),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          },
                  ),
                ],

                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.logout, color: Colors.red),
                    label: const Text(
                      "ออกจากระบบ",
                      style: TextStyle(color: Colors.red),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.red),
                      minimumSize: const Size(double.infinity, 44),
                    ),
                    onPressed: () => _confirmLogout(context),
                  ),
                ),

                const SizedBox(height: 30),
                const SizedBox(height: 30),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _sectionCard({
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Constants.white,
        borderRadius: BorderRadius.circular(Constants.borderRadius),
        border: Border.all(color: Constants.inputFieldBorderColor),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: Constants.fontSizeTitle,
              fontWeight: Constants.fontWeightBold,
            ),
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _field({
    required String label,
    required TextEditingController controller,
    required bool editable,
    required IconData icon,
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      enabled: editable,
      maxLines: maxLines,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, size: 20),
        isDense: true,
        filled: true,
        fillColor: editable ? Constants.white : Constants.inputFieldFillColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Constants.inputFieldBorderColor),
        ),
      ),
    );
  }

  Widget _readOnlyRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 13)),
          Text(value,
              style:
                  const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
        ],
      ),
    );
  }
}
