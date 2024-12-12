import 'package:dio/dio.dart';

abstract class Failure {
  final String errMessage;

  const Failure(this.errMessage);
}

class ServerFailure extends Failure {
  ServerFailure(super.errMessage);

  factory ServerFailure.fromDioException(DioException dioException) {
    switch (dioException.type) {
      case DioExceptionType.connectionTimeout:
        return ServerFailure('Connection timeout with API server');
      case DioExceptionType.sendTimeout:
        return ServerFailure('Send timeout with API server');
      case DioExceptionType.receiveTimeout:
        return ServerFailure('Receive timeout with API server');
      case DioExceptionType.badCertificate:
        return ServerFailure('Bad certificate with API server');
      case DioExceptionType.badResponse:
        if (dioException.response != null) {
          return ServerFailure.fromResponse(dioException.response!.statusCode ?? 0, dioException.response!.data);
        } else {
          return ServerFailure('Bad response with no details provided');
        }
      case DioExceptionType.cancel:
        return ServerFailure('Request to API server was canceled');
      case DioExceptionType.connectionError:
        return ServerFailure('Connection error with API server');
      case DioExceptionType.unknown:
        if (dioException.message?.contains('SocketException') ?? false) {
          return ServerFailure('No Internet connection');
        }
        return ServerFailure('Unexpected error, please try again!');
      default:
        return ServerFailure('Oops! There was an error, please try again.');
    }
  }

  factory ServerFailure.fromResponse(int statusCode, dynamic response) {
    if (response is Map<String, dynamic>) {
      if (statusCode == 400 || statusCode == 401 || statusCode == 403) {
        return ServerFailure(response['error']?['message'] ?? 'Authorization error');
      } else if (statusCode == 404) {
        return ServerFailure('Your request was not found. Please try again later.');
      } else if (statusCode == 500) {
        return ServerFailure('Internal server error. Please try later.');
      }
    }
    return ServerFailure('Oops! There was an error, please try again.');
  }
}
