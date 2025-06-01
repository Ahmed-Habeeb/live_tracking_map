import 'package:dio/dio.dart';
import 'package:live_tracking_map/src/api/model/response_model.dart';

/// A class for handling API errors
class ApiErrorHandler {
  /// Handles the error and returns a [ResponseModel] with the error message
  ///
  /// \[error\] - The error object to be handled
  ///
  /// Returns a [ResponseModel] indicating the failure and containing the error message
  static ResponseModel handleError(dynamic error, int statusCode) {
    if (statusCode != 200) {
      return ResponseModel(success: false, error: 'Something went wrong');
    }
    String message = 'Something went wrong';
    if (error is DioException) {
      message = error.message ?? '';
      if (error.response != null) {
        message = error.response!.data['message']?.toString() ?? "";
      }
      return ResponseModel(success: false, error: message);
    } else if (error is String) {
      return ResponseModel(success: false, error: error);
    }
    return ResponseModel(success: false, error: 'Something went wrong');
  }
}
