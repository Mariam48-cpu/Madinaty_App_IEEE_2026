import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../view_model/profile_cubit.dart';
import 'edit_profile_screen.dart';

class ProfileScreen extends StatelessWidget {
  final String uid;

  const ProfileScreen({super.key, required this.uid});

  @override
  Widget build(BuildContext context) {
    context.read<ProfileCubit>().fetchUserProfile(uid);

    return Scaffold(
      backgroundColor: const Color(0xFFFAF7F2),
      body: SafeArea(
        child: BlocConsumer<ProfileCubit, ProfileState>(
          listener: (context, state) {
            if (state is ProfileLoggedOut) {
              Navigator.pushReplacementNamed(context, '/auth');
            } else if (state is ProfileError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is ProfileLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            String name = "مستخدم مادينتي";
            String email = "";
            String phone = "";
            String? profileImageUrl;
            String birthDateStr = "";

            const int loyaltyPoints = 1250;

            if (state is ProfileLoaded) {
              name = state.user.name ?? name;
              email = state.user.email ?? email;
              phone = state.user.phone ?? "";
              profileImageUrl = state.user.profileImageUrl;
              birthDateStr = state.user.birthDate?.toString() ?? "";
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.settings_outlined,
                          color: Colors.brown,
                        ),
                        onPressed: () {},
                      ),
                      const Text(
                        "حسابي",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.03),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            CircleAvatar(
                              radius: 45,
                              backgroundColor: Colors.brown.shade100,
                              backgroundImage:
                                  profileImageUrl != null &&
                                      profileImageUrl!.isNotEmpty
                                  ? NetworkImage(profileImageUrl!)
                                  : null,
                              child:
                                  profileImageUrl == null ||
                                      profileImageUrl!.isEmpty
                                  ? const Icon(
                                      Icons.person,
                                      size: 50,
                                      color: Colors.brown,
                                    )
                                  : null,
                            ),

                            // Edit Button
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => BlocProvider.value(
                                      value: context.read<ProfileCubit>(),
                                      child: EditProfileScreen(
                                        uid: uid,
                                        currentName: name,
                                        currentPhone: phone,
                                        currentImageUrl: profileImageUrl,
                                        currentEmail: email,
                                        currentBirthDate: birthDateStr,
                                      ),
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: const BoxDecoration(
                                  color: Colors.black87,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.edit,
                                  size: 14,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 12),

                        Text(
                          name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 4),

                        Text(
                          email,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),

                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16.0),
                          child: Divider(color: Colors.black12),
                        ),

                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _ProfileStatItem(title: "الحجوزات", value: "12"),
                            _VerticalDivider(),
                            _ProfileStatItem(title: "المفضلة", value: "8"),
                            _VerticalDivider(),
                            _ProfileStatItem(title: "الطلبات", value: "45"),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1.4,
                    children: [
                      _buildMenuCard(
                        "حجوزاتي",
                        "إدارة الحجوزات القادمة",
                        Icons.calendar_today_outlined,
                        Colors.orange.shade100,
                        Colors.orange,
                      ),
                      _buildMenuCard(
                        "الأماكن المفضلة",
                        "مقاهيك ومطاعمك المفضلة",
                        Icons.favorite_border,
                        Colors.red.shade50,
                        Colors.red,
                      ),
                      _buildMenuCard(
                        "المنتجات المفضلة",
                        "قائمة مشروباتك المفضلة",
                        Icons.coffee_outlined,
                        Colors.brown.shade50,
                        Colors.brown,
                      ),
                      _buildMenuCard(
                        "نقاط الولاء",
                        "$loyaltyPoints نقطة",
                        Icons.workspace_premium_outlined,
                        Colors.amber.shade50,
                        Colors.amber.shade800,
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  Material(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    clipBehavior: Clip.antiAlias,
                    child: Column(
                      children: [
                        _buildListTile("طرق الدفع", Icons.credit_card_outlined),

                        const Divider(height: 1, indent: 16, endIndent: 16),

                        _buildListTile(
                          "العناوين المحفوظة",
                          Icons.location_on_outlined,
                        ),

                        const Divider(height: 1, indent: 16, endIndent: 16),

                        _buildListTile("المساعدة والدعم", Icons.help_outline),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.red),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        context.read<ProfileCubit>().logout();
                      },
                      icon: const Icon(Icons.logout, color: Colors.red),
                      label: const Text(
                        "تسجيل الخروج",
                        style: TextStyle(color: Colors.red, fontSize: 16),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildMenuCard(
    String title,
    String subtitle,
    IconData icon,
    Color bgColor,
    Color iconColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: bgColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: iconColor, size: 18),
              ),
            ],
          ),

          const SizedBox(height: 6),

          Text(
            subtitle,
            style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildListTile(String title, IconData icon) {
    return ListTile(
      leading: Icon(icon, color: Colors.black87),
      title: Text(
        title,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        size: 14,
        color: Colors.grey,
      ),
      onTap: () {},
    );
  }
}

class _ProfileStatItem extends StatelessWidget {
  final String title;
  final String value;

  const _ProfileStatItem({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          title,
          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
        ),
      ],
    );
  }
}

class _VerticalDivider extends StatelessWidget {
  const _VerticalDivider();

  @override
  Widget build(BuildContext context) {
    return Container(height: 24, width: 1, color: Colors.grey.shade300);
  }
}
