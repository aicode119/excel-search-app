# Add project specific ProGuard rules here.
# You can control the set of applied configuration files using the
# proguardFiles setting in build.gradle.
#
# For more details, see
#   http://developer.android.com/guide/developing/tools/proguard.html

# If your project uses WebView with JS, uncomment the following
# and specify the fully qualified class name to the JavaScript interface
# class:
#-keepclassmembers class fqcn.of.javascript.interface.for.webview {
#   public *;
#}

# Uncomment this to preserve the line number information for
# debugging stack traces.
#-keepattributes SourceFile,LineNumberTable

# If you keep the line number information, uncomment this to
# hide the original source file name.
#-renamesourcefileattribute SourceFile

# Keep Flutter classes
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# Keep Excel library classes
-keep class com.github.codechimp.** { *; }

# Keep file picker classes
-keep class com.mr.flutter.plugin.filepicker.** { *; }

# Keep permission handler classes
-keep class com.baseflow.permissionhandler.** { *; }

# Keep shared preferences classes
-keep class io.flutter.plugins.sharedpreferences.** { *; }

# Keep path provider classes
-keep class io.flutter.plugins.pathprovider.** { *; }

# Keep data table classes
-keep class com.maxim.datatable.** { *; }

# Keep provider classes
-keep class com.flutter.provider.** { *; }

# Keep CSV classes
-keep class com.opencsv.** { *; }

# Prevent obfuscation of model classes
-keep class com.wissam.excel_search_app.models.** { *; }
-keep class com.wissam.excel_search_app.services.** { *; }

