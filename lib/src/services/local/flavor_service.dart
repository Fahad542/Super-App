import 'package:package_info/package_info.dart';

enum Env {
  prod,
  dev,
}

class FlavorService {
  FlavorService._();

  static Env? env;

  static init(PackageInfo info) {
    final flavor = info.packageName.split(".").last;
    if (flavor == 'dev') {
      env = Env.dev;
    } else {
      env = Env.prod;
    }
  }

  static String get getSuperAppBaseApi {
    return "https://b2bpremier.com/premiersuperapp/";
  }
  static String get getSuperAppB2BBaseApi {
    return "https://b2bpremier.com/b2bAppAdmin/";
  }
  static String get getSuperAppB2BNewBaseApi {
    return "https://b2bpremier.com/b2bAppScripts/";
  }
}
