import 'package:tree_view_app/app/common/services/client/client_response.dart';

abstract class IClient {
  Future<ClientResponse> get({required String url});
}
