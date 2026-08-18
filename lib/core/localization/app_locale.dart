mixin AppLocale {
  // مفاتيح النصوص (Keys)
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

  // 🔑 نصوص التلميح (Hints) والفواصل
  static const String nameHint = 'nameHint';
  static const String emailHint = 'emailHint';
  static const String passwordHint = 'passwordHint';
  static const String confirmPasswordHint = 'confirmPasswordHint';
  static const String or = 'or';

  // 🔑 مفاتيح شاشة استعادة كلمة المرور
  static const String forgotPasswordDesc = 'forgotPasswordDesc';
  static const String enterEmailError = 'enterEmailError';
  static const String sendResetLink = 'sendResetLink';
  static const String backToLogin = 'backToLogin';

  // 🇪🇬 نصوص اللغة العربية
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
  };

  // 🇺🇸 نصوص اللغة الإنجليزية
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
  };

  // 🇰🇭 نصوص اللغة الخميرية (Khmer - KM)
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
  };

  // 🇯🇵 نصوص اللغة اليابانية (Japanese - JA)
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
  };
}