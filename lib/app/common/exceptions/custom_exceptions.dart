import 'package:tree_view_app/app/common/exceptions/base_exception.dart';

class DatabaseException implements BaseException {
  final String info;
  const DatabaseException(this.info);

  @override
  String get message => info;
}

class BuildTreeException implements BaseException {
  final String info;
  const BuildTreeException(this.info);

  @override
  String get message => info;
}

class APIResponseException implements BaseException {
  final String info;
  const APIResponseException(this.info);

  @override
  String get message => info;
}
