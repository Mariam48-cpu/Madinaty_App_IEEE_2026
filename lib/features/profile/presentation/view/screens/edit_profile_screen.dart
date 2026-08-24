import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../view_model/profile_cubit.dart';

class EditProfileScreen extends StatefulWidget {
  final String uid;
  final String currentName;
  final String currentPhone;
  final String currentEmail;
  final String? currentImageUrl;
  final String? currentBirthDate;

  const EditProfileScreen({
    super.key,
    required this.uid,
    required this.currentName,
    required this.currentPhone,
    required this.currentEmail,
    this.currentImageUrl,
    this.currentBirthDate,
  });

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late TextEditingController _birthDateController;

  File? _selectedImage;
  DateTime? _selectedBirthDate;

  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController(text: widget.currentName);

    _phoneController = TextEditingController(text: widget.currentPhone);

    _emailController = TextEditingController(text: widget.currentEmail);

    String formattedDate = '';

    if (widget.currentBirthDate != null &&
        widget.currentBirthDate!.isNotEmpty) {
      try {
        final parsedDate = DateTime.parse(widget.currentBirthDate!);

        formattedDate =
            "${parsedDate.day} / "
            "${parsedDate.month} / "
            "${parsedDate.year}";

        _selectedBirthDate = parsedDate;
      } catch (_) {
        formattedDate = widget.currentBirthDate!;
      }
    }

    _birthDateController = TextEditingController(text: formattedDate);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _birthDateController.dispose();

    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final picker = ImagePicker();

      final pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
        maxWidth: 1200,
      );

      if (pickedFile == null) return;

      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('حدث خطأ أثناء اختيار الصورة: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedBirthDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Colors.brown,
            colorScheme: const ColorScheme.light(primary: Colors.brown),
            buttonTheme: const ButtonThemeData(
              textTheme: ButtonTextTheme.primary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedBirthDate = picked;

        _birthDateController.text =
            "${picked.day} / "
            "${picked.month} / "
            "${picked.year}";
      });
    }
  }

  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          title: const Text(
            'حذف الحساب',
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: const Text(
            'هل أنت متأكد من حذف الحساب؟\n'
            'لا يمكن التراجع عن هذا الإجراء.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 15),
          ),
          actionsAlignment: MainAxisAlignment.spaceEvenly,
          actions: [
            // NO
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text(
                'لا',
                style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            // YES
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                Navigator.pop(dialogContext);

                context.read<ProfileCubit>().deleteAccount();
              },
              child: const Text(
                'نعم',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF7F2),

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "تعديل الحساب",
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),

      body: BlocConsumer<ProfileCubit, ProfileState>(
        listener: (context, state) {
          if (state is ProfileUpdateSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("تم تحديث البيانات بنجاح"),
                backgroundColor: Colors.green,
              ),
            );

            Navigator.pop(context);
          }

          if (state is ProfileAccountDeleted) {
            Navigator.pushNamedAndRemoveUntil(
              context,
              '/auth',
              (route) => false,
            );
          }

          if (state is ProfileError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },

        builder: (context, state) {
          final bool isUpdating = state is ProfileUpdating;

          final bool isDeleting = state is ProfileDeleting;

          final bool isBusy = isUpdating || isDeleting;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),

            child: Column(
              children: [
                const SizedBox(height: 10),

                Center(
                  child: Column(
                    children: [
                      Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundColor: Colors.brown.shade100,
                            backgroundImage: _selectedImage != null
                                ? FileImage(_selectedImage!)
                                : (widget.currentImageUrl != null &&
                                      widget.currentImageUrl!.isNotEmpty)
                                ? NetworkImage(widget.currentImageUrl!)
                                : const NetworkImage(
                                    'https://cdn-icons-png.flaticon.com/512/149/149071.png',
                                  ),
                          ),

                          InkWell(
                            onTap: isBusy ? null : _pickImage,
                            borderRadius: BorderRadius.circular(30),
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: const BoxDecoration(
                                color: Colors.black87,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.edit,
                                size: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),

                      TextButton(
                        onPressed: isBusy ? null : _pickImage,
                        child: const Text(
                          "تغيير الصورة",
                          style: TextStyle(
                            color: Colors.brown,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // NAME
                      const Text(
                        "الاسم الكامل",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),

                      const SizedBox(height: 8),

                      TextField(
                        controller: _nameController,
                        enabled: !isBusy,
                        textDirection: TextDirection.rtl,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: const Color(0xFFF9F9F9),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // EMAIL
                      const Text(
                        "البريد الإلكتروني",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),

                      const SizedBox(height: 8),

                      TextField(
                        controller: _emailController,
                        enabled: false,
                        textDirection: TextDirection.ltr,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.grey.shade100,
                          prefixIcon: const Icon(
                            Icons.lock,
                            color: Colors.grey,
                            size: 18,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // PHONE
                      const Text(
                        "رقم الهاتف",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),

                      const SizedBox(height: 8),

                      TextField(
                        controller: _phoneController,
                        enabled: !isBusy,
                        keyboardType: TextInputType.phone,
                        textDirection: TextDirection.ltr,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: const Color(0xFFF9F9F9),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // BIRTH DATE
                      const Text(
                        "تاريخ الميلاد",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),

                      const SizedBox(height: 8),

                      TextField(
                        controller: _birthDateController,
                        readOnly: true,
                        onTap: isBusy ? null : () => _selectDate(context),
                        textDirection: TextDirection.ltr,
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                            icon: const Icon(
                              Icons.calendar_today,
                              color: Colors.brown,
                              size: 20,
                            ),
                            onPressed: isBusy
                                ? null
                                : () => _selectDate(context),
                          ),
                          filled: true,
                          fillColor: const Color(0xFFF9F9F9),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.brown.shade800,
                      disabledBackgroundColor: Colors.brown.shade300,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: isBusy
                        ? null
                        : () {
                            final name = _nameController.text.trim();

                            final phone = _phoneController.text.trim();

                            if (name.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("من فضلك أدخل الاسم"),
                                  backgroundColor: Colors.red,
                                ),
                              );
                              return;
                            }

                            context.read<ProfileCubit>().updateProfile(
                              uid: widget.uid,
                              name: name,
                              phone: phone,
                              birthDate: _selectedBirthDate,
                              imageFile: _selectedImage,
                            );
                          },
                    child: isUpdating
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2.5,
                            ),
                          )
                        : const Text(
                            "حفظ التغييرات",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    // CHANGE PASSWORD
                    Expanded(
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          side: BorderSide(color: Colors.brown.shade200),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: isBusy ? null : () {},
                        icon: const Icon(
                          Icons.vpn_key,
                          color: Colors.brown,
                          size: 18,
                        ),
                        label: const Text(
                          "تغيير كلمة المرور",
                          style: TextStyle(color: Colors.brown, fontSize: 13),
                        ),
                      ),
                    ),

                    const SizedBox(width: 12),

                    // DELETE ACCOUNT
                    Expanded(
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          side: const BorderSide(color: Colors.redAccent),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: isBusy ? null : _showDeleteAccountDialog,
                        icon: const Icon(
                          Icons.delete_outline,
                          color: Colors.red,
                          size: 18,
                        ),
                        label: const Text(
                          "حذف الحساب",
                          style: TextStyle(color: Colors.red, fontSize: 13),
                        ),
                      ),
                    ),
                  ],
                ),
                if (isDeleting) ...[
                  const SizedBox(height: 16),

                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.red,
                        ),
                      ),
                      SizedBox(width: 10),
                      Text(
                        "جاري حذف الحساب...",
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],

                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }
}
