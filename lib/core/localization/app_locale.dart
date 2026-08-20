mixin AppLocale {
  // --- Auth & General ---
  static const String appTitle = 'appTitle';
  static const String welcome = 'welcome';
  static const String subtitle = 'subtitle';
  static const String login = 'login';
  static const String register = 'register';
  static const String emailOrPhone = 'emailOrPhone';
  static const String password = 'password';
  static const String confirmPassword = 'confirmPassword';
  static const String name = 'name';
  static const String forgotPassword = 'forgotPassword';
  static const String continueWithGoogle = 'continueWithGoogle';
  static const String haveAccount = 'haveAccount';
  static const String noAccount = 'noAccount';

  static const String nameHint = 'nameHint';
  static const String emailHint = 'emailHint';
  static const String passwordHint = 'passwordHint';
  static const String confirmPasswordHint = 'confirmPasswordHint';
  static const String or = 'or';

  static const String forgotPasswordDesc = 'forgotPasswordDesc';
  static const String enterEmailError = 'enterEmailError';
  static const String sendResetLink = 'sendResetLink';
  static const String backToLogin = 'backToLogin';

  // --- Checkout Screen ---
  static const String checkoutTitle = 'checkoutTitle';
  static const String reservationDetails = 'reservationDetails';
  static const String date = 'date';
  static const String time = 'time';
  static const String guests = 'guests';
  static const String seating = 'seating';
  static const String guestsCountText = 'guestsCountText';
  static const String occasionBadge = 'occasionBadge';

  static const String preOrdersTitle = 'preOrdersTitle';
  static const String edit = 'edit';

  static const String paymentMethodTitle = 'paymentMethodTitle';
  static const String creditDebitCard = 'creditDebitCard';
  static const String creditDebitCardSubtitle = 'creditDebitCardSubtitle';
  static const String digitalWallet = 'digitalWallet';
  static const String digitalWalletSubtitle = 'digitalWalletSubtitle';
  static const String payAtCafe = 'payAtCafe';
  static const String payAtCafeSubtitle = 'payAtCafeSubtitle';

  static const String walletPhoneNumber = 'walletPhoneNumber';
  static const String walletHint = 'walletHint';
  static const String walletHelperText = 'walletHelperText';
  static const String paymobSecureTitle = 'paymobSecureTitle';

  static const String preOrdersSubtotal = 'preOrdersSubtotal';
  static const String tableReservationFee = 'tableReservationFee';
  static const String tableReservationFeeSubtitle = 'tableReservationFeeSubtitle';
  static const String taxes = 'taxes';
  static const String total = 'total';
  static const String inclusiveOfTaxes = 'inclusiveOfTaxes';
  static const String currency = 'currency';

  static const String confirmAndPay = 'confirmAndPay';
  static const String backToCart = 'backToCart';

  // --- Confirmation Screen ---
  static const String reservationConfirmedTitle = 'reservationConfirmedTitle';
  static const String reservationConfirmedDesc = 'reservationConfirmedDesc';
  static const String bookingNumber = 'bookingNumber';
  static const String cafe = 'cafe';
  static const String appointment = 'appointment';
  static const String details = 'details';
  static const String paidAmount = 'paidAmount';
  static const String backToHome = 'backToHome';
  static const String viewMyBookings = 'viewMyBookings';

  // --- Toasts & Errors ---
  static const String paymentErrorTitle = 'paymentErrorTitle';
  static const String successTitle = 'successTitle';
  static const String reservationSuccessDesc = 'reservationSuccessDesc';
  static const String paymentFailedError = 'paymentFailedError';
  static const String walletValidationError = 'walletValidationError';
  static const String loginRequiredError = 'loginRequiredError';

  // ==========================================
  // ARABIC
  // ==========================================
  static const Map<String, dynamic> AR = {
    appTitle: 'مدينتي',
    welcome: 'أهلاً بيك في مدينتي',
    subtitle: 'اكتشف الأماكن اللي شبه ذوقك.',
    login: 'تسجيل الدخول',
    register: 'إنشاء حساب',
    emailOrPhone: 'البريد الإلكتروني',
    password: 'كلمة المرور',
    confirmPassword: 'تأكيد كلمة المرور',
    name: 'الاسم',
    forgotPassword: 'نسيت كلمة المرور؟',
    continueWithGoogle: 'المتابعة باستخدام Google',
    haveAccount: 'لديك حساب بالفعل؟ تسجيل الدخول',
    noAccount: 'ليس لديك حساب؟ إنشاء حساب',
    nameHint: 'أدخل اسمك الكامل',
    emailHint: 'أدخل إيميلك',
    passwordHint: 'أدخل كلمة المرور',
    confirmPasswordHint: 'تأكيد كلمة المرور',
    or: 'أو',
    forgotPasswordDesc: 'أدخل البريد الإلكتروني\nلإعادة تعيين كلمة المرور',
    enterEmailError: 'يرجى إدخال البريد الإلكتروني',
    sendResetLink: 'إرسال رابط الاستعادة',
    backToLogin: 'العودة لتسجيل الدخول',

    checkoutTitle: 'الدفع وتأكيد الحجز',
    reservationDetails: 'تفاصيل الحجز',
    date: 'التاريخ',
    time: 'الوقت',
    guests: 'الضيوف',
    seating: 'الجلوس',
    guestsCountText: 'أشخاص',
    occasionBadge: 'مناسبة: ',
    preOrdersTitle: 'الطلبات المسبقة',
    edit: 'تعديل',
    paymentMethodTitle: 'طريقة الدفع',
    creditDebitCard: 'بطاقة ائتمان / خصم مباشر',
    creditDebitCardSubtitle: 'فيزا، ماستركارد، ميزة',
    digitalWallet: 'محفظة رقمية',
    digitalWalletSubtitle: 'فودافون كاش، إنستاباي، وغيرها',
    payAtCafe: 'الدفع عند الوصول للكافيه',
    payAtCafeSubtitle: 'نقداً أو عبر نقاط البيع المتاحة بالكافيه',

    walletPhoneNumber: 'رقم المحفظة الإلكترونية',
    walletHint: '01xxxxxxxxx',
    walletHelperText: 'سيتم تحويلك لتأكيد الدفع عبر محفظتك الإلكترونية',
    paymobSecureTitle: 'بوابة الدفع الآمن',

    preOrdersSubtotal: 'المجموع الفرعي للطلبات',
    tableReservationFee: 'رسوم حجز الطاولة',
    tableReservationFeeSubtitle: '(تخصم من الفاتورة)',
    taxes: 'الضرائب (14%)',
    total: 'الإجمالي',
    inclusiveOfTaxes: 'شامل الضرائب',
    currency: 'ج.م',
    confirmAndPay: 'تأكيد والدفع',
    backToCart: 'العودة للسلة',

    reservationConfirmedTitle: 'تم تأكيد الحجز بنجاح!',
    reservationConfirmedDesc: 'تم إرسال تفاصيل الحجز والإشعار إلى حسابك',
    bookingNumber: 'رقم الحجز',
    cafe: 'الكافيه',
    appointment: 'الموعد',
    details: 'التفاصيل',
    paidAmount: 'المبلغ المدفوع',
    backToHome: 'العودة للرئيسية',
    viewMyBookings: 'عرض قائمة حجوزاتي',

    paymentErrorTitle: 'خطأ في عملية الدفع',
    successTitle: 'تم بنجاح',
    reservationSuccessDesc: 'تم تأكيد حجزك بنجاح!',
    paymentFailedError: 'فشلت عملية الدفع، يرجى المحاولة مرة أخرى أو اختيار طريقة دفع أخرى',
    walletValidationError: 'يرجى إدخال رقم محفظة إلكترونية صحيح (11 رقماً يبدأ بـ 01)',
    loginRequiredError: 'يرجى تسجيل الدخول أولاً لإتمام الحجز',
  };

  // ==========================================
  // ENGLISH
  // ==========================================
  static const Map<String, dynamic> EN = {
    appTitle: 'Madinaty',
    welcome: 'Welcome to Madinaty',
    subtitle: 'Discover places that match your taste.',
    login: 'Login',
    register: 'Sign Up',
    emailOrPhone: 'Email',
    password: 'Password',
    confirmPassword: 'Confirm Password',
    name: 'Name',
    forgotPassword: 'Forgot Password?',
    continueWithGoogle: 'Continue with Google',
    haveAccount: 'Already have an account? Login',
    noAccount: "Don't have an account? Sign Up",
    nameHint: 'Enter your full name',
    emailHint: 'Enter your email',
    passwordHint: 'Enter your password',
    confirmPasswordHint: 'Confirm your password',
    or: 'OR',
    forgotPasswordDesc: 'Enter your email\nto reset your password',
    enterEmailError: 'Please enter your email',
    sendResetLink: 'Send Reset Link',
    backToLogin: 'Back to Login',

    checkoutTitle: 'Checkout & Payment',
    reservationDetails: 'Reservation Details',
    date: 'Date',
    time: 'Time',
    guests: 'Guests',
    seating: 'Seating',
    guestsCountText: 'Guests',
    occasionBadge: 'Occasion: ',
    preOrdersTitle: 'Pre-Orders',
    edit: 'Edit',
    paymentMethodTitle: 'Payment Method',
    creditDebitCard: 'Credit / Debit Card',
    creditDebitCardSubtitle: 'Visa, MasterCard, Meeza',
    digitalWallet: 'Digital Wallet',
    digitalWalletSubtitle: 'Vodafone Cash, InstaPay, etc.',
    payAtCafe: 'Pay at Cafe',
    payAtCafeSubtitle: 'Cash or POS available at cafe',

    walletPhoneNumber: 'E-Wallet Phone Number',
    walletHint: '01xxxxxxxxx',
    walletHelperText: 'You will be redirected to complete payment with your wallet',
    paymobSecureTitle: 'Secure Payment Gateway',

    preOrdersSubtotal: 'Pre-Orders Subtotal',
    tableReservationFee: 'Table Reservation Fee',
    tableReservationFeeSubtitle: '(deducted from bill)',
    taxes: 'Taxes (14%)',
    total: 'Total',
    inclusiveOfTaxes: 'Inclusive of taxes',
    currency: 'EGP',
    confirmAndPay: 'Confirm & Pay',
    backToCart: 'Back to Cart',

    reservationConfirmedTitle: 'Reservation Confirmed Successfully!',
    reservationConfirmedDesc: 'Booking details and notification have been sent to your account',
    bookingNumber: 'Booking Number',
    cafe: 'Cafe',
    appointment: 'Appointment',
    details: 'Details',
    paidAmount: 'Paid Amount',
    backToHome: 'Back to Home',
    viewMyBookings: 'View My Bookings',

    paymentErrorTitle: 'Payment Error',
    successTitle: 'Success',
    reservationSuccessDesc: 'Your reservation has been confirmed successfully!',
    paymentFailedError: 'Payment failed, please try again or choose another method',
    walletValidationError: 'Please enter a valid wallet number (11 digits starting with 01)',
    loginRequiredError: 'Please login first to complete your booking',
  };

  // ==========================================
  // KHMER
  // ==========================================
  static const Map<String, dynamic> KM = {
    appTitle: 'ម៉ាឌីណាទី',
    welcome: 'សូមស្វាគមន៍មកកាន់ ម៉ាឌីណាទី',
    subtitle: 'ស្វែងរកកន្លែងដែលត្រូវនឹងចំណង់ចំណូលចិត្តរបស់អ្នក។',
    login: 'ចូលគណនី',
    register: 'ចុះឈ្មោះ',
    emailOrPhone: 'អ៊ីមែល',
    password: 'ពាក្យសម្ងាត់',
    confirmPassword: 'បញ្ជាក់ពាក្យសម្ងាត់',
    name: 'ឈ្មោះ',
    forgotPassword: 'ភ្លេចពាក្យសម្ងាត់?',
    continueWithGoogle: 'បន្តជាមួយ Google',
    haveAccount: 'មានគណនីរួចហើយ? ចូលគណនី',
    noAccount: 'មិនទាន់មានគណនី? ចុះឈ្មោះ',
    nameHint: 'បញ្ចូលឈ្មោះពេញរបស់អ្នក',
    emailHint: 'បញ្ចូលអ៊ីមែលរបស់អ្នក',
    passwordHint: 'បញ្ចូលពាក្យសម្ងាត់',
    confirmPasswordHint: 'បញ្ជាក់ពាក្យសម្ងាត់របស់អ្នក',
    or: 'ឬ',
    forgotPasswordDesc: 'បញ្ចូលអ៊ីមែលរបស់អ្នក\nដើម្បីកំណត់ពាក្យសម្ងាត់ឡើងវិញ',
    enterEmailError: 'សូមបញ្ចូលអ៊ីមែល',
    sendResetLink: 'ផ្ញើតំណកំណត់ឡើងវិញ',
    backToLogin: 'ត្រឡប់ទៅចូលគណនីវិញ',

    checkoutTitle: 'ការទូទាត់ និងការបញ្ជាក់ការកក់',
    reservationDetails: 'ព័ត៌មានលម្អិតនៃការកក់',
    date: 'កាលបរិច្ឆេទ',
    time: 'ពេលវេលា',
    guests: 'ភ្ញៀវ',
    seating: 'កន្លែងអង្គុយ',
    guestsCountText: 'នាក់',
    occasionBadge: 'ឱកាស: ',
    preOrdersTitle: 'ការកុម្ម៉ង់ទុកមុន',
    edit: 'កែប្រែ',
    paymentMethodTitle: 'វិធីសាស្ត្រទូទាត់ប្រាក់',
    creditDebitCard: 'កាតឥណទាន / ឥណពន្ធ',
    creditDebitCardSubtitle: 'Visa, MasterCard, Meeza',
    digitalWallet: 'កាបូបឌីជីថល',
    digitalWalletSubtitle: 'Vodafone Cash, InstaPay ជាដើម',
    payAtCafe: 'ទូទាត់នៅហាងកាហ្វេ',
    payAtCafeSubtitle: 'សាច់ប្រាក់ ឬម៉ាស៊ីន POS នៅហាងកាហ្វេ',

    walletPhoneNumber: 'លេខទូរស័ព្ទកាបូបឌីជីថល',
    walletHint: '01xxxxxxxxx',
    walletHelperText: 'អ្នកនឹងត្រូវបានបញ្ជូនបន្តដើម្បីបញ្ចប់ការទូទាត់',
    paymobSecureTitle: 'ច្រកទូទាត់ប្រាក់ប្រកបដោយសុវត្ថិភាព',

    preOrdersSubtotal: 'សរុបរងការកុម្ម៉ង់ទុកមុន',
    tableReservationFee: 'កម្រៃកក់តុ',
    tableReservationFeeSubtitle: '(កាត់ចេញពីវិក្កយបត្រ)',
    taxes: 'ពន្ធ (14%)',
    total: 'សរុប',
    inclusiveOfTaxes: 'រួមបញ្ចូលពន្ធ',
    currency: 'EGP',
    confirmAndPay: 'បញ្ជាក់ និងទូទាត់',
    backToCart: 'ត្រឡប់ទៅកន្ត្រកវិញ',

    reservationConfirmedTitle: 'ការកក់ត្រូវបានបញ្ជាក់ដោយជោគជ័យ!',
    reservationConfirmedDesc: 'ព័ត៌មានលម្អិត និងការជូនដំណឹងត្រូវបានផ្ញើទៅកាន់គណនីរបស់អ្នក',
    bookingNumber: 'លេខកក់',
    cafe: 'ហាងកាហ្វេ',
    appointment: 'ការណាត់ជួប',
    details: 'ព័ត៌មានលម្អិត',
    paidAmount: 'ចំនួនទឹកប្រាក់ដែលបានបង់',
    backToHome: 'ត្រឡប់ទៅទំព័រដើម',
    viewMyBookings: 'មើលបញ្ជីការកក់របស់ខ្ញុំ',

    paymentErrorTitle: 'កំហុសក្នុងការទូទាត់',
    successTitle: 'ជោគជ័យ',
    reservationSuccessDesc: 'ការកក់របស់អ្នកត្រូវបានបញ្ជាក់ដោយជោគជ័យ!',
    paymentFailedError: 'ការទូទាត់បានបរាជ័យ សូមព្យាយាមម្តងទៀត',
    walletValidationError: 'សូមបញ្ចូលលេខកាបូបឱ្យបានត្រឹមត្រូវ (11 ខ្ទង់ចាប់ផ្តើមដោយ 01)',
    loginRequiredError: 'សូមចូលគណនីជាមុនសិនដើម្បីបញ្ចប់ការកក់',
  };

  // ==========================================
  // JAPANESE
  // ==========================================
  static const Map<String, dynamic> JA = {
    appTitle: 'マディナティ',
    welcome: 'マディナティへようこそ',
    subtitle: 'あなたの好みに合った場所を見つけましょう。',
    login: 'ログイン',
    register: '新規登録',
    emailOrPhone: 'メールアドレス',
    password: 'パスワード',
    confirmPassword: 'パスワード（確認）',
    name: 'お名前',
    forgotPassword: 'パスワードをお忘れですか？',
    continueWithGoogle: 'Googleで続行',
    haveAccount: 'すでにアカウントをお持ちですか？ ログイン',
    noAccount: 'アカウントをお持ちでないですか？ 新規登録',
    nameHint: 'フルネームを入力してください',
    emailHint: 'メールアドレスを入力してください',
    passwordHint: 'パスワードを入力してください',
    confirmPasswordHint: 'パスワードを再入力してください',
    or: 'または',
    forgotPasswordDesc: 'パスワードをリセットするには\nメールアドレスを入力してください',
    enterEmailError: 'メールアドレスを入力してください',
    sendResetLink: 'リセットリンクを送信',
    backToLogin: 'ログインに戻る',

    checkoutTitle: 'お支払いと予約確定',
    reservationDetails: '予約詳細',
    date: '日付',
    time: '時間',
    guests: '人数',
    seating: '座席',
    guestsCountText: '名',
    occasionBadge: '利用目的: ',
    preOrdersTitle: '事前注文',
    edit: '変更',
    paymentMethodTitle: 'お支払い方法',
    creditDebitCard: 'クレジットカード / デビットカード',
    creditDebitCardSubtitle: 'Visa, MasterCard, Meeza',
    digitalWallet: '電子マネー',
    digitalWalletSubtitle: 'Vodafone Cash, InstaPay 等',
    payAtCafe: '店舗でお支払い',
    payAtCafeSubtitle: '現金または店舗のPOS端末でお支払い',

    walletPhoneNumber: '電子マネー電話番号',
    walletHint: '01xxxxxxxxx',
    walletHelperText: '決済画面へリダイレクトされます',
    paymobSecureTitle: '安全な決済ゲートウェイ',

    preOrdersSubtotal: '小計',
    tableReservationFee: '席予約料金',
    tableReservationFeeSubtitle: '（会計時に控除）',
    taxes: '税金 (14%)',
    total: '合計',
    inclusiveOfTaxes: '税込',
    currency: 'EGP',
    confirmAndPay: '確定してお支払い',
    backToCart: 'カートに戻る',

    reservationConfirmedTitle: '予約が完了しました！',
    reservationConfirmedDesc: '予約の詳細と通知をアカウントに送信しました',
    bookingNumber: '予約番号',
    cafe: 'カフェ',
    appointment: '予約日時',
    details: '詳細',
    paidAmount: 'お支払い金額',
    backToHome: 'ホームに戻る',
    viewMyBookings: '予約履歴を見る',

    paymentErrorTitle: '決済エラー',
    successTitle: '成功',
    reservationSuccessDesc: '予約が正常に確定しました！',
    paymentFailedError: '決済に失敗しました。もう一度お試しください',
    walletValidationError: '有効な電話番号を入力してください（01から始まる11桁）',
    loginRequiredError: '予約を完了するにはログインしてください',
  };
}