import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class API {
  final options = CacheOptions(
    store: MemCacheStore(),
    policy: CachePolicy.request,
    // hitCacheOnErrorExcept: const [401, 403],
    maxStale: const Duration(days: 7),
    priority: CachePriority.normal,
    cipher: null,
    keyBuilder: CacheOptions.defaultCacheKeyBuilder,
    allowPostMethod: false,
  );
  final Dio _dio = Dio();
  API() {
    _dio.options.baseUrl = "https://kgamify.in/championshipmaker/apis";
    _dio.interceptors.add(PrettyDioLogger());
    _dio.interceptors.add(DioCacheInterceptor(options: options));
  }

  Dio get sendRequests => _dio;
}
