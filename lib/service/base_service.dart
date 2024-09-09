import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get_connect/connect.dart';
import 'package:get/get_connect/http/src/request/request.dart';
import 'package:get/route_manager.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mobile/constants/app_constants.dart';
import 'package:mobile/view/pages/login/welcome_screen.dart';

class BaseService extends GetConnect {
  final box = GetStorage();
  final String apiKey = '05ee0af0-d3d9-4197-ae7e-97b88dbac34b';
  @override
  void onInit() {
    httpClient.baseUrl = AppConstants.getWebserviceUrl();
    httpClient.defaultContentType = "application/json; charset=UTF-8";
    httpClient.timeout = const Duration(seconds: 60);

    httpClient.addRequestModifier((Request request) {
      final token = box.read("accessToken");
      final publicToken = box.read("publicToken");
      if (token != null && token.toString().isNotEmpty) {
        request.headers['Authorization'] = "Bearer $token";
      }
      if (publicToken != null && publicToken.toString().isNotEmpty) {
        request.headers['C-Authorization'] = "Bearer $publicToken";
      }
      request.headers['ApiKey'] = apiKey;
      request.headers['X-Source'] = "Mobile App";
      return request;
    });
    super.onInit();
  }

  Future<bool> isOnline() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    return connectivityResult != ConnectivityResult.none;
  }

  @override
  Future<Response<T>> get<T>(
      String url, {
        Map<String, String>? headers,
        String? contentType,
        Map<String, dynamic>? query,
        Decoder<T>? decoder,
      }) {
    return request<T>(
      url, 'get',
      headers: headers,
      contentType: contentType,
      query: query,
      decoder: decoder,
    );
  }

  @override
  Future<Response<T>> post<T>(
      String? url,
      dynamic body, {
        String? contentType,
        Map<String, String>? headers,
        Map<String, dynamic>? query,
        Decoder<T>? decoder,
        Progress? uploadProgress,
      }) {
    return request<T>(
      url!, 'post',
      body: body,
      headers: headers,
      contentType: contentType,
      query: query,
      decoder: decoder,
      uploadProgress: uploadProgress,
    );
  }

  @override
  Future<Response<T>> put<T>(
      String url,
      dynamic body, {
        String? contentType,
        Map<String, String>? headers,
        Map<String, dynamic>? query,
        Decoder<T>? decoder,
        Progress? uploadProgress,
      }) {
    return request<T>(
      url, 'put',
      body: body,
      headers: headers,
      contentType: contentType,
      query: query,
      decoder: decoder,
      uploadProgress: uploadProgress,
    );
  }

  @override
  Future<Response<T>> patch<T>(
      String url,
      dynamic body, {
        String? contentType,
        Map<String, String>? headers,
        Map<String, dynamic>? query,
        Decoder<T>? decoder,
        Progress? uploadProgress,
      }) {
    return request<T>(
      url, 'patch',
      body: body,
      headers: headers,
      contentType: contentType,
      query: query,
      decoder: decoder,
      uploadProgress: uploadProgress,
    );
  }

  @override
  Future<Response<T>> delete<T>(
      String url, {
        Map<String, String>? headers,
        String? contentType,
        Map<String, dynamic>? query,
        Decoder<T>? decoder,
      }) {return request(
    url, 'delete',
    headers: headers,
    contentType: contentType,
    query: query,
    decoder: decoder,
  );
  }

  @override
  Future<Response<T>> request<T>(
      String url,
      String method, {
        dynamic body,
        String? contentType,
        Map<String, String>? headers,
        Map<String, dynamic>? query,
        Decoder<T>? decoder,
        Progress? uploadProgress,
      }) async {
    _checkIfDisposed();
    debugPrint('Request: $url');
    var response = await httpClient.request<T>(
      url,
      method,
      body: body,
      headers: headers,
      contentType: contentType,
      query: query,
      decoder: decoder,
      uploadProgress: uploadProgress,
    );
    if(!response.isOk){
      handleError(response);
    }

    return response;
  }

  Future<dynamic> handleError(e, {StackTrace? stackTrace}) {
    if (e is String) {
      if(kDebugMode){
        print(e);
      }
      throw e;
    }
    if (e is Response) {
      if(kDebugMode){
        print('Request: ${e.request?.url}');
        print('Status text: ${e.statusText}');
        print('Response Body: ${e.body}');
      }
      switch (e.statusCode) {
        case 400:
          throw "Geçersiz istek";
        case 404:
          throw "Bulunamadı";
        case 500:
          throw "Sunucu hatası";
        case 403:
          throw 'Bu işlemi yapmak için yetkiniz bulunmamaktadır';
        case 401:
          Get.offAll(() => const WelcomeScreen());
          break;
        default:
          throw 'Bir hata oluştu';
      }
    }
    throw e;
  }

  void _checkIfDisposed({bool isHttp = true}) {
    if (isDisposed) {
      throw 'Can not emit events to disposed clients';
    }
  }
}
