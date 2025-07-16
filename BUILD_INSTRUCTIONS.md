# تعليمات بناء تطبيق البحث في ملفات Excel

## متطلبات النظام

### للتطوير المحلي:
- Flutter SDK 3.24.5 أو أحدث
- Android Studio أو VS Code
- Java 17 أو أحدث
- Android SDK (API level 21-34)

### للبناء باستخدام CodeMagic:
- حساب CodeMagic
- Git repository يحتوي على المشروع

## البناء المحلي

### 1. إعداد البيئة

```bash
# تثبيت Flutter SDK
wget https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.24.5-stable.tar.xz
tar xf flutter_linux_3.24.5-stable.tar.xz
export PATH="$PATH:$PWD/flutter/bin"

# تثبيت Android SDK
wget https://dl.google.com/android/repository/commandlinetools-linux-11076708_latest.zip
unzip commandlinetools-linux-11076708_latest.zip
mkdir -p android-sdk/cmdline-tools/latest
mv cmdline-tools/* android-sdk/cmdline-tools/latest/

export ANDROID_HOME=$PWD/android-sdk
export PATH=$PATH:$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools

# قبول التراخيص وتثبيت المكونات
yes | sdkmanager --licenses
sdkmanager "platform-tools" "platforms;android-34" "build-tools;34.0.0"

# تكوين Flutter
flutter config --android-sdk $ANDROID_HOME
```

### 2. إعداد المشروع

```bash
# استنساخ المشروع
git clone <repository-url>
cd excel_search_app

# تثبيت التبعيات
flutter pub get

# التحقق من الإعداد
flutter doctor
```

### 3. البناء

```bash
# بناء APK للتطوير
flutter build apk --debug

# بناء APK للإنتاج
flutter build apk --release

# بناء App Bundle للنشر على Google Play
flutter build appbundle --release
```

## البناء باستخدام CodeMagic

### 1. إعداد المشروع في CodeMagic

1. قم بتسجيل الدخول إلى [CodeMagic](https://codemagic.io)
2. اربط حساب Git الخاص بك
3. أضف المشروع من repository

### 2. تكوين البناء

المشروع يحتوي على ملف `codemagic.yaml` مُعد مسبقاً مع:

- **android-workflow**: للبناء الإنتاجي مع التوقيع
- **android-debug-workflow**: للبناء التطويري

### 3. متغيرات البيئة المطلوبة

في إعدادات CodeMagic، أضف:

```yaml
environment:
  vars:
    PACKAGE_NAME: "com.wissam.excel_search_app"
    GOOGLE_PLAY_TRACK: internal # أو alpha, beta, production
```

### 4. التوقيع (للإنتاج)

لبناء APK موقع للنشر:

1. أنشئ keystore:
```bash
keytool -genkey -v -keystore upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

2. أضف معلومات التوقيع في CodeMagic:
   - Upload keystore file
   - أضف keystore password
   - أضف key alias
   - أضف key password

### 5. تشغيل البناء

1. اذهب إلى CodeMagic dashboard
2. اختر المشروع
3. اختر workflow (android-workflow أو android-debug-workflow)
4. اضغط "Start new build"

## ملفات الإخراج

بعد البناء الناجح، ستجد:

### البناء المحلي:
- `build/app/outputs/flutter-apk/app-debug.apk` (للتطوير)
- `build/app/outputs/flutter-apk/app-release.apk` (للإنتاج)
- `build/app/outputs/bundle/release/app-release.aab` (App Bundle)

### CodeMagic:
- APK files في artifacts
- Build logs
- Test results (إن وجدت)

## استكشاف الأخطاء

### مشاكل شائعة:

1. **Gradle build failed**:
   ```bash
   flutter clean
   flutter pub get
   flutter build apk --debug
   ```

2. **Android SDK not found**:
   ```bash
   flutter config --android-sdk /path/to/android-sdk
   ```

3. **Java version mismatch**:
   - تأكد من استخدام Java 17
   - تحديث `android/app/build.gradle` إذا لزم الأمر

4. **Permission issues**:
   - تأكد من إضافة الصلاحيات في `AndroidManifest.xml`
   - اختبر على جهاز حقيقي أو محاكي

### فحص الأخطاء:

```bash
# فحص إعداد Flutter
flutter doctor -v

# فحص التبعيات
flutter pub deps

# تشغيل التطبيق للاختبار
flutter run
```

## ملاحظات مهمة

1. **الصلاحيات**: التطبيق يحتاج صلاحيات الوصول للملفات
2. **الحد الأدنى للإصدار**: Android 5.0 (API 21)
3. **الحد الأقصى للإصدار**: Android 14 (API 34)
4. **الذاكرة**: يُنصح بـ 4GB RAM أو أكثر للملفات الكبيرة

## الدعم

للمساعدة أو الاستفسارات:
- راجع ملف README.md
- تحقق من logs البناء
- تواصل مع المطور

---

**تم إنشاؤه بواسطة**: العقيد وسام خيرالدين هادي  
**التاريخ**: يوليو 2025

