import 'dart:async';
import 'dart:convert';
import 'dart:developer' as dev;
import 'dart:io';

import 'package:dio/dio.dart' as dio_package;
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:path_provider/path_provider.dart';
import 'package:streamit_laravel/network/auth_apis.dart';
import 'package:streamit_laravel/screens/auth/model/login_response.dart';
import 'package:streamit_laravel/services/local_storage_service.dart';
import 'package:streamit_laravel/utils/common_base.dart';

import '../configs.dart';
import '../main.dart';
import '../utils/api_end_points.dart';
import '../utils/common_functions.dart';
import '../utils/constants.dart';

//region ------------------------ Common Utilities ------------------------

// Status code message mapping using localized message
// Get user-friendly error message for status code
String getErrorMessageForStatusCode(int statusCode, {String message = ''}) {
  return locale.value.somethingWentWrong;
}

Map<String, dynamic> handleError(dio_package.Response response) {
  final statusCode = response.statusCode ?? 0;
  final responseBody = response.data;
  // Handle specific error status codes with enhanced messages
  String errorMessage = '';

  if ((responseBody is Map<String, dynamic> && (responseBody.containsKey("message") && responseBody["message"] is String || responseBody.containsKey("error") && responseBody["error"] is String))) {
    errorMessage = responseBody["message"] ?? responseBody["error"] ?? '';
    if (responseBody.containsKey("message")) responseBody.remove("message");
    if (responseBody.containsKey("error")) responseBody.remove("error");
  }

  if (errorMessage.isEmpty || statusCode == 500) {
    errorMessage = getErrorMessageForStatusCode(statusCode);
  }

  // Create comprehensive error data
  final Map<String, dynamic> errorData = {
    'status_code': statusCode,
    "error_message": errorMessage,
    'response': responseBody,
  };

  throw errorData;
}

Future<Map<String, String>> buildHeaderTokens({String? endPoint}) async {
  Map<String, String> header = {
    HttpHeaders.cacheControlHeader: 'no-cache',
    'Access-Control-Allow-Headers': '*',
    'Access-Control-Allow-Origin': '*',
    'Accept': "application/json",
    'global-localization': selectedLanguageCode.value,
    'User-Agent': getUserAgent(),
  };

  if (endPoint == APIEndPoints.register) {
    header.putIfAbsent(HttpHeaders.acceptHeader, () => 'application/json');
  }

  header.putIfAbsent(HttpHeaders.contentTypeHeader, () => 'application/json; charset=utf-8');

  if ((await getBoolFromLocal(SharedPreferenceConst.IS_LOGGED_IN) || isLoggedIn.value) && loginUserData.value.apiToken.isNotEmpty) {
    header.putIfAbsent(HttpHeaders.authorizationHeader, () => 'Bearer ${loginUserData.value.apiToken}');
  }

  return header;
}

Map<String, String> buildHeaderForRazorpay(String razorPaySecretKey, String razorPayPublicKey) {
  return {
    'Authorization': 'Basic ${base64Encode(utf8.encode('$razorPayPublicKey:$razorPaySecretKey'))}',
    'content-type': 'application/json',
  };
}

Uri buildBaseUrl(String endPoint, {bool manageApiVersion = false}) {
  final String newEndPoint = manageApiVersion ? 'v$API_VERSION/$endPoint' : endPoint;
  return newEndPoint.startsWith('http') ? Uri.parse(newEndPoint) : Uri.parse('$BASE_URL$newEndPoint');
}

Map<String, String> defaultHeaders() => {
      HttpHeaders.cacheControlHeader: 'no-cache',
      'Access-Control-Allow-Headers': '*',
      'Access-Control-Allow-Origin': '*',
    };

Map<String, String> buildHeaderForFlutterWave(String flutterWaveSecretKey) {
  final header = defaultHeaders();
  header.putIfAbsent(HttpHeaders.authorizationHeader, () => "Bearer $flutterWaveSecretKey");
  return header;
}

String getUserAgent() {
  switch (Platform.operatingSystem) {
    case 'android':
      return 'FlutterAndroidApp/1.0 (Android)';
    case 'ios':
      return 'FlutteriOSApp/1.0 (iOS)';
    default:
      return 'FlutterApp/1.0 (Unknown)';
  }
}

Future<bool> reGenerateToken() async {
  bool result = false;
  Map<String, dynamic>? cachedLoginRequest = await getJsonFromLocal(SharedPreferenceConst.LOGIN_REQUEST);
  if (cachedLoginRequest != null) {
    loginUserData.value.apiToken = '';

    final String url = Uri.parse('$BASE_URL${await getBoolFromLocal(SharedPreferenceConst.IS_SOCIAL_LOGIN_IN) ? APIEndPoints.socialLogin : APIEndPoints.login}').toString();
    await dioClient.post(url, data: cachedLoginRequest).then(
      (value) {
        UserResponse userData = UserResponse.fromJson(Map<String, dynamic>.from(value.data));
        if (userData.status) {
          AuthServiceApis.storeUserData(userData);
          result = true;
        } else {
          removeValue(SharedPreferenceConst.LOGIN_REQUEST);
        }
      },
    ).catchError((e) {
      removeValue(SharedPreferenceConst.LOGIN_REQUEST);
    });
  }

  return result;
}

Future<void> apiPrint({
  String url = "",
  String headers = "",
  String request = "",
  int statusCode = 0,
  String responseBody = "",
  String methodType = "",
  bool fullLog = false,
  dio_package.FormData? multipartRequest,
}) async {
  if (kReleaseMode || kDebugMode) return;
  final logFunc = fullLog ? dev.log : log;
  logFunc("┌─────────────────────────────────────────────────────────────");
  logFunc("\u001b[93m Url: \u001B[39m $url");

  logFunc("\u001b[93m header: \u001B[39m \u001b[96m$headers\u001B[39m");
  if (request.isNotEmpty) logFunc('\u001b[93m Request: \u001B[39m \u001b[95m$request\u001B[39m');
  if (multipartRequest != null) {
    logFunc("\u001b[95m Multipart Request: \u001B[39m");

    // Print fields
    for (var entry in multipartRequest.fields) {
      logFunc("  \u001b[96m${entry.key}:\u001B[39m ${entry.value}");
    }

    // Print files
    for (var file in multipartRequest.files) {
      final fileName = file.value.filename;
      final length = file.value.length;
      logFunc("  \u001b[94m${file.key}:\u001B[39m file='$fileName' ($length bytes)");
    }
  }
  final formattedResponse = await compute(_prettyPrintJson, responseBody);
  logFunc(statusCode.isSuccessful() ? "\u001b[32m" : "\u001b[31m");
  logFunc('Response ($methodType) $statusCode: $formattedResponse');
  logFunc("\u001B[0m");
  logFunc("└─────────────────────────────────────────────────────────────");
}

//endregion

//region ------------------------ DIO Helpers ------------------------

class ApiInterceptor extends dio_package.Interceptor {
  @override
  void onRequest(dio_package.RequestOptions options, dio_package.RequestInterceptorHandler handler) async {
    options.headers['app-locale'] = selectedLanguageCode.value;
    handler.next(options);
  }

  @override
  void onResponse(dio_package.Response response, dio_package.ResponseInterceptorHandler handler) {
    apiPrint(
      url: response.requestOptions.uri.toString(),
      headers: jsonEncode(response.requestOptions.headers),
      request: response.requestOptions.data != null && response.requestOptions.data is! dio_package.FormData ? jsonEncode(response.requestOptions.data) : '',
      multipartRequest: response.requestOptions.data != null && (response.requestOptions.data is dio_package.FormData) ? response.requestOptions.data : null,
      statusCode: response.statusCode ?? 0,
      responseBody: jsonEncode(response.data),
      methodType: response.requestOptions.method,
    );
    handler.next(response);
  }

  @override
  void onError(dio_package.DioException err, dio_package.ErrorInterceptorHandler handler) async {
    final statusCode = err.response?.statusCode ?? 0;
    final responseData = err.response?.data;
    String errorMessage = '';

    // 🚀 Handle Timeouts & No Internet
    if (err.type == dio_package.DioExceptionType.connectionTimeout || err.type == dio_package.DioExceptionType.sendTimeout || err.type == dio_package.DioExceptionType.receiveTimeout) {
      errorMessage = locale.value.gatewayTimeout;
      return handler.reject(
        dio_package.DioException(
          requestOptions: err.requestOptions,
          error: errorMessage,
          message: errorMessage,
          type: err.type,
        ),
      );
    }

    if (err.type == dio_package.DioExceptionType.connectionError || err.type == dio_package.DioExceptionType.unknown) {
      errorMessage = locale.value.yourInternetIsNotWorking;
      return handler.reject(
        dio_package.DioException(
          requestOptions: err.requestOptions,
          error: errorMessage,
          message: errorMessage,
          type: err.type,
        ),
      );
    }
    // Handle 401 Unauthorized with token refresh
    if (statusCode == 401 && isLoggedIn.value) {
      /* log('🔁 Token expired — trying to regenerate...');
      final tokenRefreshed = await reGenerateToken();
      if (tokenRefreshed) {
        final cloneRequest = await _retryRequest(err.requestOptions);
        return handler.resolve(cloneRequest);
      } else { */
      errorSnackBar(error: locale.value.youHaveBeenLoggedOutOfYourAccountOn);
      await clearAppData();
      throw locale.value.youHaveBeenLoggedOutOfYourAccountOn;
      /* } */
    } else {
      // Enhanced API logging with better error information
      await apiPrint(
        url: err.requestOptions.path,
        headers: jsonEncode(err.requestOptions.headers),
        request: err.requestOptions.data != null && err.requestOptions.data is! dio_package.FormData ? jsonEncode(err.requestOptions.data) : '',
        multipartRequest: err.requestOptions.data != null && (err.requestOptions.data is dio_package.FormData) ? err.requestOptions.data : null,
        statusCode: statusCode,
        responseBody: jsonEncode(responseData ?? errorMessage),
        methodType: err.requestOptions.method,
      );
    }

    // Create enhanced error with better message

    final enhancedError = dio_package.DioException(
      requestOptions: err.requestOptions,
      response: err.response,
      type: err.type,
      error: errorMessage.isNotEmpty ? errorMessage : err.error,
      message: errorMessage.isNotEmpty ? errorMessage : err.message,
    );
    handler.next(enhancedError);
  }

  Future<dio_package.Response> _retryRequest(dio_package.RequestOptions requestOptions) async {
    final dio = dio_package.Dio(
      dio_package.BaseOptions(
        baseUrl: BASE_URL,
      ),
    );

    dio.interceptors.add(ApiInterceptor());

    final headers = await buildHeaderTokens(endPoint: requestOptions.path);

    final options = dio_package.Options(
      method: requestOptions.method,
      headers: headers,
    );

    return dio.request(
      requestOptions.path,
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
      options: options,
    );
  }
}

final dio_package.Dio dioClient = dio_package.Dio(
  dio_package.BaseOptions(
    baseUrl: BASE_URL,
    responseType: dio_package.ResponseType.json,
    connectTimeout: const Duration(seconds: 20),
    receiveTimeout: const Duration(seconds: 20),
  ),
)..interceptors.add(ApiInterceptor());

dio_package.Options _buildDioOptions(Map<String, String> headers, {dio_package.ResponseType responseType = dio_package.ResponseType.json}) {
  return dio_package.Options(
    headers: headers,
    responseType: responseType,
  );
}

String _prettyPrintJson(String jsonStr) {
  try {
    final dynamic parsedJson = jsonDecode(jsonStr);
    const formatter = JsonEncoder.withIndent('  ');
    return formatter.convert(parsedJson);
  } catch (_) {
    return jsonStr;
  }
}

Future<dynamic> getRemoteDataFromUrl({
  required String endPoint,
  Map<String, String>? header,
  Map<String, dynamic>? request,
  bool isDownload = false,
}) async {
  final headers = header ??
      {
        'User-Agent': 'Mozilla/5.0 (compatible; VAST Parser)',
        'Accept': 'application/xml, text/xml, */*',
      };
  final Uri url = buildBaseUrl(endPoint);
  final options = _buildDioOptions(headers, responseType: isDownload ? dio_package.ResponseType.bytes : dio_package.ResponseType.json);

  try {
    dio_package.Response response;
    if (request != null) {
      response = await dioClient.post(url.toString(), data: request, options: options);
    } else {
      response = await dioClient.get(url.toString(), options: options);
    }

    return handleRemoteDataFromUrl(response, isDownload: isDownload);
  } catch (e) {
    onCatchError(e);
  }
}

void onCatchError(dynamic e) {
  if (e is dio_package.DioException) {
    if (e.type == dio_package.DioExceptionType.connectionError || e.type == dio_package.DioExceptionType.unknown)
      throw locale.value.yourInternetIsNotWorking;
    else if (e.response != null) {
      dio_package.Response<dynamic> error = e.response!;
      throw handleError(error);
    } else
      throw locale.value.somethingWentWrong;
  } else {
    if (e is Map<String, dynamic> && (e.containsKey('message') || e.containsKey('error_message') || e.containsKey('error'))) {
      throw e['message'] ?? e['error'] ?? e['error_message'];
    } else {
      throw locale.value.somethingWentWrong;
    }
  }
}

dynamic handleRemoteDataFromUrl(dio_package.Response response, {bool isDownload = false}) {
  if (response.statusCode == 200) {
    if (isDownload) {
      return response;
    }
    return response.data;
  } else {
    return null;
  }
}

Future<String?> downloadImageAndGetPath(
  String imageUrl,
  String fileName,
) async {
  try {
    final Uint8List? bytes = await getRemoteDataFromUrl(
      endPoint: imageUrl,
      isDownload: true,
    );

    if (bytes == null || bytes.isEmpty) return null;

    final dir = await getApplicationDocumentsDirectory();
    final path = '${dir.path}/$fileName.jpg';

    final file = File(path);
    await file.writeAsBytes(bytes, flush: true);

    return path;
  } catch (e) {
    log('Image save failed: $e');
    return null;
  }
}

Future getApiResponse(
  String endPoint, {
  HttpMethodType method = HttpMethodType.GET,
  Map? request,
  String filePaths = '',
  String fileRequestKey = '',
  Map<String, String>? headers,
  bool manageApiVersion = false,
  dio_package.CancelToken? cancelToken,
}) async {
  final resolvedHeaders = headers ?? await buildHeaderTokens(endPoint: endPoint);
  final Uri url = buildBaseUrl(endPoint, manageApiVersion: manageApiVersion);

  try {
    final options = _buildDioOptions(resolvedHeaders);
    dio_package.Response response;

    switch (method) {
      case HttpMethodType.POST:
        response = await dioClient.post(
          url.toString(),
          data: request,
          options: options,
          cancelToken: cancelToken,
        );
        break;
      case HttpMethodType.PUT:
        response = await dioClient.put(
          url.toString(),
          data: request,
          options: options,
          cancelToken: cancelToken,
        );
        break;
      case HttpMethodType.DELETE:
        response = await dioClient.delete(
          url.toString(),
          data: request,
          options: options,
          cancelToken: cancelToken,
        );
        break;
      default:
        response = await dioClient.get(
          url.toString(),
          options: options,
          cancelToken: cancelToken,
        );
        break;
    }

    return handleDioResponse(response);
  } catch (e) {
    onCatchError(e);
  }
}

Map<String, dynamic> handleDioResponse(dio_package.Response response) {
  final statusCode = response.statusCode ?? 0;
  final responseBody = response.data;

  // Handle successful responses
  if (statusCode.isSuccessful() && ((responseBody.containsKey('status') && responseBody['status'] == true) || (responseBody.containsKey('status') && responseBody['status'] == 'success'))) {
    return Map<String, dynamic>.from(responseBody);
  } else {
    throw handleError(response);
  }
}

//region ------------------------ DIO Multipart Helper ------------------------

/// Build and send multipart request using Dio
Future getMultiPartResponse({
  required String endPoint,
  required Map<String, dynamic> request,
  List<String>? filePaths,
  String? fileKey, // e.g., "images"
  Map<String, String>? headers,
  bool manageApiVersion = false,
  bool indexFiles = false, // append _0, _1 if true
  dio_package.CancelToken? cancelToken,
}) async {
  try {
    final resolvedHeaders = headers ?? await buildHeaderTokens(endPoint: endPoint);
    final Uri url = buildBaseUrl(endPoint, manageApiVersion: manageApiVersion);

    final dio_package.FormData formData = dio_package.FormData();

    // Add fields
    request.forEach((key, value) {
      formData.fields.add(MapEntry(key, value.toString()));
    });

    // Add files
    if (filePaths != null && filePaths.isNotEmpty) {
      for (int i = 0; i < filePaths.length; i++) {
        final key = (indexFiles && filePaths.length > 1) ? '${fileKey}_$i' : fileKey;
        final multipartFile = await getMultiPartImageFile(filePaths[i]);
        if (multipartFile != null) {
          formData.files.add(MapEntry(key.validate(), multipartFile));
        }
      }
    }

    final response = await dioClient.post(
      url.toString(),
      data: formData,
      options: dio_package.Options(
        headers: resolvedHeaders,
        contentType: 'multipart/form-data',
      ),
      cancelToken: cancelToken,
    );

    return handleDioResponse(response);
  } catch (e) {
    onCatchError(e);
  }
}

Future<dio_package.MultipartFile?> getMultiPartImageFile(String sourcePath) async {
  if (sourcePath.isEmpty) return null;

  try {
    // Network image
    if (sourcePath.startsWith('http')) {
      final response = await dio_package.Dio().get<List<int>>(
        sourcePath,
        options: dio_package.Options(responseType: dio_package.ResponseType.bytes),
      );
      if (response.statusCode == 200) {
        return dio_package.MultipartFile.fromBytes(
          response.data!,
          filename: sourcePath.split('/').last,
        );
      }
    }

    // Asset image
    if (sourcePath.startsWith('assets/')) {
      final byteData = await rootBundle.load(sourcePath);
      final bytes = byteData.buffer.asUint8List();
      return dio_package.MultipartFile.fromBytes(bytes, filename: sourcePath.split('/').last);
    }

    // Local file
    final file = File(sourcePath);
    if (await file.exists()) {
      return await dio_package.MultipartFile.fromFile(file.path, filename: file.path.split('/').last);
    }
  } catch (e) {
    log('Error creating Dio MultipartFile: $e');
  }
  return null;
}

//endregion

//endregion