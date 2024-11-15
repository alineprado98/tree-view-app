import 'package:dio/dio.dart';
import 'package:tree_view_app/app/core/services/client/client_response.dart';
import 'package:tree_view_app/app/core/services/client/error_response.dart';
import 'package:tree_view_app/app/core/services/client/i_client.dart';

class ClientService implements IClient {
  static const String BASE_URL = String.fromEnvironment("BASE_URL", defaultValue: "");
  static final options = BaseOptions(baseUrl: BASE_URL);
  final Dio dio = Dio(options);
  ClientService();

  @override
  Future<ClientResponse> get({required String url}) async {
    try {
      final response = await dio.get(url);
      return ClientResponse(data: response.data);
    } catch (e, stackTrace) {
      return ClientResponse(
          data: null,
          error: ErrorResponse(
            stackTrace: stackTrace,
            message: 'Error Dio.get:${e.toString()}',
          ));
    }
  }
}
