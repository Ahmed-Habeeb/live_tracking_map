/// A generic response model class for API responses
///
/// \[T\] - The type of the data contained in the response
class ResponseModel<T> {
  /// Constructor for [ResponseModel]
  ///
  /// \[data\] - The data returned from the API request
  /// \[error\] - The error message, if any, returned from the API request
  /// \[success\] - Indicates whether the API request was successful
  ResponseModel({required this.success, this.data, this.error});

  /// Indicates whether the API request was successful
  bool success;

  /// The data returned from the API request
  T? data;

  /// The error message, if any, returned from the API request
  String? error;
}
