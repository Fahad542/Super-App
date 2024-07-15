import 'package:dio/dio.dart';

class SuperAppApiInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers = {
      ...options.headers,
      "Authorization": "Basic VXJhYW5BcGk6eDJGc3RWc3o="
    };
    super.onRequest(options, handler);
  }
}

class SuperAppB2BApiInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers = {
      ...options.headers,
      "Authorization": "Basic UU5FOngyRnN0VnN6"
    };
    super.onRequest(options, handler);
  }
}
