import 'package:dio/dio.dart';

/// Factory class for creating and configuring a Dio instance
class DioFactory {
  /// Private constructor to prevent instantiation
  DioFactory._();

  /// Static instance of Dio
  static Dio? dio;

  /// Returns a configured Dio instance
  ///
  /// If the Dio instance is null, it creates and configures a new instance.
  /// Otherwise, it returns the existing instance.
  ///
  /// Returns a [Dio] instance
  static Dio getDio() {
    final Duration timeOut = const Duration(seconds: 10);

    if (dio == null) {
      dio = Dio();
      dio!
        // ..options.baseUrl = EndPoints.api
        ..options.connectTimeout = timeOut
        ..options.receiveTimeout = timeOut;

      addDioInterceptor();
      return dio!;
    } else {
      return dio!;
    }
  }

  /// Adds interceptors to the Dio instance
  ///
  /// Interceptors are used for adding headers, tokens, logging, etc.
  static void addDioInterceptor() {
    dio?.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          // Do something before request is sent
          // if (CacheHelper.containsKey(key: 'token')) {
          //   options.headers['Authorization'] =
          //       "Bearer ${CacheHelper.getData(key: "token")}";
          // }
          return handler.next(options); // continue
        },
        onResponse: (response, handler) {
          // Do something with response data
          return handler.next(response); // continue
        },
        onError: (e, handler) {
          // Do something with response error
          return handler.next(e); // continue
        },
      ),
    );
    // dio?.interceptors.add(
    //   PrettyDioLogger(
    //     requestBody: true,
    //     requestHeader: true,
    //     responseHeader: true,
    //   ),
    // );
  }
}
