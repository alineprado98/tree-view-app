import 'package:tree_view_app/app/common/services/client/error_response.dart';

class ClientResponse {
  final dynamic data;
  final ErrorResponse? error;

  const ClientResponse({
    required this.data,
    this.error,
  });
}
