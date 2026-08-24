mixin AppLocale {
  // ===========================================================================
  // 1. Auth & General Keys
  // ===========================================================================
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
  static const String enterNameError = 'enterNameError';
  static const String passwordMinLengthError = 'passwordMinLengthError';
  static const String confirmPasswordRequiredError = 'confirmPasswordRequiredError';
  static const String passwordMismatchError = 'passwordMismatchError';
  static const String welcomeUserPrefix = 'welcomeUserPrefix';
  static const String resetLinkSentSuccess = 'resetLinkSentSuccess';
  static const String resetPasswordEmailSentDefault = 'resetPasswordEmailSentDefault';
  static const String verificationCodeNotFound = 'verificationCodeNotFound';
  static const String noLoggedInUserError = 'noLoggedInUserError';
  static const String googleSignInCancelled = 'googleSignInCancelled';
  static const String sendResetLink = 'sendResetLink';
  static const String backToLogin = 'backToLogin';
  static const String send = 'send';

  // OTP Keys
  static const String verifyPhoneTitle = 'verifyPhoneTitle';
  static const String otpSentToPhonePrefix = 'otpSentToPhonePrefix';
  static const String otpSentToDefault = 'otpSentToDefault';
  static const String enterCompleteOtpError = 'enterCompleteOtpError';
  static const String resendOtpInPrefix = 'resendOtpInPrefix';
  static const String resendOtpButton = 'resendOtpButton';
  static const String confirmButton = 'confirmButton';

  // ===========================================================================
  // 2. Discovery & Home Screen Keys
  // ===========================================================================
  static const String searchLocationHint = 'searchLocationHint';
  static const String nearbyCafes = 'nearbyCafes';
  static const String recommendedForYou = 'recommendedForYou';
  static const String topRated = 'topRated';
  static const String viewAll = 'viewAll';
  static const String openNow = 'openNow';
  static const String closedNow = 'closedNow';
  static const String distanceKm = 'distanceKm';
  static const String filter = 'filter';
  static const String allFilters = 'allFilters';
  static const String applyFilters = 'applyFilters';
  static const String resetFilters = 'resetFilters';

  // ===========================================================================
  // 3. Cafe Details Screen Keys
  // ===========================================================================
  static const String aboutCafe = 'aboutCafe';
  static const String menu = 'menu';
  static const String locationAndHours = 'locationAndHours';
  static const String openingHours = 'openingHours';
  static const String amenities = 'amenities';
  static const String bookTable = 'bookTable';
  static const String viewMenu = 'viewMenu';
  static const String callCafe = 'callCafe';
  static const String getDirections = 'getDirections';
  static const String shareCafe = 'shareCafe';
  static const String wifiAvailable = 'wifiAvailable';
  static const String outdoorArea = 'outdoorArea';
  static const String quietArea = 'quietArea';
  static const String parkingAvailable = 'parkingAvailable';
  static const String socketsAvailable = 'socketsAvailable';

  // ===========================================================================
  // 4. Booking Flow Keys
  // ===========================================================================
  static const String bookingTitle = 'bookingTitle';
  static const String selectDate = 'selectDate';
  static const String selectTime = 'selectTime';
  static const String selectGuestsCount = 'selectGuestsCount';
  static const String selectSeatingArea = 'selectSeatingArea';
  static const String selectOccasion = 'selectOccasion';
  static const String indoor = 'indoor';
  static const String outdoor = 'outdoor';
  static const String proceedToSummary = 'proceedToSummary';

  // ===========================================================================
  // 5. Checkout & Payment Keys
  // ===========================================================================
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

  // ===========================================================================
  // 6. Cart Screen Keys
  // ===========================================================================
  static const String cartTitle = 'cartTitle';
  static const String cartPickupOrder = 'cartPickupOrder';
  static const String orderNotesTitle = 'orderNotesTitle';
  static const String orderNotesHint = 'orderNotesHint';
  static const String cartSubtotal = 'cartSubtotal';
  static const String serviceFee = 'serviceFee';
  static const String proceedToCheckout = 'proceedToCheckout';
  static const String emptyCartTitle = 'emptyCartTitle';
  static const String emptyCartSubtitle = 'emptyCartSubtitle';
  static const String exploreMenu = 'exploreMenu';
  static const String itemAddedToCart = 'itemAddedToCart';
  static const String clearCart = 'clearCart';

  // ===========================================================================
  // 7. Pre-Order Screen Keys
  // ===========================================================================
  static const String preOrderMenuTitle = 'preOrderMenuTitle';
  static const String skipPreOrder = 'skipPreOrder';
  static const String temporaryTotal = 'temporaryTotal';
  static const String proceedToCart = 'proceedToCart';
  static const String itemsCount = 'itemsCount';
  static const String searchMenuPlaceholder = 'searchMenuPlaceholder';
  static const String allCategories = 'allCategories';
  static const String preOrder = 'preOrder';

  // ===========================================================================
  // 8. Confirmation Screen Keys
  // ===========================================================================
  static const String reservationConfirmedTitle = 'reservationConfirmedTitle';
  static const String reservationConfirmedDesc = 'reservationConfirmedDesc';
  static const String bookingNumber = 'bookingNumber';
  static const String cafe = 'cafe';
  static const String appointment = 'appointment';
  static const String details = 'details';
  static const String paidAmount = 'paidAmount';
  static const String backToHome = 'backToHome';
  static const String viewMyBookings = 'viewMyBookings';

  // ===========================================================================
  // 9. Digital Pass / Ticket Keys
  // ===========================================================================
  static const String digitalPassTitle = 'digitalPassTitle';
  static const String digitalPassSearchHint = 'digitalPassSearchHint';
  static const String addToCalendar = 'addToCalendar';
  static const String directions = 'directions';
  static const String scanQrAtEntrance = 'scanQrAtEntrance';
  static const String indoorSeating = 'indoorSeating';
  static const String outdoorSeating = 'outdoorSeating';
  static const String guestsSuffix = 'guestsSuffix';
  static const String reservationAddedToCalendar = 'reservationAddedToCalendar';

  // ===========================================================================
  // 10. Personalization Screen Keys
  // ===========================================================================
  static const String step2Of3 = 'step2Of3';
  static const String whatDoYouLikeTitle = 'whatDoYouLikeTitle';
  static const String whatDoYouLikeSubtitle = 'whatDoYouLikeSubtitle';
  static const String continueBtn = 'continueBtn';

  static const String whyGoingOutTitle = 'whyGoingOutTitle';
  static const String whyGoingOutSubtitle = 'whyGoingOutSubtitle';
  static const String showSuitablePlaces = 'showSuitablePlaces';

  static const String specialtyCoffee = 'specialtyCoffee';
  static const String study = 'study';
  static const String work = 'work';
  static const String quietChill = 'quietChill';
  static const String birthday = 'birthday';
  static const String romanticDate = 'romanticDate';
  static const String withFriends = 'withFriends';
  static const String friendsOuting = 'friendsOuting';
  static const String nileView = 'nileView';
  static const String chillSitting = 'chillSitting';
  static const String quickCoffee = 'quickCoffee';
  static const String placeWithView = 'placeWithView';

  static const String whatAreYourInterests = 'whatAreYourInterests';
  static const String interestsSubtitle = 'interestsSubtitle';
  static const String multiSelect = 'multiSelect';
  static const String singleSelect = 'singleSelect';
  static const String whatsYourMoodToday = 'whatsYourMoodToday';
  static const String chooseGeneralVibe = 'chooseGeneralVibe';
  static const String whatIsYourOccasion = 'whatIsYourOccasion';
  static const String selectOccasionType = 'selectOccasionType';

  // ===========================================================================
  // 11. AI Planner Keys
  // ===========================================================================
  static const String aiHeroSubtitle = 'aiHeroSubtitle';
  static const String aiPlanPromptTitle = 'aiPlanPromptTitle';
  static const String aiPlanPromptSubtitle = 'aiPlanPromptSubtitle';
  static const String aiInputEmptyPrompt = 'aiInputEmptyPrompt';
  static const String aiPromptFieldHint = 'aiPromptFieldHint';
  static const String aiQuickPicks = 'aiQuickPicks';
  static const String aiWhatsYourMood = 'aiWhatsYourMood';
  static const String aiPoweredBy = 'aiPoweredBy';
  static const String aiErrorTitle = 'aiErrorTitle';
  static const String aiErrorGeneric = 'aiErrorGeneric';
  static const String aiProcessingTitle = 'aiProcessingTitle';
  static const String aiProcessingFooterHint = 'aiProcessingFooterHint';
  static const String aiProcessingStep1 = 'aiProcessingStep1';
  static const String aiProcessingStep2 = 'aiProcessingStep2';
  static const String aiProcessingStep3 = 'aiProcessingStep3';
  static const String aiProcessingStep4 = 'aiProcessingStep4';
  static const String aiPlanReadyTitle = 'aiPlanReadyTitle';
  static const String placesCountText = 'placesCountText';
  static const String aiYourDayPlanTitle = 'aiYourDayPlanTitle';
  static const String aiPlanAnotherDay = 'aiPlanAnotherDay';
  static const String aiPlanMyDayButton = 'aiPlanMyDayButton';
  static const String aiDefaultHeadline = 'aiDefaultHeadline';
  static const String aiDefaultActivityTitle = 'aiDefaultActivityTitle';

  // AI Step Items
  static const String aiStepUnderstanding = 'aiStepUnderstanding';
  static const String aiStepSearchingPlaces = 'aiStepSearchingPlaces';
  static const String aiStepCheckingWeather = 'aiStepCheckingWeather';
  static const String aiStepBuildingItinerary = 'aiStepBuildingItinerary';

  // AI Activity Card
  static const String minutes = 'minutes';
  static const String viewPlace = 'viewPlace';
  static const String matchForYou = 'matchForYou';

  // AI Moods
  static const String moodCalm = 'moodCalm';
  static const String moodCheerful = 'moodCheerful';
  static const String moodRomantic = 'moodRomantic';
  static const String moodSocial = 'moodSocial';
  static const String moodProductive = 'moodProductive';

  // AI Controls
  static const String budget = 'budget';
  static const String hours = 'hours';
  static const String availableTime = 'availableTime';

  // AI Quick Picks
  static const String quickPickCoffee = 'quickPickCoffee';
  static const String quickPickStudy = 'quickPickStudy';
  static const String quickPickFood = 'quickPickFood';
  static const String quickPickDate = 'quickPickDate';
  static const String quickPickHangout = 'quickPickHangout';
  static const String iWantPrefix = 'iWantPrefix';

  // Weather Keys
  static const String weatherUnavailable = 'weatherUnavailable';
  static const String weatherSuitableOutdoor = 'weatherSuitableOutdoor';
  static const String weatherRainyIndoorPreferred = 'weatherRainyIndoorPreferred';

  // ===========================================================================
  // 12. Navigation, Lists & Favorites Keys
  // ===========================================================================
  static const String navHome = 'navHome';
  static const String navMap = 'navMap';
  static const String navMyLists = 'navMyLists';
  static const String navMyAccount = 'navMyAccount';

  static const String places = 'places';
  static const String products = 'products';
  static const String noFavoritesYet = 'noFavoritesYet';

  // ===========================================================================
  // 13. Reviews & Ratings Keys
  // ===========================================================================
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

  // ===========================================================================
  // 14. Toasts, Feedback & Error Messages Keys
  // ===========================================================================
  static const String toastSuccess = 'toastSuccess';
  static const String toastError = 'toastError';
  static const String paymentErrorTitle = 'paymentErrorTitle';
  static const String successTitle = 'successTitle';
  static const String reservationSuccessDesc = 'reservationSuccessDesc';
  static const String paymentFailedError = 'paymentFailedError';
  static const String walletValidationError = 'walletValidationError';
  static const String loginRequiredError = 'loginRequiredError';
  static const String loadingPreferences = 'loadingPreferences';
  static const String preferencesSavedSuccess = 'preferencesSavedSuccess';
  static const String selectAtLeastOneInterest = 'selectAtLeastOneInterest';
  static const String selectFavoriteInterests = 'selectFavoriteInterests';
  static const String selectGoingOutReason = 'selectGoingOutReason';

  // ===========================================================================
  // ARABIC (AR)
  // ===========================================================================
  static const Map<String, dynamic> AR = {
    // Auth
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
    enterNameError: 'يرجى إدخال الاسم الكامل',
    passwordMinLengthError: 'كلمة المرور يجب أن لا تقل عن 6 أحرف',
    confirmPasswordRequiredError: 'يرجى تأكيد كلمة المرور',
    passwordMismatchError: 'كلمتا المرور غير متطابقتين',
    welcomeUserPrefix: 'مرحباً بك',
    resetLinkSentSuccess: 'تم إرسال رابط إعادة التعيين بنجاح',
    resetPasswordEmailSentDefault: 'تم إرسال رابط إعادة تعيين كلمة المرور إلى بريدك الإلكتروني',
    verificationCodeNotFound: 'لم يتم العثور على رمز التحقق، يرجى إعادة الإرسال',
    noLoggedInUserError: 'لا يوجد مستخدم مسجل الدخول',
    googleSignInCancelled: 'تم إلغاء تسجيل الدخول عبر Google',
    sendResetLink: 'إرسال رابط الاستعادة',
    backToLogin: 'العودة لتسجيل الدخول',
    send: 'إرسال',
    verifyPhoneTitle: 'تأكيد رقم الموبايل',
    otpSentToPhonePrefix: 'أدخل الكود المرسل إلى',
    otpSentToDefault: 'أدخل الكود المرسل إلى رقمك.',
    enterCompleteOtpError: 'يرجى إدخال الرمز كاملاً (6 أرقام)',
    resendOtpInPrefix: 'إعادة إرسال الكود خلال',
    resendOtpButton: 'إعادة إرسال الكود',
    confirmButton: 'تأكيد',

    // Discovery & Details
    searchLocationHint: 'ابحث عن كافيه، منطقة أو مشروب...',
    nearbyCafes: 'كافيهات قريبة منك',
    recommendedForYou: 'ترشيحات مخصصة لك',
    topRated: 'الأعلى تقييماً',
    viewAll: 'عرض الكل',
    openNow: 'مفتوح الآن',
    closedNow: 'مغلق',
    distanceKm: 'كم',
    filter: 'تصفية',
    allFilters: 'جميع الفلاتر',
    applyFilters: 'تطبيق الفلاتر',
    resetFilters: 'إعادة ضبط',
    aboutCafe: 'عن الكافيه',
    menu: 'قائمة المشروبات والمأكولات',
    locationAndHours: 'الموقع ومواعيد العمل',
    openingHours: 'ساعات العمل',
    amenities: 'المميزات والخدمات',
    bookTable: 'حجز طاولة',
    viewMenu: 'عرض المنيو',
    callCafe: 'اتصال بالكافيه',
    getDirections: 'الاتجاهات عبر الخريطة',
    shareCafe: 'مشاركة الكافيه',
    wifiAvailable: 'واي فاي سريع',
    outdoorArea: 'جلسات خارجية',
    quietArea: 'أجواء هادئة للمذاكرة',
    parkingAvailable: 'موقف سيارات',
    socketsAvailable: 'أفياش كهرباء متوفرة',

    // Booking
    bookingTitle: 'حجز طاولة',
    selectDate: 'اختر التاريخ',
    selectTime: 'اختر الوقت',
    selectGuestsCount: 'عدد الضيوف',
    selectSeatingArea: 'مكان الجلوس المفضل',
    selectOccasion: 'نوع المناسبة',
    indoor: 'صالة داخلية',
    outdoor: 'صالة خارجية',
    proceedToSummary: 'المتابعة لملخص الحجز',

    // Checkout
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

    // Cart & PreOrder
    cartTitle: 'السلة',
    cartPickupOrder: 'طلب استلام من الفرع',
    orderNotesTitle: 'ملاحظات الطلب',
    orderNotesHint: 'أي ملاحظات؟',
    cartSubtotal: 'المجموع الفرعي',
    serviceFee: 'رسوم الخدمة',
    proceedToCheckout: 'متابعة للدفع',
    emptyCartTitle: 'السلة فارغة',
    emptyCartSubtitle: 'لم تقم بإضافة أي عناصر إلى السلة بعد',
    exploreMenu: 'استكشف القائمة',
    itemAddedToCart: 'تمت إضافة العنصر إلى السلة',
    clearCart: 'تفريغ السلة',
    preOrderMenuTitle: 'اطلب مسبقاً',
    skipPreOrder: 'تخطي الطلب المسبق',
    temporaryTotal: 'إجمالي المؤقت',
    proceedToCart: 'متابعة للسلة',
    itemsCount: 'منتجات',
    searchMenuPlaceholder: 'ابحث في القائمة...',
    allCategories: 'الكل',
    preOrder: 'اطلب مسبقاً',

    // Confirmation & Digital Pass
    reservationConfirmedTitle: 'تم تأكيد الحجز بنجاح!',
    reservationConfirmedDesc: 'تم إرسال تفاصيل الحجز والإشعار إلى حسابك',
    bookingNumber: 'رقم الحجز',
    cafe: 'الكافيه',
    appointment: 'الموعد',
    details: 'التفاصيل',
    paidAmount: 'المبلغ المدفوع',
    backToHome: 'العودة للرئيسية',
    viewMyBookings: 'عرض قائمة حجوزاتي',
    digitalPassTitle: 'التذكرة الرقمية',
    digitalPassSearchHint: 'ابحث بالاسم، المنطقة، أو نوع القهوة',
    addToCalendar: 'إضافة للتقويم',
    directions: 'الاتجاهات',
    scanQrAtEntrance: 'امسح الرمز عند الوصول للكافيه لتأكيد الدخول',
    indoorSeating: 'صالة داخلية',
    outdoorSeating: 'صالة خارجية',
    guestsSuffix: 'أفراد',
    reservationAddedToCalendar: 'تمت إضافة الحجز للتقويم بنجاح',

    // Personalization
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
    romanticDate: 'Date',
    withFriends: 'مع الأصحاب',
    friendsOuting: 'خروجة مع الأصحاب',
    nileView: 'إطلالة على النيل',
    chillSitting: 'قعدة هادية',
    quickCoffee: 'قهوة سريعة',
    placeWithView: 'مكان بإطلالة',
    whatAreYourInterests: 'ما هي اهتماماتك؟',
    interestsSubtitle: 'يمكنك اختيار أكثر من خيار للحصول على ترشيحات دقيقة',
    multiSelect: 'متعدد الاختيارات',
    singleSelect: 'اختيار فردي',
    whatsYourMoodToday: 'على مزاجك إيه النهاردة؟',
    chooseGeneralVibe: 'اختر الجو العام اللي بتفضله',
    whatIsYourOccasion: 'ما هي مناسبتك؟',
    selectOccasionType: 'حدد نوع الخروجة أو المناسبة الحالية',

    // AI Planner AR
    aiHeroSubtitle: 'سيب التخطيط عليّا 🤍',
    aiPlanPromptTitle: 'إيه اللي نفسك تعمله النهارده؟',
    aiPlanPromptSubtitle: 'احكيلي براحتك، وأنا هفهمك وأرتبلك اليوم على ذوقك.',
    aiInputEmptyPrompt: 'اكتبلي عايز تعمل إيه النهارده ✨',
    aiPromptFieldHint: 'مثلاً:\nعايزة أخرج مع صحابي النهارده، نبدأ بكافيه هادي وبعدها ناكل حاجة حلوة، والميزانية حوالي 500 جنيه.',
    aiQuickPicks: 'اختيارات سريعة',
    aiWhatsYourMood: 'إيه المود بتاعك؟',
    aiPoweredBy: 'Powered by Madinaty AI ✨',
    aiErrorTitle: 'مش قادر أجهزلك الخطة 😕',
    aiErrorGeneric: 'حصلت مشكلة بسيطة، جرّب تاني.',
    aiProcessingTitle: 'بجهزلك يومك المثالي ✨',
    aiProcessingFooterHint: 'بستخدم الأماكن الحقيقية القريبة منك وتفضيلاتك وحالة الجو النهارده.',
    aiProcessingStep1: 'بفهم طلبك وذوقك...',
    aiProcessingStep2: 'بدور على أحسن أماكن قريبة...',
    aiProcessingStep3: 'براجع حالة الجو النهارده...',
    aiProcessingStep4: 'بجهزلك اليوم المثالي...',
    aiPlanReadyTitle: 'جهزتلك الخطة 🎉',
    placesCountText: 'أماكن',
    aiYourDayPlanTitle: 'خطة يومك',
    aiPlanAnotherDay: 'خطط ليوم تاني',
    aiPlanMyDayButton: 'خططلي يومي ✨',
    aiDefaultHeadline: 'خطتك من مدينتي',
    aiDefaultActivityTitle: 'نشاط مقترح',
    aiStepUnderstanding: 'بفهم طلبك',
    aiStepSearchingPlaces: 'بدور على أماكن قريبة',
    aiStepCheckingWeather: 'براجع حالة الجو',
    aiStepBuildingItinerary: 'ببني خطتك والـ itinerary',
    minutes: 'دقيقة',
    viewPlace: 'شوف المكان',
    matchForYou: 'مناسب ليك',
    moodCalm: 'هادي',
    moodCheerful: 'فرفوش',
    moodRomantic: 'رومانسي',
    moodSocial: 'اجتماعي',
    moodProductive: 'منتج',
    budget: 'الميزانية',
    hours: 'ساعات',
    availableTime: 'الوقت المتاح',
    quickPickCoffee: 'قهوة',
    quickPickStudy: 'مذاكرة',
    quickPickFood: 'أكل',
    quickPickDate: 'دِيت',
    quickPickHangout: 'خروجة',
    iWantPrefix: 'عايز',
    weatherUnavailable: 'حالة الطقس غير متوفرة حالياً',
    weatherSuitableOutdoor: 'الجو مناسب ومثالي للخروجات المفتوحة.',
    weatherRainyIndoorPreferred: 'قد تؤثر الأمطار على الخطط الخارجية، يُفضل اختيار أماكن مغلقة.',

    // Navigation & Lists
    navHome: 'الرئيسية',
    navMap: 'الخريطة',
    navMyLists: 'قوائمي',
    navMyAccount: 'حسابي',
    places: 'الأماكن',
    products: 'المنتجات',
    noFavoritesYet: 'لا توجد عناصر في المفضلة حتى الآن',

    // Reviews
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

    // Toasts & Errors
    paymentErrorTitle: 'خطأ في عملية الدفع',
    successTitle: 'تم بنجاح',
    reservationSuccessDesc: 'تم تأكيد حجزك بنجاح!',
    paymentFailedError: 'فشلت عملية الدفع، يرجى المحاولة مرة أخرى أو اختيار طريقة دفع أخرى',
    walletValidationError: 'يرجى إدخال رقم محفظة إلكترونية صحيح (11 رقماً يبدأ بـ 01)',
    loginRequiredError: 'يرجى تسجيل الدخول أولاً لإتمام الحجز',
    loadingPreferences: 'جاري تحميل تفضيلاتك...',
    preferencesSavedSuccess: 'تم حفظ تفضيلاتك بنجاح!',
    selectAtLeastOneInterest: 'يرجى اختيار اهتمام واحد على الأقل للمتابعة',
    selectFavoriteInterests: 'يرجى اختيار اهتماماتك المفضلة',
    selectGoingOutReason: 'يرجى تحديد سبب الخروج اليوم',
    toastSuccess: 'نجاح',
    toastError: 'خطأ',
  };

  // ===========================================================================
  // ENGLISH (EN)
  // ===========================================================================
  static const Map<String, dynamic> EN = {
    // Auth
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
    enterNameError: 'Please enter your full name',
    passwordMinLengthError: 'Password must be at least 6 characters',
    confirmPasswordRequiredError: 'Please confirm your password',
    passwordMismatchError: 'Passwords do not match',
    welcomeUserPrefix: 'Welcome',
    resetLinkSentSuccess: 'Reset link sent successfully',
    resetPasswordEmailSentDefault: 'Password reset link has been sent to your email',
    verificationCodeNotFound: 'Verification code not found, please resend',
    noLoggedInUserError: 'No user is currently signed in',
    googleSignInCancelled: 'Google sign-in was cancelled',
    sendResetLink: 'Send Reset Link',
    backToLogin: 'Back to Login',
    send: 'Send',
    verifyPhoneTitle: 'Verify Phone Number',
    otpSentToPhonePrefix: 'Enter the code sent to',
    otpSentToDefault: 'Enter the code sent to your phone.',
    enterCompleteOtpError: 'Please enter the complete 6-digit code',
    resendOtpInPrefix: 'Resend code in',
    resendOtpButton: 'Resend Code',
    confirmButton: 'Confirm',

    // Discovery & Details
    searchLocationHint: 'Search for a cafe, area, or drink...',
    nearbyCafes: 'Nearby Cafes',
    recommendedForYou: 'Recommended for You',
    topRated: 'Top Rated',
    viewAll: 'View All',
    openNow: 'Open Now',
    closedNow: 'Closed',
    distanceKm: 'km',
    filter: 'Filter',
    allFilters: 'All Filters',
    applyFilters: 'Apply Filters',
    resetFilters: 'Reset',
    aboutCafe: 'About Cafe',
    menu: 'Menu',
    locationAndHours: 'Location & Hours',
    openingHours: 'Opening Hours',
    amenities: 'Amenities',
    bookTable: 'Book a Table',
    viewMenu: 'View Menu',
    callCafe: 'Call Cafe',
    getDirections: 'Get Directions',
    shareCafe: 'Share Cafe',
    wifiAvailable: 'Fast Wi-Fi',
    outdoorArea: 'Outdoor Seating',
    quietArea: 'Quiet Study Area',
    parkingAvailable: 'Parking Available',
    socketsAvailable: 'Power Sockets Available',

    // Booking
    bookingTitle: 'Book a Table',
    selectDate: 'Select Date',
    selectTime: 'Select Time',
    selectGuestsCount: 'Guests Count',
    selectSeatingArea: 'Seating Area',
    selectOccasion: 'Occasion Type',
    indoor: 'Indoor',
    outdoor: 'Outdoor',
    proceedToSummary: 'Proceed to Summary',

    // Checkout
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

    // Cart & PreOrder
    cartTitle: 'Shopping Cart',
    cartPickupOrder: 'Branch Pickup Order',
    orderNotesTitle: 'Order Notes',
    orderNotesHint: 'Any notes?',
    cartSubtotal: 'Subtotal',
    serviceFee: 'Service Fee',
    proceedToCheckout: 'Proceed to Checkout',
    emptyCartTitle: 'Your Cart is Empty',
    emptyCartSubtitle: 'You have not added any items yet',
    exploreMenu: 'Explore Menu',
    itemAddedToCart: 'Item added to cart',
    clearCart: 'Clear Cart',
    preOrderMenuTitle: 'Pre-Order Menu',
    skipPreOrder: 'Skip Pre-Order',
    temporaryTotal: 'Estimated Total',
    proceedToCart: 'Proceed to Cart',
    itemsCount: 'items',
    searchMenuPlaceholder: 'Search menu...',
    allCategories: 'All',
    preOrder: 'Pre-Order',

    // Confirmation & Digital Pass
    reservationConfirmedTitle: 'Reservation Confirmed Successfully!',
    reservationConfirmedDesc: 'Booking details and notification have been sent to your account',
    bookingNumber: 'Booking Number',
    cafe: 'Cafe',
    appointment: 'Appointment',
    details: 'Details',
    paidAmount: 'Paid Amount',
    backToHome: 'Back to Home',
    viewMyBookings: 'View My Bookings',
    digitalPassTitle: 'Digital Pass',
    digitalPassSearchHint: 'Search by name, area, or coffee type',
    addToCalendar: 'Add to Calendar',
    directions: 'Directions',
    scanQrAtEntrance: 'Scan QR at entrance to verify booking',
    indoorSeating: 'Indoor Seating',
    outdoorSeating: 'Outdoor Seating',
    guestsSuffix: 'Guests',
    reservationAddedToCalendar: 'Reservation added to calendar successfully',

    // Personalization
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
    romanticDate: 'Date',
    withFriends: 'With Friends',
    friendsOuting: 'Friends Outing',
    nileView: 'Nile View',
    chillSitting: 'Chill Sitting',
    quickCoffee: 'Quick Coffee',
    placeWithView: 'Place with a View',
    whatAreYourInterests: 'What are your interests?',
    interestsSubtitle: 'You can choose more than one option for accurate recommendations',
    multiSelect: 'Multiple Choice',
    singleSelect: 'Single Choice',
    whatsYourMoodToday: "What's your mood today?",
    chooseGeneralVibe: 'Choose the general vibe you prefer',
    whatIsYourOccasion: 'What is your occasion?',
    selectOccasionType: 'Specify the current outing or occasion type',

    // AI Planner EN
    aiHeroSubtitle: 'Leave the planning to me 🤍',
    aiPlanPromptTitle: 'What do you feel like doing today?',
    aiPlanPromptSubtitle: 'Tell me your vibe, and I will tailor the perfect day for you.',
    aiInputEmptyPrompt: 'Tell me what you would like to do today ✨',
    aiPromptFieldHint: 'e.g.:\nI want to go out with friends today, start with a cozy cafe, grab something sweet later, with a budget of around 500 EGP.',
    aiQuickPicks: 'Quick Picks',
    aiWhatsYourMood: "What's your mood?",
    aiPoweredBy: 'Powered by Madinaty AI ✨',
    aiErrorTitle: 'Unable to create your plan 😕',
    aiErrorGeneric: 'Something went wrong, please try again.',
    aiProcessingTitle: 'Crafting your perfect day ✨',
    aiProcessingFooterHint: 'Using real nearby places, your preferences, and today\'s weather forecast.',
    aiProcessingStep1: 'Understanding your taste & request...',
    aiProcessingStep2: 'Finding the best nearby spots...',
    aiProcessingStep3: 'Checking today\'s weather...',
    aiProcessingStep4: 'Crafting your perfect itinerary...',
    aiPlanReadyTitle: 'Your Plan is Ready 🎉',
    placesCountText: 'places',
    aiYourDayPlanTitle: 'Your Day Plan',
    aiPlanAnotherDay: 'Plan another day',
    aiPlanMyDayButton: 'Plan My Day ✨',
    aiDefaultHeadline: 'Your Madinaty Plan',
    aiDefaultActivityTitle: 'Suggested Activity',
    aiStepUnderstanding: 'Understanding your request',
    aiStepSearchingPlaces: 'Finding nearby spots',
    aiStepCheckingWeather: 'Checking weather forecast',
    aiStepBuildingItinerary: 'Building your itinerary',
    minutes: 'min',
    viewPlace: 'View Place',
    matchForYou: 'Match for you',
    moodCalm: 'Calm',
    moodCheerful: 'Cheerful',
    moodRomantic: 'Romantic',
    moodSocial: 'Social',
    moodProductive: 'Productive',
    budget: 'Budget',
    hours: 'hours',
    availableTime: 'Available Time',
    quickPickCoffee: 'Coffee',
    quickPickStudy: 'Study',
    quickPickFood: 'Food',
    quickPickDate: 'Date',
    quickPickHangout: 'Hangout',
    iWantPrefix: 'I want',
    weatherUnavailable: 'Weather unavailable',
    weatherSuitableOutdoor: 'Weather looks suitable for outdoor plans.',
    weatherRainyIndoorPreferred: 'Rain may affect outdoor plans. Indoor places are preferred.',

    // Navigation & Lists
    navHome: 'Home',
    navMap: 'Map',
    navMyLists: 'My Lists',
    navMyAccount: 'My Account',
    places: 'Places',
    products: 'Products',
    noFavoritesYet: 'No favorites yet',

    // Reviews
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

    // Toasts & Errors
    paymentErrorTitle: 'Payment Error',
    successTitle: 'Success',
    reservationSuccessDesc: 'Your reservation has been confirmed successfully!',
    paymentFailedError: 'Payment failed, please try again or choose another method',
    walletValidationError: 'Please enter a valid wallet number (11 digits starting with 01)',
    loginRequiredError: 'Please login first to complete your booking',
    loadingPreferences: 'Loading your preferences...',
    preferencesSavedSuccess: 'Your preferences have been saved successfully!',
    selectAtLeastOneInterest: 'Please select at least one interest to continue',
    selectFavoriteInterests: 'Please select your favorite interests',
    selectGoingOutReason: 'Please select the reason for going out today',
    toastSuccess: 'Success',
    toastError: 'Error',
  };

  // ===========================================================================
  // KHMER (KM)
  // ===========================================================================
  static const Map<String, dynamic> KM = {
    // Auth
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
    enterNameError: 'សូមបញ្ចូលឈ្មោះពេញរបស់អ្នក',
    passwordMinLengthError: 'ពាក្យសម្ងាត់ត្រូវតែមានយ៉ាងហោចណាស់ 6 តួអក្សរ',
    confirmPasswordRequiredError: 'សូមបញ្ជាក់ពាក្យសម្ងាត់របស់អ្នក',
    passwordMismatchError: 'ពាក្យសម្ងាត់មិនត្រូវគ្នាទេ',
    welcomeUserPrefix: 'សូមស្វាគមន៍',
    resetLinkSentSuccess: 'តំណកំណត់ឡើងវិញត្រូវបានផ្ញើដោយជោគជ័យ',
    resetPasswordEmailSentDefault: 'តំណកំណត់ពាក្យសម្ងាត់ឡើងវិញត្រូវបានផ្ញើទៅកាន់អ៊ីមែលរបស់អ្នក',
    verificationCodeNotFound: 'រកមិនឃើញលេខកូដផ្ទៀងផ្ទាត់ទេ សូមផ្ញើឡើងវិញ',
    noLoggedInUserError: 'មិនមានអ្នកប្រើប្រាស់បានចូលគណនីទេ',
    googleSignInCancelled: 'ការចូលតាម Google ត្រូវបានបោះបង់',
    sendResetLink: 'ផ្ញើតំណកំណត់ឡើងវិញ',
    backToLogin: 'ត្រឡប់ទៅចូលគណនីវិញ',
    send: 'ផ្ញើ',
    verifyPhoneTitle: 'ផ្ទៀងផ្ទាត់លេខទូរស័ព្ទ',
    otpSentToPhonePrefix: 'បញ្ចូលលេខកូដដែលបានផ្ញើទៅកាន់',
    otpSentToDefault: 'បញ្ចូលលេខកូដដែលបានផ្ញើទៅកាន់លេខទូរស័ព្ទរបស់អ្នក។',
    enterCompleteOtpError: 'សូមបញ្ចូលលេខកូដ 6 ខ្ទង់ឱ្យបានពេញលេញ',
    resendOtpInPrefix: 'ផ្ញើកូដឡើងវិញក្នុងរយៈពេល',
    resendOtpButton: 'ផ្ញើកូដឡើងវិញ',
    confirmButton: 'បញ្ជាក់',

    // Discovery & Details
    searchLocationHint: 'ស្វែងរកហាងកាហ្វេ តំបន់ ឬភេសជ្ជៈ...',
    nearbyCafes: 'ហាងកាហ្វេនៅក្បែរ',
    recommendedForYou: 'ណែនាំសម្រាប់អ្នក',
    topRated: 'ការវាយតម្លៃខ្ពស់បំផុត',
    viewAll: 'មើលទាំងអស់',
    openNow: 'បើកឥឡូវនេះ',
    closedNow: 'បិទ',
    distanceKm: 'គីឡូម៉ែត្រ',
    filter: 'តម្រង',
    allFilters: 'តម្រងទាំងអស់',
    applyFilters: 'អនុវត្តតម្រង',
    resetFilters: 'កំណត់ឡើងវិញ',
    aboutCafe: 'អំពីហាងកាហ្វេ',
    menu: 'ម៉ឺនុយ',
    locationAndHours: 'ទីតាំង និងម៉ោងដំណើរការ',
    openingHours: 'ម៉ោងបើក',
    amenities: 'សេវាកម្ម និងបរិក្ខារ',
    bookTable: 'កក់តុ',
    viewMenu: 'មើលម៉ឺនុយ',
    callCafe: 'ទូរស័ព្ទទៅហាង',
    getDirections: 'ទិសដៅផែនទី',
    shareCafe: 'ចែករំលែក',
    wifiAvailable: 'វ៉ាយហ្វាយលឿន',
    outdoorArea: 'កន្លែងអង្គុយខាងក្រៅ',
    quietArea: 'កន្លែងស្ងប់ស្ងាត់សម្រាប់រៀន',
    parkingAvailable: 'កន្លែងចតរថយន្ត',
    socketsAvailable: 'ព្រីភ្លើងមានស្រាប់',

    // Booking
    bookingTitle: 'កក់តុ',
    selectDate: 'ជ្រើសរើសកាលបរិច្ឆេទ',
    selectTime: 'ជ្រើសរើសពេលវេលា',
    selectGuestsCount: 'ចំនួនភ្ញៀវ',
    selectSeatingArea: 'តំបន់អង្គុយ',
    selectOccasion: 'ប្រភេទឱកាស',
    indoor: 'ខាងក្នុង',
    outdoor: 'ខាងក្រៅ',
    proceedToSummary: 'បន្តទៅសេចក្តីសង្ខេប',

    // Checkout
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

    // Cart & PreOrder
    cartTitle: 'កន្ត្រក',
    cartPickupOrder: 'ការបញ្ជាទិញទទួលពីសាខា',
    orderNotesTitle: 'កំណត់ចំណាំការបញ្ជាទិញ',
    orderNotesHint: 'មានកំណត់ចំណាំអ្វីទេ?',
    cartSubtotal: 'សរុបរង',
    serviceFee: 'ថ្លៃសេវា',
    proceedToCheckout: 'បន្តទៅការទូទាត់',
    emptyCartTitle: 'កន្ត្រករបស់អ្នកទទេ',
    emptyCartSubtitle: 'អ្នកមិនទាន់បានបន្ថែមទំនិញណាមួយនៅឡើយទេ',
    exploreMenu: 'រុករកម៉ឺនុយ',
    itemAddedToCart: 'ទំនិញត្រូវបានបន្ថែមទៅក្នុងកន្ត្រក',
    clearCart: 'សម្អាតកន្ត្រក',
    preOrderMenuTitle: 'ការបញ្ជាទិញទុកមុន',
    skipPreOrder: 'រំលងការបញ្ជាទិញទុកមុន',
    temporaryTotal: 'សរុបបណ្តោះអាសន្ន',
    proceedToCart: 'បន្តទៅកន្ត្រក',
    itemsCount: 'មុខទំនិញ',
    searchMenuPlaceholder: 'ស្វែងរកម៉ឺនុយ...',
    allCategories: 'ទាំងអស់',
    preOrder: 'ការបញ្ជាទិញទុកមុន',

    // Confirmation & Digital Pass
    reservationConfirmedTitle: 'ការកក់ត្រូវបានបញ្ជាក់ដោយជោគជ័យ!',
    reservationConfirmedDesc: 'ព័ត៌មានលម្អិត និងការជូនដំណឹងត្រូវបានផ្ញើទៅកាន់គណនីរបស់អ្នក',
    bookingNumber: 'លេខកក់',
    cafe: 'ហាងកាហ្វេ',
    appointment: 'ការណាត់ជួប',
    details: 'ព័ត៌មានលម្អិត',
    paidAmount: 'ចំនួនទឹកប្រាក់ដែលបានបង់',
    backToHome: 'ត្រឡប់ទៅទំព័រដើម',
    viewMyBookings: 'មើលបញ្ជីការកក់របស់ខ្ញុំ',
    digitalPassTitle: 'សំបុត្រឌីជីថល',
    digitalPassSearchHint: 'ស្វែងរកតាមឈ្មោះ តំបន់ ឬប្រភេទកាហ្វេ',
    addToCalendar: 'បន្ថែមទៅប្រតិទិន',
    directions: 'ទិសដៅ',
    scanQrAtEntrance: 'ស្កេន QR នៅច្រកចូលដើម្បីបញ្ជាក់ការកក់',
    indoorSeating: 'កន្លែងអង្គុយខាងក្នុង',
    outdoorSeating: 'កន្លែងអង្គុយខាងក្រៅ',
    guestsSuffix: 'នាក់',
    reservationAddedToCalendar: 'បានបន្ថែមការកក់ទៅក្នុងប្រតិទិនដោយជោគជ័យ',

    // Personalization
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
    romanticDate: 'Date',
    withFriends: 'ជាមួយមិត្តភក្តិ',
    friendsOuting: 'ដើរលេងជាមួយមិត្តភក្តិ',
    nileView: 'ទិដ្ឋភាពទន្លេ',
    chillSitting: 'អង្គុយលេង',
    quickCoffee: 'កាហ្វេរហ័ស',
    placeWithView: 'កន្លែងមានទិដ្ឋភាព',
    whatAreYourInterests: 'តើចំណាប់អារម្មណ៍របស់អ្នកជាអ្វី?',
    interestsSubtitle: 'អ្នកអាចជ្រើសរើសបានច្រើនជាងមួយជម្រើស',
    multiSelect: 'ជម្រើសច្រើន',
    singleSelect: 'ជម្រើសតែមួយ',
    whatsYourMoodToday: 'តើអារម្មណ៍របស់អ្នកយ៉ាងណាថ្ងៃនេះ?',
    chooseGeneralVibe: 'ជ្រើសរើសបរិយាកាសទូទៅ',
    whatIsYourOccasion: 'តើឱកាសរបស់អ្នកជាអ្វី?',
    selectOccasionType: 'បញ្ជាក់ប្រភេទនៃការចេញក្រៅ',

    // AI Planner KM
    aiHeroSubtitle: 'ទុកការរៀបចំផែនការឱ្យខ្ញុំ 🤍',
    aiPlanPromptTitle: 'តើអ្នកចង់ធ្វើអ្វីថ្ងៃនេះ?',
    aiPlanPromptSubtitle: 'ប្រាប់យើងពីអារម្មណ៍របស់អ្នក យើងនឹងរៀបចំថ្ងៃដ៏ល្អឥតខ្ចោះសម្រាប់អ្នក។',
    aiInputEmptyPrompt: 'សូមប្រាប់យើងពីអ្វីដែលអ្នកចង់ធ្វើថ្ងៃនេះ ✨',
    aiPromptFieldHint: 'ឧទាហរណ៍៖\nខ្ញុំចង់ចេញទៅក្រៅជាមួយមិត្តភក្តិថ្ងៃនេះ ចាប់ផ្តើមពីហាងកាហ្វេស្ងប់ស្ងាត់ បន្ទាប់មកញ៉ាំបង្អែម ជាមួយថវិកាប្រហែល 500 EGP។',
    aiQuickPicks: 'ជម្រើសរហ័ស',
    aiWhatsYourMood: 'តើអារម្មណ៍របស់អ្នកយ៉ាងណា?',
    aiPoweredBy: 'ដំណើរការដោយ Madinaty AI ✨',
    aiErrorTitle: 'មិនអាចបង្កើតគម្រោងរបស់អ្នកបានទេ 😕',
    aiErrorGeneric: 'មានបញ្ហាមួយចំនួនកើតឡើង សូមព្យាយាមម្តងទៀត។',
    aiProcessingTitle: 'កំពុងរៀបចំថ្ងៃដ៏ល្អឥតខ្ចោះរបស់អ្នក ✨',
    aiProcessingFooterHint: 'ប្រើប្រាស់ទីតាំងពិតប្រាកដនៅក្បែរអ្នក ចំណង់ចំណូលចិត្ត និងការព្យាករណ៍អាកាសធាតុថ្ងៃនេះ។',
    aiProcessingStep1: 'ស្វែងយល់ពីចំណង់ចំណូលចិត្តរបស់អ្នក...',
    aiProcessingStep2: 'កំពុងស្វែងរកកន្លែងល្អបំផុតនៅក្បែរ...',
    aiProcessingStep3: 'កំពុងពិនិត្យមើលអាកាសធាតុថ្ងៃនេះ...',
    aiProcessingStep4: 'កំពុងរៀបចំដំណើរកម្សាន្តដ៏ល្អឥតខ្ចោះ...',
    aiPlanReadyTitle: 'គម្រោងរបស់អ្នករួចរាល់ហើយ 🎉',
    placesCountText: 'ទីកន្លែង',
    aiYourDayPlanTitle: 'គម្រោងប្រចាំថ្ងៃរបស់អ្នក',
    aiPlanAnotherDay: 'រៀបចំគម្រោងសម្រាប់ថ្ងៃផ្សេងទៀត',
    aiPlanMyDayButton: 'រៀបចំថ្ងៃរបស់ខ្ញុំ ✨',
    aiDefaultHeadline: 'គម្រោង Madinaty របស់អ្នក',
    aiDefaultActivityTitle: 'សកម្មភាពដែលបានណែនាំ',
    aiStepUnderstanding: 'ស្វែងយល់ពីសំណើរបស់អ្នក',
    aiStepSearchingPlaces: 'កំពុងស្វែងរកកន្លែងនៅក្បែរ',
    aiStepCheckingWeather: 'កំពុងពិនិត្យអាកាសធាតុ',
    aiStepBuildingItinerary: 'កំពុងបង្កើតដំណើរកម្សាន្តរបស់អ្នក',
    minutes: 'នាទី',
    viewPlace: 'មើលកន្លែង',
    matchForYou: 'ស័ក្តិសមសម្រាប់អ្នក',
    moodCalm: 'ស្ងប់ស្ងាត់',
    moodCheerful: 'រីករាយ',
    moodRomantic: 'រ៉ូមែនទិក',
    moodSocial: 'សង្គម',
    moodProductive: 'មានផលិតភាព',
    budget: 'ថវិកា',
    hours: 'ម៉ោង',
    availableTime: 'ពេលវេលាដែលអាចរកបាន',
    quickPickCoffee: 'កាហ្វេ',
    quickPickStudy: 'រៀន',
    quickPickFood: 'អាហារ',
    quickPickDate: 'Date',
    quickPickHangout: 'ដើរលេង',
    iWantPrefix: 'ខ្ញុំចង់បាន',
    weatherUnavailable: 'មិនមានព័ត៌មានអាកាសធាតុទេ',
    weatherSuitableOutdoor: 'អាកាសធាតុអំណោយផលសម្រាប់គម្រោងក្រៅផ្ទះ។',
    weatherRainyIndoorPreferred: 'ភ្លៀងអាចប៉ះពាល់ដល់គម្រោងក្រៅផ្ទះ គួរជ្រើសរើសកន្លែងក្នុងផ្ទះ។',

    // Navigation & Lists
    navHome: 'ទំព័រដើម',
    navMap: 'ផែនទី',
    navMyLists: 'បញ្ជីរបស់ខ្ញុំ',
    navMyAccount: 'គណនីរបស់ខ្ញុំ',
    places: 'ទីកន្លែង',
    products: 'ផលិតផល',
    noFavoritesYet: 'មិនទាន់មានចំណូលចិត្តនៅឡើយទេ',

    // Reviews
    reviewsAndRatings: 'ការវាយតម្លៃ និងការពិនិត្យ',
    basedOn: 'ផ្អែកលើ',
    ratingsCountSuffix: 'ការវាយតម្លៃ',
    writeYourReview: 'សរសេរការវាយតម្លៃរបស់អ្នក',
    coffee: 'កាហ្វេ',
    atmosphere: 'បរិយាកាស',
    service: 'សេវាកម្ម',
    all: 'All',
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

    // Toasts & Errors
    paymentErrorTitle: 'កំហុសក្នុងការទូទាត់',
    successTitle: 'ជោគជ័យ',
    reservationSuccessDesc: 'ការកក់របស់អ្នកត្រូវបានបញ្ជាក់ដោយជោគជ័យ!',
    paymentFailedError: 'ការទូទាត់បានបរាជ័យ សូមព្យាយាមម្តងទៀត',
    walletValidationError: 'សូមបញ្ចូលលេខកាបូបឱ្យបានត្រឹមត្រូវ (11 ខ្ទង់ចាប់ផ្តើមដោយ 01)',
    loginRequiredError: 'សូមចូលគណនីជាមុនសិនដើម្បីបញ្ចប់ការកក់',
    loadingPreferences: 'កំពុងផ្ទុកចំណង់ចំណូលចិត្តរបស់អ្នក...',
    preferencesSavedSuccess: 'ចំណង់ចំណូលចិត្តរបស់អ្នកត្រូវបានរក្សាទុកដោយជោគជ័យ!',
    selectAtLeastOneInterest: 'សូមជ្រើសរើសចំណាប់អារម្មណ៍យ៉ាងហោចណាស់មួយដើម្បីបន្ត',
    selectFavoriteInterests: 'សូមជ្រើសរើសចំណាប់អារម្មណ៍ដែលអ្នកចូលចិត្ត',
    selectGoingOutReason: 'សូមជ្រើសរើសមូលហេតុនៃការចេញទៅក្រៅថ្ងៃនេះ',
    toastSuccess: 'ជោគជ័យ',
    toastError: 'កំហុស',
  };

  // ===========================================================================
  // JAPANESE (JA)
  // ===========================================================================
  static const Map<String, dynamic> JA = {
    // Auth
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
    enterNameError: 'フルネームを入力してください',
    passwordMinLengthError: 'パスワードは6文字以上で入力してください',
    confirmPasswordRequiredError: 'パスワードを再入力してください',
    passwordMismatchError: 'パスワードが一致しません',
    welcomeUserPrefix: 'ようこそ',
    resetLinkSentSuccess: 'リセットリンクが正常に送信されました',
    resetPasswordEmailSentDefault: 'パスワード再設定リンクをメールで送信しました',
    verificationCodeNotFound: '確認コードが見つかりません。再送信してください',
    noLoggedInUserError: 'ユーザーがログインしていません',
    googleSignInCancelled: 'Googleサインインがキャンセルされました',
    sendResetLink: 'リセットリンクを送信',
    backToLogin: 'ログインに戻る',
    send: '送信',
    verifyPhoneTitle: '電話番号の確認',
    otpSentToPhonePrefix: '送信先:',
    otpSentToDefault: 'ご登録の電話番号にコードを送信しました。',
    enterCompleteOtpError: '6桁のコードをすべて入力してください',
    resendOtpInPrefix: 'コードの再送信まで',
    resendOtpButton: 'コードを再送信',
    confirmButton: '確認',

    // Discovery & Details
    searchLocationHint: 'カフェ、エリア、ドリンクを検索...',
    nearbyCafes: '近くのカフェ',
    recommendedForYou: 'あなたへのおすすめ',
    topRated: '高評価のカフェ',
    viewAll: 'すべて見る',
    openNow: '営業中',
    closedNow: '営業時間外',
    distanceKm: 'km',
    filter: 'フィルター',
    allFilters: 'すべてのフィルター',
    applyFilters: '適用する',
    resetFilters: 'リセット',
    aboutCafe: '店舗情報',
    menu: 'メニュー',
    locationAndHours: '場所と営業時間',
    openingHours: '営業時間',
    amenities: '設備・サービス',
    bookTable: '席を予約する',
    viewMenu: 'メニューを見る',
    callCafe: '電話をかける',
    getDirections: 'ルート案内',
    shareCafe: 'シェアする',
    wifiAvailable: '高速Wi-Fi',
    outdoorArea: 'テラス席あり',
    quietArea: '静かな作業空間',
    parkingAvailable: '駐車場あり',
    socketsAvailable: '電源コンセントあり',

    // Booking
    bookingTitle: '席の予約',
    selectDate: '日付を選択',
    selectTime: '時間を選択',
    selectGuestsCount: '人数を選択',
    selectSeatingArea: '座席エリアを選択',
    selectOccasion: 'ご利用目的',
    indoor: '店内席',
    outdoor: 'テラス席',
    proceedToSummary: '予約内容の確認へ',

    // Checkout
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

    // Cart & PreOrder
    cartTitle: 'カート',
    cartPickupOrder: '店舗受取注文',
    orderNotesTitle: '注文メモ',
    orderNotesHint: 'ご要望など',
    cartSubtotal: '小計',
    serviceFee: 'サービス料',
    proceedToCheckout: 'お支払いに進む',
    emptyCartTitle: 'カートは空です',
    emptyCartSubtitle: '商品がまだ追加されていません',
    exploreMenu: 'メニューを見る',
    itemAddedToCart: 'カートに追加されました',
    clearCart: 'カートをクリア',
    preOrderMenuTitle: '事前注文メニュー',
    skipPreOrder: '事前注文をスキップ',
    temporaryTotal: '暫定合計',
    proceedToCart: 'カートに進む',
    itemsCount: '点',
    searchMenuPlaceholder: 'メニューを検索...',
    allCategories: 'すべて',
    preOrder: '事前注文',

    // Confirmation & Digital Pass
    reservationConfirmedTitle: '予約が完了しました！',
    reservationConfirmedDesc: '予約の詳細と通知をアカウントに送信しました',
    bookingNumber: '予約番号',
    cafe: 'カフェ',
    appointment: '予約日時',
    details: '詳細',
    paidAmount: 'お支払い金額',
    backToHome: 'ホームに戻る',
    viewMyBookings: '予約履歴を見る',
    digitalPassTitle: 'デジタルパス',
    digitalPassSearchHint: '店名、エリア、コーヒーの種類で検索',
    addToCalendar: 'カレンダーに追加',
    directions: 'ルート案内',
    scanQrAtEntrance: '来店時にQRコードを提示してください',
    indoorSeating: '店内席',
    outdoorSeating: 'テラス席',
    guestsSuffix: '名',
    reservationAddedToCalendar: '予約をカレンダーに追加しました',

    // Personalization
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
    romanticDate: 'Date',
    withFriends: '友達と',
    friendsOuting: '友達とのお出かけ',
    nileView: 'リバービュー',
    chillSitting: 'のんびり',
    quickCoffee: 'クイックコーヒー',
    placeWithView: '景色の良い場所',
    whatAreYourInterests: '興味のある項目は何ですか？',
    interestsSubtitle: 'より正確なおすすめのために複数選択できます',
    multiSelect: '複数選択',
    singleSelect: '単一選択',
    whatsYourMoodToday: '今日の気分は？',
    chooseGeneralVibe: 'お好みの雰囲気を選んでください',
    whatIsYourOccasion: 'どのような目的ですか？',
    selectOccasionType: 'お出かけの種類を指定してください',

    // AI Planner JA
    aiHeroSubtitle: 'プランニングはお任せください 🤍',
    aiPlanPromptTitle: '今日は何がしたいですか？',
    aiPlanPromptSubtitle: 'ご希望を教えていただければ、ぴったりのプランをご提案します。',
    aiInputEmptyPrompt: '今日したいことを入力してください ✨',
    aiPromptFieldHint: '例：\n今日は友達と出かけたいです。落ち着いたカフェから始めて、後でスイーツを食べたいです。予算は約500EGPです。',
    aiQuickPicks: 'クイック選択',
    aiWhatsYourMood: 'どんな気分ですか？',
    aiPoweredBy: 'Powered by Madinaty AI ✨',
    aiErrorTitle: 'プランを作成できませんでした 😕',
    aiErrorGeneric: '問題が発生しました。もう一度お試しください。',
    aiProcessingTitle: '最適な1日をプランニング中 ✨',
    aiProcessingFooterHint: '周辺の実際のスポット、お好み、今日の天気を考慮して作成しています。',
    aiProcessingStep1: '好みを理解しています...',
    aiProcessingStep2: '近くのおすすめスポットを検索中...',
    aiProcessingStep3: '今日の天気をチェック中...',
    aiProcessingStep4: '最適なプランを作成中...',
    aiPlanReadyTitle: 'プランが完成しました 🎉',
    placesCountText: 'スポット',
    aiYourDayPlanTitle: '1日のプラン',
    aiPlanAnotherDay: '別のプランを作成する',
    aiPlanMyDayButton: '1日のプランを作成 ✨',
    aiDefaultHeadline: 'マディナティプラン',
    aiDefaultActivityTitle: '提案されたアクティビティ',
    aiStepUnderstanding: 'ご要望を分析中',
    aiStepSearchingPlaces: '周辺スポットを検索中',
    aiStepCheckingWeather: '天気情報を確認中',
    aiStepBuildingItinerary: '旅程を作成中',
    minutes: '分',
    viewPlace: '店舗を見る',
    matchForYou: 'マッチ度',
    moodCalm: '穏やか',
    moodCheerful: '明るい',
    moodRomantic: 'ロマンチック',
    moodSocial: '社交的',
    moodProductive: '生産的',
    budget: '予算',
    hours: '時間',
    availableTime: '所要時間',
    quickPickCoffee: 'コーヒー',
    quickPickStudy: '勉強',
    quickPickFood: '食事',
    quickPickDate: 'Date',
    quickPickHangout: 'お出かけ',
    iWantPrefix: '希望:',
    weatherUnavailable: '天気情報が取得できません',
    weatherSuitableOutdoor: 'お出かけに適した天気です。',
    weatherRainyIndoorPreferred: '雨の可能性があるため、屋内施設をおすすめします。',

    // Navigation & Lists
    navHome: 'ホーム',
    navMap: 'マップ',
    navMyLists: 'マイリスト',
    navMyAccount: 'マイアカウント',
    places: '場所',
    products: '商品',
    noFavoritesYet: 'お気に入りはまだありません',

    // Reviews
    reviewsAndRatings: '評価とレビュー',
    basedOn: 'に基づく',
    ratingsCountSuffix: '件の評価',
    writeYourReview: 'レビューを書く',
    coffee: 'コーヒー',
    atmosphere: '雰囲気',
    service: 'サービス',
    all: 'All',
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

    // Toasts & Errors
    paymentErrorTitle: '決済エラー',
    successTitle: '成功',
    reservationSuccessDesc: '予約が正常に確定しました！',
    paymentFailedError: '決済に失敗しました。もう一度お試しください',
    walletValidationError: '有効な電話番号を入力してください（01から始まる11桁）',
    loginRequiredError: '予約を完了するにはログインしてください',
    loadingPreferences: '設定を読み込み中...',
    preferencesSavedSuccess: '好みが正常に保存されました！',
    selectAtLeastOneInterest: '続行するには少なくとも1つの項目を選択してください',
    selectFavoriteInterests: 'お気に入りの項目を選択してください',
    selectGoingOutReason: '本日のお出かけ理由を選択してください',
    toastSuccess: '成功',
    toastError: 'エラー',
  };
}