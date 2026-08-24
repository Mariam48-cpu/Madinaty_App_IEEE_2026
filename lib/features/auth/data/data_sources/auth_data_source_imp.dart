import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../models/user_model.dart';
import 'auth_data_source_interface.dart';

class AuthRemoteDataSourceImpl implements AuthRemoteDataSourceInterface {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;
  final GoogleSignIn _googleSignIn;

  AuthRemoteDataSourceImpl({
    FirebaseAuth? firebaseAuth,
    FirebaseFirestore? firestore,
    GoogleSignIn? googleSignIn,
  }) : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
       _firestore = firestore ?? FirebaseFirestore.instance,
       _googleSignIn = googleSignIn ?? GoogleSignIn.instance;

  @override
  User? get currentUser => _firebaseAuth.currentUser;

  // ==================================================
  // REGISTER
  // ==================================================

  @override
  Future<UserModel> registerWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
    String? phone,
  }) async {
    final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final user = userCredential.user!;

    if (name.isNotEmpty) {
      await user.updateDisplayName(name);
    }

    final userModel = UserModel(
      uid: user.uid,
      name: name,
      email: email,
      phone: phone,
    );

    await _firestore.collection('users').doc(user.uid).set(userModel.toMap());

    return userModel;
  }

  // ==================================================
  // LOGIN
  // ==================================================

  @override
  Future<UserModel> loginWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    final user = userCredential.user!;

    final doc = await _firestore.collection('users').doc(user.uid).get();

    if (doc.exists && doc.data() != null) {
      return UserModel.fromMap(doc.data()!, user.uid);
    }

    return UserModel(
      uid: user.uid,
      email: user.email,
      name: user.displayName,
      phone: user.phoneNumber,
    );
  }

  // ==================================================
  // RESET PASSWORD
  // ==================================================

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  // ==================================================
  // PHONE OTP
  // ==================================================

  @override
  Future<void> sendPhoneOtp({
    required String phoneNumber,
    required Function(String verificationId, int? resendToken) onCodeSent,
    required Function(FirebaseAuthException error) onVerificationFailed,
    required Function(PhoneAuthCredential credential) onVerificationCompleted,
    required Function(String verificationId) onCodeAutoRetrievalTimeout,
  }) async {
    await _firebaseAuth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: onVerificationCompleted,
      verificationFailed: onVerificationFailed,
      codeSent: onCodeSent,
      codeAutoRetrievalTimeout: onCodeAutoRetrievalTimeout,
    );
  }

  // ==================================================
  // VERIFY OTP
  // ==================================================

  @override
  Future<UserModel> verifyOtpAndSignIn({
    required String verificationId,
    required String smsCode,
  }) async {
    final credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: smsCode,
    );

    final userCredential = await _firebaseAuth.signInWithCredential(credential);

    final user = userCredential.user!;

    final doc = await _firestore.collection('users').doc(user.uid).get();

    if (doc.exists && doc.data() != null) {
      return UserModel.fromMap(doc.data()!, user.uid);
    }

    final userModel = UserModel(uid: user.uid, phone: user.phoneNumber);

    await _firestore
        .collection('users')
        .doc(user.uid)
        .set(userModel.toMap(), SetOptions(merge: true));

    return userModel;
  }

  // ==================================================
  // DELETE ACCOUNT
  // ==================================================

  @override
  Future<void> deleteAccount() async {
    final user = _firebaseAuth.currentUser;

    if (user == null) {
      throw Exception('لا يوجد مستخدم مسجل الدخول');
    }

    final uid = user.uid;

    // Delete user data from Firestore
    await _firestore.collection('users').doc(uid).delete();

    // Delete Firebase Authentication account
    await user.delete();

    // Sign out from Google if applicable
    try {
      await _googleSignIn.signOut();
    } catch (_) {}
  }

  // ==================================================
  // SIGN OUT
  // ==================================================

  @override
  Future<void> signOut() async {
    await Future.wait([_firebaseAuth.signOut(), _googleSignIn.signOut()]);
  }

  // ==================================================
  // GOOGLE SIGN IN
  // ==================================================

  @override
  Future<UserModel> signInWithGoogle() async {
    await _googleSignIn.initialize();

    final GoogleSignInAccount? googleUser = await _googleSignIn.authenticate();

    if (googleUser == null) {
      throw Exception('تم إلغاء تسجيل الدخول عبر Google');
    }

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      idToken: googleAuth.idToken,
    );

    final userCredential = await _firebaseAuth.signInWithCredential(credential);

    final user = userCredential.user!;

    final doc = await _firestore.collection('users').doc(user.uid).get();

    if (doc.exists && doc.data() != null) {
      return UserModel.fromMap(doc.data()!, user.uid);
    }

    final userModel = UserModel(
      uid: user.uid,
      name: user.displayName,
      email: user.email,
      phone: user.phoneNumber,
    );

    await _firestore
        .collection('users')
        .doc(user.uid)
        .set(userModel.toMap(), SetOptions(merge: true));

    return userModel;
  }
}
