import 'package:streamit_laravel/configs.dart';

import 'languages.dart';

class LanguageAr extends BaseLanguage {
  @override
  String get language => 'لغة';

  @override
  String get badRequest => '400: طلب سيء';

  @override
  String get forbidden => '403: ممنوع';

  @override
  String get pageNotFound => '404: الصفحة غير موجودة';

  @override
  String get tooManyRequests => '429:طلبات كثيرة جداً';

  @override
  String get internalServerError => '500: خطأ داخلي في الخادم';

  @override
  String get badGateway => '502 مدخل غير صالح';

  @override
  String get serviceUnavailable => '503: الخدمة غير متاحة';

  @override
  String get gatewayTimeout => '504: مهلة البوابة';

  @override
  String get gallery => 'معرض';

  @override
  String get camera => 'آلة تصوير';

  @override
  String get editProfile => 'تحرير الملف الشخصي';

  @override
  String get reload => 'إعادة تحميل';

  @override
  String get pressBackAgainToExitApp => 'اضغط مرة أخرى للخروج من التطبيق';

  @override
  String get invalidUrl => 'عنوان URL غير صالح';

  @override
  String get cancel => 'يلغي';

  @override
  String get delete => 'يمسح';

  @override
  String get demoUserCannotBeGrantedForThis =>
      'لا يمكن منح المستخدم التجريبي لهذا الإجراء';

  @override
  String get somethingWentWrong => 'حدث خطأ ما';

  @override
  String get yourInternetIsNotWorking => 'الإنترنت الخاص بك لا يعمل';

  @override
  String get profileUpdatedSuccessfully => 'تم تحديث الملف الشخصي بنجاح';

  @override
  String get likedSuccessfully => 'Liked successfully';

  @override
  String get unlikedSuccessfully => 'Unliked successfully';

  @override
  String get wouldYouLikeToSetProfilePhotoAs =>
      'هل ترغب في تعيين هذه الصورة كصورة ملفك الشخصي؟';

  @override
  String get yourConfirmPasswordDoesnT =>
      'تأكيد كلمة المرور الخاصة بك لا يتطابق مع كلمة المرور!';

  @override
  String get yes => 'نعم';

  @override
  String get submit => 'يُقدِّم';

  @override
  String get firstName => 'الاسم الأول';

  @override
  String get lastName => 'اسم العائلة';

  @override
  String get password => 'كلمة المرور';

  @override
  String get confirmPassword => 'تأكيد كلمة المرور';

  @override
  String get email => 'بريد إلكتروني';

  @override
  String get emailIsARequiredField => 'البريد الإلكتروني هو حقل مطلوب';

  @override
  String get pleaseEnterValidEmailAddress =>
      'يرجى إدخال عنوان بريد إلكتروني صالح!!';

  @override
  String get signIn => 'تسجيل الدخول';

  @override
  String get explore => 'يستكشف';

  @override
  String get settings => 'إعدادات';

  @override
  String get rateNow => 'قيم الآن';

  @override
  String get logout => 'تسجيل الخروج';

  @override
  String get rememberMe => 'تذكرنى';

  @override
  String get forgotPassword => 'هل نسيت كلمة السر؟';

  @override
  String get signUp => 'اشتراك';

  @override
  String get alreadyHaveAnAccount => 'هل لديك حساب بالفعل؟';

  @override
  String get deleteAccount => 'حذف الحساب';

  @override
  String get notifications => 'إشعارات';

  @override
  String get signInFailed => 'فشل تسجيل الدخول';

  @override
  String get logIn => 'تسجيل الدخول';

  @override
  String get stayTunedNoNew => 'ابقوا متابعين! لا توجد إشعارات جديدة.';

  @override
  String get noNewNotificationsAt =>
      'لا توجد إشعارات جديدة في الوقت الراهن. سنبقيك على اطلاع عندما يكون هناك تحديث';

  @override
  String get walkthroughTitle1 =>
      'شاهد على أي جهاز: استمتع بالمحتوى الخاص بنا أينما ذهبت!';

  @override
  String get walkthroughDesp1 => 'البث عبر جميع الأجهزة دون رسوم إضافية.';

  @override
  String get walkthroughTitle2 =>
      'التنزيل والانطلاق: يمكنك الوصول إلى المحتوى الخاص بك في أي مكان وفي أي وقت وعلى أي جهاز';

  @override
  String get walkthroughDesp2 =>
      'قم بتنزيل المحتوى والاستمتاع به أثناء التنقل، في أي مكان وفي أي وقت.';

  @override
  String get walkthroughTitle3 =>
      'استمتع بالحرية دون التزامات أو متاعب - انضم إلينا اليوم!';

  @override
  String get walkthroughDesp3 => 'انضم إلينا بدون أي متاعب وبدون عقود مطلوبة.';

  @override
  String get lblSkip => 'يتخطى';

  @override
  String get lblNext => 'التالي';

  @override
  String get lblGetStarted => 'ابدأ';

  @override
  String get optionTitle => 'اكتشف أفضل العروض مع الأنواع المخصصة لتفضيلاتك.';

  @override
  String get optionDesp =>
      'استكشف العروض المنسقة عبر الأنواع المصممة لتناسب تفضيلات المشاهدة الخاصة بك.';

  @override
  String get welcomeBackToStreamIt => 'مرحبًا بك مرة أخرى في $APP_NAME';

  @override
  String get weHaveEagerlyAwaitedYourReturn => 'لقد انتظرنا عودتك بفارغ الصبر.';

  @override
  String get dontHaveAnAccount => 'ليس لديك حساب؟ ';

  @override
  String get or => 'أو';

  @override
  String get linkSentToYourEmail => 'تم إرسال الرابط إلى بريدك الإلكتروني!';

  @override
  String get checkYourInboxAndChangePassword =>
      'تحقق من صندوق الوارد الخاص بك وقم بتغيير كلمة المرور';

  @override
  String get continues => 'يكمل';

  @override
  String get oTPVerification => 'التحقق من OTP';

  @override
  String get checkYourSmsInboxAndEnterTheCodeYouGet =>
      'تحقق من صندوق الوارد الخاص بالرسائل النصية القصيرة وأدخل الرمز الذي تلقيته.';

  @override
  String get weHaveSentVerificationCodeToMobileNumber =>
      'لقد أرسلنا رمز التحقق إلى رقم هاتفك المحمول. يرجى إدخاله للمتابعة.';

  @override
  String get didntGetTheOTP => 'لم تحصل على OTP؟';

  @override
  String get resendOTP => 'إعادة إرسال كلمة المرور لمرة واحدة';

  @override
  String youCanResendOTPIn(int seconds) =>
      'يمكنك إعادة إرسال OTP خلال $seconds';

  @override
  String get otpHasBeenResentToMobileNumber =>
      'تم إعادة إرسال OTP إلى رقم هاتفك المحمول';

  @override
  String get verify => 'يؤكد';

  @override
  String get clearAll => 'مسح الكل';

  @override
  String get notificationDeleted => 'تم حذف الإشعار';

  @override
  String get doYouWantToMarkAllNotificationAsRead =>
      'هل تريد مسح كافة الإخطارات؟';

  @override
  String get doYouWantToDeleteThisNotification => 'هل تريد حذف هذا الإشعار؟';

  @override
  String get successfully => 'بنجاح';

  @override
  String get userCancelled => 'تم إلغاء المستخدم';

  @override
  String get appleSigninIsNot => 'Apple SignIn غير متاح لجهازك';

  @override
  String get searchHere => 'ابحث هنا';

  @override
  String get noDataFound => 'لم يتم العثور على بيانات';

  @override
  String get subscribe => 'يشترك';

  @override
  String get subscribeToWatch => 'اشترك للمشاهدة';

  @override
  String get playNow => 'العب الآن';

  @override
  String get continueWatching => 'مواصلة المشاهدة ';

  @override
  String get noContinueWatchingTitle => 'لا يوجد محتوى للمتابعة';

  @override
  String get noContinueWatchingSubtitle => 'ابدأ مشاهدة المحتوى لعرضه هنا';

  @override
  String get shareYourThoughtsWithUs => 'شارك أفكارك معنا!';

  @override
  String get weValueYourOpinion => 'نحن نقدر رأيك! شارك بتعليقاتك معنا اليوم.';

  @override
  String get genres => 'الأنواع';

  @override
  String get trailer => 'جَرَّار';

  @override
  String get ua18 => 'ش/أ 18';

  @override
  String get watchNow => 'شاهد الآن';

  @override
  String get resume => 'استئناف';

  @override
  String get pause => 'إيقاف مؤقت';

  @override
  String get paused => 'متوقف مؤقتًا';

  @override
  String get cast => 'يلقي';

  @override
  String get directors => 'المديرين';

  @override
  String get reviews => 'التعليقات';

  @override
  String get viewAll => 'عرض الكل';

  @override
  String get rating => 'تصنيف';

  @override
  String get justNow => 'الآن';

  @override
  String get daysAgo => 'منذ أيام';

  @override
  String get yesterday => 'أمس';

  @override
  String get ago => 'منذ';

  @override
  String get min => 'دقيقة';

  @override
  String get hr => 'ساعة';

  @override
  String get s => 'ق';

  @override
  String get moreLikeThis => 'المزيد من هذا القبيل';

  @override
  String get rateThisMovie => 'قيم هذا الفيلم';

  @override
  String get rateThisTvShow => 'قيم هذا البرنامج التلفزيوني';

  @override
  String get yourReview => 'مراجعتك';

  @override
  String get edit => 'يحرر';

  @override
  String get close => 'يغلق';

  @override
  String get oppsLooksLikeYouReview =>
      'انتبه! يبدو أنك لم تقم بإضافة أي مراجعة بعد.';

  @override
  String get retry => 'أعد المحاولة';

  @override
  String get selectDownloadQuality => 'حدد جودة التنزيل';

  @override
  String get onlyOnWiFi => 'فقط على خدمة الواي فاي';

  @override
  String get download => 'تحميل';

  @override
  String get downloading => 'جاري التحميل...';

  @override
  String get downloaded => 'تم التنزيل';

  @override
  String moviesTvShowsOf(String name) => 'أفلام/مسلسلات $name';

  @override
  String reviewsOf(String name) => 'مراجعات $name';

  @override
  String get season => 'موسم';

  @override
  String get episode => 'حلقة ';

  @override
  String get watchlist => 'قائمة المشاهدة';

  @override
  String get removeFromWatchlist => 'إزالة من قائمة المشاهدة';

  @override
  String get searchMoviesShowsAndMore => 'ابحث عن الأفلام والعروض والمزيد';

  @override
  String get trendingMovies => 'الأفلام الرائجة ';

  @override
  String get comingSoon => 'قريباً';

  @override
  String get remindMe => 'ذكرني';

  @override
  String get remind => 'يتذكر';

  @override
  String get readLess => 'اقرأ أقل';

  @override
  String get readMore => '...اقرأ المزيد';

  @override
  String get liveTv => 'البث التلفزيوني المباشر';

  @override
  String get live => 'يعيش';

  @override
  String get profile => 'حساب تعريفي';

  @override
  String get expiringOn => 'تنتهي صلاحيته';

  @override
  String get updrade => 'يرقي';

  @override
  String get subscribeToEnjoyMore => 'اشترك لتستمتع أكثر';

  @override
  String get daysFreeTrail => 'اكتشف الميزات الحصرية اليوم';

  @override
  String get privacyPolicy => 'سياسة الخصوصية';

  @override
  String get helpSupport => 'دعم المساعدة';

  @override
  String get rateOurApp => 'قيّم تطبيقنا';

  @override
  String get rateOurAppSubtitle => 'قيّم تطبيقنا لدعمنا';

  @override
  String get appLanguage => 'لغة التطبيق';

  @override
  String get yourDownloads => 'التنزيلات الخاصة بك';

  @override
  String get subscriptionPlanDeviceConnected => 'خطة الاشتراك، الجهاز متصل';

  @override
  String get accountSettings => 'إعدادات الحساب';

  @override
  String get accountControl => 'التحكم في الحساب';

  @override
  String get parentalControlsSubtitle =>
      'تقييد الوصول إلى الملفات الشخصية للبالغين باستخدام رمز PIN';

  @override
  String get subscriptionAndRentals => 'الاشتراك والإيجارات';

  @override
  String deviceLimitMessage(String limit) =>
      'يمكنك استخدام ما يصل إلى $limit جهازًا في نفس الوقت.';

  @override
  String get videoCastingEnabled => 'تم تمكين بث الفيديو.';

  @override
  String get videoCastingDisabled => 'بث الفيديو غير متوفر.';

  @override
  String get adsWillBeShown => 'سيتم عرض الإعلانات';

  @override
  String get adsWillNotBeShown => 'لن يتم عرض الإعلانات';

  @override
  String get downloadResolution => 'دقة التنزيل';

  @override
  String get supportedDeviceType => 'نوع الجهاز المدعوم';

  @override
  String profileLimitMessage(String limit) =>
      'يمكنك إنشاء ما يصل إلى $limit ملفات تعريف في هذه الخطة لمستخدمين مختلفين.';

  @override
  String get transactionHistory => 'سجل المعاملات';

  @override
  String get transactionHistorySubtitle => 'إدارة سجل اشتراكك وتأجيرك';

  @override
  String get subscriptionHistorySubtitle =>
      'الوصول إلى سجلات دفعات الاشتراك الخاصة بك';

  @override
  String get rentalHistorySubtitle => 'الوصول إلى سجل مدفوعات الإيجار الخاص بك';

  @override
  String get kidsProfileCannotAccessSubscription =>
      'ميزات الاشتراك مقيدة لملفات تعريف الأطفال.';

  @override
  String get deviceManagement => 'إدارة الجهاز';

  @override
  String get accountAndActivation => 'الحساب والتفعيل';

  @override
  String get accountSectionTitle => 'الحساب';

  @override
  String get accountSectionSubtitle => 'إدارة الحساب والاشتراكات والإيجارات';

  @override
  String get activateTvWeb => 'تفعيل التلفاز والويب';

  @override
  String get activateTvWebSubtitle => 'ربط التلفاز والويب وإدارتهما';

  @override
  String get savedVideos => 'مقاطع الفيديو المحفوظة';

  @override
  String get myList => 'قائمتي';

  @override
  String get myListSubtitle => 'قائمتك للمشاهدة لاحقًا';

  @override
  String get pickUpWhereYouLeftOff => 'تابع من حيث توقفت';

  @override
  String get continueWatchingSubtitle => 'استأنف المشاهدة من حيث توقفت';

  @override
  String get rentals => 'الإيجارات';

  @override
  String get rentalsSubtitle => 'الوصول إلى أفلامك وعروضك المؤجرة';

  @override
  String get rentalsAndDownloads => 'الإيجارات والتنزيلات';

  @override
  String get yourRentals => 'إيجاراتك';

  @override
  String get noRentedContentFound => 'لم يتم العثور على محتوى مؤجر';

  @override
  String get noRentedContentSubtitle =>
      'استأجر الأفلام والمسلسلات والفيديوهات للوصول إليها فوراً هنا';

  @override
  String get autoUpdate => 'تحديث تلقائي';

  @override
  String get downloadOverWifiOnly => 'التنزيل عبر الواي فاي فقط';

  @override
  String get smartDelete => 'حذف ذكي';

  @override
  String get smartDeleteSubtitle => 'حذف المحتوى الذي تم تنزيله بعد الاكتمال';

  @override
  String get downloads => 'التنزيلات';

  @override
  String get downloadsSubtitle => 'عرض المحتوى غير المتصل وإدارته';

  @override
  String get settingsAndSupport => 'الإعدادات والدعم';

  @override
  String get settingsSubtitle => 'التحديثات واللغة والتنزيلات';

  @override
  String get helpSupportSubtitle =>
      'الأسئلة الشائعة، الشروط والأحكام وسياسة الخصوصية';

  @override
  String get appVersionPrefix => 'إصدار التطبيق';

  @override
  String get version => 'إصدار';

  @override
  String get registeredMobileNumber => 'पंजीकृत मोबाइल नंबर';

  @override
  String get otherDevices => 'أجهزة أخرى';

  @override
  String get yourDevice => 'جهازك';

  @override
  String get lastUsed => 'آخر استخدام';

  @override
  String get currentDevice => 'الجهاز الحالي';

  @override
  String get proceed => 'يتابع';

  @override
  String get allYourDataWill => 'سيتم حذف جميع بياناتك نهائيًا';

  @override
  String get deleteAccountPermanently => 'حذف الحساب نهائيا؟';

  @override
  String doYouWantToDeleteProfile(String profileName) =>
      'هل تريد حذف الملف الشخصي لـ $profileName؟';

  @override
  String shareYourThoughtsOnContent(String contentName, String type) =>
      'شارك أفكارك حول $contentName $type';

  @override
  String get mobileNumber => 'رقم الهاتف المحمول';

  @override
  String get verifyPin => 'التحقق من رمز PIN';

  @override
  String get downloadInvoice => 'تنزيل الفاتورة';

  @override
  String get saveChanges => 'حفظ التغييرات';

  @override
  String get startWatchingFromWhereYouLeftOff => 'ابدأ المشاهدة من حيث توقفت';

  @override
  String get troubleLoggingIn => 'مشكلة في تسجيل الدخول؟';

  @override
  String get getHelp => 'احصل على المساعدة';

  @override
  String get helpAndSupport => 'المساعدة والدعم';

  @override
  String get noHelpTopicsFound => 'لم يتم العثور على مواضيع الدعم';

  @override
  String get helpAndSupportTopicsSubtitle => 'ستظهر مواضيع الدعم والمساعدة هنا';

  @override
  String get yourWatchlistIsEmpty => 'قائمة المراقبة الخاصة بك فارغة';

  @override
  String get contentAddedToYourWatchlist =>
      'سيظهر هنا المحتوى المضاف إلى قائمة المراقبة الخاصة بك';

  @override
  String get add => 'يضيف';

  @override
  String get subscribeNowAndDiveInto => 'اشترك الآن وانغمس في البث اللامتناهي';

  @override
  String get pay => 'يدفع';

  @override
  String get next => 'التالي';

  @override
  String get subscription => 'الاشتراك';

  @override
  String get validUntil => 'صالحة حتى ';

  @override
  String get choosePaymentMethod => 'اختر طريقة الدفع';

  @override
  String get secureCheckoutInSeconds => 'عملية دفع آمنة بنسبة 100% في ثوانٍ';

  @override
  String get proceedPayment => 'المضي قدما في الدفع';

  @override
  String get paymentFailedMessage =>
      'تم إنهاء عملية الدفع. الرجاء المحاولة مرة أخرى إذا رغبت في المتابعة.';

  @override
  String get actors => 'الجهات الفاعلة';

  @override
  String get movies => 'أفلام';

  @override
  String get contentRestrictedAccess => '18+ وصول مقيد للمحتوى';

  @override
  String get areYou18Above => 'هل عمرك 18+ فما فوق؟';

  @override
  String get displayAClearProminentWarning =>
      'اعرض تحذيرًا واضحًا وبارزًا قبل الوصول إلى المحتوى، يفيد بأنه مخصص للبالغين.';

  @override
  String get all => 'الجميع';

  @override
  String get tVShows => 'البرامج التلفزيونية';

  @override
  String get videos => 'فيديوهات';

  @override
  String get newlyAdded => 'أضيفت حديثا';

  @override
  String get free => 'حر';

  @override
  String get phnRequiredText => 'رقم الجوال مطلوب';

  @override
  String get inputMustBeNumberOrDigit => 'يجب أن يكون الإدخال رقمًا أو رقمًا';

  @override
  String get dateOfBirth => 'تاريخ الميلاد';

  @override
  String get dateOfBirthRequired => 'تاريخ الميلاد مطلوب';

  @override
  String get whatYourMobileNo => 'ما هو رقم هاتفك المحمول';

  @override
  String get withAValidMobileNumberYouCanConnectWithStreamit =>
      'باستخدام رقم هاتف محمول صالح، يمكنك الاتصال بـstreamit';

  @override
  String get otpSentToYourSMS => 'تم إرسال OTP إلى الرسائل القصيرة الخاصة بك!';

  @override
  String get checkYourSmsInboxAndVerifyYoourMobile =>
      'تحقق من صندوق الوارد الخاص بك عبر الرسائل القصيرة وتحقق من رقم هاتفك المحمول';

  @override
  String get pleaseTryAgainAfterSomeTime =>
      'يرجى المحاولة مرة أخرى بعد مرور بعض الوقت. لقد استخدمت طلبات التحقق المتعددة!';

  @override
  String get pleaseEnterAValidCode =>
      'الرجاء إدخال كلمة المرور لمرة واحدة (OTP) صالحة';

  @override
  String get pleaseCheckYourMobileInternetConnection =>
      'يرجى التحقق من اتصالك بالإنترنت عبر الهاتف المحمول';

  @override
  String get error => 'خطأ';

  @override
  String get sorryCouldnFindYourSearch => 'عذرًا، لم أتمكن من العثور على بحثك!';

  @override
  String get trySomethingNew => 'جرب شيئًا جديدًا.';

  @override
  String get genresNotAvailable => 'الأنواع غير متوفرة!';

  @override
  String get downloadSuccessfully => 'تم التنزيل بنجاح';

  @override
  String get popularMovies => 'أفلام شعبية';

  @override
  String get confirm => 'يتأكد';

  @override
  String get doYouConfirmThisPlan => 'هل تؤكد خطة الاشتراك هذه: ';

  @override
  String get transactionFailed => 'فشلت الصفقة';

  @override
  String get transactionCancelled => 'تم إلغاء المعاملة';

  @override
  String get no => 'لا';

  @override
  String get lblChangeCountry => 'تغيير البلد';

  @override
  String get selectCountry => 'اختر الدولة';

  @override
  String get logOutAll => 'تسجيل الخروج الكل';

  @override
  String get taxIncluded => 'شامل الضريبة';

  @override
  String get bookNow => 'احجز الآن';

  @override
  String get firstNameIsRequiredField => 'الاسم الأول مطلوب';

  @override
  String get lastNameIsRequiredField => 'الاسم الأخير مطلوب';

  @override
  String get passwordIsRequired => 'كلمة المرور مطلوبة';

  @override
  String get oldPasswordIsRequired => 'كلمة المرور القديمة مطلوبة';

  @override
  String get passwordLengthRule => 'يجب أن تتكون كلمة المرور من 8 إلى 14 حرفًا';

  @override
  String get passwordUppercaseRule =>
      'يجب أن تحتوي كلمة المرور على حرف واحد كبير على الأقل';

  @override
  String get passwordLowercaseRule =>
      'يجب أن تحتوي كلمة المرور على حرف واحد صغير على الأقل';

  @override
  String get passwordSpecialCharacterRule =>
      'يجب أن تحتوي كلمة المرور على رمز خاص واحد على الأقل (@\$!%*?&)';

  @override
  String get passwordDigitRule =>
      'يجب أن تحتوي كلمة المرور على رقم واحد على الأقل';

  @override
  String get confirmPasswordIsRequired => 'تأكيد كلمة المرور أمر مطلوب';

  @override
  String get home => 'بيت';

  @override
  String get search => 'يبحث';

  @override
  String get mobileNumberIsRequired => 'رقم الجوال هو حقل مطلوب';

  @override
  String get youHaveAlreadyDownloadedThisMovie =>
      'لقد قمت بالفعل بتنزيل هذا الفيلم';

  @override
  String get imdb => 'موقع آي إم دي بي';

  @override
  String get mb => 'ميغابايت';

  @override
  String get stripePay => 'Stripe';

  @override
  String get razorPay => 'Razorpay';

  @override
  String get payStackPay => 'Paystack';

  @override
  String get paypalPay => 'Paypal';

  @override
  String get flutterWavePay => 'Fluttewave';

  @override
  String get cinetPay => 'CinetPay';

  @override
  String get lblCheckOutWithCinetPay => 'الدفع بواسطة CinetPay';

  @override
  String get contextNotFound => 'السياق غير موجود !!!!';

  @override
  String get verificationFailed => 'فشل التحقق';

  @override
  String get english => 'إنجليزي';

  @override
  String get hour => 'ساعة';

  @override
  String get minute => 'دقيقة';

  @override
  String get sec => 'ثانية';

  @override
  String get videoNotFound => 'لم يتم العثور على الفيديو!!';

  @override
  String get auto => 'آلي';

  @override
  String get recommended => 'مُستَحسَن';

  @override
  String get medium => 'واسطة';

  @override
  String get high => 'عالي';

  @override
  String get low => 'قليل';

  @override
  String get helpSetting => 'المساعدة والإعدادات';

  @override
  String get pleaseConfirmContent => 'يرجى تأكيد الوصول المقيد للمحتوى';

  @override
  String get toWatch => 'للمشاهدة';

  @override
  String get plan => 'يخطط';

  @override
  String get toThe => 'الى';

  @override
  String get noDeviceAvailable => 'لا توجد أجهزة متاحة';

  @override
  String get noItemsToContinueWatching => 'لا توجد عناصر لمواصلة المشاهدة';

  @override
  String get noItemsAddedToTheWatchlist =>
      'لم تتم إضافة أي عناصر إلى قائمة المراقبة';

  @override
  String get ok => 'نعم';

  @override
  String removeFromContinueWatchingTitle(String title, String typeLabel) =>
      'هل تريد إزالة $title $typeLabel من قائمة المتابعة المستمرة؟';

  @override
  String get addedToWatchList => 'تمت إضافة قائمة المشاهدة بنجاح';

  @override
  String get removedFromWatchList => 'تم حذف قائمة المشاهدة بنجاح';

  @override
  String get removeSelectedFromWatchList =>
      'هل تريد إزالة المحتوى المحدد من قائمة المشاهدة الخاصة بك؟';

  @override
  String get removedFromContinueWatch => 'متابعة المشاهدة المحذوفة بنجاح';

  @override
  String get pleaseEnterAValidMobileNo => 'الرجاء إدخال رقم جوال صالح';

  @override
  String get pleaseAddYourReview => 'الرجاء إضافة تقييمك';

  @override
  String get thisMovieIsCurrentlUnavailableToWatch =>
      'هذا الفيلم غير متاح حاليًا للمشاهدة';

  @override
  String get thisVideoIsCurrentlUnavailableToWatch =>
      'هذا الفيديو غير متاح حاليًا للمشاهدة';

  @override
  String get subscriptionHistory => 'تاريخ الاشتراك';

  @override
  String get type => 'يكتب';

  @override
  String get amount => 'كمية';

  @override
  String get cancelPlan => 'إلغاء الخطة';

  @override
  String get device => 'جهاز';

  @override
  String get clear => 'واضح';

  @override
  String get doYouWantToLogoutFrom => 'هل تريد تسجيل الخروج من';

  @override
  String get sAlphabet => 'س';

  @override
  String get eAlphabet => 'ه';

  @override
  String get viewMore => 'عرض المزيد';

  @override
  String get viewLess => 'عرض أقل';

  @override
  String get removeSelectedFromDownloads =>
      'هل تريد إزالة هذا من التنزيلات الخاصة بك';

  @override
  String get noPaymentMethodsFound => 'لم يتم العثور على طرق الدفع';

  @override
  String get save => 'يحفظ';

  @override
  String get completeProfile => 'أكمل ملفك الشخصي';

  @override
  String get completeProfileSubtitle => 'أخبرنا المزيد عن نفسك للبدء';

  @override
  String get getVerificationCode => 'الحصول على رمز التحقق';

  @override
  String get contentRating => 'تقييم المحتوى';

  @override
  String get profiles => 'الملفات الشخصية';

  @override
  String get addProfile => 'أضف الملف الشخصي';

  @override
  String get clearSearchHistoryConfirmation =>
      'هل تريد مسح سجل البحث الخاص بك؟';

  @override
  String get clearSearchHistorySubtitle =>
      'لا يمكن التراجع عن هذا الإجراء، وسيتم حذف جميع عمليات البحث السابقة نهائيًا.';

  @override
  String get searchingForDevice => 'البحث عن الأجهزة';

  @override
  String get screenCast => 'يلقي الشاشة';

  @override
  String get connectTo => 'الاتصال ب';

  @override
  String get disconnectFrom => 'قطع الاتصال من';

  @override
  String get signInWithGoogle => 'قم بتسجيل الدخول باستخدام جوجل';

  @override
  String get signInWithApple => 'تسجيل الدخول مع أبل';

  @override
  String get whoIsWatching => 'من يراقب؟';

  @override
  String get doYouWantTo => 'هل تريد مسح سجل البحث؟';

  @override
  String get mobile => 'متحرك';

  @override
  String get tablet => 'الكمبيوتر اللوحي ';

  @override
  String get tv => 'التلفزيون ';

  @override
  String get laptop => 'الكمبيوتر المحمول';

  @override
  String get supported => 'المدعومة';

  @override
  String get notSupported => 'غير مدعوم';

  @override
  String get freeMovies => 'أفلام مجانية';

  @override
  String get top10 => 'أعلى 10';

  @override
  String get latestMovies => 'أفلام صدرت حديثاً';

  @override
  String get topChannels => 'أهم القنوات';

  @override
  String get popularTvShows => 'البرامج التلفزيونية الشعبية';

  @override
  String get popularVideos => 'مقاطع الفيديو الأكثر مشاهدة';

  @override
  String get popularLanguages => 'اللغات الشعبية';

  @override
  String get trending => 'تتجه';

  @override
  String get trendingInYourCountry => 'تتجه في بلدك';

  @override
  String get favoriteGenres => 'الأنواع المفضلة';

  @override
  String get basedOnYourPreviousWatch => 'لأنك شاهدت';

  @override
  String get mostLiked => 'الأفلام الأكثر إعجابًا';

  @override
  String get mostViewed => 'أعلى الأفلام تقييماً على IMDB';

  @override
  String get yourFavoritePersonalities => 'شخصياتك المفضلة';

  @override
  String get name => 'اسم';

  @override
  String get enterName => 'أدخل الاسم';

  @override
  String get nameCannotBeEmpty => 'لا يمكن أن يكون الاسم فارغًا';

  @override
  String get update => 'تحديث';

  @override
  String get remove => 'يزيل';

  @override
  String get recentSearch => 'البحث الأخير';

  @override
  String get noRecentSearches => 'لا توجد عمليات بحث حديثة';

  @override
  String get chooseImageSource => 'اختر مصدر الصورة';

  @override
  String get noInternetAvailable => 'لا يوجد إنترنت متاح';

  @override
  String get goToYourDownloads => 'انتقل إلى التنزيلات الخاصة بك';

  @override
  String welcomeUserMessage(String appName, String name) =>
      "مرحبًا $name، أهلاً بك في $appName! تبدأ رحلتك إلى الترفيه غير المحدود الآن — انطلق واستمتع بالمشاهدة!";

  @override
  String get bySigningYouAgreeTo => 'بالتوقيع فإنك توافق على';

  @override
  String get lowQuality => 'جودة منخفضة';

  @override
  String get mediumQuality => 'جودة متوسطة';

  @override
  String get highQuality => 'جودة عالية';

  @override
  String get veryHighQuality => 'جودة عالية جدًا';

  @override
  String get ultraQuality => 'جودة فائقة';

  @override
  String get termsConditions => 'الشروط والأحكام';

  @override
  String get ofAll => 'للجميع';

  @override
  String get servicesAnd => 'الخدمات و ';

  @override
  String get newProfileAddedSuccessfully =>
      'تمت إضافة الملف الشخصي الجديد بنجاح';

  @override
  String get doYouWantToDeleteYourReview => 'هل تريد حذف رأيك؟';

  @override
  String get noSearchDataFound => 'لم يتم العثور على بيانات البحث';

  @override
  String get searchHistory => 'سجل البحث';

  @override
  String get youHaveBeenLoggedOutOfYourAccountOn =>
      'لقد تم تسجيل الخروج من حسابك على';

  @override
  String get faqs => 'الأسئلة الشائعة';

  @override
  String get termsOfUse => 'شروط الاستخدام';

  @override
  String get refundAndCancellationPolicy => 'سياسة الاسترداد والإلغاء';

  @override
  String get dataDeletionRequest => 'طلب حذف البيانات';

  @override
  String get aboutUs => 'معلومات عنا';

  @override
  String get total => 'المجموع';

  @override
  String get percentage => 'نسبة مئوية';

  @override
  String get fixed => 'مُثَبَّت';

  @override
  String get android => 'أندرويد';

  @override
  String get ios => 'دائرة الرقابة الداخلية';

  @override
  String get hindi => 'الهندية';

  @override
  String get arabic => 'عربي';

  @override
  String get french => 'فرنسي';

  @override
  String get german => 'الألمانية';

  @override
  String get noFAQsfound => 'لم يتم العثور على أسئلة متكررة';

  @override
  String get tax => 'ضريبة';

  @override
  String get downloadHasBeenStarted => 'لقد بدأ التنزيل';

  @override
  String get yourDeviceIsNot => 'جهازك غير مدعوم بالخطة الحالية';

  @override
  String get pleaseUpgradeToContinue =>
      'يرجى الترقية لمواصلة الاستمتاع بالخدمة';

  @override
  String get cancelled => 'تم الإلغاء';

  @override
  String get deactivated => 'معطّل';

  @override
  String get expired => 'منتهي الصلاحية';

  @override
  String get active => 'نشيط';

  @override
  String get connectToWIFI => 'يرجى الاتصال بالواي فاي';

  @override
  String get logoutAllConfirmation =>
      'هل تريد تسجيل الخروج من جميع الأجهزة الأخرى؟';

  @override
  String get logoutAllConfirmationMessage =>
      'لتطبيق حد الأجهزة الخاص بخطتك الجديدة، يجب عليك تسجيل الخروج من جميع الأجهزة فورًا.';

  @override
  String get changePasswordMessage =>
      'تم تحديث كلمة المرور الخاصة بك. يرجى تسجيل الدخول مرة أخرى للمتابعة.';

  @override
  String get share => 'يشارك';

  @override
  String get like => 'يحب';

  @override
  String get pip => 'نقطة';

  @override
  String get videoCast => 'يقذف';

  @override
  String get castingNotSupported => 'الإرسال غير مدعوم في الخطة الحالية.';

  @override
  String get left => "المتبقي";

  @override
  String get loginWithOtp => 'تسجيل الدخول باستخدام OTP';

  @override
  String get loginWithEmail => 'تسجيل الدخول باستخدام البريد الإلكتروني';

  @override
  String get createYourAccount => 'قم بإنشاء حسابك';

  @override
  String get changePassword => 'تغيير كلمة المرور';

  @override
  String get yourNewPasswordMust =>
      'يجب أن تكون كلمة المرور الجديدة مختلفة عن كلمة المرور السابقة';

  @override
  String get yourOldPasswordDoesnT =>
      'كلمة المرور القديمة الخاصة بك غير صحيحة!';

  @override
  String get yourNewPasswordDoesnT =>
      "كلمة المرور المؤكدة لا تتطابق مع كلمة المرور الجديدة!";

  @override
  String get oldAndNewPassword => 'كلمة المرور القديمة والجديدة هي نفسها.';

  @override
  String get yourPasswordHasBeen =>
      'تمت إعادة تعيين كلمة المرور الخاصة بك بنجاح';

  @override
  String get youCanNowLog =>
      'يمكنك الآن تسجيل الدخول إلى حسابك الجديد باستخدام كلمة المرور الجديدة';

  @override
  String get done => 'منتهي';

  @override
  String get oldPassword => 'كلمة المرور القديمة';

  @override
  String get newPassword => 'كلمة المرور الجديدة';

  @override
  String get confirmNewPassword => 'تأكيد كلمة المرور الجديدة';

  @override
  String get birthdayIsRequired => 'مطلوب عيد ميلاد';

  @override
  String get childrenSProfile => 'ملف تعريف الأطفال';

  @override
  String get madeForKidsUnder12 => 'مصنوعة للأطفال دون سن 12 عامًا';

  @override
  String get otpVerifiedFailed => 'فشل التحقق من OTP';

  @override
  String get otpVerifiedSuccessfully => 'تم التحقق من OTP بنجاح';

  @override
  String get otpSentSuccessfully =>
      'تم إرسال كلمة المرور لمرة واحدة (OTP) بنجاح';

  @override
  String get weHaveSentYouOTPOnYourRegisterEmailAddress =>
      'لقد أرسلنا لك OTP على عنوان بريدك الإلكتروني المسجل';

  @override
  String get otpVerification => 'التحقق من OTP';

  @override
  String get enterPIN => 'أدخل رقم التعريف الشخصي';

  @override
  String get enterYourNewParentalPinForYourKids =>
      'أدخل رقم التعريف الشخصي الجديد الخاص بأطفالك';

  @override
  String get enterYourOldParentalPinForYourKids =>
      'أدخل رقم التعريف الشخصي القديم الخاص بأطفالك';

  @override
  String get confirmPIN => 'تأكيد رقم التعريف الشخصي';

  @override
  String get setPIN => 'تعيين رقم التعريف الشخصي';

  @override
  String get changePIN => 'تغيير رقم التعريف الشخصي';

  @override
  String get parentalControl => 'الرقابة الأبوية';

  @override
  String get invalidPIN => 'رقم التعريف الشخصي غير صالح';

  @override
  String get kids => 'أطفال';

  @override
  String get enter4DigitParentalControlPIN =>
      'أدخل رقم التعريف الشخصي (PIN) الخاص بالرقابة الأبوية والمكون من 4 أرقام';

  @override
  String get parentalLock => 'قفل الوالدين';

  @override
  String get profileDeletedSuccessfully => 'تم حذف الملف الشخصي بنجاح';

  @override
  String get pinNotMatched => 'رقم التعريف الشخصي غير متطابق';

  @override
  String get pleaseEnterNewPIN => 'الرجاء إدخال رقم التعريف الشخصي الجديد';

  @override
  String get pleaseEnterOldPIN => 'الرجاء إدخال رقم التعريف الشخصي القديم';

  @override
  String get pleaseEnterConfirmPin => 'الرجاء إدخال تأكيد رقم التعريف الشخصي';

  @override
  String get codeWithColon => 'أدخل الرمز:';

  @override
  String get useThisCodeToGet => 'استخدم هذا الرمز للحصول على ';

  @override
  String get off => ' عن';

  @override
  String get expiryDate => 'تاريخ انتهاء الصلاحية: ';

  @override
  String get apply => 'يتقدم';

  @override
  String get coupons => 'كوبونات';

  @override
  String get enterCouponCode => 'أدخل رمز القسيمة';

  @override
  String get check => 'يفحص';

  @override
  String get allCoupons => 'جميع القسائم';

  @override
  String get oopsWeCouldnTFind =>
      'أُووبس! لم نتمكن من العثور على أي رموز قسيمة مطابقة';

  @override
  String doYouWantToRemoveCoupon(String name) => 'هل تريد إزالة قسيمة $name؟';

  @override
  String get noSubscriptionHistoryFound => 'لم يتم العثور على سجل الاشتراك';

  @override
  String get couponDiscount => 'خصم القسيمة ';

  @override
  String get linkTv => 'رابط التلفزيون';

  @override
  String get youHaveBeenLoggedOutSuccessfully => 'تم تسجيل خروجك بنجاح';

  @override
  String get rented => 'مستأجر';

  @override
  String get rent => 'إيجار';

  @override
  String get rentFor => 'إيجار ل';

  @override
  String get oneTime => 'مرة واحدة';

  @override
  String get oneTimeFor => 'مرة واحدة لـ';

  @override
  String rentedesc(int availableFor, int duration) =>
      'أمامك $availableFor ${availableFor > 1 ? 'أيام' : 'يوم'} لبدء المشاهدة بعد الاستئجار. سيكون لديك $duration ${duration > 1 ? 'أيام' : 'يوم'} لإنهاء المشاهدة بعد بدء البث.';

  @override
  String youCanWatchThis(int duration) =>
      'يمكنك مشاهدة هذا المحتوى عدة مرات خلال فترة $duration ${duration > 1 ? 'ائام' : 'يوم'}.';

  @override
  String get thisIsANonRefundable => 'هذه معاملة غير قابلة للاسترداد.';

  @override
  String get thisContentIsOnly =>
      'هذا المحتوى متاح للإيجار فقط وليس جزءًا من الاشتراك المميز.';

  @override
  String get youCanPlayYour =>
      'يمكنك تشغيل المحتوى الخاص بك على الأجهزة المدعومة.';

  @override
  String get validity => 'صحة';

  @override
  String get day => 'يوم';

  @override
  String get days => 'أيام';

  @override
  String get watchTime => 'وقت المشاهدة';

  @override
  String get hours => 'ساعات';

  @override
  String get week => 'أسبوع';

  @override
  String get weeks => 'أسابيع';

  @override
  String get month => 'شهر';

  @override
  String get months => 'أشهر';

  @override
  String get year => 'سنة';

  @override
  String get years => 'سنوات';

  @override
  String get byRentingYouAgreeToOur => 'من خلال الإيجار فإنك توافق على شروطنا';

  @override
  String get pleaseAgreeToThe =>
      'يرجى الموافقة على شروط الاستخدام قبل المتابعة.';

  @override
  String enjoyUntilDays(int days) => 'استمتع حتى $days أيام';

  @override
  String get beginWatching => 'ابدأ المشاهدة';

  @override
  String doYouConfirmThis(String movieName) => 'هل تؤكد استئجار $movieName؟';

  @override
  String get unlockedVideo => 'فيديو مفتوح';

  @override
  String get info => 'معلومات';

  @override
  String confirmDeleteDownload(String title) =>
      'هل تريد حذف $title من التنزيلات الخاصة بك؟';

  @override
  String get payPerView => 'دالدفع مقابل المشاهدة';

  @override
  String skipIn(int seconds) => 'تخطي في $seconds';

  @override
  String get newPinSuccessfullySaved =>
      'تم حفظ رقم التعريف الشخصي الجديد بنجاح';

  @override
  String get successfullyUpdated => 'تم التحديث بنجاح';

  @override
  String get defaultLabel => 'افتراضي';

  @override
  String get quality => 'جودة';

  @override
  String get audio => 'صوت';

  @override
  String get audioAndQuality => 'الصوت والجودة';

  @override
  String get subtitle => 'الترجمة الفرعية';

  @override
  String get skip => 'تخطي';

  @override
  String get skipIntro => 'تخطى المقدمة';

  @override
  String get nextEpisode => 'الحلقة التالية';

  @override
  String get rentDetails => 'تفاصيل الإيجار';

  @override
  String get rentalInfo => 'معلومات الاستئجار';

  @override
  String get pleaseSelectPaymentMethod => 'الرجاء اختيار طريقة الدفع.';

  @override
  String get tvLinkedSuccessfully => 'تم ربط التلفاز بنجاح!';

  @override
  String get cameraPermissionDenied =>
      'تم رفض إذن الكاميرا. يُرجى تفعيله من الإعدادات.';

  @override
  String get advertisement => 'إعلان';

  @override
  String get readyToCastToYourDevice =>
      'تأكد من تشغيل جهاز Chromecast وتوصيله بنفس شبكة Wi-Fi.';

  @override
  String get disconnect => 'يتصل';

  @override
  String get connect => 'قطع الاتصال';

  @override
  String get playOnTV => 'تشغيل على التلفزيون';

  @override
  String get castConnectInfo => 'جاهز للإرسال إلى جهازك';

  @override
  String get castSupportInfo =>
      'البث متاح فقط لمقاطع الفيديو من نوع URL أو HLS أو Local. لا يدعم البث صيغًا أخرى.';

  @override
  String doYouConfirmThisPlanWithPlanName(String planName) =>
      'هل تؤكد هذه الخطة $planName؟';

  @override
  String get pinVerifiedSuccessfully => 'تم التحقق من رقم التعريف الشخصي بنجاح';

  @override
  String get female => 'أنثى';

  @override
  String get male => 'ذكر';

  @override
  String get other => 'آخر';

  @override
  String get gender => 'جنس';

  @override
  String get rentalHistory => 'تاريخ الإيجار';

  @override
  String get noRentalHistoryFound => 'لم يتم العثور على تاريخ الإيجار';

  @override
  String get scanTvQrCode => 'مسح التلفاز والويب QR Code';

  @override
  String get successfullyRented => 'تم التأجير بنجاح';

  @override
  String get currentPlan => 'الخطة الحالية';

  @override
  String purchaseInfo1(int duration) =>
      'لديك $duration ${duration > 1 ? 'يومًا' : 'يوم'} لبدء المشاهدة بعد الشراء. صلاحية غير محدودة لإكمال المشاهدة بعد بدء البث.';

  @override
  String get purchaseInfo2 =>
      'يمكنك مشاهدة هذا المحتوى عدة مرات حتى فترة الانتهاء.';

  @override
  String get address => 'العنوان';

  @override
  String get subscriptionSuccessful => 'تم تفعيل الاشتراك';

  @override
  String get subscriptionSuccessfulSubtitle => 'اشتراكك نشط الآن';

  @override
  String get startEnjoyingContent =>
      'يمكنك الآن الاستمتاع بالبث المستمر غير المحدود وجميع الميزات المميزة';

  @override
  String get noGenresFound => 'لم يتم العثور على أنواع';

  @override
  String get noGenresAvailableSubtitle => 'لا توجد أنواع متاحة في الوقت الحالي';

  @override
  String get noSubscriptionPlans => 'لا توجد خطط اشتراك';

  @override
  String get noSubscriptionPlansSubtitle =>
      'لا تتوفر خطط اشتراك في الوقت الحالي';

  @override
  String get noContentFound => 'لم يتم العثور على محتوى';

  @override
  String get noContentMatchesFilter =>
      'لا يوجد محتوى يطابق معايير التصفية الخاصة بك';

  @override
  String get movie => 'فيلم';

  @override
  String get tvShow => 'مسلسل تلفزيوني';

  @override
  String get video => 'فيديو';

  @override
  String get episodes => 'حلقات';

  @override
  String get cancelSubscription => 'هل أنت متأكد أنك تريد إلغاء اشتراكك؟';

  @override
  String get coupanApplied => 'تم تطبيق القسيمة بنجاح';

  @override
  String get coupanRemoved => 'تم إزالة القسيمة بنجاح';

  @override
  String get controlYourDevices => "تحكم في أجهزتك";

  @override
  String resendOtpCountText(int count) =>
      'يمكنك إعادة إرسال رمز التحقق بعد $count ثانية.';

  @override
  String get comingSoonOn => 'قريباً في';

  @override
  String get noComingSoonContentAvailable => 'لا يوجد محتوى قادم متاح.';

  @override
  String get noComingSoonMovieAvailable => 'لا يوجد فيلم قادم متاح.';

  @override
  String get noComingSoonTvShowAvailable =>
      'لا يوجد برنامج تلفزيوني قادم متاح.';

  @override
  String get noComingSoonVideoAvailable => 'لا يوجد فيديو قادم متاح.';

  @override
  String get clips => 'مقاطع';

  @override
  String get noContentDetails => 'لا يوجد تفاصيل المحتوى';

  @override
  String get contentInformationIsNotAvailable => 'لا يوجد معلومات عن المحتوى';

  @override
  String get episodesAreNotAvailableYet => 'لا يوجد حلقات متاحة بعد';

  @override
  String get checkBackAgainShortly => 'تحقق مرة أخرى قريباً';

  @override
  String get stayTuned => 'ابق على اطلاع';

  @override
  String get weArePreparingExcitingEpisodesForThisSeason =>
      'نحن نحضر حلقات مثيرة لهذا الموسم';

  @override
  String get ad => 'إعلان';

  @override
  String get adsLoadingIn => 'تحميل الإعلانات';

  @override
  String get browseAndRentContentToWatchInstantly =>
      'تصفح واستأجر المحتوى للمشاهدة فوراً';

  @override
  String get byCreatingAnAccountYouAgreeTo => 'بإنشاء حسابك، توافق على شروطنا';

  @override
  String get categories => 'الفئات';

  @override
  String get channelInformationIsNotAvailable => 'لا يوجد معلومات عن القناة';

  @override
  String get chooseTheQualityForDownloadingThisContent =>
      'اختر الجودة لتحميل هذا المحتوى';

  @override
  String get deviceLogins => 'تسجيل الدخول على الأجهزة';

  @override
  String get downloadContentToWatchOffline =>
      'تحميل المحتوى للمشاهدة خارج الخط';

  @override
  String get inAppPurchase => 'الشراء من التطبيق';

  @override
  String get isAvailableInThisCategory => 'متاح في هذه الفئة';

  @override
  String get noCastOrCrewMembersAvailable => 'لا يوجد ممثلين أو مخرجين متاحين';

  @override
  String get noChannelDetails => 'لا يوجد تفاصيل القناة';

  @override
  String get noChannelsAreAvailableInThisCategory =>
      'لا يوجد قنوات متاحة في هذه الفئة';

  @override
  String get noChannelsFound => 'لا يوجد قنوات متاحة';

  @override
  String get noContentAvailableInThisGenre => 'لا يوجد محتوى متاح في هذا النوع';

  @override
  String get noContentInGenre => 'لا يوجد محتوى في هذا النوع';

  @override
  String get noDownloadsFound => 'لا يوجد تنزيلات متاحة';

  @override
  String get noLiveTvChannels => 'لا يوجد قنوات تلفزيونية مباشرة متاحة';

  @override
  String get noLiveTvChannelsAreCurrentlyAvailable =>
      'لا يوجد قنوات تلفزيونية مباشرة متاحة في الوقت الحالي';

  @override
  String noMoviesOrTvShowsFeaturing(String name) =>
      'لا يوجد أفلام أو برامج تلفزيونية متاحة لـ $name';

  @override
  String get noPayPerViewContent => 'لا يوجد محتوى متاح للدفع مقابل المشاهدة';

  @override
  String get noPeopleFound => 'لا يوجد منتسبين متاحين';

  @override
  String get noWatchlistFound => 'لا يوجد قائمة مشاهدة متاحة';

  @override
  String get ofAllServicesAnd => 'لجميع الخدمات والميزات';

  @override
  String get oneTimePurchase => 'الشراء لمرة واحدة';

  @override
  String get openSettings => 'افتح الإعدادات';

  @override
  String get paymentSuccessful => 'تم الدفع بنجاح';

  @override
  String get permissionNotGranted => 'تم رفض الإذن';

  @override
  String get popularSearches => 'البحث الشائع';

  @override
  String get resetPasswordLinkSentToYourEmail =>
      'سنرسل لك رابط إعادة تعيين كلمة المرور إلى بريدك الإلكتروني. فتح البريد الإلكتروني والنقر على الرابط لإعادة تعيين كلمة المرور مباشرة.';

  @override
  String get searchAgain => 'ابحث مرة أخرى';

  @override
  String get sendResetLink => 'إرسال رابط إعادة تعيين';

  @override
  String get skipAd => 'تخطي الإعلان';

  @override
  String get suggestedChannels => 'القنوات المقترحة';

  @override
  String get topGenre => 'الأنواع الأكثر مشاهدة';

  @override
  String get unableToLoadDownload => 'لا يمكن تحميل التنزيلات';

  @override
  String get uploadCustomProfileImage => 'رفع صورة ملف شخصي مخصصة';

  @override
  String get visitAdvertiser => 'زيارة المعلن';

  @override
  String get youCanNotRevertThisActionLater =>
      'لا يمكن التراجع عن هذا الإجراء لاحقاً';

  @override
  String get youDoNotHaveAccessToWatch =>
      'ليس لديك حق الوصول لمشاهدة هذا المحتوى';

  @override
  String get yourCurrentPlanSupports => 'يدعم الخطة الحالية';

  @override
  String get yourPaymentWasCompleted => 'تم إكمال الدفع';

  @override
  String get otherSections => 'الأقسام الأخرى';

  @override
  String get newPasswordRequired => 'كلمة المرور الجديدة مطلوبة';

  @override
  String get noMoviesAvailable => 'لا توجد أفلام متاحة';

  @override
  String get noTvShowsAvailable => 'لا توجد برامج تلفزيونية متاحة';

  @override
  String get noVideosAvailable => 'لا توجد مقاطع فيديو متاحة';

  @override
  String noContentAvailableInContentType(String content, String contentType) =>
      'لا يوجد $contentType متاح في $content';

  @override
  String get unableToDownloadFilePleaseTryAgainLater =>
      'تعذر تنزيل الملف. يرجى المحاولة مرة أخرى لاحقًا.';

  @override
  String sorryCouldntShareThis(String type) =>
      'عذرًا، لا يمكن مشاركة هذا $type';

  @override
  String errorWhileMonitoringDownloadUpdates(String error) =>
      'حدث خطأ أثناء مراقبة تحديثات التنزيل: $error';

  @override
  String get pleaseSelectACastingDeviceFirst => 'يرجى تحديد جهاز الإرسال أولاً';

  @override
  String get noVideoUrlAvailableForCasting => 'لا يوجد رابط فيديو متاح للإرسال';

  @override
  String get contentTypeNotAvailableForCasting =>
      'نوع المحتوى غير متاح للإرسال';

  @override
  String get invalidVideoUrlFormat => 'تنسيق رابط الفيديو غير صالح';

  @override
  String get failedInitiateRazorpayPayment =>
      'فشل بدء عملية الدفع عبر Razorpay';

  @override
  String cantFindPlanOnStore(String planName, String storeName) =>
      'لا يمكن العثور على $planName في $storeName';

  @override
  String get paymentNotCapturedContactSupport =>
      'لم يتم تأكيد الدفع. يرجى الاتصال بالدعم.';

  @override
  String get downloadDeletedSuccessfully => 'تم حذف التنزيل بنجاح!';

  @override
  String get pleaseSelectRating => 'يرجى اختيار التقييم';

  @override
  String get downloadsAllowedOnWifiOnly =>
      'التنزيلات مسموحة عبر شبكة Wi-Fi فقط. يرجى الاتصال بـ Wi-Fi أو تعطيل هذا الإعداد.';

  @override
  String get thisContentIsNotDownloadable =>
      'عذرًا! هذا المحتوى غير قابل للتنزيل';

  @override
  String get failedToStartDownload => 'فشل بدء التنزيل';

  @override
  String get failedToResumeDownload => 'فشل استئناف التنزيل';

  @override
  String get downloadCancelled => 'تم إلغاء التنزيل';

  @override
  String get downloadCompleted => 'اكتمل التنزيل';

  @override
  String get thePasswordDoesNotMatch => 'كلمة المرور غير متطابقة';

  @override
  String get deleteMultipleDownload =>
      'هل تريد حذف المحتوى المحدد من التنزيلات؟';

  @override
  String profileLimitIncreaseMessage({
    required String planName,
    required int limit,
  }) {
    final profileText = limit > 1 ? "ملفات شخصية" : "ملف شخصي";

    return "تسمح خطة $planName فقط بـ $limit $profileText. "
        "يرجى إزالة $profileText الإضافي للمتابعة.";
  }

  @override
  String get contectRestrictedForKidProfile =>
      'هذا المحتوى غير مسموح به في ملف الأطفال.';

  @override
  String get recommendedForYou => 'موصى به لك';

  @override
  String get shortDrama => 'دراما قصيرة';

  @override
  String get yourNextObsessionStartsHere => 'هوسك القادم يبدأ هنا';

  @override
  String get shortDramasIntenseStorytelling =>
      'دراما قصيرة، وسرد قصصي مكثف، ورومانسية عاطفية، وتقلبات مثيرة. اكتشف ترفيهًا مصممًا لكل حالة مزاجية.';

  @override
  String get exploreMore => 'استكشف المزيد';

  @override
  String get dramaForYou => 'دراما لك';

  @override
  String get noEpisodesAvailable => 'لا توجد حلقات متاحة';

  @override
  String get audioLanguage => 'لغة الصوت';

  @override
  String get cantPlayThisTitleRightNow => 'لا يمكن تشغيل هذا العنوان الآن';

  @override
  String get goBack => 'رجوع';

  @override
  String get unableToFindThisDramaForPlayback =>
      'تعذر العثور على هذه الدراما للتشغيل.';

  @override
  String get pleaseCheckYourConnectionAndTryAgain =>
      'يرجى التحقق من الاتصال وإعادة المحاولة.';

  @override
  String get seasons => 'مواسم';

  @override
  String get mute => 'كتم الصوت';

  @override
  String get unmute => 'إلغاء كتم الصوت';

  @override
  String get noInternetConnection => 'لا يوجد اتصال بالإنترنت';

  @override
  String get continueWatchingForYou => 'متابعة المشاهدة لك';

  @override
  String get playbackErrorGeneric => 'تعذر تشغيل هذه الحلقة في الوقت الحالي. يرجى المحاولة مرة أخرى.';
  
  @override
  String get playbackErrorSessionExpired => 'انتهت جلسة الدراما القصيرة. يرجى تسجيل الدخول مرة أخرى والمحاولة مرة أخرى.';
  
  @override
  String get playbackErrorTokenExpired => 'انتهت صلاحية رمز التشغيل. يرجى إعادة تشغيل هذه الحلقة.';
  
  @override
  String get playbackErrorVideoPluginUnavailable => 'ملحق مشغل الفيديو غير متاح. يرجى إعادة تشغيل التطبيق والمحاولة مرة أخرى.';

  @override
  String get less => 'أقل';

  @override
  String get more => 'قراءة المزيد';
}

