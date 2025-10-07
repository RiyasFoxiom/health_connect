# health_connect

A new Flutter project.

# health_connect

A Flutter project scaffold focused on health-related features and common UI utilities.

## State Management Implementation

While the initial requirement suggested Provider/Riverpod for state management, this project implements GetX (^4.7.2) for several reasons:


### Benefits of Current Implementation
- Clean architecture separation (Controllers, Views, Models)
- Reactive state updates without setState
- Easy testing and mocking
- Simplified route management
- Efficient memory management

## Package Selection Note

Originally, this project was planned to use `flutter_health_connect`, but due to namespace issues and compatibility concerns, we switched to the `health` package (^13.2.0). Here's why:

### Why not flutter_health_connect?
- Namespace conflicts with Android Health Connect
- Limited platform support
- Some implementation challenges with recent Android versions

### Why health package?
- Broader platform support
- More stable API
- Better compatibility with both Android and iOS
- Extensive features including:
  - Step counting
  - Heart rate monitoring
  - Activity tracking
  - Proper permission handling
  - Real-time health data updates

### Migration Benefits
- More reliable health data access
- Better cross-platform consistency
- Improved permission management
- Regular package maintenance and updates

## Project Architecture with GetX

The project follows a clean architecture pattern using GetX, organized as follows:

### Controllers
- Located in `app/controller/`
- Handle business logic and state management
- Extend `GetxController`
- Use `.obs` for reactive state

### Views
- Located in `app/view/`
- Pure UI components
- Use `Obx` for reactive updates
- Minimal logic, mostly UI rendering

### Models
- Located in `app/model/`
- Data structures and business objects
- Response models for API handling
- Clean data representations

### Services
- Located in `core/service/`
- Handle external interactions
- API calls, device features
- Dependency injection via Get.put()

## Project folder structure

The `lib/` folder in this project follows this layout (folders only — files shown as example locations):

```
lib/
├── app/
│   ├── controller/
│   │   └── auth_controller.dart
│   ├── view/
│   │   ├── home/
│   │   │   └── home_view.dart
│   │   ├── cart/
│   │   │   └── cart_view.dart
│   ├── model/
│   │   ├── response/
│   │   │   └── product_response.dart
│   │   └── product.dart
│   ├── widget/
│   │   ├── app_loader.dart
│   │   └── app_chip.dart
│   └── config.dart
├── core/
│   ├── extension/
│   │   ├── margin_ext.dart
│   │   └── string.ext.dart
│   ├── service/
│   │   ├── api.dart
│   │   ├── api_response.dart
│   │   ├── multipart_api.dart
│   │   └── urls.dart
│   ├── style/
│   │   ├── colors.dart
│   │   └── string.dart
│   ├── theme.dart
│   ├── sharedpreference.dart
│   └── screen_utils.dart
├── shared/
│   ├── dialog/
│   │   ├── app_snackbar.dart
│   │   └── image_picker.dart
│   ├── pushnotification/
│   │   └── push_notification.dart
│   ├── utils/
│   │   ├── get_validators.dart
│   │   ├── hex_color_code.dart
│   │   └── date_formatted.dart
│   └── widgets/
│       ├── app_cached_image.dart
│       ├── app_date_picker.dart
│       └── app_lottie.dart
└── main.dart
```

> Note: The tree above lists example file locations. If you want me to scaffold any of the missing Dart files, say which ones and I'll add basic templates.

## Health Package Implementation

### Android Requirements

#### SDK Versions
```gradle
minSdk = 26    // Minimum SDK version required
targetSdk = 34 // Target SDK version
```

These SDK versions are required for:
- Health Connect API compatibility
- Modern Android features support
- Optimal performance and security
- Latest health data access features

### Android Setup

#### SDK Configuration
In `android/app/build.gradle.kts`:
```kotlin
android {
    defaultConfig {
        minSdk = 26
        targetSdk = 34
    }
}
```


#### Required Permissions
Add to `android/app/src/main/AndroidManifest.xml`:
```xml
<!-- Health Connect permissions -->
<uses-permission android:name="android.permission.health.READ_STEPS"/>
<uses-permission android:name="android.permission.health.READ_HEART_RATE"/>
<uses-permission android:name="android.permission.ACTIVITY_RECOGNITION"/>
```

#### iOS
Add to `ios/Runner/Info.plist`:
```xml
<key>NSHealthShareUsageDescription</key>
<string>We need access to your health data to track your fitness progress</string>
<key>NSHealthUpdateUsageDescription</key>
<string>We need permission to save your workout data</string>
```

## Dependencies (from `pubspec.yaml`)

The project currently declares these important dependencies:

- get: ^4.7.2 — state management & routing
- lottie: ^3.3.2 — Lottie animations
- flutter_svg: ^2.2.1 — SVG rendering
- health: ^13.2.0 — access health data on supported platforms

If you changed versions locally, those are reflected here.

## Assets & Fonts (from `pubspec.yaml`)

Assets included in the project:

- assets/lottie/
- assets/images/
- assets/fonts/

Fonts configured:

- Inter_SemiBold (assets/fonts/Inter_SemiBold.ttf) — weight 600
- Inter_Regular (assets/fonts/Inter_Regular.ttf) — weight 400

Add any additional assets to the `flutter:` -> `assets:` list in `pubspec.yaml`.
