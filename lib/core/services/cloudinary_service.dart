import 'dart:io';
import 'package:dio/dio.dart';

class CloudinaryService {
  static const String _cloudName = 'u7mbg3t6';
  static const String _uploadPreset = 'madinaty_profile';

  final Dio _dio;

  CloudinaryService({Dio? dio}) : _dio = dio ?? Dio();

  Future<String> uploadProfileImage(File imageFile) async {
    try {
      final fileName = imageFile.path.split('/').last;

      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          imageFile.path,
          filename: fileName,
        ),
        'upload_preset': _uploadPreset,
        'folder': 'madinaty/profile',
      });

      final response = await _dio.post(
        'https://api.cloudinary.com/v1_1/$_cloudName/image/upload',
        data: formData,
      );

      final data = response.data;

      if (data is Map && data['secure_url'] != null) {
        return data['secure_url'].toString();
      }

      throw Exception('Cloudinary did not return an image URL');
    } on DioException catch (e) {
      throw Exception(
        'Image upload failed: ${e.response?.data ?? e.message}',
      );
    } catch (e) {
      throw Exception('Image upload failed: $e');
    }
  }
}