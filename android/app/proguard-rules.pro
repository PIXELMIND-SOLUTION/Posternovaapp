##############################################
# Flutter Core
##############################################
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

##############################################
# General Rules
##############################################
-keepattributes *Annotation*
-dontwarn kotlin.**
-dontwarn org.jetbrains.**

##############################################
# Razorpay
##############################################
-dontwarn com.razorpay.**
-keep class com.razorpay.** { *; }

-keepclasseswithmembers class * {
    public void onPayment*(...);
}

##############################################
# Firebase (Auth, Messaging, Core)
##############################################
-keep class com.google.firebase.** { *; }
-dontwarn com.google.firebase.**

##############################################
# Audioplayers (IMPORTANT)
##############################################
-keep class xyz.luan.audioplayers.** { *; }
-dontwarn xyz.luan.audioplayers.**

##############################################
# Video Player / Chewie
##############################################
-keep class io.flutter.plugins.videoplayer.** { *; }

##############################################
# Media3 (YOU ADDED MANUALLY)
##############################################
-keep class androidx.media3.** { *; }
-dontwarn androidx.media3.**

##############################################
# ExoPlayer (used internally)
##############################################
-keep class com.google.android.exoplayer2.** { *; }
-dontwarn com.google.android.exoplayer2.**

##############################################
# FFmpeg Kit
##############################################
-keep class com.arthenica.ffmpegkit.** { *; }
-dontwarn com.arthenica.ffmpegkit.**

##############################################
# Android Media
##############################################
-keep class android.media.** { *; }

##############################################
# Google ML Kit (your existing rules)
##############################################
-dontwarn com.google.mlkit.vision.text.chinese.ChineseTextRecognizerOptions$Builder
-dontwarn com.google.mlkit.vision.text.chinese.ChineseTextRecognizerOptions
-dontwarn com.google.mlkit.vision.text.devanagari.DevanagariTextRecognizerOptions$Builder
-dontwarn com.google.mlkit.vision.text.devanagari.DevanagariTextRecognizerOptions
-dontwarn com.google.mlkit.vision.text.japanese.JapaneseTextRecognizerOptions$Builder
-dontwarn com.google.mlkit.vision.text.japanese.JapaneseTextRecognizerOptions
-dontwarn com.google.mlkit.vision.text.korean.KoreanTextRecognizerOptions$Builder
-dontwarn com.google.mlkit.vision.text.korean.KoreanTextRecognizerOptions

##############################################
# Gson / JSON (VERY IMPORTANT for API parsing)
##############################################
-keep class com.google.gson.** { *; }
-keep class * {
    @com.google.gson.annotations.SerializedName <fields>;
}

##############################################
# Keep your model classes (CHANGE PACKAGE NAME)
##############################################
-keep class com.posternova.posternova.** { *; }

##############################################
# Prevent stripping exceptions (debugging)
##############################################
-keep class * extends java.lang.Exception { *; }