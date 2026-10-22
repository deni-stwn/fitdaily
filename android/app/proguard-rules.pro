# shared_preferences_android (2.5.x) calls its Kotlin API from Dart through
# JNI (package:jni). R8 cannot see those calls: it strips/renames the plugin
# methods and the Kotlin types in their signatures (Continuation, Result…)
# → NoSuchMethodError / ClassNotFoundException on startup in release builds
# (black screen).
-keep class io.flutter.plugins.sharedpreferences.** { *; }
-keep class com.github.dart_lang.jni.** { *; }
-keep class kotlin.** { *; }
-keep class kotlinx.coroutines.** { *; }
