import 'package:dio/dio.dart';
import 'package:live_tracking_map/src/api/model/response_model.dart';


  /// Abstract class defining the base methods for making HTTP requests using Dio
  abstract class BaseDio {
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
    ///
    ///
    Future<ResponseModel> post(
      String path, {
      data,
      Map<String, dynamic>? queryParameters,
      Options? options,
      CancelToken? cancelToken,
      ProgressCallback? onSendProgress,
      ProgressCallback? onReceiveProgress,
      String? baseUrl,
    });

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
    Future<ResponseModel> delete(
      String path, {
      data,
      Map<String, dynamic>? queryParameters,
      Options? options,
      CancelToken? cancelToken,
      String? baseUrl,
    });

    /// Makes a GET request to the given path
    ///
    /// \[path\] - The endpoint path
    /// \[queryParameters\] - The query parameters to be sent with the request
    /// \[options\] - The options for the request
    /// \[cancelToken\] - The cancel token for the request
    /// \[onReceiveProgress\] - The callback for tracking the receive progress
    /// \[baseUrl\] - The base URL for the request
    ///
    /// Returns a [Future] containing a [ResponseModel] with the response data
    Future<ResponseModel> get(
      String path, {
      Map<String, dynamic>? queryParameters,
      Options? options,
      CancelToken? cancelToken,
      ProgressCallback? onReceiveProgress,
      String? baseUrl,
    });

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
    Future<ResponseModel> put(
      String path, {
      data,
      Map<String, dynamic>? queryParameters,
      Options? options,
      CancelToken? cancelToken,
      ProgressCallback? onSendProgress,
      ProgressCallback? onReceiveProgress,
      String? baseUrl,
    });
  }