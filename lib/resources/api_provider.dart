import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:careqar/constants/strings.dart';
import 'package:careqar/models/error_model.dart';
import 'package:careqar/models/success_model.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';

import '../user_session.dart';

class ApiProvider {
  final Client _client = Client();

  Future<Either<ErrorModel, SuccessModel>> post({
    Map<String, dynamic>? body,
    String? path,
    bool authorization = false,
    bool isFormData = false,
    String? accessToken,
    File? file,
    List<dynamic>? files,
    bool isPatch = false,
  }) async {
    try {
      Response response;

      // 🟡 Request debug
      if (kDebugMode) {
        debugPrint("SAHAr📤 [POST ${isFormData ? 'FormData' : 'JSON'}] → $kApiBaseUrl/$path");
        if (body != null) debugPrint("SAHAr📦 Request Body: ${jsonEncode(body)}");
      }

      if (isFormData) {
        var request = MultipartRequest(isPatch ? "PATCH" : "POST", Uri.parse("$kApiBaseUrl/$path"));
        request.headers[HttpHeaders.authorizationHeader] =
        authorization ? "Bearer ${accessToken ?? UserSession.accessToken}" : "";
        request.headers[HttpHeaders.acceptHeader] = 'application/json';
        request.headers["API_KEY"] = kApiKey;
        request.headers[HttpHeaders.contentTypeHeader] = 'multipart/form-data';

        if (file != null) {
          request.files.add(await MultipartFile.fromPath('file', file.path,
              contentType: MediaType('file', file.path.split(".").last)));
        } else if (files != null) {
          for (var item in files) {
            request.files.add(await MultipartFile.fromPath('', item.path,
                contentType: MediaType('file', item.path.split(".").last)));
          }
        }

        if (body != null) {
          request.fields.addAll(body.cast<String, String>());
        }

        final StreamedResponse streamResponse = await request.send();
        response = await Response.fromStream(streamResponse);
      } else {
        response = await _client.post(Uri.parse("$kApiBaseUrl/$path"),
            body: jsonEncode(body),
            headers: {
              "content-type": "application/json",
              "accept": "application/json",
              "API_KEY": kApiKey,
              "Authorization": authorization
                  ? "Bearer ${accessToken ?? UserSession.accessToken ?? ''}"
                  : ""
            });
      }

      // 🟢 Response debug
      if (kDebugMode) {
        debugPrint("SAHAr✅ [POST] Status Code:${UserSession.accessToken}   ${response.statusCode}");
        debugPrint("SAHAr📨 [POST] Response Body:  ${response.body}");
      }

      var parsedBody = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return right(SuccessModel(
            title: "Success",
            data: parsedBody["data"],
            message: parsedBody["message"] ?? "Success"));
      } else {
        return left(ErrorModel(
            data: parsedBody["data"],
            title: "Error",
            errorCode: response.statusCode,
            message: parsedBody["message"] ?? "Error"));
      }
    } on SocketException {
      return left(ErrorModel(
          message: "No internet connection", title: "Error", errorCode: 400));
    } on HttpException {
      return left(ErrorModel(
          message: "Server is not responding. Try later",
          title: "Error",
          errorCode: 400));
    } on TimeoutException {
      return left(ErrorModel(
        message: "Request timeout. Please try again.",
        title: "Error",
        errorCode: 408,
      ));
    } catch (ex, stackTrace) {
      if (kDebugMode) {
        debugPrint("SAHAr❌ Error in post request: $ex");
        debugPrint("SAHAr📍 Stack Trace: $stackTrace");
      }
      return left(ErrorModel(
          message: "Something went wrong. Try again",
          title: "Error",
          errorCode: 420));
    }
  }

  Future<Either<ErrorModel, SuccessModel>> get({
    String? path,
    accessToken,
    bool isFormData = false,
    Map<String, String>? body,
    bool authorization = false,
    File? file,
  }) async {
    try {
      Response response;

      // Debug token information
      String finalToken = accessToken ?? UserSession.accessToken ?? '';
      print("SAHAr📥 [GET] → $kApiBaseUrl/$path");
      print("SAHAr🔐 Authorization: $authorization");
      print("SAHAr🎫 Token (first 20 chars): ${finalToken.length > 20 ? finalToken.substring(0, 20) + '...' : finalToken}");
      print("SAHAr🎫 Token Length: ${finalToken.length}");

      if (body != null) print("SAHAr Request Params: ${jsonEncode(body)}");

      if (isFormData) {
        var request = MultipartRequest("GET", Uri.parse("$kApiBaseUrl/$path"));

        if (authorization && finalToken.isNotEmpty) {
          request.headers[HttpHeaders.authorizationHeader] = "Bearer $finalToken";
        }
        request.headers[HttpHeaders.acceptHeader] = 'application/json';
        request.headers["API_KEY"] = kApiKey;
        request.headers[HttpHeaders.contentTypeHeader] = 'multipart/form-data';

        if (body != null) {
          request.fields.addAll(body);
        }

        final StreamedResponse streamResponse = await request.send();
        response = await Response.fromStream(streamResponse);
      } else {
        Map<String, String> headers = {
          "content-type": "application/json",
          "accept": "application/json",
          "API_KEY": kApiKey,
        };

        if (authorization && finalToken.isNotEmpty) {
          headers["Authorization"] = "Bearer $finalToken";
        }

        print("SAHAr📋 Request Headers: $headers");

        response = await _client.get(Uri.parse("$kApiBaseUrl/$path"), headers: headers);
      }

      // Response debug
      print("SAHAr✅ [GET] Status Code: ${response.statusCode}");
      print("SAHAr📨 [GET] Response Body: ${response.body}");

      var parsedBody = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return right(SuccessModel(
            title: "Success",
            data: parsedBody["data"],
            message: parsedBody["message"] ?? "Success"));
      } else {
        return left(ErrorModel(
            data: parsedBody["data"],
            message: parsedBody["message"] ?? "Error",
            title: "Error",
            errorCode: response.statusCode));
      }
    } on SocketException {
      return left(ErrorModel(
          message: "No internet connection!", title: "Error", errorCode: 400));
    } on HttpException {
      return left(ErrorModel(
          message: "Server is not responding. Try later",
          title: "Error",
          errorCode: 400));
    } on TimeoutException {
      return left(ErrorModel(
        message: "Request timeout. Please try again.",
        title: "Error",
        errorCode: 408,
      ));
    } catch (e, stackTrace) {
      if (kDebugMode) {
        debugPrint("SAHAr❌ Error in get request: $e");
        debugPrint("SAHAr📍 Stack Trace: $stackTrace");
      }
      return left(ErrorModel(
          message: "Something went wrong. Try again",
          title: "Error",
          errorCode: 400));
    }
  }
}
