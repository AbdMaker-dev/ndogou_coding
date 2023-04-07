import 'dart:async';
import 'package:dio/dio.dart';

class HttpHelper extends Interceptor {
  final String BASE_URL ="https://newsapi.org/v2/top-headlines?country=fr&apiKey=821440346a494e7dab7afed916f44fac";
  Dio _dio = Dio();
  RequestOptions? rOptions;

  bool isContainsPath(String path) {
    return path.contains('/auth/login') || path.contains('/auth/check-otp');
  }

  Future<Response<dynamic>> retry(RequestOptions requestOptions) async {
    final options = Options(
      method: requestOptions.method,
      headers: requestOptions.headers,
    );
    return _dio.request<dynamic>(requestOptions.path,
        data: requestOptions.data,
        queryParameters: requestOptions.queryParameters,
        options: options);
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    if (!isContainsPath(options.path)) {
      // String accessToken = await getAccessToken();
      // options.headers['Authorization'] = 'Bearer $accessToken';
      // rOptions = options;
    }
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) async {
    // if (response.statusCode == 401 && !_refreshing) {
    //   String refreshToken = await refreshAccessToken();
    //   if (refreshToken != null) {
    //     Dio dio = Dio();
    //     dio.options.headers['Authorization'] = 'Bearer $refreshToken';
    //     Response refreshResponse = await dio.post('/refresh_token', data: {
    //       'refresh_token': refreshToken,
    //     });
    //     if (refreshResponse.statusCode == 200 && rOptions != null) {
    //       NB: SAVE NEW TOKEN
    //       retry(rOptions!);
    //     }
    //   }
    // }
    handler.next(response);
  }


  Future<dynamic> doGetRequest(String api, {params}) async {
    try {
      print("-----------HANDLE POST REQUEST -----------");
      var res = await _dio.get('$BASE_URL', queryParameters: params);
      print(res.data);
      print(res.statusCode);
      return res.data;
    } on DioError catch (e) {
      return e.response!=null ? e.response!.data : null;
    }
  }


  Future<dynamic> doPostRequest(String api, Map<String, dynamic> data) async {
    try {
      // print("-----------HANDLE POST REQUEST -----------");
      var res = await _dio.post('$BASE_URL/$api/', data: data);
      // print(res.data);
      // print(res.statusCode);
      return res.data;
    } on DioError catch (e) {
       return e.response!=null ? e.response!.data : null;
    }
  }
  
}
