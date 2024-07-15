# Flutter starter app with MVVM stacked architecture and RxDart

## Setup

### Change AppName and Package Name in pubspec.yaml

```bash
flutter clean
flutter pub get
flutter pub run package_rename:set
dart setup/setup.dart --dartBundleName="premier"
flutter pub get
```

## build releasse

### Dev: `flutter build apk --release --flavor dev -t lib/main_dev.dart`

### Prod: `flutter build apk --release --flavor prod -t lib/main.dart`

## Run

### Dev: `flutter run --release --flavor dev -t lib/main_dev.dart`

### Prod: `flutter run --release --flavor prod -t lib/main.dart`

## Build Runner Build

`flutter packages pub run build_runner build --delete-conflicting-outputs`#   s u p e r a p p 2  
 