import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:go_router/go_router.dart';
import 'package:tree_view_app/app/core/services/locator/dependency_locator_service.dart';
import 'package:tree_view_app/app/features/companies/domain/repositories/i_company_remote_repository.dart';
import 'package:tree_view_app/app/splash/presenter/cubit/splash_cubit_state.dart';

class SplashCubit extends Cubit<SplashCubitState> {
  final BuildContext context;
  SplashCubit(this.context) : super(LoadingSplashState());

  final companyRepository = getIt.get<ICompanyRemoteRepository>();

  Future<void> firstCharge() async {
    await companyRepository.firstLoadCompanies();
    FlutterNativeSplash.remove();
    context.go('/home_page');
  }
}
