plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

// Firebase config is git-ignored. Without it the app builds and push stays off.
if (file("google-services.json").exists()) {
    apply(plugin = "com.google.gms.google-services")
}

// Maps key comes from the git-ignored env file: prod when present, else dev.
val envFile = listOf("env/prod.json", "env/dev.json")
    .map { rootProject.file("../$it") }
    .firstOrNull { it.exists() }
val amarMapsKey = envFile
    ?.let { (groovy.json.JsonSlurper().parse(it) as Map<*, *>)["AMAR_MAPS_KEY"] as? String }
    .orEmpty()

android {
    namespace = "com.example.amar_app"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.ajyal.amar"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        manifestPlaceholders["amarMapsKey"] = amarMapsKey
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}
