import 'package:streamit_laravel/configs.dart';

import 'languages.dart';

class LanguageDe extends BaseLanguage {
  @override
  String get language => 'Sprache';

  @override
  String get badRequest => 'Ungültige Anfrage';

  @override
  String get forbidden => 'Verboten';

  @override
  String get pageNotFound => 'Seite nicht gefunden';

  @override
  String get tooManyRequests => 'Zu viele Anfragen';

  @override
  String get internalServerError => 'Interner Serverfehler';

  @override
  String get badGateway => 'Schlechtes Gateway';

  @override
  String get serviceUnavailable => 'Dienst nicht verfügbar';

  @override
  String get gatewayTimeout => 'Gateway-Timeout';

  @override
  String get gallery => 'Galerie';

  @override
  String get camera => 'Kamera';

  @override
  String get editProfile => 'Profil bearbeiten';

  @override
  String get reload => 'Neu laden';

  @override
  String get pressBackAgainToExitApp =>
      'Drücken Sie erneut „Zurück“, um die App zu verlassen';

  @override
  String get invalidUrl => 'Ungültige URL';

  @override
  String get cancel => 'Stornieren';

  @override
  String get delete => 'Löschen';

  @override
  String get demoUserCannotBeGrantedForThis =>
      'Für diese Aktion kann kein Demo-Benutzer zugelassen werden';

  @override
  String get somethingWentWrong => 'Etwas ist schief gelaufen';

  @override
  String get yourInternetIsNotWorking => 'Ihr Internet funktioniert nicht';

  @override
  String get profileUpdatedSuccessfully => 'Profil erfolgreich aktualisiert';

  @override
  String get likedSuccessfully => 'Liked successfully';

  @override
  String get unlikedSuccessfully => 'Unliked successfully';

  @override
  String get wouldYouLikeToSetProfilePhotoAs =>
      'Möchten Sie dieses Bild als Ihr Profilfoto festlegen?';

  @override
  String get yourConfirmPasswordDoesnT =>
      'Ihr Bestätigungspasswort stimmt nicht mit dem Passwort überein!';

  @override
  String get yes => 'Ja';

  @override
  String get submit => 'Einreichen';

  @override
  String get firstName => 'Vorname';

  @override
  String get lastName => 'Nachname';

  @override
  String get password => 'Passwort';

  @override
  String get confirmPassword => 'Passwort bestätigen';

  @override
  String get email => 'E-Mail';

  @override
  String get emailIsARequiredField => 'E-Mail ist ein Pflichtfeld';

  @override
  String get pleaseEnterValidEmailAddress =>
      'Bitte geben Sie eine gültige E-Mail-Adresse ein!!';

  @override
  String get signIn => 'Anmelden';

  @override
  String get explore => 'Erkunden';

  @override
  String get settings => 'Einstellungen';

  @override
  String get rateNow => 'Jetzt bewerten';

  @override
  String get logout => 'Abmelden';

  @override
  String get rememberMe => 'Erinnere dich an mich';

  @override
  String get forgotPassword => 'Passwort vergessen?';

  @override
  String get signUp => 'Melden Sie sich an';

  @override
  String get alreadyHaveAnAccount => 'Sie haben bereits ein Konto?';

  @override
  String get deleteAccount => 'Konto löschen';

  @override
  String get notifications => 'Benachrichtigungen';

  @override
  String get signInFailed => 'Die Anmeldung ist fehlgeschlagen';

  @override
  String get logIn => 'EINLOGGEN';

  @override
  String get stayTunedNoNew =>
      'Bleiben Sie dran! Keine neuen Benachrichtigungen.';

  @override
  String get noNewNotificationsAt =>
      'Im Moment keine neuen Benachrichtigungen. Wir halten Sie auf dem Laufenden, wenn es ein Update gibt';

  @override
  String get walkthroughTitle1 =>
      'Auf jedem Gerät ansehen: Genießen Sie unsere Inhalte, wo immer Sie sind!';

  @override
  String get walkthroughDesp1 =>
      'Streamen Sie auf allen Geräten ohne zusätzliche Kosten.';

  @override
  String get walkthroughTitle2 =>
      'Herunterladen und loslegen: Greifen Sie überall, jederzeit und auf jedem Gerät auf Ihre Inhalte zu';

  @override
  String get walkthroughDesp2 =>
      'Laden Sie Inhalte herunter und genießen Sie sie unterwegs, überall und jederzeit.';

  @override
  String get walkthroughTitle3 =>
      'Genießen Sie die Freiheit ohne Verpflichtungen oder Ärger – schließen Sie sich uns noch heute an!';

  @override
  String get walkthroughDesp3 =>
      'Treten Sie uns problemlos bei und es sind keine Verträge erforderlich.';

  @override
  String get lblSkip => 'Überspringen';

  @override
  String get lblNext => 'Nächste';

  @override
  String get lblGetStarted => 'Fangen Sie an';

  @override
  String get optionTitle =>
      'Entdecken Sie Top-Sendungen mit Genres, die auf Ihre Vorlieben zugeschnitten sind.';

  @override
  String get optionDesp =>
      'Entdecken Sie kuratierte Shows verschiedener Genres, die auf Ihre Sehvorlieben zugeschnitten sind.';

  @override
  String get welcomeBackToStreamIt => 'Willkommen zurück bei $APP_NAME!';

  @override
  String get weHaveEagerlyAwaitedYourReturn =>
      'Wir haben sehnsüchtig auf Ihre Rückkehr gewartet.';

  @override
  String get dontHaveAnAccount => 'Sie haben noch kein Konto? ';

  @override
  String get or => 'ODER';

  @override
  String get linkSentToYourEmail => 'Link an Ihre E-Mail gesendet!';

  @override
  String get checkYourInboxAndChangePassword =>
      'Überprüfen Sie Ihren Posteingang und ändern Sie das Passwort';

  @override
  String get continues => 'Weitermachen';

  @override
  String get oTPVerification => 'OTP-Überprüfung';

  @override
  String get checkYourSmsInboxAndEnterTheCodeYouGet =>
      'Überprüfen Sie Ihren SMS-Posteingang und geben Sie den Code ein, den Sie erhalten haben.';

  @override
  String get weHaveSentVerificationCodeToMobileNumber =>
      'Wir haben einen Bestätigungscode an Ihre Mobilnummer gesendet. Bitte geben Sie ihn ein, um fortzufahren.';

  @override
  String get didntGetTheOTP => 'Haben Sie das OTP nicht erhalten?';

  @override
  String get resendOTP => 'OTP erneut senden';

  @override
  String youCanResendOTPIn(int seconds) =>
      'Sie können das OTP in $seconds erneut senden';

  @override
  String get otpHasBeenResentToMobileNumber =>
      'OTP wurde erneut an Ihre Mobilnummer gesendet';

  @override
  String get verify => 'Verifizieren';

  @override
  String get clearAll => 'Alles löschen';

  @override
  String get notificationDeleted => 'Benachrichtigung gelöscht';

  @override
  String get doYouWantToMarkAllNotificationAsRead =>
      'Möchten Sie alle Benachrichtigungen löschen?';

  @override
  String get doYouWantToDeleteThisNotification =>
      'Möchten Sie diese Benachrichtigung löschen?';

  @override
  String get successfully => 'Erfolgreich';

  @override
  String get userCancelled => 'Benutzer hat abgesagt';

  @override
  String get appleSigninIsNot =>
      'Apple SignIn ist für Ihr Gerät nicht verfügbar';

  @override
  String get searchHere => 'Suchen Sie hier';

  @override
  String get noDataFound => 'Keine Daten gefunden';

  @override
  String get subscribe => 'Abonnieren';

  @override
  String get subscribeToWatch => 'Abonnieren Sie, um zuzuschauen';

  @override
  String get playNow => 'jetzt spielen';

  @override
  String get continueWatching => 'Schauen Sie weiter ';

  @override
  String get noContinueWatchingTitle => 'Keine Titel zum Weiterschauen';

  @override
  String get noContinueWatchingSubtitle =>
      'Beginne mit dem Ansehen von Inhalten, um sie hier zu sehen';

  @override
  String get shareYourThoughtsWithUs => 'Teilen Sie Ihre Gedanken mit uns!';

  @override
  String get weValueYourOpinion =>
      'Wir legen Wert auf Ihre Meinung! Teilen Sie uns noch heute Ihr Feedback mit.';

  @override
  String get genres => 'Genres';

  @override
  String get trailer => 'ANHÄNGER';

  @override
  String get ua18 => 'U/A 18';

  @override
  String get watchNow => 'Jetzt ansehen';

  @override
  String get resume => 'Fortsetzen';

  @override
  String get pause => 'Pause';

  @override
  String get paused => 'Pausiert';

  @override
  String get cast => 'Abgüsse';

  @override
  String get directors => 'Direktoren';

  @override
  String get reviews => 'Rezensionen';

  @override
  String get viewAll => 'Alle anzeigen';

  @override
  String get rating => 'Bewertung';

  @override
  String get justNow => 'Soeben';

  @override
  String get daysAgo => 'vor Tagen';

  @override
  String get yesterday => 'Gestern';

  @override
  String get ago => 'vor';

  @override
  String get min => 'min';

  @override
  String get hr => 'Std';

  @override
  String get s => 'S';

  @override
  String get moreLikeThis => 'Eher so';

  @override
  String get rateThisMovie => 'Bewerten Sie diesen Film';

  @override
  String get rateThisTvShow => 'Bewerten Sie diese TV-Sendung';

  @override
  String get yourReview => 'Ihre Bewertung';

  @override
  String get edit => 'Bearbeiten';

  @override
  String get close => 'Schließen';

  @override
  String get oppsLooksLikeYouReview =>
      'Upps! Anscheinend haben Sie noch keine Bewertung hinzugefügt.';

  @override
  String get retry => 'Wiederholen';

  @override
  String get selectDownloadQuality => 'Wählen Sie die Downloadqualität aus';

  @override
  String get onlyOnWiFi => 'Nur über WLAN';

  @override
  String get download => 'Herunterladen';

  @override
  String get downloading => 'Wird heruntergeladen...';

  @override
  String get downloaded => 'Heruntergeladen';

  @override
  String moviesTvShowsOf(String name) => 'Filme/Serien von $name';

  @override
  String reviewsOf(String name) => 'Bewertungen von $name';

  @override
  String get season => 'Jahreszeit';

  @override
  String get episode => 'Folge ';

  @override
  String get watchlist => 'Beobachtungsliste';

  @override
  String get removeFromWatchlist => 'Aus der Beobachtungsliste entfernen';

  @override
  String get searchMoviesShowsAndMore =>
      'Suchen Sie nach Filmen, Shows und mehr';

  @override
  String get trendingMovies => 'Trendfilme ';

  @override
  String get comingSoon => 'Kommt bald';

  @override
  String get remindMe => 'Erinnere mich daran';

  @override
  String get remind => 'Erinnern';

  @override
  String get readLess => 'Weniger lesen';

  @override
  String get readMore => '...Mehr lesen';

  @override
  String get liveTv => 'Live-TV';

  @override
  String get live => 'Live';

  @override
  String get profile => 'Profil';

  @override
  String get expiringOn => 'Läuft am ab';

  @override
  String get updrade => 'Upgrade';

  @override
  String get subscribeToEnjoyMore => 'Abonnieren Sie, um mehr zu genießen';

  @override
  String get daysFreeTrail =>
      'Schalten Sie noch heute exklusive Funktionen frei';

  @override
  String get privacyPolicy => 'Datenschutzrichtlinie';

  @override
  String get helpSupport => 'Hilfe-Support';

  @override
  String get rateOurApp => 'Bewerte unsere App';

  @override
  String get rateOurAppSubtitle => 'Bewerte unsere App, um uns zu unterstützen';

  @override
  String get appLanguage => 'App-Sprache';

  @override
  String get yourDownloads => 'Ihre Downloads';

  @override
  String get subscriptionPlanDeviceConnected =>
      'Abonnementplan, Gerät verbunden';

  @override
  String get accountSettings => 'Kontoeinstellungen';

  @override
  String get accountControl => 'Kontensteuerung';

  @override
  String get parentalControlsSubtitle =>
      'Zugriff auf Erwachsenenprofile mit einer PIN einschränken';

  @override
  String get subscriptionAndRentals => 'Abonnement & Leihen';

  @override
  String deviceLimitMessage(String limit) =>
      'Sie können bis zu $limit Geräte gleichzeitig verwenden.';

  @override
  String get videoCastingEnabled => 'Video-Casting ist aktiviert.';

  @override
  String get videoCastingDisabled => 'Video-Casting ist nicht verfügbar.';

  @override
  String get adsWillBeShown => 'Werbung wird angezeigt';

  @override
  String get adsWillNotBeShown => 'Keine Werbung wird angezeigt';

  @override
  String get downloadResolution => 'Download-Auflösung';

  @override
  String get supportedDeviceType => 'Unterstützter Gerätetyp';

  @override
  String profileLimitMessage(String limit) =>
      'Sie können bis zu $limit Profile in diesem Tarif für verschiedene Benutzer erstellen.';

  @override
  String get transactionHistory => 'Transaktionsverlauf';

  @override
  String get transactionHistorySubtitle =>
      'Verwalten Sie Ihre Abonnement- & Leihhistorie';

  @override
  String get subscriptionHistorySubtitle =>
      'Greifen Sie auf Ihre Abonnement-Zahlungsaufzeichnungen zu';

  @override
  String get rentalHistorySubtitle =>
      'Greifen Sie auf Ihre Miet-Zahlungshistorie zu';

  @override
  String get deviceManagement => 'Geräteverwaltung';

  @override
  String get kidsProfileCannotAccessSubscription =>
      'Abonnement-Funktionen sind für Kinderprofile eingeschränkt.';

  @override
  String get accountAndActivation => 'Konto & Aktivierung';

  @override
  String get accountSectionTitle => 'Konto';

  @override
  String get accountSectionSubtitle =>
      'Konto, Abonnements und Leihen verwalten';

  @override
  String get activateTvWeb => 'TV & Web aktivieren';

  @override
  String get activateTvWebSubtitle => 'TV & Web verbinden und verwalten';

  @override
  String get savedVideos => 'Gespeicherte Videos';

  @override
  String get myList => 'Meine Liste';

  @override
  String get myListSubtitle => 'Ihre Liste zum späteren Ansehen';

  @override
  String get pickUpWhereYouLeftOff => 'Dort weitermachen, wo du aufgehört hast';

  @override
  String get continueWatchingSubtitle =>
      'Dort weiterschauen, wo du aufgehört hast';

  @override
  String get rentals => 'Leihen';

  @override
  String get rentalsSubtitle =>
      'Greife auf deine geliehenen Filme und Serien zu';

  @override
  String get rentalsAndDownloads => 'Leihen und Downloads';

  @override
  String get yourRentals => 'Deine Leihen';

  @override
  String get noRentedContentFound => 'Kein geliehener Inhalt gefunden';

  @override
  String get noRentedContentSubtitle =>
      'Mieten Sie Filme, Episoden und Videos, um sofort hier Zugriff zu erhalten';

  @override
  String get autoUpdate => 'Automatische Aktualisierung';

  @override
  String get downloadOverWifiOnly => 'Nur über WLAN herunterladen';

  @override
  String get smartDelete => 'Intelligentes Löschen';

  @override
  String get smartDeleteSubtitle =>
      'Heruntergeladene Inhalte nach Abschluss löschen';

  @override
  String get downloads => 'Downloads';

  @override
  String get downloadsSubtitle => 'Offline-Inhalte anzeigen und verwalten';

  @override
  String get settingsAndSupport => 'Einstellungen & Support';

  @override
  String get settingsSubtitle => 'Updates, Sprache und Downloads';

  @override
  String get helpSupportSubtitle => 'FAQs, AGB und Datenschutzrichtlinie';

  @override
  String get appVersionPrefix => 'App-Version';

  @override
  String get version => 'Version';

  @override
  String get registeredMobileNumber => 'Registrierte Handynummer';

  @override
  String get otherDevices => 'Andere Geräte';

  @override
  String get yourDevice => 'Ihr Gerät';

  @override
  String get lastUsed => 'Zuletzt verwendet';

  @override
  String get currentDevice => 'Aktuelles Gerät';

  @override
  String get proceed => 'Fortfahren';

  @override
  String get allYourDataWill => 'Alle Ihre Daten werden dauerhaft gelöscht';

  @override
  String get deleteAccountPermanently => 'Konto dauerhaft löschen?';

  @override
  String doYouWantToDeleteProfile(String profileName) =>
      'Möchten Sie das Profil für $profileName löschen?';

  @override
  String shareYourThoughtsOnContent(String contentName, String type) =>
      'Teilen Sie Ihre Gedanken zu $contentName $type';

  @override
  String get mobileNumber => 'Handynummer';

  @override
  String get verifyPin => 'PIN überprüfen';

  @override
  String get downloadInvoice => 'Rechnung herunterladen';

  @override
  String get saveChanges => 'Änderungen speichern';

  @override
  String get startWatchingFromWhereYouLeftOff =>
      'Fangen Sie dort an, wo Sie aufgehört haben';

  @override
  String get troubleLoggingIn => 'Probleme beim Anmelden?';

  @override
  String get getHelp => 'Holen Sie sich Hilfe';

  @override
  String get helpAndSupport => 'Hilfe & Support';

  @override
  String get noHelpTopicsFound => 'Keine Hilfethemen gefunden';

  @override
  String get helpAndSupportTopicsSubtitle =>
      'Hilfe- und Supportthemen werden hier angezeigt';

  @override
  String get yourWatchlistIsEmpty => 'Ihre Merkliste ist leer';

  @override
  String get contentAddedToYourWatchlist =>
      'Zu Ihrer Beobachtungsliste hinzugefügte Inhalte werden hier angezeigt';

  @override
  String get add => 'Hinzufügen';

  @override
  String get subscribeNowAndDiveInto =>
      'Abonnieren Sie jetzt und tauchen Sie ein in endloses Streaming';

  @override
  String get pay => 'Zahlen';

  @override
  String get next => 'Nächste';

  @override
  String get subscription => 'Abonnement';

  @override
  String get validUntil => 'Gültig bis ';

  @override
  String get choosePaymentMethod => 'Wählen Sie die Zahlungsmethode';

  @override
  String get secureCheckoutInSeconds =>
      '100 % sicherer Checkout in Sekundenschnelle';

  @override
  String get proceedPayment => 'Zahlung fortsetzen';

  @override
  String get paymentFailedMessage =>
      'Zahlung abgebrochen. Bitte versuchen Sie es erneut, wenn Sie fortfahren möchten.';

  @override
  String get actors => 'Schauspieler';

  @override
  String get movies => 'Filme';

  @override
  String get contentRestrictedAccess =>
      'Beschränkter Zugriff auf Inhalte ab 18 Jahren';

  @override
  String get areYou18Above => 'Sind Sie mindestens 18 Jahre alt?';

  @override
  String get displayAClearProminentWarning =>
      'Zeigen Sie vor dem Zugriff auf den Inhalt eine klare und deutliche Warnung an, die darauf hinweist, dass er für ein erwachsenes Publikum bestimmt ist.';

  @override
  String get all => 'Alle';

  @override
  String get tVShows => 'Fernsehsendungen';

  @override
  String get videos => 'Videos';

  @override
  String get newlyAdded => 'Neu hinzugefügt';

  @override
  String get free => 'frei';

  @override
  String get phnRequiredText => 'Handynummer ist erforderlich';

  @override
  String get inputMustBeNumberOrDigit =>
      'Die Eingabe muss eine Zahl oder Ziffer sein';

  @override
  String get dateOfBirth => 'Geburtsdatum';

  @override
  String get dateOfBirthRequired => 'Geburtsdatum ist erforderlich';

  @override
  String get whatYourMobileNo => 'Wie lautet Ihre Handynummer?';

  @override
  String get withAValidMobileNumberYouCanConnectWithStreamit =>
      'Mit einer gültigen Handynummer können Sie sich mit streamit verbinden';

  @override
  String get otpSentToYourSMS => 'OTP an Ihre SMS gesendet!';

  @override
  String get checkYourSmsInboxAndVerifyYoourMobile =>
      'Überprüfen Sie Ihren SMS-Posteingang und bestätigen Sie Ihre Handynummer';

  @override
  String get pleaseTryAgainAfterSomeTime =>
      'Bitte versuchen Sie es nach einiger Zeit erneut. Sie haben mehrere Zeitverifizierungsanfragen verwendet!';

  @override
  String get pleaseEnterAValidCode => 'Bitte geben Sie ein gültiges OTP ein';

  @override
  String get pleaseCheckYourMobileInternetConnection =>
      'Bitte überprüfen Sie Ihre mobile Internetverbindung';

  @override
  String get error => 'Fehler';

  @override
  String get sorryCouldnFindYourSearch =>
      'Leider konnte Ihre Suche nicht gefunden werden!';

  @override
  String get trySomethingNew => 'Probieren Sie etwas Neues aus.';

  @override
  String get genresNotAvailable => 'Genres nicht verfügbar!';

  @override
  String get downloadSuccessfully => 'Erfolgreich heruntergeladen';

  @override
  String get popularMovies => 'Beliebte Filme';

  @override
  String get confirm => 'Bestätigen';

  @override
  String get doYouConfirmThisPlan => 'Bestätigen Sie diesen Abonnementplan ';

  @override
  String get transactionFailed => 'Transaktion fehlgeschlagen';

  @override
  String get transactionCancelled => 'Transaktion abgebrochen';

  @override
  String get no => 'NEIN';

  @override
  String get lblChangeCountry => 'Land ändern';

  @override
  String get selectCountry => 'Land auswählen';

  @override
  String get logOutAll => 'Alle abmelden';

  @override
  String get taxIncluded => 'Inklusive Steuern';

  @override
  String get bookNow => 'Buchen Sie jetzt';

  @override
  String get firstNameIsRequiredField => 'Der Vorname ist erforderlich';

  @override
  String get lastNameIsRequiredField => 'Der Nachname ist erforderlich';

  @override
  String get passwordIsRequired => 'Ein Passwort ist erforderlich';

  @override
  String get oldPasswordIsRequired => 'Das alte Passwort ist erforderlich';

  @override
  String get passwordLengthRule => 'Das Passwort muss 8–14 Zeichen lang sein';

  @override
  String get passwordUppercaseRule =>
      'Das Passwort muss mindestens einen Großbuchstaben enthalten';

  @override
  String get passwordLowercaseRule =>
      'Das Passwort muss mindestens einen Kleinbuchstaben enthalten';

  @override
  String get passwordSpecialCharacterRule =>
      'Das Passwort muss mindestens ein Sonderzeichen (@\$!%*?&) enthalten';

  @override
  String get passwordDigitRule =>
      'Das Passwort muss mindestens eine Ziffer enthalten';

  @override
  String get confirmPasswordIsRequired =>
      '„Passwort bestätigen“ ist erforderlich';

  @override
  String get home => 'Heim';

  @override
  String get search => 'Suchen';

  @override
  String get mobileNumberIsRequired =>
      'Die Mobiltelefonnummer ist ein Pflichtfeld';

  @override
  String get youHaveAlreadyDownloadedThisMovie =>
      'Sie haben diesen Film bereits heruntergeladen';

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
  String get flutterWavePay => 'Flutterwave';

  @override
  String get cinetPay => 'CinetPay';

  @override
  String get lblCheckOutWithCinetPay => 'Bezahlen mit CinetPay';

  @override
  String get contextNotFound => 'Kontext nicht gefunden!!!!';

  @override
  String get verificationFailed => 'Überprüfung fehlgeschlagen';

  @override
  String get english => 'Englisch';

  @override
  String get hour => 'Stunde';

  @override
  String get minute => 'Minute';

  @override
  String get sec => 'Sek';

  @override
  String get videoNotFound => 'Video nicht gefunden!!';

  @override
  String get auto => 'Auto';

  @override
  String get recommended => 'Empfohlen';

  @override
  String get medium => 'Medium';

  @override
  String get high => 'Hoch';

  @override
  String get low => 'Niedrig';

  @override
  String get helpSetting => 'Hilfe & Einstellung';

  @override
  String get pleaseConfirmContent =>
      'Bitte bestätigen Sie den eingeschränkten Inhaltszugriff';

  @override
  String get toWatch => 'Zum Anschauen';

  @override
  String get plan => 'Planen';

  @override
  String get toThe => 'Zum';

  @override
  String get noDeviceAvailable => 'Keine Geräte verfügbar';

  @override
  String get noItemsToContinueWatching =>
      'Keine Artikel zum Weiterschauen vorhanden';

  @override
  String get noItemsAddedToTheWatchlist =>
      'Der Beobachtungsliste wurden keine Elemente hinzugefügt';

  @override
  String get ok => 'OK';

  @override
  String removeFromContinueWatchingTitle(String title, String typeLabel) =>
      'Möchten Sie $title $typeLabel aus Ihrer „Weiter ansehen“-Liste entfernen?';

  @override
  String get addedToWatchList => 'Beobachtungsliste erfolgreich hinzugefügt';

  @override
  String get removedFromWatchList => 'Beobachtungsliste erfolgreich gelöscht';

  @override
  String get removeSelectedFromWatchList =>
      'Möchten Sie ausgewählte Inhalte aus Ihrer Beobachtungsliste entfernen?';

  @override
  String get removedFromContinueWatch =>
      'Weiter beobachten, erfolgreich gelöscht';

  @override
  String get pleaseEnterAValidMobileNo =>
      'Bitte geben Sie eine gültige Handynummer ein';

  @override
  String get pleaseAddYourReview => 'Bitte fügen Sie Ihre Bewertung hinzu';

  @override
  String get thisMovieIsCurrentlUnavailableToWatch =>
      'Dieser Film kann derzeit nicht angesehen werden';

  @override
  String get thisVideoIsCurrentlUnavailableToWatch =>
      'Dieses Video kann derzeit nicht angesehen werden';

  @override
  String get subscriptionHistory => 'Abonnementverlauf';

  @override
  String get type => 'Typ';

  @override
  String get amount => 'Menge';

  @override
  String get cancelPlan => 'Plan kündigen';

  @override
  String get device => 'Gerät';

  @override
  String get clear => 'Klar';

  @override
  String get doYouWantToLogoutFrom => 'Möchten Sie sich abmelden';

  @override
  String get sAlphabet => 'S';

  @override
  String get eAlphabet => 'E';

  @override
  String get viewMore => 'Mehr anzeigen';

  @override
  String get viewLess => 'Weniger anzeigen';

  @override
  String get removeSelectedFromDownloads =>
      'Möchten Sie dies aus Ihren Downloads entfernen?';

  @override
  String get noPaymentMethodsFound => 'Keine Zahlungsmethoden gefunden';

  @override
  String get save => 'Speichern';

  @override
  String get completeProfile => 'Vervollständigen Sie Ihr Profil';

  @override
  String get completeProfileSubtitle =>
      'Erzählen Sie uns zunächst mehr über sich';

  @override
  String get getVerificationCode => 'Holen Sie sich den Bestätigungscode';

  @override
  String get contentRating => 'Inhaltsbewertung';

  @override
  String get profiles => 'Profile';

  @override
  String get addProfile => 'Profil hinzufügen';

  @override
  String get clearSearchHistoryConfirmation =>
      'Möchten Sie Ihren Suchverlauf löschen?';

  @override
  String get clearSearchHistorySubtitle =>
      'Diese Aktion kann nicht rückgängig gemacht werden und alle vorherigen Suchvorgänge werden dauerhaft gelöscht.';

  @override
  String get searchingForDevice => 'Suche nach Geräten';

  @override
  String get screenCast => 'Screencast';

  @override
  String get connectTo => 'Verbinden mit';

  @override
  String get disconnectFrom => 'Trennen Sie sich von';

  @override
  String get signInWithGoogle => 'Melden Sie sich mit Google an';

  @override
  String get signInWithApple => 'Melden Sie sich bei Apple an';

  @override
  String get whoIsWatching => 'Wer schaut zu?';

  @override
  String get doYouWantTo => 'Möchten Sie den Suchverlauf löschen?';

  @override
  String get mobile => 'Mobil ';

  @override
  String get tablet => 'Tablette ';

  @override
  String get tv => 'Tv ';

  @override
  String get laptop => 'Laptop ';

  @override
  String get supported => 'Unterstützt';

  @override
  String get notSupported => 'Nicht unterstützt';

  @override
  String get freeMovies => 'Kostenlose Filme';

  @override
  String get top10 => 'Top 10';

  @override
  String get latestMovies => 'Neu erschienene Filme';

  @override
  String get topChannels => 'Top-Kanäle';

  @override
  String get popularTvShows => 'Beliebte Fernsehsendungen';

  @override
  String get popularVideos => 'Meistgesehene Videos';

  @override
  String get popularLanguages => 'Beliebte Sprachen';

  @override
  String get trending => 'Im Trend';

  @override
  String get trendingInYourCountry => 'Trend in Ihrem Land';

  @override
  String get favoriteGenres => 'Lieblingsgenres';

  @override
  String get basedOnYourPreviousWatch => 'Weil du es dir angesehen hast';

  @override
  String get mostLiked => 'Am meisten gefallene Filme';

  @override
  String get mostViewed => 'Bestbewertete Filme auf IMDB';

  @override
  String get yourFavoritePersonalities => 'Ihre Lieblingspersönlichkeiten';

  @override
  String get name => 'Name';

  @override
  String get enterName => 'Name eingeben';

  @override
  String get nameCannotBeEmpty => 'Der Name darf nicht leer sein';

  @override
  String get update => 'Aktualisieren';

  @override
  String get remove => 'Entfernen';

  @override
  String get recentSearch => 'Letzte Suche';

  @override
  String get noRecentSearches => 'Keine aktuellen Suchanfragen';

  @override
  String get chooseImageSource => 'Wählen Sie Bildquelle';

  @override
  String get noInternetAvailable => 'Kein Internet verfügbar';

  @override
  String get goToYourDownloads => 'Gehen Sie zu Ihren Downloads';

  @override
  String welcomeUserMessage(String appName, String name) =>
      "Hey $name, willkommen bei $appName! Deine Reise in unbegrenzte Unterhaltung beginnt jetzt – tauche ein und genieße die Show!";

  @override
  String get bySigningYouAgreeTo =>
      'Mit Ihrer Unterschrift erklären Sie sich damit einverstanden';

  @override
  String get lowQuality => 'Niedrige Qualität';

  @override
  String get mediumQuality => 'Mittlere Qualität';

  @override
  String get highQuality => 'Hohe Qualität';

  @override
  String get veryHighQuality => 'Sehr hohe Qualität';

  @override
  String get ultraQuality => 'Ultra-Qualität';

  @override
  String get termsConditions => 'Allgemeine Geschäftsbedingungen';

  @override
  String get ofAll => 'von allen';

  @override
  String get servicesAnd => 'Dienstleistungen und ';

  @override
  String get newProfileAddedSuccessfully =>
      'Neues Profil erfolgreich hinzugefügt';

  @override
  String get doYouWantToDeleteYourReview =>
      'Möchten Sie Ihre Bewertung löschen?';

  @override
  String get noSearchDataFound => 'Keine Suchdaten gefunden';

  @override
  String get searchHistory => 'Suchverlauf';

  @override
  String get youHaveBeenLoggedOutOfYourAccountOn =>
      'Sie wurden am von Ihrem Konto abgemeldet';

  @override
  String get faqs => 'FAQs';

  @override
  String get termsOfUse => 'Nutzungsbedingungen';

  @override
  String get refundAndCancellationPolicy =>
      'Rückerstattungs- und Stornierungsbedingungen';

  @override
  String get dataDeletionRequest => 'Antrag auf Datenlöschung';

  @override
  String get aboutUs => 'Über uns';

  @override
  String get total => 'Gesamt';

  @override
  String get percentage => 'Prozentsatz';

  @override
  String get fixed => 'behoben';

  @override
  String get android => 'Android';

  @override
  String get ios => 'iOS';

  @override
  String get hindi => 'Hindi';

  @override
  String get arabic => 'Arabisch';

  @override
  String get french => 'Französisch';

  @override
  String get german => 'Deutsch';

  @override
  String get noFAQsfound => 'Keine FAQs gefunden';

  @override
  String get tax => 'Steuer';

  @override
  String get downloadHasBeenStarted => 'Der Download wurde gestartet';

  @override
  String get yourDeviceIsNot =>
      'Ihr Gerät wird mit dem aktuellen Plan nicht unterstützt';

  @override
  String get pleaseUpgradeToContinue =>
      'Bitte aktualisieren Sie, um den Service weiterhin nutzen zu können';

  @override
  String get cancelled => 'Abgesagt';

  @override
  String get deactivated => 'Deaktiviert';

  @override
  String get expired => 'Abgelaufen';

  @override
  String get active => 'Aktiv';

  @override
  String get connectToWIFI => 'Bitte stellen Sie eine WLAN-Verbindung her';

  @override
  String get logoutAllConfirmation =>
      'Möchten Sie alle anderen Geräte abmelden?';

  @override
  String get logoutAllConfirmationMessage =>
      'Um das Gerätelimit Ihres neuen Tarifs durchzusetzen, müssen Sie sich sofort von allen Geräten abmelden.';

  @override
  String get changePasswordMessage =>
      'Ihr Passwort wurde aktualisiert. Bitte melden Sie sich erneut an, um fortzufahren.';

  @override
  String get share => 'Aktie';

  @override
  String get like => 'Wie';

  @override
  String get pip => 'PIP';

  @override
  String get videoCast => 'Gießen';

  @override
  String get castingNotSupported =>
      'Casting wird mit dem aktuellen Plan nicht unterstützt.';

  @override
  String get left => "verbleibend";

  @override
  String get loginWithOtp => 'Melden Sie sich mit OTP an';

  @override
  String get loginWithEmail => 'Melden Sie sich mit E-Mail an';

  @override
  String get createYourAccount => 'Erstellen Sie Ihr Konto';

  @override
  String get changePassword => 'Kennwort ändern';

  @override
  String get yourNewPasswordMust =>
      'Ihr neues Passwort muss sich von Ihrem vorherigen Passwort unterscheiden';

  @override
  String get yourOldPasswordDoesnT => 'Ihr altes Passwort ist nicht korrekt!';

  @override
  String get yourNewPasswordDoesnT =>
      "Ihr bestätigtes Passwort stimmt nicht mit dem neuen Passwort überein!";

  @override
  String get oldAndNewPassword => 'Altes und neues Passwort sind gleich.';

  @override
  String get yourPasswordHasBeen =>
      'Ihr Passwort wurde erfolgreich zurückgesetzt';

  @override
  String get youCanNowLog =>
      'Sie können sich jetzt mit Ihrem neuen Passwort bei Ihrem neuen Konto anmelden';

  @override
  String get done => 'Erledigt';

  @override
  String get oldPassword => 'Altes Passwort';

  @override
  String get newPassword => 'Neues Passwort';

  @override
  String get confirmNewPassword => 'Bestätigen Sie das neue Passwort';

  @override
  String get birthdayIsRequired => 'Geburtstag ist erforderlich';

  @override
  String get childrenSProfile => 'Kinderprofil';

  @override
  String get madeForKidsUnder12 => 'Für Kinder unter 12 Jahren';

  @override
  String get otpVerifiedFailed => 'Die OTP-Überprüfung ist fehlgeschlagen';

  @override
  String get otpVerifiedSuccessfully => 'OTP erfolgreich verifiziert';

  @override
  String get otpSentSuccessfully => 'OTP erfolgreich gesendet';

  @override
  String get weHaveSentYouOTPOnYourRegisterEmailAddress =>
      'Wir haben Ihnen OTP an Ihre registrierte E-Mail-Adresse gesendet';

  @override
  String get otpVerification => 'OTP-Verifizierung';

  @override
  String get enterPIN => 'PIN eingeben';

  @override
  String get enterYourNewParentalPinForYourKids =>
      'Geben Sie Ihre neue Eltern-PIN für Ihre Kinder ein';

  @override
  String get enterYourOldParentalPinForYourKids =>
      'Geben Sie Ihre alte Eltern-PIN für Ihre Kinder ein';

  @override
  String get confirmPIN => 'PIN bestätigen';

  @override
  String get setPIN => 'PIN festlegen';

  @override
  String get changePIN => 'PIN ändern';

  @override
  String get parentalControl => 'Kindersicherung';

  @override
  String get invalidPIN => 'Ungültige PIN';

  @override
  String get kids => 'KINDER';

  @override
  String get enter4DigitParentalControlPIN =>
      'Geben Sie die 4-stellige Kindersicherungs-PIN ein';

  @override
  String get parentalLock => 'Kindersicherung';

  @override
  String get profileDeletedSuccessfully => 'Profil erfolgreich gelöscht';

  @override
  String get pinNotMatched => 'PIN stimmt nicht überein';

  @override
  String get pleaseEnterNewPIN => 'Bitte geben Sie eine neue PIN ein';

  @override
  String get pleaseEnterOldPIN => 'Bitte geben Sie Ihre alte PIN ein';

  @override
  String get pleaseEnterConfirmPin =>
      'Bitte geben Sie die Bestätigungs-PIN ein';

  @override
  String get codeWithColon => 'Code eingeben:';

  @override
  String get useThisCodeToGet => 'Verwenden Sie diesen Code, um zu erhalten ';

  @override
  String get off => ' aus';

  @override
  String get expiryDate => 'Verfallsdatum: ';

  @override
  String get apply => 'Anwenden';

  @override
  String get coupons => 'Gutscheine';

  @override
  String get enterCouponCode => 'Gutscheincode eingeben';

  @override
  String get check => 'Überprüfen';

  @override
  String get allCoupons => 'Alle Gutscheine';

  @override
  String get oopsWeCouldnTFind =>
      'Hoppla! Wir konnten keine passenden Gutscheincodes finden';

  @override
  String doYouWantToRemoveCoupon(String name) =>
      'Möchten Sie diesen $name Gutschein entfernen?';

  @override
  String get noSubscriptionHistoryFound => 'Kein Abonnementverlauf gefunden';

  @override
  String get couponDiscount => 'Coupon-Rabatt ';

  @override
  String get linkTv => 'Link-TV';

  @override
  String get youHaveBeenLoggedOutSuccessfully =>
      'Sie wurden erfolgreich abgemeldet';

  @override
  String get rented => 'GEMIETET';

  @override
  String get rent => 'MIETEN';

  @override
  String get rentFor => 'Mieten für';

  @override
  String get oneTime => 'EINMAL';

  @override
  String get oneTimeFor => 'Einmal für';

  @override
  String rentedesc(int availableFor, int duration) =>
      'Nach der Ausleihe haben Sie $availableFor ${availableFor > 1 ? 'Tage' : 'Tag'} Zeit, um mit dem Ansehen zu beginnen. Nach dem Start des Streamings haben Sie $duration ${duration > 1 ? 'Tage' : 'Tag'} Zeit, um das Video zu beenden.';

  @override
  String youCanWatchThis(int duration) =>
      'Sie können diesen Inhalt während des Zeitraums von $duration ${duration > 1 ? 'Tage' : 'Tag'} mehrmals ansehen.';

  @override
  String get thisIsANonRefundable =>
      'Dies ist eine nicht erstattungsfähige Transaktion.';

  @override
  String get thisContentIsOnly =>
      'Dieser Inhalt ist nur zum Mieten verfügbar und nicht Teil des Premium-Abonnements.';

  @override
  String get youCanPlayYour =>
      'Sie können Ihre Inhalte auf unterstützten Geräten abspielen.';

  @override
  String get validity => 'Gültigkeit';

  @override
  String get day => 'Tag';

  @override
  String get days => 'Tage';

  @override
  String get watchTime => 'Wiedergabezeit';

  @override
  String get hours => 'Std';

  @override
  String get week => 'Woche';

  @override
  String get weeks => 'Wochen';

  @override
  String get month => 'Monat';

  @override
  String get months => 'Monate';

  @override
  String get year => 'Jahr';

  @override
  String get years => 'Jahre';

  @override
  String get byRentingYouAgreeToOur => 'Mit der Anmietung stimmen Sie unseren';

  @override
  String get pleaseAgreeToThe =>
      'Bitte stimmen Sie den Nutzungsbedingungen zu, bevor Sie fortfahren.';

  @override
  String enjoyUntilDays(int days) => 'Genießen Sie bis zu $days Tage';

  @override
  String get beginWatching => 'Jetzt ansehen';

  @override
  String doYouConfirmThis(String movieName) =>
      'Bestätigen Sie die Ausleihe von $movieName?';

  @override
  String get unlockedVideo => 'freigeschaltetes Video';

  @override
  String get info => 'Info';

  @override
  String confirmDeleteDownload(String title) =>
      'Möchten Sie $title aus Ihren Downloads löschen?';

  @override
  String get payPerView => 'Bezahlung pro Ansicht';

  @override
  String skipIn(int seconds) => 'Überspringen in $seconds';

  @override
  String get newPinSuccessfullySaved => 'Neue PIN erfolgreich gespeichert';

  @override
  String get successfullyUpdated => 'Erfolgreich aktualisiert';

  @override
  String get defaultLabel => 'Standard';

  @override
  String get quality => 'Qualität';

  @override
  String get audio => 'Audio';

  @override
  String get audioAndQuality => 'Audio & Qualität';

  @override
  String get subtitle => 'Untertitel';

  @override
  String get skip => 'Überspringen';

  @override
  String get skipIntro => 'Intro überspringen';

  @override
  String get nextEpisode => 'Nächste Folge';

  @override
  String get rentDetails => 'Mietdetails';

  @override
  String get rentalInfo => 'Mietinformationen';

  @override
  String get pleaseSelectPaymentMethod =>
      'Bitte wählen Sie eine Zahlungsmethode.';

  @override
  String get tvLinkedSuccessfully => 'TV erfolgreich verbunden!';

  @override
  String get cameraPermissionDenied =>
      'Kameraberechtigung verweigert. Bitte aktivieren Sie sie in den Einstellungen.';

  @override
  String get advertisement => 'Werbung';

  @override
  String get castConnectInfo =>
      'Stellen Sie sicher, dass Ihr Chromecast-Gerät eingeschaltet und mit demselben WLAN-Netzwerk verbunden ist.';

  @override
  String get connect => 'Verbinden';

  @override
  String get disconnect => 'Trennen';

  @override
  String get playOnTV => 'Auf dem Fernseher abspielen';

  @override
  String get readyToCastToYourDevice => 'Bereit zum Übertragen auf Ihr Gerät';

  @override
  String get castSupportInfo =>
      'Casting wird nur für Videos vom Typ URL, HLS oder Lokal unterstützt. Andere Formate werden nicht unterstützt.';

  @override
  String doYouConfirmThisPlanWithPlanName(String planName) =>
      'Bestätigen Sie diesen Plan $planName?';

  @override
  String get pinVerifiedSuccessfully => 'PIN erfolgreich verifiziert';

  @override
  String get female => 'Weiblich';

  @override
  String get male => 'Männlich';

  @override
  String get other => 'Andere';

  @override
  String get gender => 'Geschlecht';

  @override
  String get rentalHistory => 'Mietverlauf';

  @override
  String get noRentalHistoryFound => 'Keine Miethistorie gefunden';

  @override
  String get scanTvQrCode => 'TV & Web QR Code scannen';

  @override
  String get successfullyRented => 'Erfolgreich vermietet';

  @override
  String get currentPlan => 'Aktuelles Mietplan';

  @override
  String purchaseInfo1(int duration) =>
      'Sie haben $duration ${duration > 1 ? 'Tage' : 'Tag'} Zeit, um nach dem Kauf mit dem Anschauen zu beginnen. Unbegrenzte Gültigkeit, um das Ansehen zu beenden, sobald das Streaming begonnen wurde.';

  @override
  String get purchaseInfo2 =>
      'Sie können diesen Inhalt mehrfach ansehen, bis die Ablaufzeit erreicht ist.';

  @override
  String get address => 'Adresse';

  @override
  String get subscriptionSuccessful => 'Abonnement aktiviert';

  @override
  String get subscriptionSuccessfulSubtitle => 'Ihr Abonnement ist jetzt aktiv';

  @override
  String get startEnjoyingContent =>
      'Sie können jetzt unbegrenztes Streaming und alle Premium-Funktionen genießen';

  @override
  String get noGenresFound => 'Keine Genres gefunden';

  @override
  String get noGenresAvailableSubtitle =>
      'Im Moment sind keine Genres verfügbar';

  @override
  String get noSubscriptionPlans => 'Keine Abonnementpläne';

  @override
  String get noSubscriptionPlansSubtitle =>
      'Derzeit sind keine Abonnementpläne verfügbar';

  @override
  String get noContentFound => 'Kein Inhalt gefunden';

  @override
  String get noContentMatchesFilter =>
      'Kein Inhalt stimmt mit Ihren Filterkriterien überein';

  @override
  String get movie => 'Film';

  @override
  String get tvShow => 'TV-Sendung';

  @override
  String get video => 'Video';

  @override
  String get episodes => 'Episoden';

  @override
  String get cancelSubscription =>
      'Sind Sie sicher, dass Sie Ihr Abonnement kündigen möchten?';

  @override
  String get coupanApplied => 'Gutschein erfolgreich angewendet';

  @override
  String get coupanRemoved => 'Gutschein erfolgreich entfernt';

  @override
  String get controlYourDevices => "Steuern Sie Ihre Geräte";

  @override
  String resendOtpCountText(int count) =>
      'Sie können den OTP-Code in $count Sekunden erneut senden.';

  @override
  String get comingSoonOn => 'Kommt bald am';

  @override
  String get noComingSoonContentAvailable =>
      'Kein demnächst verfügbares Inhalt.';

  @override
  String get noComingSoonMovieAvailable => 'Kein demnächst verfügbarer Film.';

  @override
  String get noComingSoonTvShowAvailable =>
      'Keine demnächst verfügbare TV-Sendung.';

  @override
  String get noComingSoonVideoAvailable => 'Kein demnächst verfügbares Video.';

  @override
  String get clips => 'Clips';

  @override
  String get checkBackAgainShortly => 'Überprüfen Sie erneut in Kürze';

  @override
  String get contentInformationIsNotAvailable =>
      'Inhaltsinformationen sind nicht verfügbar';

  @override
  String get episodesAreNotAvailableYet => 'Episoden sind noch nicht verfügbar';

  @override
  String get noContentDetails => 'Keine Inhaltsdetails';

  @override
  String get stayTuned => 'Bleib auf dem Laufenden';

  @override
  String get weArePreparingExcitingEpisodesForThisSeason =>
      'Wir bereiten spannende Episoden für dieses Jahr vor';

  @override
  String get ad => 'Werbung';

  @override
  String get adsLoadingIn => 'Werbung wird geladen';

  @override
  String get browseAndRentContentToWatchInstantly =>
      'Erkunden und leihen Sie Inhalte, um sofort anzusehen';

  @override
  String get byCreatingAnAccountYouAgreeTo =>
      'Durch die Erstellung eines Kontos stimmen Sie unseren';

  @override
  String get categories => 'Kategorien';

  @override
  String get channelInformationIsNotAvailable =>
      'Kanalinformationen sind nicht verfügbar';

  @override
  String get chooseTheQualityForDownloadingThisContent =>
      'Wählen Sie die Qualität für das Herunterladen dieses Inhalts';

  @override
  String get deviceLogins => 'Geräteanmeldungen';

  @override
  String get downloadContentToWatchOffline =>
      'Inhalte herunterladen, um offline zu sehen';

  @override
  String get inAppPurchase => 'In-App-Kauf';

  @override
  String get isAvailableInThisCategory => 'Verfügbar in dieser Kategorie';

  @override
  String get noCastOrCrewMembersAvailable =>
      'Keine Schauspieler oder Regisseure verfügbar';

  @override
  String get noChannelDetails => 'Keine Kanaldetails';

  @override
  String get noChannelsAreAvailableInThisCategory =>
      'Keine Kanäle verfügbar in dieser Kategorie';

  @override
  String get noChannelsFound => 'Keine Kanäle gefunden';

  @override
  String get noContentAvailableInThisGenre =>
      'Kein Inhalt verfügbar in diesem Genre';

  @override
  String get noContentInGenre => 'Kein Inhalt in diesem Genre';

  @override
  String get noDownloadsFound => 'Keine Downloads gefunden';

  @override
  String get noLiveTvChannels => 'Keine Live-TV-Kanäle gefunden';

  @override
  String get noLiveTvChannelsAreCurrentlyAvailable =>
      'Keine Live-TV-Kanäle verfügbar in derzeit';

  @override
  String noMoviesOrTvShowsFeaturing(String name) =>
      'Keine Filme oder TV-Sendungen mit $name';

  @override
  String get noPayPerViewContent => 'Kein Pay-Per-View-Inhalt verfügbar';

  @override
  String get noPeopleFound => 'Keine Personen gefunden';

  @override
  String get noWatchlistFound => 'Keine Beobachtungsliste gefunden';

  @override
  String get ofAllServicesAnd => 'für alle Dienste und';

  @override
  String get oneTimePurchase => 'Einmalig kaufen';

  @override
  String get openSettings => 'Einstellungen öffnen';

  @override
  String get paymentSuccessful => 'Zahlung erfolgreich';

  @override
  String get permissionNotGranted => 'Berechtigung nicht erteilt';

  @override
  String get popularSearches => 'Beliebte Suchen';

  @override
  String get resetPasswordLinkSentToYourEmail =>
      'Wir senden Ihnen die Anweisungen zum Zurücksetzen des Passworts zu Ihrer E-Mail. Öffnen Sie die E-Mail und klicken Sie auf den Link, um das Passwort sofort zurückzusetzen.';

  @override
  String get searchAgain => 'Erneut suchen';

  @override
  String get sendResetLink => 'Passwort-Reset-Link senden';

  @override
  String get skipAd => 'Werbung überspringen';

  @override
  String get suggestedChannels => 'Vorgeschlagene Kanäle';

  @override
  String get topGenre => 'Beliebteste Genre';

  @override
  String get unableToLoadDownload => 'Downloads nicht laden';

  @override
  String get uploadCustomProfileImage =>
      'Benutzerdefinierte Profilbild hochladen';

  @override
  String get visitAdvertiser => 'Werbender besuchen';

  @override
  String get youCanNotRevertThisActionLater =>
      'Sie können diese Aktion später nicht rückgängig machen';

  @override
  String get youDoNotHaveAccessToWatch =>
      'Sie haben keinen Zugriff auf diesen Inhalt';

  @override
  String get yourCurrentPlanSupports => 'Ihr aktueller Plan unterstützt';

  @override
  String get yourPaymentWasCompleted =>
      'Ihre Zahlung wurde erfolgreich abgeschlossen';

  @override
  String get otherSections => 'Andere Abschnitte';

  @override
  String get newPasswordRequired => 'Neues Passwort ist erforderlich';

  @override
  String get noMoviesAvailable => 'Keine Filme verfügbar';

  @override
  String get noTvShowsAvailable => 'Keine TV-Sendungen verfügbar';

  @override
  String get noVideosAvailable => 'Keine Videos verfügbar';

  @override
  String noContentAvailableInContentType(String content, String contentType) =>
      'Kein $contentType verfügbar in $content';

  @override
  String get unableToDownloadFilePleaseTryAgainLater =>
      'Datei konnte nicht heruntergeladen werden. Bitte versuchen Sie es später erneut.';

  @override
  String sorryCouldntShareThis(String type) =>
      'Entschuldigung, dieses $type konnte nicht geteilt werden';

  @override
  String errorWhileMonitoringDownloadUpdates(String error) =>
      'Fehler beim Überwachen der Download-Aktualisierungen: $error';

  @override
  String get pleaseSelectACastingDeviceFirst =>
      'Bitte wählen Sie zuerst ein Casting-Gerät aus';

  @override
  String get noVideoUrlAvailableForCasting =>
      'Keine Video-URL für das Casting verfügbar';

  @override
  String get contentTypeNotAvailableForCasting =>
      'Inhaltstyp für das Casting nicht verfügbar';

  @override
  String get invalidVideoUrlFormat => 'Ungültiges Video-URL-Format';

  @override
  String get failedInitiateRazorpayPayment =>
      'Start der Razorpay-Zahlung fehlgeschlagen';

  @override
  String cantFindPlanOnStore(String planName, String storeName) =>
      'Der Plan $planName konnte im Store $storeName nicht gefunden werden';

  @override
  String get paymentNotCapturedContactSupport =>
      'Zahlung nicht erfasst. Bitte wenden Sie sich an den Support.';

  @override
  String get downloadDeletedSuccessfully => 'Download erfolgreich gelöscht!';

  @override
  String get pleaseSelectRating => 'Bitte wählen Sie eine Bewertung aus';

  @override
  String get downloadsAllowedOnWifiOnly =>
      'Downloads sind nur über WLAN erlaubt. Bitte verbinden Sie sich mit WLAN oder deaktivieren Sie diese Einstellung.';

  @override
  String get thisContentIsNotDownloadable =>
      'Entschuldigung! Dieser Inhalt kann nicht heruntergeladen werden';

  @override
  String get failedToStartDownload => 'Download konnte nicht gestartet werden';

  @override
  String get failedToResumeDownload =>
      'Download konnte nicht fortgesetzt werden';

  @override
  String get downloadCancelled => 'Download abgebrochen';

  @override
  String get downloadCompleted => 'Download abgeschlossen';

  @override
  String get thePasswordDoesNotMatch => 'Das Passwort stimmt nicht überein';

  @override
  String get deleteMultipleDownload =>
      'Möchten Sie den ausgewählten Inhalt aus den Downloads löschen?';

  @override
  String profileLimitIncreaseMessage({
    required String planName,
    required int limit,
  }) {
    final profileText = limit > 1 ? "Profile" : "Profil";

    return "Der $planName Plan erlaubt nur $limit $profileText. "
        "Bitte entfernen Sie das zusätzliche $profileText, um fortzufahren.";
  }

  @override
  String get contectRestrictedForKidProfile =>
      'Dieser Inhalt ist für Kinderprofile nicht erlaubt.';

  @override
  String get recommendedForYou => 'Für dich empfohlen';

  @override
  String get shortDrama => 'Kurzdrama';

  @override
  String get yourNextObsessionStartsHere =>
      'Deine nächste Obsession beginnt hier';

  @override
  String get shortDramasIntenseStorytelling =>
      'Kurzdramen, intensive Geschichten, emotionale Romanzen und spannende Wendungen. Entdecke Unterhaltung für jede Stimmung.';

  @override
  String get exploreMore => 'Mehr erkunden';

  @override
  String get dramaForYou => 'Drama für dich';

  @override
  String get noEpisodesAvailable => 'Keine Episoden verfügbar';

  @override
  String get audioLanguage => 'Audiosprache';

  @override
  String get cantPlayThisTitleRightNow =>
      'Dieser Titel kann momentan nicht abgespielt werden';

  @override
  String get goBack => 'Zurückgehen';

  @override
  String get unableToFindThisDramaForPlayback =>
      'Dieses Drama kann nicht zur Wiedergabe gefunden werden.';

  @override
  String get pleaseCheckYourConnectionAndTryAgain =>
      'Bitte überprüfen Sie Ihre Verbindung und versuchen Sie es erneut.';

  @override
  String get seasons => 'Staffeln';

  @override
  String get mute => 'Stumm';

  @override
  String get unmute => 'Laut';

  @override
  String get noInternetConnection => 'Keine Internetverbindung';

  @override
  String get continueWatchingForYou => 'Für Sie weitersehen';

  @override
  String get playbackErrorGeneric =>
      'Wir konnten diese Episode im Moment nicht abspielen. Bitte versuchen Sie es erneut.';

  @override
  String get playbackErrorSessionExpired =>
      'Die Short-Drama-Sitzung ist abgelaufen. Bitte melden Sie sich erneut an und versuchen Sie es erneut.';
  
  @override
  String get playbackErrorTokenExpired => 'Die Wiedergabe ist abgelaufen. Bitte versuchen Sie diese Episode erneut.';
  
  @override
  String get playbackErrorVideoPluginUnavailable => 'Video-Player-Plugin ist nicht verfügbar. Bitte starten Sie die App neu und versuchen Sie es erneut.';

  @override
  String get less => 'Weniger';

  @override
  String get more => 'Weiterlesen';
}
