# NOTE: -repackageclasses is not declared here on purpose. AGP 9.1+ repackages
# renamed classes into the root package by default; declaring it explicitly is
# redundant. Add -keeppackagenames only if repackaging ever needs disabling.

# Room / WorkManager
-keep class * extends androidx.room.RoomDatabase { <init>(); }
-dontwarn androidx.room.paging.**

# Stripe related rules
-keep class com.stripe.android.payments.PaymentFlowResult** { *; }
-keepclassmembers class com.stripe.android.** { public static ** Companion; }
-keepclassmembers class * implements android.os.Parcelable { public static final ** CREATOR; }
# Wildcarded on purpose. These previously named obfuscated inner classes
# (PushProvisioningActivity$g), which R8 re-letters on every Stripe bump --
# flutter_stripe 14 renamed it to $f and broke the release build. Push
# provisioning is unused (the root build.gradle.kts also excludes
# play-services-tapandpay), so suppress the whole package.
-dontwarn com.stripe.android.pushProvisioning.**

# General rules for Flutter and Kotlin
# (Flutter libraries ship their own consumer proguard rules; keeping them here is redundant)

# Razorpay
-keep class proguard.annotation.Keep { *; }
-keep class proguard.annotation.KeepClassMembers { *; }
-keep class com.razorpay.** { *; }
-keepattributes RuntimeVisibleAnnotations,AnnotationDefault

# GPay client classes used by Razorpay (fixes missing PaymentsClient, Wallet, WalletUtils)
-keep class com.google.android.apps.nbu.paisa.inapp.client.api.** { *; }
-dontwarn com.google.android.apps.nbu.paisa.inapp.client.api.**

# ProGuard annotations
-keep @interface proguard.annotation.Keep
-keep @interface proguard.annotation.KeepClassMembers

# Keep Google Play Services Identity API (fixes GetSignInIntentRequest ClassNotFoundException)
-keep class com.google.android.gms.auth.api.identity.** { *; }
