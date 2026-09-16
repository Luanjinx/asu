import 'package:streamit_laravel/configs.dart';

import 'languages.dart';

class LanguageEn extends BaseLanguage {
  @override
  String get language => 'Language';

  @override
  String get badRequest => 'Bad Request';

  @override
  String get forbidden => 'Forbidden';

  @override
  String get pageNotFound => 'Page Not Found';

  @override
  String get tooManyRequests => 'Too Many Requests';

  @override
  String get internalServerError => 'Internal Server Error';

  @override
  String get badGateway => 'Bad Gateway';

  @override
  String get serviceUnavailable => '503: Service Unavailable';

  @override
  String get gatewayTimeout => '504: Gateway Timeout';

  @override
  String get gallery => 'Gallery';

  @override
  String get camera => 'Camera';

  @override
  String get editProfile => 'Edit Profile';

  @override
  String get reload => 'Reload';

  @override
  String get pressBackAgainToExitApp => 'Press back again to exit app';

  @override
  String get invalidUrl => 'Invalid URL';

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get demoUserCannotBeGrantedForThis =>
      'Demo user cannot be granted for this action';

  @override
  String get somethingWentWrong => 'Something Went Wrong';

  @override
  String get yourInternetIsNotWorking => 'Your internet is not working';

  @override
  String get profileUpdatedSuccessfully => 'Profile Updated Successfully';

  @override
  String get likedSuccessfully => 'Liked successfully';

  @override
  String get unlikedSuccessfully => 'Unliked successfully';

  @override
  String get wouldYouLikeToSetProfilePhotoAs =>
      'Would you like to set this picture as your profile photo?';

  @override
  String get yourConfirmPasswordDoesnT =>
      "Your confirm password doesn't match password!";

  @override
  String get yes => 'Yes';

  @override
  String get submit => 'Submit';

  @override
  String get firstName => 'First Name';

  @override
  String get lastName => 'Last Name';

  @override
  String get password => 'Password';

  @override
  String get confirmPassword => 'Confirm Password';

  @override
  String get email => 'Email';

  @override
  String get emailIsARequiredField => 'Email is a required field';

  @override
  String get pleaseEnterValidEmailAddress =>
      'Please enter a valid email address!!';

  @override
  String get signIn => 'Sign In';

  @override
  String get explore => 'Explore';

  @override
  String get settings => 'Settings';

  @override
  String get rateNow => 'Rate Now';

  @override
  String get logout => 'Logout';

  @override
  String get rememberMe => 'Remember Me';

  @override
  String get forgotPassword => 'Forgot Password?';

  @override
  String get signUp => 'Sign up';

  @override
  String get alreadyHaveAnAccount => 'Already have an account?';

  @override
  String get deleteAccount => 'Delete Account';

  @override
  String get notifications => 'Notifications';

  @override
  String get signInFailed => 'Sign in failed';

  @override
  String get logIn => 'Login';

  @override
  String get stayTunedNoNew => 'Stay tuned! No new notifications.';

  @override
  String get noNewNotificationsAt =>
      "No new notifications at the moment. We'll keep you posted when there's an update";

  @override
  String get walkthroughTitle1 =>
      'Watch on any device: Enjoy our content wherever you go!';

  @override
  String get walkthroughDesp1 =>
      'Stream across all devices without extra charges.';

  @override
  String get walkthroughTitle2 =>
      'Download and Go: Access Your Content Anywhere, Anytime, on Any Device';

  @override
  String get walkthroughDesp2 =>
      'Download & enjoy content on the go, anywhere, anytime.';

  @override
  String get walkthroughTitle3 =>
      'Enjoy Freedom Without Commitments or Hassles - Join Us Today!';

  @override
  String get walkthroughDesp3 =>
      'Join us hassle-free and no contracts required.';

  @override
  String get lblSkip => 'Skip';

  @override
  String get lblNext => 'Next';

  @override
  String get lblGetStarted => 'Get started';

  @override
  String get optionTitle =>
      'Discover top shows with genres tailored to your preferences.';

  @override
  String get optionDesp =>
      'Explore curated shows across genres tailored to suit your viewing preferences.';

  @override
  String get welcomeBackToStreamIt => 'Welcome Back to $APP_NAME!';

  @override
  String get weHaveEagerlyAwaitedYourReturn =>
      'We have eagerly awaited your return.';

  @override
  String get dontHaveAnAccount => 'Don’t have an account? ';

  @override
  String get or => 'OR';

  @override
  String get linkSentToYourEmail => 'Link sent to your Email!';

  @override
  String get checkYourInboxAndChangePassword =>
      'Check your inbox and change password';

  @override
  String get continues => 'Continue';

  @override
  String get oTPVerification => 'OTP verification';

  @override
  String get checkYourSmsInboxAndEnterTheCodeYouGet =>
      'Check your SMS Inbox and enter the code you recieved.';

  @override
  String get weHaveSentVerificationCodeToMobileNumber =>
      "We've sent a verification code to your mobile number. Please enter it to proceed.";

  @override
  String get didntGetTheOTP => "Didn't receive the OTP?";

  @override
  String get resendOTP => 'Resend OTP';

  @override
  String youCanResendOTPIn(int seconds) => 'You can resend the OTP in $seconds';

  @override
  String get otpHasBeenResentToMobileNumber =>
      'OTP has been resent to your mobile number';

  @override
  String get verify => 'Verify';

  @override
  String get clearAll => 'Clear All';

  @override
  String get notificationDeleted => 'Notification deleted';

  @override
  String get doYouWantToMarkAllNotificationAsRead =>
      'Do you want to clear all notifications?';

  @override
  String get doYouWantToDeleteThisNotification =>
      'Do you want to delete this notification?';

  @override
  String get successfully => 'Successfully';

  @override
  String get userCancelled => 'User cancelled';

  @override
  String get appleSigninIsNot =>
      'Apple SignIn is not available for your device';

  @override
  String get searchHere => 'Search Here';

  @override
  String get noDataFound => 'No Data Found';

  @override
  String get subscribe => 'Subscribe';

  @override
  String get subscribeToWatch => 'Subscribe to watch';

  @override
  String get playNow => 'Play Now';

  @override
  String get continueWatching => 'Continue watching';

  @override
  String get noContinueWatchingTitle => 'No Continue Watching';

  @override
  String get noContinueWatchingSubtitle =>
      'Start watching content to see it here';

  @override
  String get shareYourThoughtsWithUs => 'Share Your Thoughts with Us!';

  @override
  String get weValueYourOpinion =>
      'We value your opinion! Share your feedback with us today.';

  @override
  String get genres => 'Genres';

  @override
  String get trailer => 'TRAILER';

  @override
  String get ua18 => 'U/A 18';

  @override
  String get watchNow => 'Watch Now';

  @override
  String get resume => 'Resume';

  @override
  String get pause => 'Pause';

  @override
  String get paused => 'Paused';

  @override
  String get cast => 'Casts';

  @override
  String get directors => 'Directors';

  @override
  String get reviews => 'Reviews';

  @override
  String get viewAll => 'View All';

  @override
  String get rating => 'rating';

  @override
  String get justNow => 'Just now';

  @override
  String get daysAgo => 'days ago';

  @override
  String get yesterday => 'Yesterday';

  @override
  String get ago => 'ago';

  @override
  String get min => 'min';

  @override
  String get hr => 'hr';

  @override
  String get s => 's';

  @override
  String get moreLikeThis => 'More like this';

  @override
  String get rateThisMovie => 'Rate This Movie';

  @override
  String get rateThisTvShow => 'Rate This TV Show';

  @override
  String get yourReview => 'Your Review';

  @override
  String get edit => 'Edit';

  @override
  String get close => 'Close';

  @override
  String get oppsLooksLikeYouReview =>
      'Opps! looks like you have not added any review yet.';

  @override
  String get retry => 'Retry';

  @override
  String get selectDownloadQuality => 'Select download quality';

  @override
  String get onlyOnWiFi => 'Only on Wi-fi';

  @override
  String get download => 'Download';

  @override
  String get downloading => 'Downloading...';

  @override
  String get downloaded => 'Downloaded';

  @override
  String moviesTvShowsOf(String name) => 'Movies & TV Shows of $name';

  @override
  String reviewsOf(String name) => 'Reviews of $name';

  @override
  String get season => 'Season';

  @override
  String get episode => 'Episode ';

  @override
  String get watchlist => 'Watchlist';

  @override
  String get removeFromWatchlist => 'Remove from Watchlist';

  @override
  String get searchMoviesShowsAndMore => 'Search movies, tv shows and more';

  @override
  String get trendingMovies => 'Trending movies ';

  @override
  String get comingSoon => 'Coming soon';

  @override
  String get remindMe => 'Remind me';

  @override
  String get remind => 'Remind on';

  @override
  String get readLess => 'Read Less';

  @override
  String get readMore => '...Read More';

  @override
  String get liveTv => 'Live TV';

  @override
  String get live => 'Live';

  @override
  String get profile => 'Profile';

  @override
  String get expiringOn => 'Expiring on';

  @override
  String get updrade => 'Upgrade';

  @override
  String get subscribeToEnjoyMore => 'Subscribe to enjoy more';

  @override
  String get daysFreeTrail => 'Unlock Exclusive Features Today';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get helpSupport => 'Help Support';

  @override
  String get rateOurApp => 'Rate Our App';

  @override
  String get rateOurAppSubtitle => 'Rate our app to support us';

  @override
  String get appLanguage => 'Languages';

  @override
  String get yourDownloads => 'Your Downloads';

  @override
  String get subscriptionPlanDeviceConnected =>
      'Subscription plan, device connected';

  @override
  String get accountSettings => 'Account Settings';

  @override
  String get accountControl => 'Account Control';

  @override
  String get parentalControlsSubtitle =>
      'Restrict access to adult profiles with a pin';

  @override
  String get subscriptionAndRentals => 'Subscription & Rentals';

  @override
  String deviceLimitMessage(String limit) =>
      'You can use up to $limit device(s) simultaneously.';

  @override
  String get videoCastingEnabled => 'Video Casting is enabled.';

  @override
  String get videoCastingDisabled => 'Video Casting is not available.';

  @override
  String get adsWillBeShown => 'Ads will be shown';

  @override
  String get adsWillNotBeShown => 'Ads will not be shown';

  @override
  String get downloadResolution => 'Download Resolution';

  @override
  String get supportedDeviceType => 'Supported Device Type';

  @override
  String profileLimitMessage(String limit) =>
      'You can create up to $limit profiles on this plan for different users.';

  @override
  String get transactionHistory => 'Transaction History';

  @override
  String get transactionHistorySubtitle =>
      'Manage your subscription & rental history';

  @override
  String get subscriptionHistorySubtitle =>
      'Access your subscription payment records';

  @override
  String get rentalHistorySubtitle => 'Access your rental payment history';

  @override
  String get deviceManagement => 'Device Management';

  @override
  String get kidsProfileCannotAccessSubscription =>
      'Subscription features are restricted for kid profiles.';

  @override
  String get accountAndActivation => 'Account & Activation';

  @override
  String get accountSectionTitle => 'Account';

  @override
  String get accountSectionSubtitle =>
      'Manage account, subscriptions & rentals';

  @override
  String get activateTvWeb => 'Activate TV & Web';

  @override
  String get activateTvWebSubtitle => 'Control your TV & Web';

  @override
  String get savedVideos => 'Saved videos';

  @override
  String get myList => 'My List';

  @override
  String get myListSubtitle => 'Your watch-later list';

  @override
  String get pickUpWhereYouLeftOff => 'Pick up where you left off';

  @override
  String get continueWatchingSubtitle =>
      'Resume watching from where you left off';

  @override
  String get rentals => 'Rentals';

  @override
  String get rentalsSubtitle => 'Access your rented movies and shows';

  @override
  String get rentalsAndDownloads => 'Rentals and Downloads';

  @override
  String get yourRentals => 'Your Rentals';

  @override
  String get noRentedContentFound => 'No Rented Content Found';

  @override
  String get noRentedContentSubtitle =>
      'Rent Movies, Episode, and Videos to access them instantly here.';

  @override
  String get autoUpdate => 'Auto Update';

  @override
  String get downloadOverWifiOnly => 'Download over WI-FI only';

  @override
  String get smartDelete => 'Smart Delete';

  @override
  String get smartDeleteSubtitle =>
      'Delete downloaded content after completion';

  @override
  String get downloads => 'Downloads';

  @override
  String get downloadsSubtitle => 'View and manage your offline content';

  @override
  String get settingsAndSupport => 'Settings & Support';

  @override
  String get settingsSubtitle => 'Updates, language & downloads';

  @override
  String get helpSupportSubtitle =>
      'FAQ\'s, Terms & Conditions and Privacy Policy';

  @override
  String get appVersionPrefix => 'App Version';

  @override
  String get version => 'Version';

  @override
  String get registeredMobileNumber => 'Registered mobile number';

  @override
  String get otherDevices => 'Other Devices';

  @override
  String get yourDevice => 'Your Device';

  @override
  String get lastUsed => 'Last used';

  @override
  String get currentDevice => 'Current Device';

  @override
  String get proceed => 'Proceed';

  @override
  String get allYourDataWill => 'All your data will be permanently deleted';

  @override
  String get deleteAccountPermanently => 'Delete Account Permanently?';

  @override
  String doYouWantToDeleteProfile(String profileName) =>
      'Do you want to delete this $profileName profile ?';

  @override
  String shareYourThoughtsOnContent(String contentName, String type) =>
      'Share your thoughts on $contentName $type';

  @override
  String get mobileNumber => 'Mobile Number';

  @override
  String get verifyPin => 'Verify PIN';

  @override
  String get downloadInvoice => 'Download Invoice';

  @override
  String get saveChanges => 'Save changes';

  @override
  String get startWatchingFromWhereYouLeftOff =>
      'Start watching from where you left off';

  @override
  String get troubleLoggingIn => 'Trouble logging in?';

  @override
  String get getHelp => 'Get help';

  @override
  String get helpAndSupport => 'Help & Support';

  @override
  String get noHelpTopicsFound => 'No Help Topics Found';

  @override
  String get helpAndSupportTopicsSubtitle =>
      'Help and support topics will appear here';

  @override
  String get yourWatchlistIsEmpty => 'Your Watch list is empty';

  @override
  String get contentAddedToYourWatchlist =>
      'Content added to your Watch list will appear here';

  @override
  String get add => 'Add';

  @override
  String get subscribeNowAndDiveInto =>
      'Subscribe now and dive into endless streaming';

  @override
  String get pay => 'Pay';

  @override
  String get next => 'Next';

  @override
  String get subscription => 'Subscription';

  @override
  String get validUntil => 'Valid until ';

  @override
  String get choosePaymentMethod => 'Choose Payment Method';

  @override
  String get secureCheckoutInSeconds => '100% secure checkout in seconds';

  @override
  String get proceedPayment => 'Proceed Payment';

  @override
  String get paymentFailedMessage =>
      'Payment Terminated. Please try again if you wish to proceed.';

  @override
  String get actors => 'Actors';

  @override
  String get movies => 'Movies';

  @override
  String get contentRestrictedAccess => '18+ Content Restricted Access';

  @override
  String get areYou18Above => 'Are you 18+ above?';

  @override
  String get displayAClearProminentWarning =>
      "Display a clear & prominent warning before accessing the content, stating it's intended for mature audiences ";

  @override
  String get all => 'All';

  @override
  String get tVShows => 'TV Shows';

  @override
  String get videos => 'Videos';

  @override
  String get newlyAdded => 'Newly added';

  @override
  String get free => 'free';

  @override
  String get phnRequiredText => 'Mobile number is required';

  @override
  String get inputMustBeNumberOrDigit => 'Input must be number or digit';

  @override
  String get dateOfBirth => 'Date of birth';

  @override
  String get dateOfBirthRequired => 'Date of Birth is a required';

  @override
  String get whatYourMobileNo => "What's Your Mobile Number";

  @override
  String get withAValidMobileNumberYouCanConnectWithStreamit =>
      'With a valid mobile number you can connect with Streamit';

  @override
  String get otpSentToYourSMS => 'OTP Sent To Your SMS!';

  @override
  String get checkYourSmsInboxAndVerifyYoourMobile =>
      'Check your sms inbox and verify your mobile number';

  @override
  String get pleaseTryAgainAfterSomeTime =>
      'Please try again after some time. You have used multiple time verification requests!';

  @override
  String get pleaseEnterAValidCode =>
      'The OTP you entered is invalid. Please try again.';

  @override
  String get pleaseCheckYourMobileInternetConnection =>
      'Please check your mobile internet connection';

  @override
  String get error => 'Error';

  @override
  String get sorryCouldnFindYourSearch => "Sorry, Couldn't find your search!";

  @override
  String get trySomethingNew => 'Try something new.';

  @override
  String get genresNotAvailable => 'Genres Not Available!';

  @override
  String get downloadSuccessfully => 'Download Successfully';

  @override
  String get popularMovies => 'Popular movies';

  @override
  String get confirm => 'Confirm';

  @override
  String doYouWantToCancelDownloading(String name, String type) =>
      'Do you want to cancel downloading $name ($type)?';

  String get doYouConfirmThisPlan => 'Do you confirm this subscription plan ';

  @override
  String get transactionFailed => 'Transaction Failed';

  @override
  String get transactionCancelled => 'Transaction cancelled';

  @override
  String get no => 'No';

  @override
  String get lblChangeCountry => 'Change Country';

  @override
  String get selectCountry => 'Select Country';

  @override
  String get logOutAll => 'Logout All';

  @override
  String get taxIncluded => 'Tax Included';

  @override
  String get bookNow => 'Book Now';

  @override
  String get firstNameIsRequiredField => 'First name is a required';

  @override
  String get lastNameIsRequiredField => 'Last name is a required';

  @override
  String get passwordIsRequired => 'Password is required';

  @override
  String get oldPasswordIsRequired => 'Old password is required';

  @override
  String get passwordLengthRule => 'Password must be 8-14 characters long';

  @override
  String get passwordUppercaseRule =>
      'Password must contain at least one uppercase letter';

  @override
  String get passwordLowercaseRule =>
      'Password must contain at least one lowercase letter';

  @override
  String get passwordSpecialCharacterRule =>
      'Password must contain at least one special character (@\$!%*?&)';

  @override
  String get passwordDigitRule => 'Password must contain at least one digit';

  @override
  String get confirmPasswordIsRequired => 'Confirm Password is a required';

  @override
  String get home => 'Home';

  @override
  String get search => 'Search';

  @override
  String get mobileNumberIsRequired => 'Mobile Number is a required';

  @override
  String get youHaveAlreadyDownloadedThisMovie =>
      'You have already downloaded this movie';

  @override
  String get imdb => 'IMDB';

  @override
  String get mb => 'MB';

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
  String get lblCheckOutWithCinetPay => 'Checkout with CinetPay';

  @override
  String get contextNotFound => 'context not found!!!!';

  @override
  String get verificationFailed => 'Verification Failed';

  @override
  String get english => 'English';

  @override
  String get hour => 'hour';

  @override
  String get minute => 'minute';

  @override
  String get sec => 'sec';

  @override
  String get videoNotFound => 'Video Not Found!!';

  @override
  String get auto => 'Auto';

  @override
  String get recommended => 'Recommended';

  @override
  String get medium => 'Medium';

  @override
  String get high => 'High';

  @override
  String get low => 'Low';

  @override
  String get helpSetting => 'Help & Setting';

  @override
  String get pleaseConfirmContent => 'Please confirm content restricted access';

  @override
  String get toWatch => 'To Watch';

  @override
  String get plan => 'Plan';

  @override
  String get toThe => 'To The';

  @override
  String get noDeviceAvailable => 'No Devices Available';

  @override
  String get noItemsToContinueWatching => 'No items to continue watching';

  @override
  String get noItemsAddedToTheWatchlist => 'No items added to the Watch list';

  @override
  String get ok => 'Ok';

  @override
  String removeFromContinueWatchingTitle(String title, String typeLabel) =>
      'Do you want to remove the $title $typeLabel from your Continue Watching?';

  @override
  String get addedToWatchList => 'Watchlist added successfully';

  @override
  String get removedFromWatchList => 'Watchlist deleted successfully';

  @override
  String get removeSelectedFromWatchList =>
      'Do you want to remove selected content from your Watchlist?';

  @override
  String get removedFromContinueWatch => 'Continue watch deleted successfully';

  @override
  String get pleaseEnterAValidMobileNo => 'Please enter a valid mobile number';

  @override
  String get pleaseAddYourReview => 'Please add your rating';

  @override
  String get thisMovieIsCurrentlUnavailableToWatch =>
      'This movie is currently unavailable to watch';

  @override
  String get thisVideoIsCurrentlUnavailableToWatch =>
      'This video is currently unavailable to watch';

  @override
  String get subscriptionHistory => 'Subscription History';

  @override
  String get type => 'Type';

  @override
  String get amount => 'Amount';

  @override
  String get cancelPlan => 'Cancel Plan';

  @override
  String get device => 'Device';

  @override
  String get clear => 'Clear';

  @override
  String get doYouWantToLogoutFrom => 'Do you want to logout from ';

  @override
  String get sAlphabet => 'S';

  @override
  String get eAlphabet => 'E';

  @override
  String get viewMore => 'View More';

  @override
  String get viewLess => 'View Less';

  @override
  String get removeSelectedFromDownloads =>
      'Do you want to remove this from your downloads';

  @override
  String get noPaymentMethodsFound => 'No payment methods found';

  @override
  String get save => 'Save';

  @override
  String get completeProfile => 'Complete Your Profile';

  @override
  String get completeProfileSubtitle =>
      'Tell us more about yourself to get started';

  @override
  String get getVerificationCode => 'Get verification code';

  @override
  String get contentRating => 'Content Rating';

  @override
  String get profiles => 'Profiles';

  @override
  String get addProfile => 'Add Profile';

  @override
  String get clearSearchHistoryConfirmation =>
      'Do you want to clear your search history?';

  @override
  String get clearSearchHistorySubtitle =>
      'This action cannot be undone, and all previous searches will be permanently deleted.';

  @override
  String get searchingForDevice => 'Searching for devices';

  @override
  String get screenCast => 'Screen cast';

  @override
  String get connectTo => 'Connect to';

  @override
  String get disconnectFrom => 'Disconnect from';

  @override
  String get signInWithGoogle => 'Sign in with Google';

  @override
  String get signInWithApple => 'Sign in with Apple';

  @override
  String get whoIsWatching => 'Who is watching?';

  @override
  String get doYouWantTo => 'Do you want to clear search history?';

  @override
  String get mobile => 'Mobile ';

  @override
  String get tablet => 'Tablet ';

  @override
  String get tv => 'Tv ';

  @override
  String get laptop => 'Laptop ';

  @override
  String get supported => 'Supported';

  @override
  String get notSupported => 'Not Supported';

  @override
  String get freeMovies => 'Free Movies';

  @override
  String get top10 => 'Top 10';

  @override
  String get latestMovies => 'New Released Movies';

  @override
  String get topChannels => 'Top Channels';

  @override
  String get popularTvShows => 'Popular TV Shows';

  @override
  String get popularVideos => 'Most Watched Videos';

  @override
  String get popularLanguages => 'Popular Languages';

  @override
  String get trending => 'Trending';

  @override
  String get trendingInYourCountry => 'Trending Movies in your Country';

  @override
  String get favoriteGenres => 'Favorite Genres';

  @override
  String get basedOnYourPreviousWatch => 'Because You Watch';

  @override
  String get mostLiked => 'Most Liked Movies';

  @override
  String get mostViewed => 'Top Rated Movies on IMDB';

  @override
  String get yourFavoritePersonalities => 'Favorite Personality';

  @override
  String get name => 'Name';

  @override
  String get enterName => 'Enter Name';

  @override
  String get nameCannotBeEmpty => 'Name cannot be empty';

  @override
  String get update => 'Update';

  @override
  String get remove => 'Remove';

  @override
  String get recentSearch => 'Recent search';

  @override
  String get noRecentSearches => 'No recent searches';

  @override
  String get chooseImageSource => 'Choose Image Source';

  @override
  String get noInternetAvailable => 'No internet available';

  @override
  String get goToYourDownloads => 'Go to your downloads';

  @override
  String welcomeUserMessage(String appName, String name) =>
      "Hey $name, welcome to $appName! Your journey into unlimited entertainment begins now — dive in and enjoy the show!";

  @override
  String get bySigningYouAgreeTo => 'By signing, you agree to';

  @override
  String get lowQuality => 'Low Quality';

  @override
  String get mediumQuality => 'Medium Quality';

  @override
  String get highQuality => 'High Quality';

  @override
  String get veryHighQuality => 'Very High Quality';

  @override
  String get ultraQuality => 'Ultra Quality';

  @override
  String get termsConditions => 'Terms & Conditions';

  @override
  String get ofAll => 'of all';

  @override
  String get servicesAnd => 'Services and ';

  @override
  String get newProfileAddedSuccessfully => 'New profile added successfully';

  @override
  String get doYouWantToDeleteYourReview =>
      'Do you want to delete your review?';

  @override
  String get noSearchDataFound => 'No Search Data Found';

  @override
  String get searchHistory => 'Search history';

  @override
  String get youHaveBeenLoggedOutOfYourAccountOn =>
      'You have been logged out of your account on';

  @override
  String get faqs => 'FAQs';

  @override
  String get termsOfUse => 'Terms of Use';

  @override
  String get refundAndCancellationPolicy => 'Refund and Cancellation Policy';

  @override
  String get dataDeletionRequest => 'Data Deletion Request';

  @override
  String get aboutUs => 'About Us';

  @override
  String get total => 'Total';

  @override
  String get percentage => 'percentage';

  @override
  String get fixed => 'fixed';

  @override
  String get android => 'Android';

  @override
  String get ios => 'iOS';

  @override
  String get hindi => 'Hindi';

  @override
  String get arabic => 'Arabic';

  @override
  String get french => 'French';

  @override
  String get german => 'German';

  @override
  String get noFAQsfound => 'No FAQs found';

  @override
  String get tax => 'Tax';

  @override
  String get downloadHasBeenStarted => 'Download has been started';

  @override
  String get yourDeviceIsNot =>
      'Your device is not supported with the current plan';

  @override
  String get pleaseUpgradeToContinue =>
      'Please upgrade to continue enjoying the service';

  @override
  String get cancelled => 'Cancelled';

  @override
  String get deactivated => 'Deactivated';

  @override
  String get expired => 'Expired';

  @override
  String get active => 'Active';

  @override
  String get connectToWIFI => 'Please connect to WIFI';

  @override
  String get logoutAllConfirmation =>
      'Do you want to log out all other Devices?';

  @override
  String get logoutAllConfirmationMessage =>
      'To enforce your new plan device limit, you have to logout from all devices immediately.';

  @override
  String get changePasswordMessage =>
      'Your password has been updated. Please log in again to continue.';

  @override
  String get share => 'Share';

  @override
  String get like => 'Like';

  @override
  String get pip => 'PIP';

  @override
  String get videoCast => 'Cast';

  @override
  String get castingNotSupported =>
      'Casting is not supported with the current plan.';

  @override
  String get left => "left";

  @override
  String get loginWithOtp => 'Login with OTP';

  @override
  String get loginWithEmail => 'Login with Email';

  @override
  String get createYourAccount => 'Create Your Account';

  @override
  String get changePassword => 'Change Password';

  @override
  String get yourNewPasswordMust =>
      'Your New Password Must Be Different From Your Previous Password';

  @override
  String get yourOldPasswordDoesnT => "Your old password doesn't correct!";

  @override
  String get yourNewPasswordDoesnT =>
      "Your confirm password doesn't match new password!";

  @override
  String get oldAndNewPassword => 'Old and new password are same.';

  @override
  String get yourPasswordHasBeen => 'Your Password Has Been Successfully Reset';

  @override
  String get youCanNowLog =>
      'You Can Now Log In To Your New Account With Your New Password';

  @override
  String get done => 'Done';

  @override
  String get oldPassword => 'Old Password';

  @override
  String get newPassword => 'New Password';

  @override
  String get confirmNewPassword => 'Confirm New Password';

  @override
  String get birthdayIsRequired => 'Birthday is required';

  @override
  String get childrenSProfile => "Children's Profile";

  @override
  String get madeForKidsUnder12 => 'Made for kids under 12';

  @override
  String get otpVerifiedFailed => 'OTP verification failed';

  @override
  String get otpVerifiedSuccessfully => 'OTP verified successfully';

  @override
  String get otpSentSuccessfully => 'OTP sent successfully';

  @override
  String get weHaveSentYouOTPOnYourRegisterEmailAddress =>
      'We have sent you OTP on your registered email address';

  @override
  String get otpVerification => 'OTP Verification';

  @override
  String get enterPIN => 'Enter PIN';

  @override
  String get enterYourNewParentalPinForYourKids =>
      'Enter your new parental pin for your kids';

  @override
  String get enterYourOldParentalPinForYourKids =>
      'Enter your old parental pin for your kids';

  @override
  String get confirmPIN => 'Confirm PIN';

  @override
  String get setPIN => 'Set PIN';

  @override
  String get changePIN => 'Change PIN';

  @override
  String get parentalControl => 'Parental Control';

  @override
  String get invalidPIN => 'Invalid PIN';

  @override
  String get kids => 'KIDS';

  @override
  String get enter4DigitParentalControlPIN =>
      'Enter 4 digit parental control PIN';

  @override
  String get parentalLock => 'Parental Lock';

  @override
  String get profileDeletedSuccessfully => 'Profile deleted successfully';

  @override
  String get pinNotMatched => 'PIN not matched';

  @override
  String get pleaseEnterNewPIN => 'Please enter new PIN';

  @override
  String get pleaseEnterOldPIN => 'Please enter old PIN';

  @override
  String get pleaseEnterConfirmPin => 'Please enter confirm PIN';

  @override
  String get codeWithColon => 'Enter Code:';

  @override
  String get useThisCodeToGet => 'Use this code to get ';

  @override
  String get off => ' Off';

  @override
  String get expiryDate => 'Expiry Date: ';

  @override
  String get apply => 'Apply';

  @override
  String get coupons => 'Coupons';

  @override
  String get enterCouponCode => 'Enter coupon code';

  @override
  String get check => 'Check';

  @override
  String get allCoupons => 'All Coupons';

  @override
  String get oopsWeCouldnTFind =>
      'Oops! We couldn’t find any matching coupon codes';

  @override
  String doYouWantToRemoveCoupon(String name) =>
      'Do you want to remove this $name coupon?';

  @override
  String get noSubscriptionHistoryFound => 'No subscription history found';

  @override
  String get couponDiscount => 'Coupon Discount ';

  @override
  String get linkTv => 'Link Tv';

  @override
  String get youHaveBeenLoggedOutSuccessfully =>
      'You have been logged out successfully';

  @override
  String get rented => 'RENTED';

  @override
  String get rent => 'RENT';

  @override
  String get rentFor => 'Rent For';

  @override
  String get oneTime => 'ONE TIME';

  @override
  String get oneTimeFor => 'One Time For';

  @override
  String rentedesc(int availableFor, int duration) =>
      'You have $availableFor ${availableFor > 1 ? 'days' : 'day'} to start watching once rented. You will have $duration ${duration > 1 ? 'days' : 'day'} to finish once started streaming.';

  @override
  String youCanWatchThis(int duration) =>
      'You can watch this content multiple times during the $duration ${duration > 1 ? 'days' : 'day'} period.';

  @override
  String get thisIsANonRefundable => 'This is a non-refundable transaction.';

  @override
  String get thisContentIsOnly =>
      'This content is only available for rent and not part of the Premium Subscription.';

  @override
  String get youCanPlayYour =>
      'You can play your content on supported devices.';

  @override
  String get validity => 'Validity';

  @override
  String get day => 'Day';

  @override
  String get days => 'Days';

  @override
  String get watchTime => 'Watch Time';

  @override
  String get hours => 'Hours';

  @override
  String get week => 'Week';

  @override
  String get weeks => 'Weeks';

  @override
  String get month => 'Month';

  @override
  String get months => 'Months';

  @override
  String get year => 'Year';

  @override
  String get years => 'Years';

  @override
  String get byRentingYouAgreeToOur => 'By renting you agree to our ';

  @override
  String get pleaseAgreeToThe =>
      'Please agree to the Terms of Use before proceeding.';

  @override
  String enjoyUntilDays(int days) => 'Enjoy until $days days';

  @override
  String get beginWatching => 'Begin Watching';

  @override
  String doYouConfirmThis(String movieName) =>
      'Do you confirm rental of $movieName';

  @override
  String get unlockedVideo => 'Unlocked Video';

  @override
  String get info => 'Info';

  @override
  String confirmDeleteDownload(String title) =>
      'Do you want to delete $title from your downloads?';

  @override
  String get payPerView => 'Pay Per View';

  @override
  String skipIn(int seconds) => 'Skip in $seconds';

  @override
  String get newPinSuccessfullySaved => 'New PIN successfully saved';

  @override
  String get successfullyUpdated => 'Successfully Updated';

  @override
  String get defaultLabel => 'Default';

  @override
  String get quality => 'Quality';

  @override
  String get audio => 'Audio';

  @override
  String get audioAndQuality => 'Audio & Quality';

  @override
  String get subtitle => 'Subtitle';

  @override
  String get skip => 'Skip';

  @override
  String get skipIntro => 'Skip Intro';

  @override
  String get nextEpisode => 'Next Episode';

  @override
  String get rentDetails => 'Rent Details';

  @override
  String get rentalInfo => 'Rental Info';

  @override
  String get pleaseSelectPaymentMethod => 'Please select a payment method. ';

  @override
  String get tvLinkedSuccessfully => 'TV linked successfully!';

  @override
  String get cameraPermissionDenied =>
      'Camera permission denied. Please enable it in settings.';

  @override
  String get advertisement => 'Advertisement';

  @override
  String get castConnectInfo =>
      'Make sure your Chromecast device is powered on and connected to the same Wi-Fi network.';

  @override
  String get connect => 'Connect';

  @override
  String get disconnect => 'Disconnect';

  @override
  String get playOnTV => 'Play on TV';

  @override
  String get readyToCastToYourDevice => 'Ready to cast to your device';

  @override
  String get castSupportInfo =>
      'Casting is only supported for videos of type URL, HLS, or Local. Other formats are not supported for casting.';

  @override
  String doYouConfirmThisPlanWithPlanName(String planName) =>
      'Do you confirm this plan $planName ?';

  @override
  String get pinVerifiedSuccessfully => 'PIN verified successfully';

  @override
  String get female => 'Female';

  @override
  String get male => 'Male';

  @override
  String get other => 'Other';

  @override
  String get gender => 'Gender';

  @override
  String get rentalHistory => 'Rental History';

  @override
  String get noRentalHistoryFound => 'No rental history found';

  @override
  String get scanTvQrCode => 'Scan TV & Web QR Code';

  @override
  String get successfullyRented => 'Successfully Rented';

  @override
  String get subscriptionSuccessful => 'Subscription Activated';

  @override
  String get subscriptionSuccessfulSubtitle =>
      'Your subscription is now active';

  @override
  String get startEnjoyingContent =>
      'You can now enjoy unlimited streaming and all premium features';

  @override
  String get currentPlan => 'Current Plan';

  @override
  String purchaseInfo1(int duration) =>
      'You have $duration ${duration > 1 ? 'days' : 'day'} to start watching once purchased. Unlimited validity to finish once started streaming.';

  @override
  String get purchaseInfo2 =>
      'You can watch this content multiple times until the expiration period.';

  @override
  String get address => 'Address';

  @override
  String get noGenresFound => 'No Genres Found';

  @override
  String get noGenresAvailableSubtitle =>
      'No genres are available at the moment';

  @override
  String get noSubscriptionPlans => 'No Subscription Plans';

  @override
  String get noSubscriptionPlansSubtitle =>
      'No subscription plans are currently available';

  @override
  String get noContentFound => 'No Content Found';

  @override
  String get noContentMatchesFilter =>
      'No content matches your filter criteria';

  @override
  String get movie => 'Movie';

  @override
  String get tvShow => 'TV Show';

  @override
  String get video => 'Video';

  @override
  String get episodes => 'Episodes';

  @override
  String get cancelSubscription =>
      'Are you sure you want to cancel your subscription?';

  @override
  String get coupanApplied => 'Coupan applied successfully';

  @override
  String get coupanRemoved => 'Coupan removed successfully';

  @override
  String get controlYourDevices => "Control Your Devices";

  @override
  String resendOtpCountText(int count) =>
      'You can resend the OTP in $count seconds.';

  @override
  String get comingSoonOn => 'Coming Soon on';

  @override
  String get noComingSoonContentAvailable =>
      'No coming soon content available.';

  @override
  String get noComingSoonMovieAvailable => 'No coming soon movie is available.';

  @override
  String get noComingSoonTvShowAvailable =>
      'No coming soon TV show is available.';

  @override
  String get noComingSoonVideoAvailable => 'No coming soon video is available.';

  @override
  String get clips => 'Clips';

  @override
  String get noContentDetails => 'No Content Details';

  @override
  String get contentInformationIsNotAvailable =>
      'Content information is not available';

  @override
  String get episodesAreNotAvailableYet => 'Episodes are not available yet';

  @override
  String get stayTuned => 'Stay tuned';

  @override
  String get weArePreparingExcitingEpisodesForThisSeason =>
      'We are preparing exciting episodes for this season';

  @override
  String get checkBackAgainShortly => 'Check back again shortly';

  @override
  String get ad => 'Advertisement';

  @override
  String get adsLoadingIn => 'Ads Loading In';

  @override
  String get browseAndRentContentToWatchInstantly =>
      'Browse And Rent Content To Watch Instantly';

  @override
  String get byCreatingAnAccountYouAgreeTo =>
      'By Creating An Account You Agree To';

  @override
  String get categories => 'Categories';

  @override
  String get channelInformationIsNotAvailable =>
      'Channel Information Is Not Available';

  @override
  String get chooseTheQualityForDownloadingThisContent =>
      'Choose The Quality For Downloading This Content';

  @override
  String get deviceLogins => 'Device Logins';

  @override
  String get downloadContentToWatchOffline =>
      'Download Content To Watch Offline';

  @override
  String get inAppPurchase => 'In App Purchase';

  @override
  String get isAvailableInThisCategory => 'Is Available In This Category';

  @override
  String get noCastOrCrewMembersAvailable =>
      'No Cast or Crew Members Available';

  @override
  String get noChannelDetails => 'No Channel Details';

  @override
  String get noChannelsAreAvailableInThisCategory =>
      'No Channels Are Available In This Category';

  @override
  String get noChannelsFound => 'No Channels Found';

  @override
  String get noContentAvailableInThisGenre =>
      'No Content Available In This Genre';

  @override
  String get noContentInGenre => 'No Content In Genre';

  @override
  String get noDownloadsFound => 'No Downloads Found';

  @override
  String get noLiveTvChannels => 'No Live TV Channels';

  @override
  String get noLiveTvChannelsAreCurrentlyAvailable =>
      'No Live TV Channels Are Currently Available';

  @override
  String noMoviesOrTvShowsFeaturing(String name) =>
      'No Movies or TV Shows Featuring $name';

  @override
  String get noPayPerViewContent => 'No Pay Per View Content';

  @override
  String get noPeopleFound => 'No People Found';

  @override
  String get noWatchlistFound => 'No Watchlist Found';

  @override
  String get ofAllServicesAnd => 'of all services and';

  @override
  String get oneTimePurchase => 'One Time Purchase';

  @override
  String get openSettings => 'Open Settings';

  @override
  String get paymentSuccessful => 'Payment Successful';

  @override
  String get permissionNotGranted => 'Permission not granted';

  @override
  String get popularSearches => 'Popular Searches';

  @override
  String get resetPasswordLinkSentToYourEmail =>
      'We will send the password reset instructions to your email. Open email and click the link to reset password instantly.';

  @override
  String get searchAgain => 'Search Again';

  @override
  String get sendResetLink => 'Send Reset Link';

  @override
  String get skipAd => 'Skip Ad';

  @override
  String get suggestedChannels => 'Suggested Channels';

  @override
  String get topGenre => 'Top Genre';

  @override
  String get unableToLoadDownload => 'Unable To Load Download';

  @override
  String get uploadCustomProfileImage => 'Upload Custom Profile Image';

  @override
  String get visitAdvertiser => 'Visit Advertiser';

  @override
  String get youCanNotRevertThisActionLater =>
      'You Can Not Revert This Action Later';

  @override
  String get youDoNotHaveAccessToWatch => 'You Do Not Have Access To Watch';

  @override
  String get yourCurrentPlanSupports => 'Your Current Plan Supports';

  @override
  String get yourPaymentWasCompleted => 'Your Payment Was Completed';

  @override
  String get otherSections => 'Other Sections';

  @override
  String get newPasswordRequired => 'New password is required';

  @override
  String get noMoviesAvailable => 'No Movies Available';

  @override
  String get noTvShowsAvailable => 'No TV Shows Available';

  @override
  String get noVideosAvailable => 'No Videos Available';

  @override
  String noContentAvailableInContentType(String content, String contentType) =>
      'No $contentType available in $content';

  @override
  String get unableToDownloadFilePleaseTryAgainLater =>
      'Unable to download file. Please try again later.';

  @override
  String sorryCouldntShareThis(String type) =>
      "Sorry couldn't share this $type";

  @override
  String errorWhileMonitoringDownloadUpdates(String error) =>
      'Error while monitoring download updates: $error';

  @override
  String get pleaseSelectACastingDeviceFirst =>
      'Please select a casting device first';

  @override
  String get noVideoUrlAvailableForCasting =>
      'No video URL available for casting';

  @override
  String get contentTypeNotAvailableForCasting =>
      'Content type not available for casting';

  @override
  String get invalidVideoUrlFormat => 'Invalid video URL format';

  @override
  String get failedInitiateRazorpayPayment =>
      'Failed initiate Razorpay payment';

  @override
  String cantFindPlanOnStore(String planName, String storeName) =>
      "Can't find $planName on $storeName";

  @override
  String get paymentNotCapturedContactSupport =>
      'Payment not captured. Please contact support.';

  @override
  String get downloadDeletedSuccessfully => 'Download Deleted Successfully!';

  @override
  String get pleaseSelectRating => 'Please select rating';

  @override
  String get downloadsAllowedOnWifiOnly =>
      'Downloads allowed on WiFi only. Please connect to WiFi or disable the setting.';

  @override
  String get thisContentIsNotDownloadable =>
      'Sorry! this content is not downloadable';

  @override
  String get failedToStartDownload => 'Failed to start download';

  @override
  String get failedToResumeDownload => 'Failed to resume download';

  @override
  String get downloadCancelled => 'Download cancelled';

  @override
  String get downloadCompleted => 'Download completed';

  @override
  String get thePasswordDoesNotMatch => "The password doesn't match";

  @override
  String get deleteMultipleDownload =>
      'Do you want to delete the selected Content from the downloads?';

  @override
  String profileLimitIncreaseMessage({
    required String planName,
    required int limit,
  }) {
    final profileText = limit > 1 ? "profiles" : "profile";

    return "$planName plan allows only $limit $profileText. "
        "Please remove the extra $profileText to continue.";
  }

  @override
  String get contectRestrictedForKidProfile =>
      'This content is not allowed on a kids profile.';

  @override
  String get recommendedForYou => 'Recommended For You';

  @override
  String get shortDrama => 'Short Drama';

  @override
  String get yourNextObsessionStartsHere => 'Your Next Obsession Starts Here';

  @override
  String get shortDramasIntenseStorytelling =>
      'Short dramas, intense storytelling, emotional romance, and exciting twists. Discover entertainment crafted for every mood.';

  @override
  String get exploreMore => 'Explore More';

  @override
  String get dramaForYou => 'Drama For You';

  @override
  String get noEpisodesAvailable => 'No episodes available';

  @override
  String get audioLanguage => 'Audio Language';

  @override
  String get cantPlayThisTitleRightNow => "Can't play this title right now";

  @override
  String get goBack => 'Go Back';

  @override
  String get unableToFindThisDramaForPlayback =>
      'Unable to find this drama for playback.';

  @override
  String get pleaseCheckYourConnectionAndTryAgain =>
      'Please check your connection and try again.';

  @override
  String get seasons => 'Seasons';

  @override
  String get mute => 'Mute';

  @override
  String get unmute => 'Unmute';

  @override
  String get noInternetConnection => 'No Internet Connection';

  @override
  String get continueWatchingForYou => 'Continue Watching For You';

  @override
  String get playbackErrorGeneric =>
      'We couldn\'t play this episode at the moment. Please try again.';

  @override
  String get playbackErrorSessionExpired =>
      'The short drama session has expired. Please log in again and try again.';

  @override
  String get playbackErrorTokenExpired => 'The playback token has expired. Please try this episode again.';

  @override
  String get playbackErrorVideoPluginUnavailable => 'The video plugin is unavailable. Please restart the app and try again.';

  @override
  String get less => 'Less';

  @override
  String get more => 'More';
}
