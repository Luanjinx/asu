import 'package:streamit_laravel/configs.dart';
import 'package:streamit_laravel/locale/languages.dart';

class LanguageEl extends BaseLanguage {
  @override
  String get language => 'Ελληνικά';

  @override
  String get badRequest => 'Μη έγκυρο αίτημα';

  @override
  String get forbidden => 'Απαγορευμένο';

  @override
  String get pageNotFound => 'Η σελίδα δεν βρέθηκε';

  @override
  String get tooManyRequests => 'Πάρα πολλά αιτήματα';

  @override
  String get internalServerError => 'Εσωτερικό σφάλμα διακομιστή';

  @override
  String get badGateway => 'Κακή πύλη';

  @override
  String get serviceUnavailable => 'Η υπηρεσία δεν είναι διαθέσιμη';

  @override
  String get gatewayTimeout => 'Λήξη χρόνου πύλης';

  @override
  String get gallery => 'Συλλογή';

  @override
  String get camera => 'Κάμερα';

  @override
  String get editProfile => 'Επεξεργασία προφίλ';

  @override
  String get reload => 'Επαναφόρτωση';

  @override
  String get pressBackAgainToExitApp =>
      'Πατήστε πίσω ξανά για έξοδο από την εφαρμογή';

  @override
  String get invalidUrl => 'Μη έγκυρο URL';

  @override
  String get cancel => 'Ακύρωση';

  @override
  String get delete => 'Διαγραφή';

  @override
  String get demoUserCannotBeGrantedForThis =>
      'Ο δοκιμαστικός χρήστης δεν μπορεί να έχει πρόσβαση σε αυτή την ενέργεια';

  @override
  String get somethingWentWrong => 'Κάτι πήγε στραβά';

  @override
  String get yourInternetIsNotWorking => 'Το διαδίκτυό σας δεν λειτουργεί';

  @override
  String get profileUpdatedSuccessfully => 'Το προφίλ ενημερώθηκε με επιτυχία';

  @override
  String get likedSuccessfully => 'Liked successfully';

  @override
  String get unlikedSuccessfully => 'Unliked successfully';

  @override
  String get wouldYouLikeToSetProfilePhotoAs =>
      'Θα θέλατε να ορίσετε αυτή την εικόνα ως φωτογραφία προφίλ;';

  @override
  String get yourConfirmPasswordDoesnT =>
      'Ο κωδικός επιβεβαίωσης δεν ταιριάζει!';

  @override
  String get yes => 'Ναι';

  @override
  String get submit => 'Υποβολή';

  @override
  String get firstName => 'Όνομα';

  @override
  String get lastName => 'Επώνυμο';

  @override
  String get password => 'Κωδικός';

  @override
  String get confirmPassword => 'Επιβεβαίωση κωδικού';

  @override
  String get email => 'Email';

  @override
  String get emailIsARequiredField => 'Το email είναι υποχρεωτικό πεδίο';

  @override
  String get pleaseEnterValidEmailAddress =>
      'Παρακαλώ εισάγετε έγκυρη διεύθυνση email!';

  @override
  String get signIn => 'Σύνδεση';

  @override
  String get explore => 'Εξερεύνηση';

  @override
  String get settings => 'Ρυθμίσεις';

  @override
  String get rateNow => 'Αξιολογήστε τώρα';

  @override
  String get logout => 'Αποσύνδεση';

  @override
  String get rememberMe => 'Να με θυμάσαι';

  @override
  String get forgotPassword => 'Ξεχάσατε τον κωδικό;';

  @override
  String get signUp => 'Εγγραφή';

  @override
  String get alreadyHaveAnAccount => 'Έχετε ήδη λογαριασμό;';

  @override
  String get deleteAccount => 'Διαγραφή λογαριασμού';

  @override
  String get notifications => 'Ειδοποιήσεις';

  @override
  String get signInFailed => 'Η σύνδεση απέτυχε';

  @override
  String get logIn => 'Σύνδεση';

  @override
  String get stayTunedNoNew =>
      'Μείνετε συντονισμένοι! Δεν υπάρχουν νέες ειδοποιήσεις.';

  @override
  String get noNewNotificationsAt =>
      'Δεν υπάρχουν νέες ειδοποιήσεις αυτή τη στιγμή. Θα σας ενημερώσουμε όταν υπάρξει κάποια ενημέρωση';

  @override
  String get walkthroughTitle1 =>
      'Παρακολουθήστε σε οποιαδήποτε συσκευή: Απολαύστε το περιεχόμενό μας όπου κι αν βρίσκεστε!';

  @override
  String get walkthroughDesp1 =>
      'Μετάδοση σε όλες τις συσκευές χωρίς επιπλέον χρεώσεις.';

  @override
  String get walkthroughTitle2 =>
      'Κατεβάστε και συνεχίστε: Πρόσβαση στο περιεχόμενό σας οπουδήποτε, οποτεδήποτε, σε οποιαδήποτε συσκευή';

  @override
  String get walkthroughDesp2 =>
      'Κατεβάστε & απολαύστε περιεχόμενο εν κινήσει, οπουδήποτε, οποτεδήποτε.';

  @override
  String get walkthroughTitle3 =>
      'Απολαύστε την ελευθερία χωρίς δεσμεύσεις ή προβλήματα - Γίνετε μέλος σήμερα!';

  @override
  String get walkthroughDesp3 =>
      'Γίνετε μέλος χωρίς προβλήματα και χωρίς συμβόλαια.';

  @override
  String get lblSkip => 'Παράλειψη';

  @override
  String get lblNext => 'Επόμενο';

  @override
  String get lblGetStarted => 'Ξεκινήστε';

  @override
  String get optionTitle =>
      'Ανακαλύψτε κορυφαίες εκπομπές με είδη προσαρμοσμένα στις προτιμήσεις σας.';

  @override
  String get optionDesp =>
      'Εξερευνήστε επιμελημένες εκπομπές σε διάφορα είδη προσαρμοσμένες στις προτιμήσεις θέασής σας.';

  @override
  String get welcomeBackToStreamIt => 'Καλώς ήρθατε πίσω στο $APP_NAME!';

  @override
  String get weHaveEagerlyAwaitedYourReturn =>
      'Περιμέναμε με ανυπομονησία την επιστροφή σας.';

  @override
  String get dontHaveAnAccount => 'Δεν έχετε λογαριασμό; ';

  @override
  String get or => 'Ή';

  @override
  String get linkSentToYourEmail => 'Ο σύνδεσμος στάλθηκε στο email σας!';

  @override
  String get checkYourInboxAndChangePassword =>
      'Ελέγξτε τα εισερχόμενά σας και αλλάξτε τον κωδικό σας';

  @override
  String get continues => 'Συνέχεια';

  @override
  String get oTPVerification => 'Επαλήθευση OTP';

  @override
  String get checkYourSmsInboxAndEnterTheCodeYouGet =>
      'Ελέγξτε τα SMS σας και εισάγετε τον κωδικό που λάβατε.';

  @override
  String get weHaveSentVerificationCodeToMobileNumber =>
      'Έχουμε στείλει έναν κωδικό επαλήθευσης στον αριθμό του κινητού σας τηλεφώνου. Παρακαλώ εισάγετέ τον για να συνεχίσετε.';

  @override
  String get didntGetTheOTP => 'Δεν λάβατε το OTP;';

  @override
  String get resendOTP => 'Επαναποστολή OTP';

  @override
  String youCanResendOTPIn(int seconds) =>
      'Μπορείτε να επαναλάβετε την αποστολή OTP σε $seconds';

  @override
  String get otpHasBeenResentToMobileNumber =>
      'Το OTP έχει σταλεί ξανά στον αριθμό του κινητού σας τηλεφώνου';

  @override
  String get verify => 'Επαλήθευση';

  @override
  String get clearAll => 'Εκκαθάριση όλων';

  @override
  String get notificationDeleted => 'Η ειδοποίηση διαγράφηκε';

  @override
  String get doYouWantToMarkAllNotificationAsRead =>
      'Θέλετε να διαγράψετε όλες τις ειδοποιήσεις';

  @override
  String get doYouWantToDeleteThisNotification =>
      'Θέλετε να διαγράψετε αυτή την ειδοποίηση;';

  @override
  String get successfully => 'Επιτυχώς';

  @override
  String get userCancelled => 'Ο χρήστης ακύρωσε';

  @override
  String get appleSigninIsNot =>
      'Η σύνδεση με Apple δεν είναι διαθέσιμη για τη συσκευή σας';

  @override
  String get searchHere => 'Αναζήτηση εδώ';

  @override
  String get noDataFound => 'Δεν βρέθηκαν δεδομένα';

  @override
  String get subscribe => 'Εγγραφή';

  @override
  String get subscribeToWatch => 'Εγγραφείτε για να παρακολουθήσετε';

  @override
  String get playNow => 'Αναπαραγωγή τώρα';

  @override
  String get continueWatching => 'Συνέχεια παρακολούθησης ';

  @override
  String get noContinueWatchingTitle => 'Δεν υπάρχει περιεχόμενο για συνέχεια';

  @override
  String get noContinueWatchingSubtitle =>
      'Ξεκινήστε να παρακολουθείτε περιεχόμενο για να εμφανιστεί εδώ';

  @override
  String get shareYourThoughtsWithUs => 'Μοιραστείτε τις σκέψεις σας μαζί μας!';

  @override
  String get weValueYourOpinion =>
      'Εκτιμούμε τη γνώμη σας! Μοιραστείτε τα σχόλιά σας μαζί μας σήμερα.';

  @override
  String get genres => 'Είδη';

  @override
  String get trailer => 'ΤΡΕΪΛΕΡ';

  @override
  String get ua18 => 'U/A 18';

  @override
  String get watchNow => 'Δείτε τώρα';

  @override
  String get resume => 'Συνέχεια';

  @override
  String get pause => 'Παύση';

  @override
  String get paused => 'Σε παύση';

  @override
  String get cast => 'Ηθοποιοί';

  @override
  String get directors => 'Σκηνοθέτες';

  @override
  String get reviews => 'Κριτικές';

  @override
  String get viewAll => 'Προβολή όλων';

  @override
  String get rating => 'βαθμολογία';

  @override
  String get justNow => 'Μόλις τώρα';

  @override
  String get daysAgo => 'ημέρες πριν';

  @override
  String get yesterday => 'Χθες';

  @override
  String get ago => 'πριν';

  @override
  String get min => 'λεπ';

  @override
  String get hr => 'ώρα';

  @override
  String get s => 'δ';

  @override
  String get moreLikeThis => 'Περισσότερα σαν κι αυτό';

  @override
  String get rateThisMovie => 'Βαθμολογήστε αυτή την ταινία';

  @override
  String get rateThisTvShow => 'Βαθμολογήστε αυτή τη σειρά';

  @override
  String get yourReview => 'Η κριτική σας';

  @override
  String get edit => 'Επεξεργασία';

  @override
  String get close => 'Κλείσιμο';

  @override
  String get oppsLooksLikeYouReview =>
      'Ωχ! Φαίνεται ότι δεν έχετε προσθέσει ακόμη κριτική.';

  @override
  String get retry => 'Επανάληψη';

  @override
  String get selectDownloadQuality => 'Επιλέξτε ποιότητα λήψης';

  @override
  String get onlyOnWiFi => 'Μόνο με Wi-Fi';

  @override
  String get download => 'Λήψη';

  @override
  String get downloading => 'Λήψη...';

  @override
  String get downloaded => 'Ληφθέν';

  @override
  String moviesTvShowsOf(String name) => 'Ταινίες/Σειρές του $name';

  @override
  String reviewsOf(String name) => 'Κριτικές του $name';

  @override
  String get season => 'Σεζόν';

  @override
  String get episode => 'Επεισόδιο ';

  @override
  String get watchlist => 'Λίστα παρακολούθησης ';

  @override
  String get removeFromWatchlist => 'Κατάργηση από τη λίστα παρακολούθησης';

  @override
  String get searchMoviesShowsAndMore => 'Αναζήτηση ταινιών, σειρών και άλλων';

  @override
  String get trendingMovies => 'Δημοφιλείς ταινίες ';

  @override
  String get comingSoon => 'Προσεχώς';

  @override
  String get remindMe => 'Υπενθύμιση';

  @override
  String get remind => 'Υπενθύμιση στις';

  @override
  String get readLess => 'Λιγότερα';

  @override
  String get readMore => '...Περισσότερα';

  @override
  String get liveTv => 'Ζωντανή TV';

  @override
  String get live => 'ΖΩΝΤΑΝΑ';

  @override
  String get profile => 'Προφίλ';

  @override
  String get expiringOn => 'Λήγει στις';

  @override
  String get updrade => 'Αναβάθμιση';

  @override
  String get subscribeToEnjoyMore => 'Εγγραφείτε για να απολαύσετε περισσότερα';

  @override
  String get daysFreeTrail => 'Ξεκλειδώστε αποκλειστικές λειτουργίες σήμερα';

  @override
  String get privacyPolicy => 'Πολιτική Απορρήτου';

  @override
  String get helpSupport => 'Βοήθεια & Υποστήριξη';

  @override
  String get rateOurApp => 'Βαθμολογήστε την εφαρμογή μας';

  @override
  String get rateOurAppSubtitle =>
      'Βαθμολογήστε την εφαρμογή μας για να μας υποστηρίξετε';

  @override
  String get appLanguage => 'Γλώσσα εφαρμογής';

  @override
  String get yourDownloads => 'Οι λήψεις σας';

  @override
  String get subscriptionPlanDeviceConnected =>
      'Πρόγραμμα συνδρομής, συνδεδεμένη συσκευή';

  @override
  String get accountSettings => 'Ρυθμίσεις λογαριασμού';

  @override
  String get accountControl => 'Έλεγχος λογαριασμού';

  @override
  String get parentalControlsSubtitle =>
      'Περιορίστε την πρόσβαση σε προφίλ ενηλίκων με PIN';

  @override
  String get subscriptionAndRentals => 'Συνδρομή & Ενοικιάσεις';

  @override
  String deviceLimitMessage(String limit) =>
      'Μπορείτε να χρησιμοποιήσετε έως και $limit συσκευές ταυτόχρονα.';

  @override
  String get videoCastingEnabled => 'Η μετάδοση βίντεο είναι ενεργοποιημένη.';

  @override
  String get videoCastingDisabled => 'Η μετάδοση βίντεο δεν είναι διαθέσιμη.';

  @override
  String get adsWillBeShown => 'Θα εμφανιστούν διαφημίσεις';

  @override
  String get adsWillNotBeShown => 'Δεν θα εμφανιστούν διαφημίσεις';

  @override
  String get downloadResolution => 'Ανάλυση λήψης';

  @override
  String get supportedDeviceType => 'Υποστηριζόμενος τύπος συσκευής';

  @override
  String profileLimitMessage(String limit) =>
      'Μπορείτε να δημιουργήσετε έως και $limit προφίλ σε αυτό το πακέτο για διαφορετικούς χρήστες.';

  @override
  String get transactionHistory => 'Ιστορικό συναλλαγών';

  @override
  String get transactionHistorySubtitle =>
      'Διαχειριστείτε το ιστορικό συνδρομών & ενοικιάσεών σας';

  @override
  String get subscriptionHistorySubtitle =>
      'Πρόσβαση στα αρχεία πληρωμών συνδρομής σας';

  @override
  String get rentalHistorySubtitle =>
      'Πρόσβαση στο ιστορικό πληρωμών ενοικίασης';

  @override
  String get deviceManagement => 'Διαχείριση συσκευών';

  @override
  String get kidsProfileCannotAccessSubscription =>
      'Οι δυνατότητες συνδρομής είναι περιορισμένες για τα προφίλ παιδιών.';

  @override
  String get accountAndActivation => 'Λογαριασμός & Ενεργοποίηση';

  @override
  String get accountSectionTitle => 'Λογαριασμός';

  @override
  String get accountSectionSubtitle =>
      'Διαχείριση λογαριασμού, συνδρομών και ενοικιάσεων';

  @override
  String get activateTvWeb => 'Ενεργοποίηση TV & Web';

  @override
  String get activateTvWebSubtitle => 'Σύνδεση και διαχείριση TV & Web';

  @override
  String get savedVideos => 'Αποθηκευμένα βίντεο';

  @override
  String get myList => 'Η λίστα μου';

  @override
  String get myListSubtitle => 'Η λίστα σας για αργότερα';

  @override
  String get pickUpWhereYouLeftOff => 'Συνέχισε από εκεί που σταμάτησες';

  @override
  String get continueWatchingSubtitle =>
      'Συνέχισε την προβολή από εκεί που σταμάτησες';

  @override
  String get rentals => 'Ενοικιάσεις';

  @override
  String get rentalsSubtitle =>
      'Πρόσβαση στις ταινίες και σειρές που έχεις ενοικιάσει';

  @override
  String get rentalsAndDownloads => 'Ενοικιάσεις και Λήψεις';

  @override
  String get yourRentals => 'Οι ενοικιάσεις σας';

  @override
  String get noRentedContentFound => 'Δεν βρέθηκε ενοικιασμένο περιεχόμενο';

  @override
  String get noRentedContentSubtitle =>
      'Ενοικιάστε ταινίες, επεισόδια και βίντεο για να αποκτήσετε άμεση πρόσβαση εδώ';

  @override
  String get autoUpdate => 'Αυτόματη ενημέρωση';

  @override
  String get downloadOverWifiOnly => 'Λήψη μόνο μέσω WI-FI';

  @override
  String get smartDelete => 'Έξυπνη διαγραφή';

  @override
  String get smartDeleteSubtitle =>
      'Διαγραφή των ληφθέντων μετά την ολοκλήρωση';

  @override
  String get downloads => 'Λήψεις';

  @override
  String get downloadsSubtitle =>
      'Προβολή και διαχείριση του περιεχομένου εκτός σύνδεσης';

  @override
  String get settingsAndSupport => 'Ρυθμίσεις & Υποστήριξη';

  @override
  String get settingsSubtitle => 'Ενημερώσεις, γλώσσα και λήψεις';

  @override
  String get helpSupportSubtitle =>
      'Συχνές ερωτήσεις, όροι & προϋποθέσεις και πολιτική απορρήτου';

  @override
  String get appVersionPrefix => 'Έκδοση εφαρμογής';

  @override
  String get version => 'Έκδοση';

  @override
  String get registeredMobileNumber => 'Καταχωρημένος αριθμός κινητού';

  @override
  String get otherDevices => 'Άλλες συσκευές';

  @override
  String get yourDevice => 'Η συσκευή σας';

  @override
  String get lastUsed => 'Τελευταία χρήση';

  @override
  String get currentDevice => 'Τρέχουσα συσκευή';

  @override
  String get proceed => 'Συνέχεια';

  @override
  String get allYourDataWill => 'Όλα τα δεδομένα σας θα διαγραφούν μόνιμα';

  @override
  String get deleteAccountPermanently => 'Οριστική διαγραφή λογαριασμού;';

  @override
  String doYouWantToDeleteProfile(String profileName) =>
      'Θέλετε να διαγράψετε το προφίλ για $profileName;';

  @override
  String shareYourThoughtsOnContent(String contentName, String type) =>
      'Μοιραστείτε τις σκέψεις σας για το $contentName $type';

  @override
  String get mobileNumber => 'Αριθμός κινητού';

  @override
  String get verifyPin => 'Επιβεβαίωση PIN';

  @override
  String get downloadInvoice => 'Λήψη τιμολογίου';

  @override
  String get saveChanges => 'Αποθήκευση αλλαγών';

  @override
  String get startWatchingFromWhereYouLeftOff =>
      'Ξεκινήστε να παρακολουθείτε από εκεί που σταματήσατε';

  @override
  String get troubleLoggingIn => 'Πρόβλημα σύνδεσης;';

  @override
  String get getHelp => 'Λάβετε βοήθεια';

  @override
  String get helpAndSupport => 'Βοήθεια & Υποστήριξη';

  @override
  String get noHelpTopicsFound => 'Δεν βρέθηκαν θέματα βοήθειας';

  @override
  String get helpAndSupportTopicsSubtitle =>
      'Τα θέματα βοήθειας και υποστήριξης θα εμφανίζονται εδώ';

  @override
  String get yourWatchlistIsEmpty => 'Η λίστα παρακολούθησής σας είναι κενή';

  @override
  String get contentAddedToYourWatchlist =>
      'Το περιεχόμενο που προσθέτετε στη λίστα παρακολούθησης θα εμφανίζεται εδώ';

  @override
  String get add => 'Προσθήκη';

  @override
  String get subscribeNowAndDiveInto =>
      'Εγγραφείτε τώρα και βυθιστείτε σε ατελείωτη ροή';

  @override
  String get pay => 'Πληρωμή';

  @override
  String get next => 'Επόμενο';

  @override
  String get subscription => 'Συνδρομή';

  @override
  String get validUntil => 'Ισχύει μέχρι ';

  @override
  String get choosePaymentMethod => 'Επιλέξτε τρόπο πληρωμής';

  @override
  String get secureCheckoutInSeconds => '100% ασφαλής πληρωμή σε δευτερόλεπτα';

  @override
  String get proceedPayment => 'Συνέχεια στην πληρωμή';

  @override
  String get paymentFailedMessage =>
      'Η πληρωμή τερματίστηκε. Δοκιμάστε ξανά αν θέλετε να προχωρήσετε.';

  @override
  String get actors => 'Ηθοποιοί';

  @override
  String get movies => 'Ταινίες';

  @override
  String get contentRestrictedAccess =>
      'Περιορισμένη πρόσβαση περιεχομένου 18+';

  @override
  String get areYou18Above => 'Είστε άνω των 18 ετών;';

  @override
  String get displayAClearProminentWarning =>
      'Εμφάνιση σαφούς & εμφανούς προειδοποίησης πριν την πρόσβαση στο περιεχόμενο, δηλώνοντας ότι προορίζεται για ενήλικο κοινό';

  @override
  String get all => 'Όλα';

  @override
  String get tVShows => 'Τηλεοπτικές σειρές';

  @override
  String get videos => 'Βίντεο';

  @override
  String get newlyAdded => 'Πρόσφατα προστεθέντα';

  @override
  String get free => 'δωρεάν';

  @override
  String get phnRequiredText => 'Απαιτείται αριθμός κινητού';

  @override
  String get inputMustBeNumberOrDigit =>
      'Η εισαγωγή πρέπει να είναι αριθμός ή ψηφίο';

  @override
  String get dateOfBirth => 'Ημερομηνία γέννησης';

  @override
  String get dateOfBirthRequired => 'Απαιτείται ημερομηνία γέννησης';

  @override
  String get whatYourMobileNo => 'Ποιος είναι ο αριθμός κινητού σας';

  @override
  String get withAValidMobileNumberYouCanConnectWithStreamit =>
      'Με έναν έγκυρο αριθμό κινητού μπορείτε να συνδεθείτε με το Streamit';

  @override
  String get otpSentToYourSMS => 'Το OTP στάλθηκε στο SMS σας!';

  @override
  String get checkYourSmsInboxAndVerifyYoourMobile =>
      'Ελέγξτε τα SMS σας και επαληθεύστε τον αριθμό του κινητού σας';

  @override
  String get pleaseTryAgainAfterSomeTime =>
      'Παρακαλώ δοκιμάστε ξανά μετά από λίγο. Έχετε χρησιμοποιήσει πολλαπλές αιτήσεις επαλήθευσης!';

  @override
  String get pleaseEnterAValidCode => 'Παρακαλώ εισάγετε έγκυρο OTP';

  @override
  String get pleaseCheckYourMobileInternetConnection =>
      'Παρακαλώ ελέγξτε τη σύνδεση του κινητού σας στο διαδίκτυο';

  @override
  String get error => 'Σφάλμα';

  @override
  String get sorryCouldnFindYourSearch =>
      'Συγγνώμη, δεν βρέθηκε η αναζήτησή σας!';

  @override
  String get trySomethingNew => 'Δοκιμάστε κάτι νέο.';

  @override
  String get genresNotAvailable => 'Τα είδη δεν είναι διαθέσιμα!';

  @override
  String get downloadSuccessfully => 'Η λήψη ολοκληρώθηκε με επιτυχία';

  @override
  String get popularMovies => 'Δημοφιλείς ταινίες';

  @override
  String get confirm => 'Επιβεβαίωση';

  @override
  String get doYouConfirmThisPlan =>
      'Επιβεβαιώνετε αυτό το πρόγραμμα συνδρομής';

  @override
  String get transactionFailed => 'Η συναλλαγή απέτυχε';

  @override
  String get transactionCancelled => 'Η συναλλαγή ακυρώθηκε';

  @override
  String get no => 'Όχι';

  @override
  String get lblChangeCountry => 'Αλλαγή χώρας';

  @override
  String get selectCountry => 'Επιλέξτε χώρα';

  @override
  String get logOutAll => 'Αποσύνδεση όλων';

  @override
  String get taxIncluded => 'Συμπεριλαμβάνεται ΦΠΑ';

  @override
  String get bookNow => 'Κράτηση τώρα';

  @override
  String get firstNameIsRequiredField => 'Το όνομα είναι υποχρεωτικό';

  @override
  String get lastNameIsRequiredField => 'Το επώνυμο είναι υποχρεωτικό';

  @override
  String get passwordIsRequired => 'Ο κωδικός είναι υποχρεωτικός';

  @override
  String get oldPasswordIsRequired => 'Ο παλιός κωδικός είναι υποχρεωτικός';

  @override
  String get passwordLengthRule =>
      'Ο κωδικός πρόσβασης πρέπει να έχει μήκος 8-14 χαρακτήρες';

  @override
  String get passwordUppercaseRule =>
      'Ο κωδικός πρόσβασης πρέπει να περιέχει τουλάχιστον ένα κεφαλαίο γράμμα';

  @override
  String get passwordLowercaseRule =>
      'Ο κωδικός πρόσβασης πρέπει να περιέχει τουλάχιστον ένα πεζό γράμμα';

  @override
  String get passwordSpecialCharacterRule =>
      'Ο κωδικός πρόσβασης πρέπει να περιέχει τουλάχιστον έναν ειδικό χαρακτήρα (@\$!%*?&)';

  @override
  String get passwordDigitRule =>
      'Ο κωδικός πρόσβασης πρέπει να περιέχει τουλάχιστον ένα ψηφίο';

  @override
  String get confirmPasswordIsRequired =>
      'Η επιβεβαίωση κωδικού είναι υποχρεωτική';

  @override
  String get home => 'Αρχική';

  @override
  String get search => 'Αναζήτηση';

  @override
  String get mobileNumberIsRequired =>
      'Ο αριθμός κινητού είναι υποχρεωτικό πεδίο';

  @override
  String get youHaveAlreadyDownloadedThisMovie =>
      'Έχετε ήδη κατεβάσει αυτή την ταινία';

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
  String get lblCheckOutWithCinetPay => 'Ολοκλήρωση αγοράς με CinetPay';

  @override
  String get contextNotFound => 'Το context δεν βρέθηκε!!!!';

  @override
  String get verificationFailed => 'Η επαλήθευση απέτυχε';

  @override
  String get english => 'Αγγλικά';

  @override
  String get hour => 'ώρα';

  @override
  String get minute => 'λεπτό';

  @override
  String get sec => 'δευτ';

  @override
  String get videoNotFound => 'Το βίντεο δεν βρέθηκε!!';

  @override
  String get auto => 'Αυτόματο';

  @override
  String get recommended => 'Προτεινόμενο';

  @override
  String get medium => 'Μεσαία';

  @override
  String get high => 'Υψηλή';

  @override
  String get low => 'Χαμηλή';

  @override
  String get helpSetting => 'Βοήθεια & Ρυθμίσεις';

  @override
  String get pleaseConfirmContent =>
      'Παρακαλώ επιβεβαιώστε την πρόσβαση σε περιορισμένο περιεχόμενο';

  @override
  String get toWatch => 'Για παρακολούθηση';

  @override
  String get plan => 'Πρόγραμμα';

  @override
  String get toThe => 'Στο';

  @override
  String get noDeviceAvailable => 'Δεν υπάρχουν διαθέσιμες συσκευές';

  @override
  String get noItemsToContinueWatching =>
      'Δεν υπάρχουν στοιχεία για συνέχιση παρακολούθησης';

  @override
  String get noItemsAddedToTheWatchlist =>
      'Δεν έχουν προστεθεί στοιχεία στη λίστα παρακολούθησης';

  @override
  String get ok => 'Εντάξει';

  @override
  String removeFromContinueWatchingTitle(String title, String typeLabel) =>
      'Θέλετε να αφαιρέσετε το $title $typeLabel από τη λίστα Συνέχεια παρακολούθησης;';

  @override
  String get addedToWatchList =>
      'Προστέθηκε στη λίστα παρακολούθησης με επιτυχία';

  @override
  String get removedFromWatchList =>
      'Διαγράφηκε από τη λίστα παρακολούθησης με επιτυχία';

  @override
  String get removeSelectedFromWatchList =>
      'Θέλετε να αφαιρέσετε το επιλεγμένο περιεχόμενο από τη λίστα παρακολούθησης;';

  @override
  String get removedFromContinueWatch =>
      'Διαγράφηκε από τη συνέχιση παρακολούθησης με επιτυχία';

  @override
  String get pleaseEnterAValidMobileNo =>
      'Παρακαλώ εισάγετε έγκυρο αριθμό κινητού';

  @override
  String get pleaseAddYourReview => 'Παρακαλώ προσθέστε τη βαθμολογία σας';

  @override
  String get thisMovieIsCurrentlUnavailableToWatch =>
      'Αυτή η ταινία δεν είναι διαθέσιμη για παρακολούθηση αυτή τη στιγμή';

  @override
  String get thisVideoIsCurrentlUnavailableToWatch =>
      'Αυτό το βίντεο δεν είναι διαθέσιμο για παρακολούθηση αυτή τη στιγμή';

  @override
  String get subscriptionHistory => 'Ιστορικό συνδρομών';

  @override
  String get type => 'Τύπος';

  @override
  String get amount => 'Ποσό';

  @override
  String get cancelPlan => 'Ακύρωση προγράμματος';

  @override
  String get device => 'Συσκευή';

  @override
  String get clear => 'Εκκαθάριση';

  @override
  String get doYouWantToLogoutFrom => 'Θέλετε να αποσυνδεθείτε από το ';

  @override
  String get sAlphabet => 'Σ';

  @override
  String get eAlphabet => 'Ε';

  @override
  String get viewMore => 'Δείτε περισσότερα';

  @override
  String get viewLess => 'Λιγότερα';

  @override
  String get removeSelectedFromDownloads =>
      'Θέλετε να αφαιρέσετε αυτό από τις λήψεις σας';

  @override
  String get noPaymentMethodsFound => 'Δεν βρέθηκαν μέθοδοι πληρωμής';

  @override
  String get save => 'Αποθήκευση';

  @override
  String get completeProfile => 'Συμπληρώστε το προφίλ σας';

  @override
  String get completeProfileSubtitle =>
      'Πείτε μας περισσότερα για τον εαυτό σας για να ξεκινήσετε';

  @override
  String get getVerificationCode => 'Λήψη κωδικού επαλήθευσης';

  @override
  String get contentRating => 'Αξιολόγηση περιεχομένου';

  @override
  String get profiles => 'Προφίλ';

  @override
  String get addProfile => 'Προσθήκη προφίλ';

  @override
  String get clearSearchHistoryConfirmation =>
      'Θέλετε να διαγράψετε το ιστορικό αναζήτησης;';

  @override
  String get clearSearchHistorySubtitle =>
      'Αυτή η ενέργεια δεν μπορεί να αναιρεθεί και όλες οι προηγούμενες αναζητήσεις θα διαγραφούν μόνιμα.';

  @override
  String get searchingForDevice => 'Αναζήτηση συσκευών';

  @override
  String get screenCast => 'Μετάδοση οθόνης';

  @override
  String get connectTo => 'Σύνδεση με';

  @override
  String get disconnectFrom => 'Αποσύνδεση από';

  @override
  String get signInWithGoogle => 'Σύνδεση με Google';

  @override
  String get signInWithApple => 'Σύνδεση με Apple';

  @override
  String get whoIsWatching => 'Ποιος παρακολουθεί;';

  @override
  String get doYouWantTo => 'Θέλετε να διαγράψετε το ιστορικό αναζήτησης;';

  @override
  String get mobile => 'Κινητό ';

  @override
  String get tablet => 'Tablet ';

  @override
  String get tv => 'Tv ';

  @override
  String get laptop => 'Laptop ';

  @override
  String get supported => 'Υποστηρίζεται';

  @override
  String get notSupported => 'Δεν υποστηρίζεται';

  @override
  String get freeMovies => 'Δωρεάν ταινίες';

  @override
  String get top10 => 'Top 10';

  @override
  String get latestMovies => 'Νέες κυκλοφορίες ταινιών';

  @override
  String get topChannels => 'Κορυφαία κανάλια';

  @override
  String get popularTvShows => 'Δημοφιλείς τηλεοπτικές σειρές';

  @override
  String get popularVideos => 'Τα πιο δημοφιλή βίντεο';

  @override
  String get popularLanguages => 'Δημοφιλείς γλώσσες';

  @override
  String get trending => 'Τάσεις';

  @override
  String get trendingInYourCountry => 'Τάσεις στη χώρα σας';

  @override
  String get favoriteGenres => 'Αγαπημένα είδη';

  @override
  String get basedOnYourPreviousWatch => 'Επειδή παρακολούθησες';

  @override
  String get mostLiked => 'Ταινίες με τα περισσότερα likes';

  @override
  String get mostViewed => 'Ταινίες με την υψηλότερη βαθμολογία στο IMDB';

  @override
  String get yourFavoritePersonalities => 'Οι αγαπημένες σας προσωπικότητες';

  @override
  String get name => 'Όνομα';

  @override
  String get enterName => 'Εισάγετε όνομα';

  @override
  String get nameCannotBeEmpty => 'Το όνομα δεν μπορεί να είναι κενό';

  @override
  String get update => 'Ενημέρωση';

  @override
  String get remove => 'Αφαίρεση';

  @override
  String get recentSearch => 'Πρόσφατη αναζήτηση';

  @override
  String get noRecentSearches => 'Δεν υπάρχουν πρόσφατες αναζητήσεις';

  @override
  String get chooseImageSource => 'Επιλογή πηγής εικόνας';

  @override
  String get noInternetAvailable => 'Δεν υπάρχει διαθέσιμο διαδίκτυο';

  @override
  String get goToYourDownloads => 'Μετάβαση στις λήψεις σας';

  @override
  String welcomeUserMessage(String appName, String name) =>
      "Γεια σου $name, καλώς ήρθες στο $appName! Το ταξίδι σου στην απεριόριστη ψυχαγωγία ξεκινά τώρα — βούτηξε και απόλαυσε το σόου!";

  @override
  String get bySigningYouAgreeTo => 'Με την εγγραφή, συμφωνείτε με';

  @override
  String get lowQuality => 'Χαμηλή ποιότητα';

  @override
  String get mediumQuality => 'Μεσαία ποιότητα';

  @override
  String get highQuality => 'Υψηλή ποιότητα';

  @override
  String get veryHighQuality => 'Πολύ υψηλή ποιότητα';

  @override
  String get ultraQuality => 'Εξαιρετική ποιότητα';

  @override
  String get termsConditions => 'Όροι & προϋποθέσεις';

  @override
  String get ofAll => 'όλων των';

  @override
  String get servicesAnd => 'Υπηρεσιών και ';

  @override
  String get newProfileAddedSuccessfully =>
      'Το νέο προφίλ προστέθηκε με επιτυχία';

  @override
  String get doYouWantToDeleteYourReview =>
      'Θέλετε να διαγράψετε την κριτική σας;';

  @override
  String get noSearchDataFound => 'Δεν βρέθηκαν δεδομένα αναζήτησης';

  @override
  String get searchHistory => 'Ιστορικό αναζήτησης';

  @override
  String get youHaveBeenLoggedOutOfYourAccountOn =>
      'Έχετε αποσυνδεθεί από τον λογαριασμό σας στο';

  @override
  String get faqs => 'Συχνές ερωτήσεις';

  @override
  String get termsOfUse => 'Όροι χρήσης';

  @override
  String get refundAndCancellationPolicy => 'Πολιτική επιστροφών και ακυρώσεων';

  @override
  String get dataDeletionRequest => 'Αίτημα διαγραφής δεδομένων';

  @override
  String get aboutUs => 'Σχετικά με εμάς';

  @override
  String get total => 'Σύνολο';

  @override
  String get percentage => 'ποσοστό';

  @override
  String get fixed => 'σταθερό';

  @override
  String get android => 'Android';

  @override
  String get ios => 'iOS';

  @override
  String get hindi => 'Χίντι';

  @override
  String get arabic => 'Αραβικά';

  @override
  String get french => 'Γαλλικά';

  @override
  String get german => 'Γερμανικά';

  @override
  String get noFAQsfound => 'Δεν βρέθηκαν συχνές ερωτήσεις';

  @override
  String get tax => 'ΦΠΑ';

  @override
  String get downloadHasBeenStarted => 'Η λήψη ξεκίνησε';

  @override
  String get yourDeviceIsNot =>
      'Η συσκευή σας δεν υποστηρίζεται με το τρέχον πρόγραμμα';

  @override
  String get pleaseUpgradeToContinue =>
      'Παρακαλώ αναβαθμίστε για να συνεχίσετε να απολαμβάνετε την υπηρεσία';

  @override
  String get cancelled => 'Ακυρώθηκε';

  @override
  String get deactivated => 'Απενεργοποιημένο';

  @override
  String get expired => 'Έληξε';

  @override
  String get active => 'Ενεργό';

  @override
  String get connectToWIFI => 'Παρακαλώ συνδεθείτε σε WIFI';

  @override
  String get logoutAllConfirmation =>
      'Θέλετε να αποσυνδεθείτε από όλες τις άλλες συσκευές;';

  @override
  String get logoutAllConfirmationMessage =>
      'Για την εφαρμογή του ορίου συσκευών του νέου σας προγράμματος, πρέπει να αποσυνδεθείτε άμεσα από όλες τις συσκευές.';

  @override
  String get changePasswordMessage =>
      'Ο κωδικός πρόσβασής σας ενημερώθηκε. Παρακαλώ συνδεθείτε ξανά για να συνεχίσετε.';

  @override
  String get share => 'Κοινοποίηση';

  @override
  String get like => 'Μου αρέσει';

  @override
  String get pip => 'PIP';

  @override
  String get videoCast => 'Μετάδοση';

  @override
  String get castingNotSupported =>
      'Η μετάδοση δεν υποστηρίζεται με το τρέχον πρόγραμμα.';

  @override
  String get left => "απομένει";

  @override
  String get loginWithOtp => 'Σύνδεση με OTP';

  @override
  String get loginWithEmail => 'Σύνδεση με Email';

  @override
  String get createYourAccount => 'Δημιουργήστε τον λογαριασμό σας';

  @override
  String get changePassword => 'Αλλαγή κωδικού';

  @override
  String get yourNewPasswordMust =>
      'Ο νέος σας κωδικός πρέπει να είναι διαφορετικός από τον προηγούμενο';

  @override
  String get yourOldPasswordDoesnT => 'Ο παλιός σας κωδικός δεν είναι σωστός!';

  @override
  String get yourNewPasswordDoesnT =>
      "Ο κωδικός επιβεβαίωσης δεν ταιριάζει με τον νέο κωδικό!";

  @override
  String get oldAndNewPassword => 'Ο παλιός και ο νέος κωδικός είναι ίδιοι.';

  @override
  String get yourPasswordHasBeen =>
      'Ο κωδικός σας έχει επαναφερθεί με επιτυχία';

  @override
  String get youCanNowLog =>
      'Μπορείτε τώρα να συνδεθείτε στον νέο σας λογαριασμό με τον νέο κωδικό';

  @override
  String get done => 'Ολοκληρώθηκε';

  @override
  String get oldPassword => 'Παλιός κωδικός';

  @override
  String get newPassword => 'Νέος κωδικός';

  @override
  String get confirmNewPassword => 'Επιβεβαίωση νέου κωδικού';

  @override
  String get birthdayIsRequired => 'Η ημερομηνία γέννησης είναι υποχρεωτική';

  @override
  String get childrenSProfile => 'Προφίλ παιδιών';

  @override
  String get madeForKidsUnder12 => 'Για παιδιά κάτω των 12 ετών';

  @override
  String get otpVerifiedFailed => 'Η επαλήθευση OTP απέτυχε';

  @override
  String get otpVerifiedSuccessfully => 'Το OTP επαληθεύτηκε με επιτυχία';

  @override
  String get otpSentSuccessfully => 'Το OTP στάλθηκε με επιτυχία';

  @override
  String get weHaveSentYouOTPOnYourRegisterEmailAddress =>
      'Σας έχουμε στείλει OTP στην καταχωρημένη διεύθυνση email σας';

  @override
  String get otpVerification => 'Επαλήθευση OTP';

  @override
  String get enterPIN => 'Εισαγωγή PIN';

  @override
  String get enterYourNewParentalPinForYourKids =>
      'Εισάγετε το νέο σας γονικό PIN για τα παιδιά σας';

  @override
  String get enterYourOldParentalPinForYourKids =>
      'Εισάγετε το παλιό σας γονικό PIN για τα παιδιά σας';

  @override
  String get confirmPIN => 'Επιβεβαίωση PIN';

  @override
  String get setPIN => 'Ορισμός PIN';

  @override
  String get changePIN => 'Αλλαγή PIN';

  @override
  String get parentalControl => 'Γονικός έλεγχος';

  @override
  String get invalidPIN => 'Μη έγκυρο PIN';

  @override
  String get kids => 'ΠΑΙΔΙΑ';

  @override
  String get enter4DigitParentalControlPIN =>
      'Εισάγετε 4ψήφιο PIN γονικού ελέγχου';

  @override
  String get parentalLock => 'Γονικό κλείδωμα';

  @override
  String get profileDeletedSuccessfully => 'Το προφίλ διαγράφηκε με επιτυχία';

  @override
  String get pinNotMatched => 'Το PIN δεν ταιριάζει';

  @override
  String get pleaseEnterNewPIN => 'Παρακαλώ εισάγετε νέο PIN';

  @override
  String get pleaseEnterOldPIN => 'Παρακαλώ εισάγετε παλιό PIN';

  @override
  String get pleaseEnterConfirmPin => 'Παρακαλώ εισάγετε επιβεβαίωση PIN';

  @override
  String get codeWithColon => 'Εισάγετε κωδικό:';

  @override
  String get useThisCodeToGet =>
      'Χρησιμοποιήστε αυτόν τον κωδικό για να πάρετε ';

  @override
  String get off => ' έκπτωση';

  @override
  String get expiryDate => 'Ημερομηνία λήξης: ';

  @override
  String get apply => 'Εφαρμογή';

  @override
  String get coupons => 'Κουπόνια';

  @override
  String get enterCouponCode => 'Εισάγετε κωδικό κουπονιού';

  @override
  String get check => 'Έλεγχος';

  @override
  String get allCoupons => 'Όλα τα κουπόνια';

  @override
  String get oopsWeCouldnTFind =>
      'Ωχ! Δεν μπορέσαμε να βρούμε κωδικούς κουπονιών που να ταιριάζουν';

  @override
  String doYouWantToRemoveCoupon(String name) =>
      'Θέλετε να αφαιρέσετε αυτό το κουπόνι $name;';

  @override
  String get noSubscriptionHistoryFound => 'Δεν βρέθηκε ιστορικό συνδρομών';

  @override
  String get couponDiscount => 'Έκπτωση κουπονιού ';

  @override
  String get linkTv => 'Σύνδεση TV';

  @override
  String get youHaveBeenLoggedOutSuccessfully =>
      'Έχετε αποσυνδεθεί με επιτυχία';

  @override
  String get rented => 'ΕΝΟΙΚΙΑΣΤΗΚΕ';

  @override
  String get rent => 'ΕΝΟΙΚΙΑΣΗ';

  @override
  String get rentFor => 'Ενοικίαση για';

  @override
  String get oneTime => 'ΜΙΑ ΦΟΡΑ';

  @override
  String get oneTimeFor => 'Μία φορά για';

  @override
  String rentedesc(int availableFor, int duration) =>
      'Έχετε $availableFor ${availableFor > 1 ? 'ημέρες' : 'ημερή'} για να ξεκινήσετε την παρακολούθηση μετά την ενοικίαση. Θα έχετε $duration ${duration > 1 ? 'ημέρες' : 'ημερή'} για να ολοκληρώσετε αφού ξεκινήσετε τη ροή.';

  @override
  String youCanWatchThis(int duration) =>
      'Μπορείτε να παρακολουθήσετε αυτό το περιεχόμενο πολλές φορές κατά τη διάρκεια της περιόδου των $duration ${duration > 1 ? 'ημέρες' : 'ημερή'}.';

  @override
  String get thisIsANonRefundable =>
      'Αυτή είναι μια μη επιστρεφόμενη συναλλαγή.';

  @override
  String get thisContentIsOnly =>
      'Αυτό το περιεχόμενο είναι διαθέσιμο μόνο για ενοικίαση και δεν περιλαμβάνεται στη συνδρομή Premium.';

  @override
  String get youCanPlayYour =>
      'Μπορείτε να αναπαράγετε το περιεχόμενό σας σε υποστηριζόμενες συσκευές.';

  @override
  String get validity => 'Ισχύς';

  @override
  String get day => 'Ημέρα';

  @override
  String get days => 'Ημέρες';

  @override
  String get watchTime => 'Χρόνος παρακολούθησης';

  @override
  String get hours => 'Ώρες';

  @override
  String get week => 'Εβδομάδα';

  @override
  String get weeks => 'Εβδομάδες';

  @override
  String get month => 'Μήνας';

  @override
  String get months => 'Μήνες';

  @override
  String get year => 'Έτος';

  @override
  String get years => 'Έτη';

  @override
  String get byRentingYouAgreeToOur => 'Με την ενοικίαση συμφωνείτε με τους ';

  @override
  String get pleaseAgreeToThe =>
      'Παρακαλώ συμφωνήστε με τους Όρους Χρήσης πριν συνεχίσετε.';

  @override
  String enjoyUntilDays(int days) => 'Απολαύστε για $days ημέρες';

  @override
  String get beginWatching => 'Έναρξη παρακολούθησης';

  @override
  String doYouConfirmThis(String movieName) =>
      'Επιβεβαιώνετε την ενοικίαση του $movieName;';

  @override
  String get unlockedVideo => 'Ξεκλειδωμένο βίντεο';

  @override
  String get info => 'Πληροφορίες';

  @override
  String confirmDeleteDownload(String title) =>
      'Θέλετε να διαγράψετε το $title από τις λήψεις σας;';

  @override
  String get payPerView => 'Pay Per View';

  @override
  String skipIn(int seconds) => 'Παράλειψη σε $seconds';

  @override
  String get newPinSuccessfullySaved => 'Το νέο PIN αποθηκεύτηκε με επιτυχία';

  @override
  String get successfullyUpdated => 'Ενημερώθηκε με επιτυχία';

  @override
  String get defaultLabel => 'Προεπιλογή';

  @override
  String get quality => 'Ποιότητα';

  @override
  String get audio => 'Ήχος';

  @override
  String get audioAndQuality => 'Ήχος & Ποιότητα';

  @override
  String get subtitle => 'Υπότιτλοι';

  @override
  String get skip => 'Παράλειψη';

  @override
  String get skipIntro => 'Παράλειψη εισαγωγής';

  @override
  String get nextEpisode => 'Επόμενο επεισόδιο';

  @override
  String get rentDetails => 'Λεπτομέρειες ενοικίασης';

  @override
  String get rentalInfo => 'Πληροφορίες ενοικίασης';

  @override
  String get pleaseSelectPaymentMethod => 'Παρακαλώ επιλέξτε μέθοδο πληρωμής. ';

  @override
  String get tvLinkedSuccessfully => 'Η TV συνδέθηκε με επιτυχία!';

  @override
  String get cameraPermissionDenied =>
      'Η άδεια κάμερας απορρίφθηκε. Παρακαλώ ενεργοποιήστε την στις ρυθμίσεις.';

  @override
  String get advertisement => 'Διαφήμιση';

  @override
  String get castConnectInfo =>
      'Βεβαιωθείτε ότι η συσκευή Chromecast είναι ενεργοποιημένη και συνδεδεμένη στο ίδιο δίκτυο Wi-Fi.';

  @override
  String get connect => 'Σύνδεση';

  @override
  String get disconnect => 'Αποσύνδεση';

  @override
  String get playOnTV => 'Αναπαραγωγή στην TV';

  @override
  String get readyToCastToYourDevice => 'Έτοιμο για μετάδοση στη συσκευή σας';

  @override
  String get castSupportInfo =>
      'Η μετάδοση υποστηρίζεται μόνο για βίντεο τύπου URL, HLS, ή τοπικά. Άλλες μορφές δεν υποστηρίζονται για μετάδοση.';

  @override
  String doYouConfirmThisPlanWithPlanName(String planName) =>
      'Επιβεβαιώνετε αυτό το πρόγραμμα $planName;';

  @override
  String get pinVerifiedSuccessfully => 'Το PIN επαληθεύτηκε με επιτυχία';

  @override
  String get female => 'Γυναίκα';

  @override
  String get male => 'Άνδρας';

  @override
  String get other => 'Άλλο';

  @override
  String get gender => 'Φύλο';

  @override
  String get rentalHistory => 'Ιστορικό ενοικιάσεων';

  @override
  String get noRentalHistoryFound => 'Δεν βρέθηκε ιστορικό ενοικιάσεων';

  @override
  String get scanTvQrCode => 'Σάρωση TV & Web QR Code';

  @override
  String get successfullyRented => 'Ενοικιάστηκε με επιτυχία';

  @override
  String get currentPlan => 'Τρεχοντικό προγραμματισμό';

  @override
  String purchaseInfo1(int duration) =>
      'Έχετε $duration ${duration > 1 ? 'ημέρες' : 'ημέρα'} για να ξεκινήσετε την παρακολούθηση μετά την αγορά. Απεριόριστη ισχύς για να ολοκληρώσετε την παρακολούθηση από τη στιγμή που ξεκινάτε το streaming.';

  @override
  String get purchaseInfo2 =>
      'Μπορείτε να παρακολουθήσετε αυτό το περιεχόμενο πολλές φορές μέχρι την ημερομηνία λήξης.';

  @override
  String get address => 'Διευθύνση';

  @override
  String get subscriptionSuccessful => 'Η συνδρομή ενεργοποιήθηκε';

  @override
  String get subscriptionSuccessfulSubtitle =>
      'Η συνδρομή σας είναι πλέον ενεργή';

  @override
  String get startEnjoyingContent =>
      'Μπορείτε τώρα να απολαύσετε ατελείωτη ροή και όλες τις δυνατότητες premium';

  @override
  String get noGenresFound => 'Δεν βρέθηκαν είδη';

  @override
  String get noGenresAvailableSubtitle =>
      'Δεν υπάρχουν διαθέσιμα είδη αυτή τη στιγμή';

  @override
  String get noSubscriptionPlans => 'Δεν βρέθηκαν σχέδια συνδρομής';

  @override
  String get noSubscriptionPlansSubtitle =>
      'Δεν υπάρχουν διαθέσιμα σχέδια συνδρομής αυτή τη στιγμή';

  @override
  String get noContentFound => 'Δεν βρέθηκε περιεχόμενο';

  @override
  String get noContentMatchesFilter =>
      'Δεν υπάρχει περιεχόμενο που να ταιριάζει με τα κριτήρια φίλτρού σας';

  @override
  String get movie => 'Ταινία';

  @override
  String get tvShow => 'Τηλεοπτική εκπομπή';

  @override
  String get video => 'Βίντεο';

  @override
  String get episodes => 'Επεισόδια';

  @override
  String get cancelSubscription =>
      'Είστε βέβαιοι ότι θέλετε να ακυρώσετε τη συνδρομή σας;';

  @override
  String get coupanApplied => 'Το κουπόνι εφαρμόστηκε με επιτυχία';

  @override
  String get coupanRemoved => 'Το κουπόνι αφαιρέθηκε με επιτυχία';

  @override
  String get controlYourDevices => "Ελέγξτε τις συσκευές σας";

  @override
  String resendOtpCountText(int count) =>
      'Μπορείτε να στείλετε ξανά το OTP σε $count δευτερόλεπτα.';

  @override
  String get comingSoonOn => 'Προσεχώς στις';

  @override
  String get noComingSoonContentAvailable =>
      'Δεν υπάρχει διαθέσιμο περιεχόμενο που έρχεται σύντομα.';

  @override
  String get noComingSoonMovieAvailable =>
      'Δεν υπάρχει διαθέσιμη ταινία που έρχεται σύντομα.';

  @override
  String get noComingSoonTvShowAvailable =>
      'Δεν υπάρχει διαθέσιμη τηλεοπτική εκπομπή που έρχεται σύντομα.';

  @override
  String get noComingSoonVideoAvailable =>
      'Δεν υπάρχει διαθέσιμο βίντεο που έρχεται σύντομα.';

  @override
  String get clips => 'Κλιπ';

  @override
  String get checkBackAgainShortly => 'Ελέγξτε ξανά σύντομα';

  @override
  String get contentInformationIsNotAvailable =>
      'Η πληροφορία του περιεχομένου δεν είναι διαθέσιμη';

  @override
  String get episodesAreNotAvailableYet =>
      'Τα επεισόδια δεν είναι διαθέσιμα ακόμη';

  @override
  String get noContentDetails => 'Χωρίς λεπτομέρειες περιεχομένου';

  @override
  String get stayTuned => 'Παρακολουθήστε τις ενημερώσεις';

  @override
  String get weArePreparingExcitingEpisodesForThisSeason =>
      'Προετοιμαζόμαστε εντυπωσιακά επεισόδια για αυτό το έτος';

  @override
  String get ad => 'Διαφήμιση';

  @override
  String get adsLoadingIn => 'Φόρτωση διαφημίσεων';

  @override
  String get browseAndRentContentToWatchInstantly =>
      'Περιηγηθείτε και ενοικιάστε περιεχόμενο για άμεση παρακολούθηση';

  @override
  String get byCreatingAnAccountYouAgreeTo =>
      'Με την δημιουργία ενός λογαριασμού συμφωνείτε με τους';

  @override
  String get categories => 'Κατηγορίες';

  @override
  String get channelInformationIsNotAvailable =>
      'Η πληροφορία του καναλιού δεν είναι διαθέσιμη';

  @override
  String get chooseTheQualityForDownloadingThisContent =>
      'Επιλέξτε την ποιότητα για την λήψη αυτού του περιεχομένου';

  @override
  String get deviceLogins => 'Συσκευές σύνδεσης';

  @override
  String get downloadContentToWatchOffline =>
      'Λήψη περιεχομένου για παρακολούθηση εκτός σύνδεσης';

  @override
  String get inAppPurchase => 'Αγορά σε εφαρμογή';

  @override
  String get isAvailableInThisCategory => 'Διαθέσιμο σε αυτήν την κατηγορία';

  @override
  String get noCastOrCrewMembersAvailable =>
      'Δεν υπάρχουν ηθοποιοί ή σκηνοθέτες διαθέσιμοι';

  @override
  String get noChannelDetails => 'Χωρίς λεπτομέρειες καναλιού';

  @override
  String get noChannelsAreAvailableInThisCategory =>
      'Δεν υπάρχουν κανάλια διαθέσιμα σε αυτήν την κατηγορία';

  @override
  String get noChannelsFound => 'Δεν βρέθηκαν κανάλια';

  @override
  String get noContentAvailableInThisGenre =>
      'Δεν υπάρχει περιεχόμενο διαθέσιμο σε αυτήν την κατηγορία';

  @override
  String get noContentInGenre =>
      'Δεν υπάρχει περιεχόμενο σε αυτήν την κατηγορία';

  @override
  String get noDownloadsFound => 'Δεν βρέθηκαν λήψεις';

  @override
  String get noLiveTvChannels => 'Δεν βρέθηκαν ζωντανές τηλεοπτικές εκπομπές';

  @override
  String get noLiveTvChannelsAreCurrentlyAvailable =>
      'Δεν υπάρχουν ζωντανές τηλεοπτικές εκπομπές διαθέσιμες αυτή τη στιγμή';

  @override
  String noMoviesOrTvShowsFeaturing(String name) =>
      'Δεν υπάρχουν ταινίες ή τηλεοπτικές εκπομπές με $name';

  @override
  String get noPayPerViewContent =>
      'Δεν υπάρχει περιεχόμενο pay per view διαθέσιμο';

  @override
  String get noPeopleFound => 'Δεν βρέθηκαν άνθρωποι';

  @override
  String get noWatchlistFound => 'Δεν βρέθηκαν λίστες παρακολούθησης';

  @override
  String get ofAllServicesAnd => 'για όλες τις υπηρεσίες και';

  @override
  String get oneTimePurchase => 'Μια φορά αγορά';

  @override
  String get openSettings => 'Ρυθμίσεις ανοίγματος';

  @override
  String get paymentSuccessful => 'Η πληρωμή επιτυχής';

  @override
  String get permissionNotGranted => 'Η άδεια δεν έχει δοθεί';

  @override
  String get popularSearches => 'Δημοφιλείς αναζητήσεις';

  @override
  String get resetPasswordLinkSentToYourEmail =>
      'Θα σας στείλουμε τις οδηγίες για την επαναφορά του κωδικού σας στην ηλεκτρονική σας διεύθυνση. Ανοίξτε την ηλεκτρονική σας διεύθυνση και κάντε κλικ στον σύνδεσμο για να επαναφέρετε τον κωδικό σας αμέσως.';

  @override
  String get searchAgain => 'Αναζήτηση ξανά';

  @override
  String get sendResetLink => 'Στείλετε τον σύνδεσμο επαναφοράς';

  @override
  String get skipAd => 'Παράλειψη διαφημίσεων';

  @override
  String get suggestedChannels => 'Συστημένα κανάλια';

  @override
  String get topGenre => 'Το πιο δημοφιλές είδος';

  @override
  String get unableToLoadDownload => 'Δεν είναι δυνατή η φόρτωση της λήψης';

  @override
  String get uploadCustomProfileImage =>
      'Υποβολή προσαρμοσμένου εικονιδίου προφίλ';

  @override
  String get visitAdvertiser => 'Επισκεφθείτε τον διαφημιστή';

  @override
  String get youCanNotRevertThisActionLater =>
      'Δεν μπορείτε να ανακαλέσετε αυτήν την ενέργεια αργότερα';

  @override
  String get youDoNotHaveAccessToWatch =>
      'Δεν έχετε πρόσβαση να παρακολουθήσετε αυτό το περιεχόμενο';

  @override
  String get yourCurrentPlanSupports => 'Το τρέχον σας πρόγραμμα υποστηρίζει';

  @override
  String get yourPaymentWasCompleted => 'Η πληρωμή σας ολοκληρώθηκε επιτυχώς';

  @override
  String get otherSections => 'Άλλες ενότητες';

  @override
  String get newPasswordRequired => 'Απαιτείται νέος κωδικός πρόσβασης';

  @override
  String get noMoviesAvailable => 'Δεν υπάρχουν διαθέσιμες ταινίες';

  @override
  String get noTvShowsAvailable =>
      'Δεν υπάρχουν διαθέσιμες τηλεοπτικές εκπομπές';

  @override
  String get noVideosAvailable => 'Δεν υπάρχουν διαθέσιμα βίντεο';

  @override
  String noContentAvailableInContentType(String content, String contentType) =>
      'Δεν υπάρχει διαθέσιμο $contentType στο $content';

  @override
  String get unableToDownloadFilePleaseTryAgainLater =>
      'Δεν είναι δυνατή η λήψη του αρχείου. Παρακαλώ δοκιμάστε ξανά αργότερα.';

  @override
  String sorryCouldntShareThis(String type) =>
      'Λυπούμαστε, δεν ήταν δυνατή η κοινή χρήση αυτού του $type';

  @override
  String errorWhileMonitoringDownloadUpdates(String error) =>
      'Σφάλμα κατά την παρακολούθηση ενημερώσεων λήψης: $error';

  @override
  String get pleaseSelectACastingDeviceFirst =>
      'Παρακαλώ επιλέξτε πρώτα μια συσκευή μετάδοσης';

  @override
  String get noVideoUrlAvailableForCasting =>
      'Δεν υπάρχει διαθέσιμη διεύθυνση URL βίντεο για μετάδοση';

  @override
  String get contentTypeNotAvailableForCasting =>
      'Ο τύπος περιεχομένου δεν είναι διαθέσιμος για μετάδοση';

  @override
  String get invalidVideoUrlFormat => 'Μη έγκυρη μορφή URL βίντεο';

  @override
  String get failedInitiateRazorpayPayment =>
      'Αποτυχία έναρξης πληρωμής μέσω Razorpay';

  @override
  String cantFindPlanOnStore(String planName, String storeName) =>
      'Δεν είναι δυνατή η εύρεση του $planName στο $storeName';

  @override
  String get paymentNotCapturedContactSupport =>
      'Η πληρωμή δεν ολοκληρώθηκε. Παρακαλώ επικοινωνήστε με την υποστήριξη.';

  @override
  String get downloadDeletedSuccessfully => 'Η λήψη διαγράφηκε με επιτυχία!';

  @override
  String get pleaseSelectRating => 'Παρακαλώ επιλέξτε βαθμολογία';

  @override
  String get downloadsAllowedOnWifiOnly =>
      'Οι λήψεις επιτρέπονται μόνο μέσω Wi-Fi. Παρακαλώ συνδεθείτε σε Wi-Fi ή απενεργοποιήστε αυτήν τη ρύθμιση.';

  @override
  String get thisContentIsNotDownloadable =>
      'Λυπούμαστε! Αυτό το περιεχόμενο δεν είναι διαθέσιμο για λήψη';

  @override
  String get failedToStartDownload => 'Αποτυχία έναρξης λήψης';

  @override
  String get failedToResumeDownload => 'Αποτυχία συνέχισης λήψης';

  @override
  String get downloadCancelled => 'Η λήψη ακυρώθηκε';

  @override
  String get downloadCompleted => 'Η λήψη ολοκληρώθηκε';

  @override
  String get thePasswordDoesNotMatch => 'Ο κωδικός πρόσβασης δεν ταιριάζει';

  @override
  String get deleteMultipleDownload =>
      'Θέλετε να διαγράψετε το επιλεγμένο περιεχόμενο από τις λήψεις;';

  @override
  String profileLimitIncreaseMessage({
    required String planName,
    required int limit,
  }) {
    final profileText = limit > 1 ? "προφίλ" : "προφίλ";

    return "Το πρόγραμμα $planName επιτρέπει μόνο $limit $profileText. "
        "Παρακαλώ αφαιρέστε το επιπλέον $profileText για να συνεχίσετε.";
  }

  @override
  String get contectRestrictedForKidProfile =>
      'Αυτό το περιεχόμενο δεν επιτρέπεται σε παιδικό προφίλ.';

  @override
  String get recommendedForYou => 'Προτεινόμενα για εσάς';

  @override
  String get shortDrama => 'Μικρό Δράμα';

  @override
  String get yourNextObsessionStartsHere => 'Η επόμενη εμμονή σας ξεκινά εδώ';

  @override
  String get shortDramasIntenseStorytelling =>
      'Μικρά δράματα, έντονη αφήγηση, συναισθηματικό ρομάντζο και συναρπαστικές ανατροπές. Ανακαλύψτε ψυχαγωγία φτιαγμένη για κάθε διάθεση.';

  @override
  String get exploreMore => 'Εξερευνήστε περισσότερα';

  @override
  String get dramaForYou => 'Δράμα για εσάς';

  @override
  String get noEpisodesAvailable => 'Δεν υπάρχουν διαθέσιμα επεισόδια';

  @override
  String get audioLanguage => 'Γλώσσα ήχου';

  @override
  String get cantPlayThisTitleRightNow =>
      'Δεν είναι δυνατή η αναπαραγωγή αυτού του τίτλου αυτή τη στιγμή';

  @override
  String get goBack => 'Πίσω';

  @override
  String get unableToFindThisDramaForPlayback =>
      'Δεν είναι δυνατή η εύρεση αυτού του δράματος για αναπαραγωγή.';

  @override
  String get pleaseCheckYourConnectionAndTryAgain =>
      'Παρακαλούμε ελέγξτε τη σύνδεσή σας και δοκιμάστε ξανά.';

  @override
  String get seasons => 'Εποχές';

  @override
  String get mute => 'Σίγαση';

  @override
  String get unmute => 'Κατάργηση σίγασης';

  @override
  String get noInternetConnection => 'Δεν υπάρχει σύνδεση στο Διαδίκτυο';

  @override
  String get continueWatchingForYou => 'Συνεχίστε την προβολή για εσάς';
  
  @override
  String get playbackErrorGeneric => 'Σφάλμα αναπαραγωγής: Γενικό σφάλμα. Παρακαλώ δοκιμάστε ξανά.';
  
  @override
  String get playbackErrorSessionExpired => 'Σφάλμα αναπαραγωγής: Η περίοδος σύνδεσης έχει λήξει. Παρακαλώ συνδεθείτε ξανά και δοκιμάστε ξανά.';
  
  @override
  String get playbackErrorTokenExpired => 'Σφάλμα αναπαραγωγής: Η άδεια έχει λήξει. Παρακαλώ δοκιμάστε ξανά αυτό το επεισόδιο.';
  
  @override
  String get playbackErrorVideoPluginUnavailable => 'Σφάλμα αναπαραγωγής: Το πρόσθετο αναπαραγωγής βίντεο δεν είναι διαθέσιμο. Παρακαλώ επανεκκινήστε την εφαρμογή και δοκιμάστε ξανά.';

  @override
  String get less => 'Λιγότερα';

  @override
  String get more => 'Διαβάστε περισσότερα';
}

