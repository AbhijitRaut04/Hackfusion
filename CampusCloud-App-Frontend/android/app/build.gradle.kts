plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

val backgroundGeolocation = project(":flutter_background_geolocation")
apply { from("${backgroundGeolocation.projectDir}/background_geolocation.gradle") }

android {
    namespace = "com.frontman_404.campus_cloud"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
        isCoreLibraryDesugaringEnabled = true // ✅ Enable core library desugaring
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.frontman_404.campus_cloud"
        minSdk = 21
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        manifestPlaceholders["MAPS_API_KEY"] = project.property("MAPS_API_KEY") as String
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
            isShrinkResources = false
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    implementation("androidx.core:core-ktx:1.12.0") // Ensure latest version
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.0.3") // ✅ Java 8+ desugaring
}
