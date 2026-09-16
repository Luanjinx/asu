import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/configs.dart';
import 'package:the_apple_sign_in/the_apple_sign_in.dart';

import '../../../main.dart';
import '../../../utils/constants.dart';
import '../../subscription/model/subscription_plan_model.dart';
import '../model/login_response.dart';

//region FIREBASE AUTH
final FirebaseAuth auth = FirebaseAuth.instance;
//endregion

class GoogleSignInAuthService {
  GoogleSignIn googleSignIn = GoogleSignIn.instance;

  Future<UserData?> signInWithGoogle() async {
    try {
      await googleSignIn.initialize(clientId: FIREBASE_CLIENT_ID);

      final GoogleSignInAccount googleSignInAuthentication = await googleSignIn.authenticate();

      final authentication = await googleSignInAuthentication.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: authentication.idToken,
      );

      final UserCredential authResult = await FirebaseAuth.instance.signInWithCredential(credential);
      final User user = authResult.user!;

      assert(!user.isAnonymous);

      final User currentUser = FirebaseAuth.instance.currentUser!;
      assert(user.uid == currentUser.uid);

      try {
        final AuthCredential emailAuthCredential = EmailAuthProvider.credential(email: user.email!, password: Constants.DEFAULT_PASS);
        await user.linkWithCredential(emailAuthCredential);
      } catch (e) {
        log('Error linking credential: $e');
      }
      log('CURRENTUSER: $currentUser');

      await googleSignIn.signOut();

      String firstName = '';
      String lastName = '';
      if (currentUser.displayName.validate().split(' ').isNotEmpty) firstName = currentUser.displayName.splitBefore(' ');
      if (currentUser.displayName.validate().split(' ').length >= 2) lastName = currentUser.displayName.splitAfter(' ');

      /// Create a temporary request to send
      UserData tempUserData = UserData(planDetails: SubscriptionPlanModel())
        ..mobile = currentUser.phoneNumber.validate()
        ..email = currentUser.email.validate()
        ..firstName = firstName.validate()
        ..lastName = lastName.validate()
        ..profileImage = currentUser.photoURL.validate()
        ..loginType = LoginTypeConst.loginTypeGoogle
        ..fullName = currentUser.displayName.validate();

      return tempUserData;
    } on GoogleSignInException {
      rethrow;
    } catch (e, stackTrace) {
      log('--- signInWithGoogle ERROR ---');
      log('Exception: $e');
      log('StackTrace: $stackTrace');
    }
    return null;
  }

  // region Apple Sign
  Future<UserData> signInWithApple() async {
    if (await TheAppleSignIn.isAvailable()) {
      final AuthorizationResult result = await TheAppleSignIn.performRequests([
        const AppleIdRequest(requestedScopes: [Scope.email, Scope.fullName]),
      ]);

      switch (result.status) {
        case AuthorizationStatus.authorized:
          final appleIdCredential = result.credential!;
          final oAuthProvider = OAuthProvider('apple.com');
          final credential = oAuthProvider.credential(
            idToken: String.fromCharCodes(appleIdCredential.identityToken!),
            accessToken: String.fromCharCodes(appleIdCredential.authorizationCode!),
          );

          final authResult = await auth.signInWithCredential(credential);
          final User user = authResult.user!;
          assert(!user.isAnonymous);

          final User currentUser = auth.currentUser!;
          assert(user.uid == currentUser.uid);

          log('CURRENTUSER: $currentUser');

          // await googleSignIn.signOut();

          String firstName = '';
          String lastName = '';
          log('result.credential ==> ${result.credential?.toMap()}');
          log('result.credential!.fullName ==> ${result.credential!.fullName!.toMap()}');

          if (result.credential != null && result.credential!.fullName != null) {
            firstName = result.credential!.fullName!.givenName.validate();
            lastName = result.credential!.fullName!.familyName.validate();
          }

          /// Create a temporary request to send
          UserData tempUserData = UserData(planDetails: SubscriptionPlanModel())
            ..mobile = currentUser.phoneNumber.validate()
            ..email = currentUser.email.validate()
            ..firstName = firstName.validate()
            ..lastName = lastName.validate()
            ..profileImage = currentUser.photoURL.validate()
            ..loginType = LoginTypeConst.loginTypeApple
            ..fullName = "${firstName.validate()} ${lastName.validate()}";

          return tempUserData;
        case AuthorizationStatus.error:
          throw "${locale.value.signInFailed}: ${result.error!.localizedDescription}";
        case AuthorizationStatus.cancelled:
          throw locale.value.userCancelled;
      }
    } else {
      throw locale.value.appleSigninIsNot;
    }
  }
}
