import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:madinaty_app_ieee_2026/features/booking/data/models/booking_model.dart';
import 'package:madinaty_app_ieee_2026/features/booking/domain/entities/booking_entity.dart';
import 'package:madinaty_app_ieee_2026/features/checkout/data/data_sources/payment_data_source_interface.dart';

class PaymentRemoteDataSourceImpl implements PaymentDataSourceInterface {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  final http.Client _client;

  // IMPORTANT:
  // Put your existing Paymob API key here.
  static const String _apiKey =
      "ZXlKaGJHY2lPaUpJVXpVeE1pSXNJblI1Y0NJNklrcFhWQ0o5LmV5SmpiR0Z6Y3lJNklrMWxjbU5vWVc1MElpd2ljSEp2Wm1sc1pWOXdheUk2TVRJeE5qTTFOQ3dpYm1GdFpTSTZJakUzT0RjeE9EY3pPVGt1NnpJbHEza2pkRHo1eTZEZGV6bTFBemFLUkpXQ0E=";

  static const int _integrationId = 5859277;
  static const int _walletIntegrationId = 5863433;
  static const int _iframeId = 1070206;

  PaymentRemoteDataSourceImpl({
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
    http.Client? client,
  }) : _firestore = firestore ?? FirebaseFirestore.instance,
       _auth = auth ?? FirebaseAuth.instance,
       _client = client ?? http.Client();

  @override
  Future<String> getPaymobWalletUrl({
    required double amount,
    required String userEmail,
    required String userPhone,
    required String userName,
    required String walletNumber,
  }) async {
    try {
      final headers = {'Content-Type': 'application/json'};

      final authResponse = await _client.post(
        Uri.parse('https://accept.paymob.com/api/auth/tokens'),
        headers: headers,
        body: jsonEncode({'api_key': _apiKey}),
      );

      if (authResponse.statusCode != 200 && authResponse.statusCode != 201) {
        throw Exception('فشل المصادقة مع Paymob: ${authResponse.body}');
      }

      final authToken = jsonDecode(authResponse.body)['token'];

      final int amountCents = (amount * 100).toInt();

      final orderResponse = await _client.post(
        Uri.parse('https://accept.paymob.com/api/ecommerce/orders'),
        headers: headers,
        body: jsonEncode({
          'auth_token': authToken,
          'delivery_needed': 'false',
          'amount_cents': amountCents,
          'currency': 'EGP',
          'items': [],
        }),
      );

      if (orderResponse.statusCode != 200 && orderResponse.statusCode != 201) {
        throw Exception('فشل تسجيل الطلب في Paymob: ${orderResponse.body}');
      }

      final int orderId = jsonDecode(orderResponse.body)['id'];

      final names = userName.trim().split(' ');

      final firstName = names.isNotEmpty && names.first.isNotEmpty
          ? names.first
          : 'User';

      final lastName = names.length > 1
          ? names.sublist(1).join(' ')
          : 'Customer';

      final paymentKeyResponse = await _client.post(
        Uri.parse('https://accept.paymob.com/api/acceptance/payment_keys'),
        headers: headers,
        body: jsonEncode({
          'auth_token': authToken,
          'amount_cents': amountCents,
          'expiration': 3600,
          'order_id': orderId,
          'billing_data': {
            'apartment': 'NA',
            'email': userEmail.isNotEmpty ? userEmail : 'user@madinaty.com',
            'floor': 'NA',
            'first_name': firstName,
            'street': 'NA',
            'building': 'NA',
            'phone_number': walletNumber,
            'shipping_method': 'NA',
            'postal_code': 'NA',
            'city': 'Cairo',
            'country': 'EGY',
            'last_name': lastName,
            'state': 'Cairo',
          },
          'currency': 'EGP',
          'integration_id': _walletIntegrationId,
        }),
      );

      if (paymentKeyResponse.statusCode != 200 &&
          paymentKeyResponse.statusCode != 201) {
        throw Exception(
          'فشل توليد مفتاح دفع المحفظة: '
          '${paymentKeyResponse.body}',
        );
      }

      final String paymentToken = jsonDecode(paymentKeyResponse.body)['token'];

      final walletPayResponse = await _client.post(
        Uri.parse('https://accept.paymob.com/api/acceptance/payments/pay'),
        headers: headers,
        body: jsonEncode({
          'source': {'identifier': walletNumber, 'subtype': 'WALLET'},
          'payment_token': paymentToken,
        }),
      );

      if (walletPayResponse.statusCode != 200 &&
          walletPayResponse.statusCode != 201) {
        throw Exception(
          'فشل طلب الدفع بالمحفظة: '
          '${walletPayResponse.body}',
        );
      }

      final walletData = jsonDecode(walletPayResponse.body);

      final String? redirectUrl =
          walletData['redirection_url'] ??
          walletData['redirect_url'] ??
          walletData['iframe_redirection_url'] ??
          walletData['url'];

      if (redirectUrl == null || redirectUrl.isEmpty) {
        throw Exception('لم يتم استلام رابط الدفع للمحفظة من Paymob');
      }

      return redirectUrl;
    } catch (e) {
      throw Exception('فشل في بدء دفع المحفظة الإلكترونية: $e');
    }
  }

  @override
  Future<String> getPaymobPaymentUrl({
    required double amount,
    required String userEmail,
    required String userPhone,
    required String userName,
  }) async {
    try {
      final headers = {'Content-Type': 'application/json'};

      final authResponse = await _client.post(
        Uri.parse('https://accept.paymob.com/api/auth/tokens'),
        headers: headers,
        body: jsonEncode({'api_key': _apiKey}),
      );

      if (authResponse.statusCode != 200 && authResponse.statusCode != 201) {
        throw Exception('فشل المصادقة مع Paymob: ${authResponse.body}');
      }

      final authData = jsonDecode(authResponse.body);
      final String authToken = authData['token'];

      final int amountCents = (amount * 100).toInt();

      final orderResponse = await _client.post(
        Uri.parse('https://accept.paymob.com/api/ecommerce/orders'),
        headers: headers,
        body: jsonEncode({
          'auth_token': authToken,
          'delivery_needed': 'false',
          'amount_cents': amountCents,
          'currency': 'EGP',
          'items': [],
        }),
      );

      if (orderResponse.statusCode != 200 && orderResponse.statusCode != 201) {
        throw Exception(
          'فشل تسجيل الطلب في Paymob: '
          '${orderResponse.body}',
        );
      }

      final orderData = jsonDecode(orderResponse.body);
      final int orderId = orderData['id'];

      final names = userName.trim().split(' ');

      final firstName = names.isNotEmpty && names.first.isNotEmpty
          ? names.first
          : 'User';

      final lastName = names.length > 1
          ? names.sublist(1).join(' ')
          : 'Customer';

      final paymentKeyResponse = await _client.post(
        Uri.parse('https://accept.paymob.com/api/acceptance/payment_keys'),
        headers: headers,
        body: jsonEncode({
          'auth_token': authToken,
          'amount_cents': amountCents,
          'expiration': 3600,
          'order_id': orderId,
          'billing_data': {
            'apartment': 'NA',
            'email': userEmail.isNotEmpty ? userEmail : 'user@madinaty.com',
            'floor': 'NA',
            'first_name': firstName,
            'street': 'NA',
            'building': 'NA',
            'phone_number': userPhone.isNotEmpty ? userPhone : '+201000000000',
            'shipping_method': 'NA',
            'postal_code': 'NA',
            'city': 'Cairo',
            'country': 'EGY',
            'last_name': lastName,
            'state': 'Cairo',
          },
          'currency': 'EGP',
          'integration_id': _integrationId,
        }),
      );

      if (paymentKeyResponse.statusCode != 200 &&
          paymentKeyResponse.statusCode != 201) {
        throw Exception(
          'فشل توليد مفتاح الدفع: '
          '${paymentKeyResponse.body}',
        );
      }

      final paymentKeyData = jsonDecode(paymentKeyResponse.body);

      final String paymentToken = paymentKeyData['token'];

      return 'https://accept.paymob.com/api/acceptance/iframes/'
          '$_iframeId?payment_token=$paymentToken';
    } catch (e) {
      throw Exception('فشل في إعداد عملية الدفع مع Paymob: $e');
    }
  }

  @override
  Future<BookingModel> saveAndConfirmBooking(BookingModel booking) async {
    final user = _auth.currentUser;

    if (user == null) {
      throw Exception('يرجى تسجيل الدخول أولاً لإتمام الحجز');
    }

    final cafeId = booking.cafeId.trim();

    if (cafeId.isEmpty) {
      throw Exception('بيانات الكافيه غير صحيحة');
    }

    final bookingDate = booking.date;

    if (bookingDate == null) {
      throw Exception('يرجى اختيار تاريخ الحجز');
    }

    final bookingTime = booking.time?.trim();

    if (bookingTime == null || bookingTime.isEmpty) {
      throw Exception('يرجى اختيار وقت الحجز');
    }

    if (booking.guests <= 0) {
      throw Exception('عدد الأشخاص غير صحيح');
    }

    final normalizedDate = DateTime(
      bookingDate.year,
      bookingDate.month,
      bookingDate.day,
    );

    final dateKey =
        '${normalizedDate.year}-'
        '${normalizedDate.month.toString().padLeft(2, '0')}-'
        '${normalizedDate.day.toString().padLeft(2, '0')}';

    final timeKey = _normalizeKeyPart(bookingTime);

    final seatingKey = _normalizeKeyPart(booking.seatingPreference ?? 'any');

    /*
   * نفس الكافيه + نفس اليوم + نفس الوقت + نفس الجلسة
   * = نفس الـ document.
   */
    final bookingId =
        '${cafeId}_'
        '${dateKey}_'
        '${timeKey}_'
        '${seatingKey}';

    final bookingRef = _firestore.collection('bookings').doc(bookingId);

    late BookingModel confirmedBooking;

    await _firestore.runTransaction((transaction) async {
      final existingSnapshot = await transaction.get(bookingRef);

      if (existingSnapshot.exists) {
        final data = existingSnapshot.data();

        final existingStatus = data?['status']?.toString().toLowerCase();

        /*
         * فقط الحجوزات النشطة تمنع الحجز.
         */
        if (existingStatus == BookingStatus.approved.name ||
            existingStatus == BookingStatus.pending.name) {
          throw Exception('هذا الموعد محجوز بالفعل');
        }

        /*
         * cancelled / rejected
         * يسمحوا بإعادة الحجز.
         */
      }

      confirmedBooking = BookingModel(
        id: bookingId,
        userId: user.uid,
        cafeId: cafeId,
        cafeName: booking.cafeName,
        cafeLocation: booking.cafeLocation,
        date: normalizedDate,
        time: bookingTime,
        guests: booking.guests,
        occasion: booking.occasion,
        seatingPreference: booking.seatingPreference,
        status: BookingStatus.approved,
        createdAt: DateTime.now(),
        totalAmount: booking.totalAmount,
        reservationFee: booking.reservationFee,
      );

      transaction.set(bookingRef, confirmedBooking.toFirestore());
    });

    /*
   * النقاط بعد نجاح الحجز فقط.
   */
    try {
      await _firestore.collection('users').doc(user.uid).set({
        'points': FieldValue.increment(50),
        'loyaltyPoints': FieldValue.increment(50),
      }, SetOptions(merge: true));
    } catch (_) {
      // فشل النقاط لا يلغي الحجز.
    }

    return confirmedBooking;
  }

  String _normalizeKeyPart(String value) {
    return value
        .trim()
        .toLowerCase()
        .replaceAll(RegExp(r'\s+'), '_')
        .replaceAll(':', '-')
        .replaceAll('/', '-')
        .replaceAll('\\', '-');
  }
}
