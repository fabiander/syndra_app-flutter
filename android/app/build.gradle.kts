// ESTE ES EL ARCHIVO: C:\Users\AdminSena\Documents\Proyectos_flutter\syndra_app\android\app\build.gradle.kts

plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.syndra_app"
    compileSdk = flutter.compileSdkVersion
    // ndkVersion = flutter.ndkVersion // <--- COMENTA O ELIMINA ESTA LÍNEA ORIGINAL si quieres

    // AÑADE O ASEGÚRATE DE QUE ESTA LÍNEA ESTÉ AQUÍ, DESPUÉS DE compileSdk
    ndkVersion = "27.0.12077973" // <--- ¡Esta es la línea que necesitamos!

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.example.syndra_app"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
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