import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:premier/src/models/wrappers/response_wrapper.dart';

const _defaultConnectTimeout = Duration.millisecondsPerMinute;
const _defaultReceiveTimeout = Duration.millisecondsPerMinute;

class ApiClient {
  Dio? _dio;

  final List<Interceptor>? interceptors;

  ApiClient(Dio dio, {required String baseUrl, this.interceptors}) {
    _dio = dio;
    final customHeaders = Map<String, dynamic>();
    customHeaders['Content-Type'] = 'application/json';
    customHeaders['Accept'] = 'application/json';
    _dio!
      ..options.baseUrl = baseUrl
      ..options.connectTimeout = _defaultConnectTimeout
      ..options.receiveTimeout = _defaultReceiveTimeout
      ..httpClientAdapter
      ..options.headers = customHeaders;
    if (interceptors?.isNotEmpty ?? false) {
      _dio?.interceptors.addAll(interceptors!);
    }
  }

  ResponseWrapper _jsonResponse(dynamic response) {
    var data = jsonDecode(response?.data);
    return ResponseWrapper(
      data: data['response'] ?? data,
      message: data['status_message'] ?? "Ok",
      statusCode: int.parse(data['status'] ?? "200"),
    );
  }

  ResponseWrapper _response(Response? response) {
    return ResponseWrapper(
      data: response?.data?['response'] ?? response?.data,
      message: response?.data?['status_message'] ?? response?.statusMessage,
      statusCode: int.parse(
          response?.data?['status'] ?? response?.statusCode.toString()),
    );
  }

  Future<ResponseWrapper<dynamic>> getReq(
    String uri, {
    bool wantJsonParse = false,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      var response = await _dio?.get(
        uri,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
      return wantJsonParse ? _jsonResponse(response) : _response(response);
    } on SocketException catch (e) {
      throw SocketException(e.toString());
    } on FormatException catch (_) {
      throw FormatException("Unable to process the data");
    } catch (e) {
      throw e;
    }
  }

  Future<ResponseWrapper<dynamic>> postReq(
    String uri, {
    data,
    bool wantJsonParse = false,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      var response = await _dio?.post(
        uri,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return wantJsonParse ? _jsonResponse(response) : _response(response);
    } on SocketException catch (e) {
      throw SocketException(e.toString());
    } on FormatException catch (_) {
      throw FormatException("Unable to process the data");
    } catch (e) {
      throw e;
    }
  }

  Future<ResponseWrapper<dynamic>> patchReq(
    String uri, {
    data,
    bool wantJsonParse = false,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      var response = await _dio?.patch(
        uri,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return wantJsonParse ? _jsonResponse(response) : _response(response);
    } on SocketException catch (e) {
      throw SocketException(e.toString());
    } on FormatException catch (_) {
      throw FormatException("Unable to process the data");
    } catch (e) {
      throw e;
    }
  }

  Future<ResponseWrapper<dynamic>> putReq(
    String uri, {
    data,
    bool wantJsonParse = false,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      var response = await _dio?.put(
        uri,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return wantJsonParse ? _jsonResponse(response) : _response(response);
    } on SocketException catch (e) {
      throw SocketException(e.toString());
    } on FormatException catch (_) {
      throw FormatException("Unable to process the data");
    } catch (e) {
      throw e;
    }
  }

  Future<ResponseWrapper<dynamic>> deleteReq(
    String uri, {
    data,
    bool wantJsonParse = false,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      var response = await _dio?.delete(
        uri,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return wantJsonParse ? _jsonResponse(response) : _response(response);
    } on SocketException catch (e) {
      throw SocketException(e.toString());
    } on FormatException catch (_) {
      throw FormatException("Unable to process the data");
    } catch (e) {
      throw e;
    }
  }
}
