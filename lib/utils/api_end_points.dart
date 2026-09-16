class APIEndPoints {
  static const String appConfiguration = 'app-configuration';

  //Auth & User
  static const String register = 'register';
  static const String socialLogin = 'social-login';
  static const String login = 'login';
  static const String checkMobileNoExist = 'check-mobile-exists';
  static const String deviceLogout = 'device-logout';
  static const String deviceLogoutNoAuth = 'device-logout-data';
  static const String logOutAll = 'logout-all';
  static const String logOutAllNoAuth = 'logout-all-data';
  static const String changePassword = 'change-password';
  static const String forgotPassword = 'forgot-password';
  static const String deleteUserAccount = 'delete-account';

  static const String notificationList = 'notification-list';
  static const String deleteNotification = 'v3/delete-notification';

  //home choose service api
  static const String dashboardDetails = 'dashboard-detail';
  static const String notificationCount = 'notification-count';
  static const String dashboardDetailsOtherData = 'dashboard-detail-data';
  static const String genresDetails = 'genre-list';
  static const String actorDetails = 'castcrew-list';
  static const String watchList = 'watch-list';
  static const String deleteWatchList = 'delete-watchlist';
  static const String deleteDownloads = 'delete-download';
  static const String planLists = 'plan-list';
  static const String channelList = 'channel-list';
  static const String liveTvDashboard = 'livetv-dashboard';
  static const String liveTvDetails = 'livetv-details';
  static const String episodeList = 'episode-list';
  static const String movieDetails = 'movie-details';
  static const String saveRating = 'save-rating';
  static const String deleteRating = 'delete-rating';
  static const String saveDownload = 'save-download';
  static const String saveContinueWatch = 'save-continuewatch';
  static const String saveLikes = 'save-likes';
  static const String searchList = 'search-list';
  static const String searchContent = 'get-search';
  static const String comingSoon = 'coming-soon';
  static const String saveWatchlist = 'save-watchlist';
  static const String saveEntertainmentViews = 'save-entertainment-views';
  static const String profileDetails = 'profile-details';
  static const String accountSetting = 'account-setting';
  static const String reviewDetails = 'get-rating';
  static const String editProfile = 'update-profile';
  static const String saveReminder = 'save-reminder';
  static const String deleteReminder = 'delete-reminder';
  static const String saveSubscriptionDetails = 'save-subscription-details';
  static const String subscriptionHistory = 'user-subscription_histroy';
  static const String cancelSubscription = 'cancle-subscription';
  static const String pageList = 'page-list';

  // Continue Watching Api
  static const String continueWatchList = 'continuewatch-list';
  static const String deleteContinueWatch = 'delete-continuewatch';

  // watch profile
  static const String watchingProfileList = 'user-profile-list';
  static const String saveUserProfile = 'save-userprofile';
  static const String deleteWatchingProfile = 'delete-userprofile';

  // search
  static const String saveSearch = 'save-search';
  static const String deleteSearch = 'delete-search';
  static const String saveEntertainmentCompletedView = 'save-watch-content';
  static const String popularSearchList = 'popular-search-list';

  static const String faqList = 'faq-list';
  static const String bannerList = 'banner-data';
  static const String changePin = 'change-pin';
  static const String sendOtp = 'send-otp';
  static const String verifyOtp = 'verify-otp';
  static const String updateParentalLock = 'update-parental-lock';

  // Coupon Api
  static const String couponList = 'coupon-list';

  // QR Code Scan Link TV
  static const String linkTv = 'web-qr-scan';

  //Rental
  static const String rentedContentList = 'rented-content-list';
  static const String payPerViewList = 'pay-per-view-list';
  static const String startDate = 'start-date';
  static const String rentalHistory = 'transaction-history';
  static const String saveRentDetails = 'save-payment-pay-per-view';
  static const String downloadInvoice = 'download-invoice';
  static const String payPerViewInvoice = 'pay-per-view-invoice';
  static const String paymentMethod = 'payment-methods';
  static const String contentDetails = 'content-details';
  static const String contentList = 'content-list';
  static const String onboardingList = 'onboarding-data-list';
  static const String castDetails = 'cast-details';
}

class ApiRequestKeys {
  static const String allKey = 'all';
  static const String idKey = 'id';
  static const String channelKey = 'channel_id';
  static const String userIdKey = 'user_id';
  static const String profileIdKey = 'profile_id';
  static const String deviceIdKey = 'device_id';
  static const String deviceNameKey = 'device_name';
  static const String platformKey = 'platform';
  static const String isRestrictedKey = 'is_restricted';
  static const String isAuthenticatedKey = 'is_authenticated';
  static const String typeKey = 'type';
  static const String roleKey = 'role';
  static const String contentKey = 'content';
  static const String contentTypeKey = 'content_type';
  static const String bannerTypeKey = 'banner_for';
  static const String pageKey = 'page';
  static const String perPageKey = 'per_page';
  static const String seasonIdKey = 'season_id';
  static const String tvShowIdKey = 'tv_show_id';
  static const String entertainmentIdKey = 'entertainment_id';

  static const String releaseDateKey = 'release_date';
  static const String episodeIdKey = 'episode_id';
  static const String entertainmentTypeKey = 'entertainment_type';
  static const String isAjaxKey = 'is_ajax';
  static const String isLikeKey = 'is_like';
  static const String categoryIdKey = 'category_id';
  static const String downloadQualityKey = 'download_quality';
  static const String isRemindKey = 'is_remind';
  static const String searchKey = 'search';
  static const String searchQueryKey = 'search_query';
  static const String searchTypeKey = 'search_type';
  static const String searchIdKey = 'search_id';
  static const String accessKey = 'access';
  static String language = 'language';
  static String genreId = 'genre_id';

  static String directorKey = 'director';

  static String actorKey = 'actor';
  static String actorId = 'actor_id';
  static String directorId = 'director_id';

  static const String otpKey = 'otp';

  static const String pinKey = 'pin';

  static const String confirmPinKey = 'confirm_pin';

  //region Review Ratings
  static const String reviewKey = 'review';
  static const String ratingKey = 'rating';

  static const String sessionIdKey = 'session_id';

  //region User
  static String firstName = 'first_name';
  static String lastName = 'last_name';
  static String username = 'username';
  static String email = 'email';
  static String password = 'password';
  static String gender = 'gender';
  static String dateOfBirth = 'date_of_birth';
  static String address = 'address';
  static String confirmPassword = 'confirm_password';
  static String mobile = 'mobile';
  static String countryCode = 'country_code';
  static String oldPassword = 'old_password';
  static String newPassword = 'new_password';
  static String loginType = 'login_type';
  static String fileUrl = 'file_url';
  static String isDemoUser = 'is_demo_user';
  static String isParentalLockKey = 'is_parental_lock_enable';
  static String isReleasedKey = 'is_released';

  //endregion
  //region ContinueWatch
  static const String watchedTimeKey = 'watched_time';
  static const String totalWatchedTimeKey = 'total_watched_time';

  //endregion
  //region Subscription
  static const String planIdKey = 'plan_id';
  static const String identifierKey = 'identifier';
  static const String paymentStatusKey = 'payment_status';
  static const String paymentTypeKey = 'payment_type';
  static const String paymentDate = 'payment_date';
  static const String transactionIdKey = 'transaction_id';
  static const String couponIdKey = 'coupon_id';
  static const String couponCode = 'coupon_code';
  static const String activeInAppPurchaseIdentifierKey = 'active_in_app_purchase_identifier';

//endregion
}