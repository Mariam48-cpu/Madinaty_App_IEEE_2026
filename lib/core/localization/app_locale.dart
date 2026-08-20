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

  // 🔑 مفاتيح شاشات التفضيلات (Personalization)
  static const String step2Of3 = 'step2Of3';
  static const String whatDoYouLikeTitle = 'whatDoYouLikeTitle';
  static const String whatDoYouLikeSubtitle = 'whatDoYouLikeSubtitle';
  static const String continueBtn = 'continueBtn';

  static const String whyGoingOutTitle = 'whyGoingOutTitle';
  static const String whyGoingOutSubtitle = 'whyGoingOutSubtitle';
  static const String showSuitablePlaces = 'showSuitablePlaces';

  // Interests / Moods / Occasions labels
  static const String specialtyCoffee = 'specialtyCoffee';
  static const String study = 'study';
  static const String work = 'work';
  static const String quietChill = 'quietChill';
  static const String birthday = 'birthday';
  static const String date = 'date';
  static const String withFriends = 'withFriends';
  static const String friendsOuting = 'friendsOuting';
  static const String nileView = 'nileView';
  static const String chillSitting = 'chillSitting';
  static const String quickCoffee = 'quickCoffee';
  static const String placeWithView = 'placeWithView';

  // Bottom Navigation
  static const String navHome = 'navHome';
  static const String navMap = 'navMap';
  static const String navMyLists = 'navMyLists';
  static const String navMyAccount = 'navMyAccount';

  // Feedback & Loading
  static const String loadingPreferences = 'loadingPreferences';
  static const String preferencesSavedSuccess = 'preferencesSavedSuccess';
  static const String selectAtLeastOneInterest = 'selectAtLeastOneInterest';
  static const String selectFavoriteInterests = 'selectFavoriteInterests';
  static const String selectGoingOutReason = 'selectGoingOutReason';
  static const String toastSuccess = 'toastSuccess';
  static const String toastError = 'toastError';

  // Additional widget labels
  static const String whatAreYourInterests = 'whatAreYourInterests';
  static const String interestsSubtitle = 'interestsSubtitle';
  static const String multiSelect = 'multiSelect';
  static const String singleSelect = 'singleSelect';
  static const String whatsYourMoodToday = 'whatsYourMoodToday';
  static const String chooseGeneralVibe = 'chooseGeneralVibe';
  static const String whatIsYourOccasion = 'whatIsYourOccasion';
  static const String selectOccasionType = 'selectOccasionType';

  // 🔑 Favorites & My Lists
  static const String places = 'places';
  static const String products = 'products';
  static const String noFavoritesYet = 'noFavoritesYet';

  // 🔑 Reviews & Ratings
  static const String reviewsAndRatings = 'reviewsAndRatings';
  static const String basedOn = 'basedOn';
  static const String ratingsCountSuffix = 'ratingsCountSuffix';
  static const String writeYourReview = 'writeYourReview';
  static const String coffee = 'coffee';
  static const String atmosphere = 'atmosphere';
  static const String service = 'service';
  static const String all = 'all';
  static const String withPhotos = 'withPhotos';
  static const String highestRating = 'highestRating';
  static const String helpful = 'helpful';
  static const String noReviewsYet = 'noReviewsYet';
  static const String submitReview = 'submitReview';
  static const String yourRating = 'yourRating';
  static const String writeReviewHint = 'writeReviewHint';
  static const String ratingRequired = 'ratingRequired';
  static const String commentRequired = 'commentRequired';
  static const String reviewSubmittedSuccess = 'reviewSubmittedSuccess';
  static const String editReview = 'editReview';
  static const String retry = 'retry';
  static const String loginRequiredToReview = 'loginRequiredToReview';

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

    // Personalization AR
    step2Of3: 'الخطوة 2 من 3',
    whatDoYouLikeTitle: 'إيه اللي بتحبه؟',
    whatDoYouLikeSubtitle: 'اختياراتك هتساعدنا نرشحلك أماكن مناسبة ليك.',
    continueBtn: 'كمل  ←',

    whyGoingOutTitle: 'إنت خارج النهارده ليه؟',
    whyGoingOutSubtitle: 'اختار اللي يناسبك وإحنا هنرشحلك المكان.',
    showSuitablePlaces: 'اعرض الأماكن المناسبة',

    specialtyCoffee: 'قهوة مختصة',
    study: 'مذاكرة',
    work: 'شغل',
    quietChill: 'جلسة هادئة',
    birthday: 'عيد ميلاد',
    date: 'Date',
    withFriends: 'مع الأصحاب',
    friendsOuting: 'خروجة مع الأصحاب',
    nileView: 'إطلالة على النيل',
    chillSitting: 'قعدة هادية',
    quickCoffee: 'قهوة سريعة',
    placeWithView: 'مكان بإطلالة',

    navHome: 'الرئيسية',
    navMap: 'الخريطة',
    navMyLists: 'قوائمي',
    navMyAccount: 'حسابي',

    loadingPreferences: 'جاري تحميل تفضيلاتك...',
    preferencesSavedSuccess: 'تم حفظ تفضيلاتك بنجاح!',
    selectAtLeastOneInterest: 'يرجى اختيار اهتمام واحد على الأقل للمتابعة',
    selectFavoriteInterests: 'يرجى اختيار اهتماماتك المفضلة',
    selectGoingOutReason: 'يرجى تحديد سبب الخروج اليوم',
    toastSuccess: 'نجاح',
    toastError: 'خطأ',

    whatAreYourInterests: 'ما هي اهتماماتك؟',
    interestsSubtitle: 'يمكنك اختيار أكثر من خيار للحصول على ترشيحات دقيقة',
    multiSelect: 'متعدد الاختيارات',
    singleSelect: 'اختيار فردي',
    whatsYourMoodToday: 'على مزاجك إيه النهاردة؟',
    chooseGeneralVibe: 'اختر الجو العام اللي بتفضله',
    whatIsYourOccasion: 'ما هي مناسبتك؟',
    selectOccasionType: 'حدد نوع الخروجة أو المناسبة الحالية',

    // Favorites & Reviews AR
    places: 'الأماكن',
    products: 'المنتجات',
    noFavoritesYet: 'لا توجد عناصر في المفضلة حتى الآن',
    reviewsAndRatings: 'التقييمات والمراجعات',
    basedOn: 'بناءً على',
    ratingsCountSuffix: 'تقييم',
    writeYourReview: 'اكتب تقييمك',
    coffee: 'القهوة',
    atmosphere: 'الجو العام',
    service: 'الخدمة',
    all: 'الكل',
    withPhotos: 'لديها صور',
    highestRating: 'أعلى تقييم',
    helpful: 'مفيد',
    noReviewsYet: 'لا توجد تقييمات حتى الآن',
    submitReview: 'إرسال التقييم',
    yourRating: 'تقييمك',
    writeReviewHint: 'اكتب رأيك وتجربتك هنا بالتفصيل...',
    ratingRequired: 'يرجى اختيار التقييم بالنجوم',
    commentRequired: 'يرجى كتابة نص المراجعة',
    reviewSubmittedSuccess: 'تم إرسال تقييمك بنجاح!',
    editReview: 'تعديل التقييم',
    retry: 'إعادة المحاولة',
    loginRequiredToReview: 'يرجى تسجيل الدخول أولاً لتتمكن من كتابة تقييم',
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

    // Personalization EN
    step2Of3: 'Step 2 of 3',
    whatDoYouLikeTitle: 'What do you like?',
    whatDoYouLikeSubtitle: 'Your choices will help us recommend suitable places for you.',
    continueBtn: 'Continue  ←',

    whyGoingOutTitle: 'Why are you going out today?',
    whyGoingOutSubtitle: 'Choose what suits you and we will recommend the place.',
    showSuitablePlaces: 'Show Suitable Places',

    specialtyCoffee: 'Specialty Coffee',
    study: 'Study',
    work: 'Work',
    quietChill: 'Quiet Chill',
    birthday: 'Birthday',
    date: 'Date',
    withFriends: 'With Friends',
    friendsOuting: 'Friends Outing',
    nileView: 'Nile View',
    chillSitting: 'Chill Sitting',
    quickCoffee: 'Quick Coffee',
    placeWithView: 'Place with a View',

    navHome: 'Home',
    navMap: 'Map',
    navMyLists: 'My Lists',
    navMyAccount: 'My Account',

    loadingPreferences: 'Loading your preferences...',
    preferencesSavedSuccess: 'Your preferences have been saved successfully!',
    selectAtLeastOneInterest: 'Please select at least one interest to continue',
    selectFavoriteInterests: 'Please select your favorite interests',
    selectGoingOutReason: 'Please select the reason for going out today',
    toastSuccess: 'Success',
    toastError: 'Error',

    whatAreYourInterests: 'What are your interests?',
    interestsSubtitle: 'You can choose more than one option for accurate recommendations',
    multiSelect: 'Multiple Choice',
    singleSelect: 'Single Choice',
    whatsYourMoodToday: "What's your mood today?",
    chooseGeneralVibe: 'Choose the general vibe you prefer',
    whatIsYourOccasion: 'What is your occasion?',
    selectOccasionType: 'Specify the current outing or occasion type',

    // Favorites & Reviews EN
    places: 'Places',
    products: 'Products',
    noFavoritesYet: 'No favorites yet',
    reviewsAndRatings: 'Reviews & Ratings',
    basedOn: 'Based on',
    ratingsCountSuffix: 'reviews',
    writeYourReview: 'Write your review',
    coffee: 'Coffee',
    atmosphere: 'Atmosphere',
    service: 'Service',
    all: 'All',
    withPhotos: 'With photos',
    highestRating: 'Highest rating',
    helpful: 'Helpful',
    noReviewsYet: 'No reviews yet',
    submitReview: 'Submit Review',
    yourRating: 'Your Rating',
    writeReviewHint: 'Write your thoughts and experience here in detail...',
    ratingRequired: 'Please select a star rating',
    commentRequired: 'Please write your review comment',
    reviewSubmittedSuccess: 'Your review has been submitted successfully!',
    editReview: 'Edit Review',
    retry: 'Retry',
    loginRequiredToReview: 'Please login first to submit a review',
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

    step2Of3: 'ជំហានទី ២ នៃ ៣',
    whatDoYouLikeTitle: 'តើអ្នកចូលចិត្តអ្វី?',
    whatDoYouLikeSubtitle: 'ជម្រើសរបស់អ្នកនឹងជួយយើងណែនាំកន្លែងសមរម្យសម្រាប់អ្នក។',
    continueBtn: 'បន្ត  ←',
    whyGoingOutTitle: 'ហេតុអ្វីអ្នកចេញទៅក្រៅថ្ងៃនេះ?',
    whyGoingOutSubtitle: 'ជ្រើសរើសអ្វីដែលសាកសមនឹងអ្នក ហើយយើងនឹងណែនាំកន្លែង។',
    showSuitablePlaces: 'បង្ហាញកន្លែងដែលសមរម្យ',
    specialtyCoffee: 'កាហ្វេពិសេស',
    study: 'រៀន',
    work: 'ការងារ',
    quietChill: 'កន្លែងស្ងប់ស្ងាត់',
    birthday: 'ថ្ងៃកំណើត',
    date: 'Date',
    withFriends: 'ជាមួយមិត្តភក្តិ',
    friendsOuting: 'ដើរលេងជាមួយមិត្តភក្តិ',
    nileView: 'ទិដ្ឋភាពទន្លេ',
    chillSitting: 'អង្គុយលេង',
    quickCoffee: 'កាហ្វេរហ័ស',
    placeWithView: 'កន្លែងមានទិដ្ឋភាព',
    navHome: 'ទំព័រដើម',
    navMap: 'ផែនទី',
    navMyLists: 'បញ្ជីរបស់ខ្ញុំ',
    navMyAccount: 'គណនីរបស់ខ្ញុំ',
    loadingPreferences: 'កំពុងផ្ទុកចំណង់ចំណូលចិត្តរបស់អ្នក...',
    preferencesSavedSuccess: 'ចំណង់ចំណូលចិត្តរបស់អ្នកត្រូវបានរក្សាទុកដោយជោគជ័យ!',
    selectAtLeastOneInterest: 'សូមជ្រើសរើសចំណាប់អារម្មណ៍យ៉ាងហោចណាស់មួយដើម្បីបន្ត',
    selectFavoriteInterests: 'សូមជ្រើសរើសចំណាប់អារម្មណ៍ដែលអ្នកចូលចិត្ត',
    selectGoingOutReason: 'សូមជ្រើសរើសមូលហេតុនៃការចេញទៅក្រៅថ្ងៃនេះ',
    toastSuccess: 'ជោគជ័យ',
    toastError: 'កំហុស',

    // Favorites & Reviews KM
    places: 'ទីកន្លែង',
    products: 'ផលិតផល',
    noFavoritesYet: 'មិនទាន់មានចំណូលចិត្តនៅឡើយទេ',
    reviewsAndRatings: 'ការវាយតម្លៃ និងការពិនិត្យ',
    basedOn: 'ផ្អែកលើ',
    ratingsCountSuffix: 'ការវាយតម្លៃ',
    writeYourReview: 'សរសេរការវាយតម្លៃរបស់អ្នក',
    coffee: 'កាហ្វេ',
    atmosphere: 'បរិយាកាស',
    service: 'សេវាកម្ម',
    all: 'ទាំងអស់',
    withPhotos: 'មានរូបថត',
    highestRating: 'ការវាយតម្លៃខ្ពស់បំផុត',
    helpful: 'មានប្រយោជន៍',
    noReviewsYet: 'មិនទាន់មានការវាយតម្លៃនៅឡើយទេ',
    submitReview: 'ផ្ញើការវាយតម្លៃ',
    yourRating: 'ការវាយតម្លៃរបស់អ្នក',
    writeReviewHint: 'សរសេរគំនិតនិងបទពិសោធន៍របស់អ្នកនៅទីនេះ...',
    ratingRequired: 'សូមជ្រើសរើសការវាយតម្លៃផ្កាយ',
    commentRequired: 'សូមសរសេរមតិយោបល់របស់អ្នក',
    reviewSubmittedSuccess: 'ការវាយតម្លៃរបស់អ្នកត្រូវបានដាក់ស្នើដោយជោគជ័យ!',
    editReview: 'កែសម្រួលការវាយតម្លៃ',
    retry: 'ព្យាយាមម្តងទៀត',
    loginRequiredToReview: 'សូមចូលគណនីជាមុនសិនដើម្បីសរសេរការវាយតម្លៃ',
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

    step2Of3: 'ステップ 2 / 3',
    whatDoYouLikeTitle: '何が好きですか？',
    whatDoYouLikeSubtitle: 'あなたの選択がぴったりの場所を見つける手助けになります。',
    continueBtn: '続ける  ←',
    whyGoingOutTitle: '今日はどんなお出かけですか？',
    whyGoingOutSubtitle: '目的に合わせておすすめの場所をご案内します。',
    showSuitablePlaces: 'おすすめの場所を見る',
    specialtyCoffee: 'スペシャルティコーヒー',
    study: '勉強',
    work: '仕事',
    quietChill: '静かに過ごす',
    birthday: '誕生日',
    date: 'Date',
    withFriends: '友達と',
    friendsOuting: '友達とのお出かけ',
    nileView: 'リバービュー',
    chillSitting: 'のんびり',
    quickCoffee: 'クイックコーヒー',
    placeWithView: '景色の良い場所',
    navHome: 'ホーム',
    navMap: 'マップ',
    navMyLists: 'マイリスト',
    navMyAccount: 'マイアカウント',
    loadingPreferences: '設定を読み込み中...',
    preferencesSavedSuccess: '好みが正常に保存されました！',
    selectAtLeastOneInterest: '続行するには少なくとも1つの項目を選択してください',
    selectFavoriteInterests: 'お気に入りの項目を選択してください',
    selectGoingOutReason: '本日のお出かけ理由を選択してください',
    toastSuccess: '成功',
    toastError: 'エラー',

    // Favorites & Reviews JA
    places: '場所',
    products: '商品',
    noFavoritesYet: 'お気に入りはまだありません',
    reviewsAndRatings: '評価とレビュー',
    basedOn: 'に基づく',
    ratingsCountSuffix: '件の評価',
    writeYourReview: 'レビューを書く',
    coffee: 'コーヒー',
    atmosphere: '雰囲気',
    service: 'サービス',
    all: 'すべて',
    withPhotos: '写真付き',
    highestRating: '最高評価',
    helpful: '役に立った',
    noReviewsYet: 'レビューはまだありません',
    submitReview: 'レビューを送信',
    yourRating: 'あなたの評価',
    writeReviewHint: 'ここに感想や体験を入力してください...',
    ratingRequired: '星の評価を選択してください',
    commentRequired: 'レビューコメントを入力してください',
    reviewSubmittedSuccess: 'レビューが正常に送信されました！',
    editReview: 'レビューを編集',
    retry: '再試行',
    loginRequiredToReview: 'レビューを書くにはログインしてください',
  };
}