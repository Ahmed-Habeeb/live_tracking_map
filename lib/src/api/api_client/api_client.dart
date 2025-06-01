import 'package:dio/dio.dart';
import 'package:live_tracking_map/src/api/api_client/base_dio.dart';
import 'package:live_tracking_map/src/api/end_points/end_points.dart';
import 'package:live_tracking_map/src/api/error_handler/api_error_handler.dart';
import 'package:live_tracking_map/src/api/model/response_model.dart';

/// API client class for making HTTP requests
///
/// Extends [BaseDio] to provide methods for making HTTP requests
class ApiClient extends BaseDio {
  /// Constructor for [ApiClient]
  ///
  /// \[options\] - The [BaseOptions] instance for configuring the [Dio] instance
  /// \[dio\] - The [Dio] instance to be used for making requests
  ApiClient({required BaseOptions options, required Dio dio})
    : _options = options,
      _dio = dio {
    _dio.options = _options;
  }

  /// Instance of [Dio] for making HTTP requests
  final Dio _dio;

  /// Options for configuring the [Dio] instance
  final BaseOptions _options;

  Dio get instance => _dio;

  /// Makes a POST request to the given path
  ///
  /// \[path\] - The endpoint path
  /// \[data\] - The data to be sent in the request body
  /// \[queryParameters\] - The query parameters to be sent with the request
  /// \[options\] - The options for the request
  /// \[cancelToken\] - The cancel token for the request
  /// \[onSendProgress\] - The callback for tracking the send progress
  /// \[onReceiveProgress\] - The callback for tracking the receive progress
  /// \[baseUrl\] - The base URL for the request
  ///
  /// Returns a [Future] containing a [ResponseModel] with the response data
  @override
  Future<ResponseModel> post(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    String? baseUrl,
  }) async {
    try {
      _dio.options.baseUrl = baseUrl ?? EndPoints.api;

      final Response<dynamic> res = await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      if (res.statusCode == 200 || res.statusCode == 201) {
        return ResponseModel(success: true, data: res.data);
      } else {
        return ApiErrorHandler.handleError(res, res.statusCode!);
      }
    } on DioException catch (e) {
      return ApiErrorHandler.handleError(e, e.response?.statusCode ?? 500);
    }
  }

  /// Makes a DELETE request to the given path
  ///
  /// \[path\] - The endpoint path
  /// \[data\] - The data to be sent in the request body
  /// \[queryParameters\] - The query parameters to be sent with the request
  /// \[options\] - The options for the request
  /// \[cancelToken\] - The cancel token for the request
  /// \[baseUrl\] - The base URL for the request
  ///
  /// Returns a [Future] containing a [ResponseModel] with the response data
  @override
  Future<ResponseModel> delete(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    String? baseUrl,
  }) async {
    try {
      _dio.options.baseUrl = baseUrl ?? EndPoints.api;

      final Response<dynamic> response = await _dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return ResponseModel(success: true, data: response.data);
      } else {
        return ApiErrorHandler.handleError(response, response.statusCode!);
      }
    } on DioException catch (e) {
      return ApiErrorHandler.handleError(e, e.response?.statusCode ?? 500);
    }
  }

  /// Makes a GET request to the given path
  ///
  /// \[path\] - The endpoint path
  /// \[data\] - The data to be sent in the request body
  /// \[queryParameters\] - The query parameters to be sent with the request
  /// \[options\] - The options for the request
  /// \[cancelToken\] - The cancel token for the request
  /// \[onReceiveProgress\] - The callback for tracking the receive progress
  /// \[baseUrl\] - The base URL for the request
  ///
  /// Returns a [Future] containing a [ResponseModel] with the response data
  @override
  Future<ResponseModel> get(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
    String? baseUrl,
  }) async {
    try {
      _dio.options.baseUrl = baseUrl ?? EndPoints.api;

      final Response<dynamic> response = await _dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return ResponseModel(success: true, data: response.data);
      } else {
        return ApiErrorHandler.handleError(response, response.statusCode!);
      }
    } on DioException catch (e) {
      return ApiErrorHandler.handleError(e, e.response?.statusCode ?? 500);
    }
  }

  /// Makes a PUT request to the given path
  ///
  /// \[path\] - The endpoint path
  /// \[data\] - The data to be sent in the request body
  /// \[queryParameters\] - The query parameters to be sent with the request
  /// \[options\] - The options for the request
  /// \[cancelToken\] - The cancel token for the request
  /// \[onSendProgress\] - The callback for tracking the send progress
  /// \[onReceiveProgress\] - The callback for tracking the receive progress
  /// \[baseUrl\] - The base URL for the request
  ///
  /// Returns a [Future] containing a [ResponseModel] with the response data
  @override
  Future<ResponseModel> put(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    String? baseUrl,
  }) async {
    try {
      _dio.options.baseUrl = baseUrl ?? EndPoints.api;

      final Response<dynamic> response = await _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return ResponseModel(success: true, data: response.data);
      } else {
        return ApiErrorHandler.handleError(response, response.statusCode!);
      }
    } on DioException catch (e) {
      return ApiErrorHandler.handleError(e, e.response?.statusCode ?? 500);
    }
  }
}
