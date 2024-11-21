import 'package:get_it/get_it.dart';
import 'package:tree_view_app/app/core/services/client/client_service.dart';
import 'package:tree_view_app/app/core/services/client/i_client.dart';
import 'package:tree_view_app/app/core/services/database/i_database.dart';
import 'package:tree_view_app/app/core/services/database/sqflite/sqflite_config.dart';
import 'package:tree_view_app/app/core/services/database/sqflite/sqflite_database_service.dart';
import 'package:tree_view_app/app/features/companies/data/repositories/company_remote_repository.dart';
import 'package:tree_view_app/app/features/companies/data/repositories/company_repository.dart';
import 'package:tree_view_app/app/features/companies/domain/repositories/i_company_remote_repository.dart';
import 'package:tree_view_app/app/features/companies/domain/repositories/i_company_repository.dart';

GetIt getIt = GetIt.instance;

class DependencyLocatorService {
  static Future<void> setup() async {
    final databaseInstance = await SqfliteConfig.getInstance();
    getIt.registerSingleton<IDatabase>(
      SqfliteDatabaseService(databaseConfig: databaseInstance),
    );
    getIt.registerFactory<IClient>(() => ClientService());
    getIt.registerFactory<ICompanyRemoteRepository>(() => CompanyRemoteRepository(
          clientService: getIt.get<IClient>(),
          databaseService: getIt.get<IDatabase>(),
        ));
    getIt.registerFactory<ICompanyRepository>(() => CompanyRepository(
          remoteRepository: getIt.get<ICompanyRemoteRepository>(),
          databaseService: getIt.get<IDatabase>(),
        ));
  }
}
