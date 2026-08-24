import 'dart:io';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import '../../../auth/data/models/user_model.dart';

abstract class ProfileRemoteDataSource {
  Future<UserModel> getUserProfile(String uid);

  Future<void> updateProfile({
    required String uid,
    required String name,
    required String phone,
    DateTime? birthDate,
    File? imageFile,
  });
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final FirebaseFirestore _firestore;

  ProfileRemoteDataSourceImpl({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  static const String _cloudName = 'u7mbg3t6';
  static const String _uploadPreset = 'madinaty_profile';

  @override
  Future<UserModel> getUserProfile(String uid) async {
    final docSnapshot = await _firestore.collection('users').doc(uid).get();

    if (!docSnapshot.exists || docSnapshot.data() == null) {
      throw Exception("User profile not found");
    }

    return UserModel.fromMap(docSnapshot.data()!, uid);
  }

  @override
  Future<void> updateProfile({
    required String uid,
    required String name,
    required String phone,
    DateTime? birthDate,
    File? imageFile,
  }) async {
    String? imageUrl;

    if (imageFile != null) {
      imageUrl = await _uploadImageToCloudinary(imageFile, uid);
    }
    final Map<String, dynamic> updateData = {'name': name, 'phone': phone};
    if (birthDate != null) {
      updateData['birthDate'] = birthDate.toIso8601String();
    }
    if (imageUrl != null && imageUrl.isNotEmpty) {
      updateData['profileImageUrl'] = imageUrl;
    }

    await _firestore
        .collection('users')
        .doc(uid)
        .set(updateData, SetOptions(merge: true));
  }

  Future<String> _uploadImageToCloudinary(File imageFile, String uid) async {
    final uri = Uri.parse(
      'https://api.cloudinary.com/v1_1/$_cloudName/image/upload',
    );

    final request = http.MultipartRequest('POST', uri);
    request.fields['upload_preset'] = _uploadPreset;
    request.fields['folder'] = 'profile_images';
    request.fields['public_id'] =
        '${uid}_${DateTime.now().millisecondsSinceEpoch}';
    request.files.add(
      await http.MultipartFile.fromPath('file', imageFile.path),
    );

    final streamedResponse = await request.send();

    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode != 200) {
      throw Exception(
        'Cloudinary upload failed: '
        '${response.statusCode} - ${response.body}',
      );
    }

    final responseData = jsonDecode(response.body);

    final secureUrl = responseData['secure_url'];

    if (secureUrl == null || secureUrl.toString().isEmpty) {
      throw Exception('Cloudinary did not return an image URL');
    }

    return secureUrl.toString();
  }
}
