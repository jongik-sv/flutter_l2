import 'package:acutal/common/const/data.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../secure_storage.dart';

final dioProvider = Provider<Dio>(
  (ref) {
    final dio = Dio();
    final storage = ref.watch(secureStorageProvider);
    dio.interceptors.add(CustomInterceptor(storage: storage));
    return dio;
  },
);

class CustomInterceptor extends Interceptor {
  final FlutterSecureStorage storage;

  CustomInterceptor({required this.storage});

  /// 1) 요청 보낼 때 보내기 전 호출
  /// 요청이 보내질 때 마다
  /// 만약 요청의 Header에 accessToken : true 라는 값이 있다면
  /// 실제 토큰을 storage에서 가져와서  'authorization':'Bearer $token'
  /// 로 헤더를 변경
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    print('[REQ] [${options.method}] ${options.uri}');
    // print('============1 : ${options.headers}');
    /// 요청 시 acccessToken을 붙여서 보내라~
    if (options.headers['accessToken'] == 'true') {
      options.headers.remove('accessToken');

      final token = await storage.read(key: ACCESS_TOKEN_KEY);
      options.headers.addAll({
        'authorization': 'Bearer $token',
      });
      // print('============2 : ${options.headers}');
    }

    if (options.headers['refreshToken'] == 'true') {
      options.headers.remove('refreshToken');

      final token = await storage.read(key: REFRESH_TOKEN_KEY);
      options.headers.addAll({
        'authorization': 'Bearer $token',
      });
      // print('============2 : ${options.headers}');
    }

    // print('============options.headers : ${options.headers}');
    super.onRequest(options, handler);
  }

// 2) 응답을 받을 때
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    print('[RES] [${response.requestOptions.method}] ${response.requestOptions.uri.toString()}');

    super.onResponse(response, handler);
  }

// 3) 에러가 났을 때
  @override
  void onError(DioError err, ErrorInterceptorHandler handler) async {
    /// 401에러가 났을때 (status codE) ; 토큰에 문제가 있을 때
    /// 토큰 재발급 시도, 재발급 되면
    /// 새로운 토큰으로 요청

    print('[ERR] [${err.requestOptions.method}] ${err.requestOptions.uri.toString()}');
    final refreshToken = await storage.read(key: REFRESH_TOKEN_KEY);

    if (refreshToken == null) {
      return handler.reject(err); // 에러 발생시키고 에러를 던진다.
    }

    final isStatus401 = err.response?.statusCode == 401; // 에러코드가 401이면 true 저장
    final isPathRefresh = err.requestOptions.path == '/auth/token'; // 토큰을 새로 발급 받다가 오류가 발생하면

    if (isStatus401 && !isPathRefresh) {
      // access 토큰을 새로 발급 받는다.
      final dio = Dio();
      try {
        final resp = await dio.post('http://$ip/auth/token',
            options: Options(headers: {'authorization': 'Bearer $refreshToken'}));

        final accessToken = resp.data['accessToken'];

        final options = err.requestOptions;

        // 토큰 변경하기
        options.headers.addAll({
          'authorization': 'Bearer $accessToken',
        });

        await storage.write(key: ACCESS_TOKEN_KEY, value: accessToken);

        //요청 재전송; 에러난 request 의 옵션을 바꿔서 다시 전송
        final response = await dio.fetch(options);
        return handler.resolve(response); // 에러에 대한 해결결, 에러가 없어짐
      } on DioError catch (e) {
        // on DioError 일때만 ; 없어도 전체 잡으면 되어서 상관없음
        return handler.reject(err);
      }
    }

    // return super.onError(err, handler);
  }
}
