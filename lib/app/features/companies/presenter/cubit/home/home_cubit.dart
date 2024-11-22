import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tree_view_app/app/common/locator/dependency_locator_service.dart';
import 'package:tree_view_app/app/features/companies/domain/repositories/i_company_remote_repository.dart';
import 'package:tree_view_app/app/features/companies/presenter/cubit/home/home_cubit_state.dart';

class HomeCubit extends Cubit<HomeCubitState> {
  final BuildContext context;
  HomeCubit(this.context) : super(InitialState());

  Future<void> loadComapanies() async {
    final companyRepository = getIt.get<ICompanyRemoteRepository>();

    emit(LoadingState());

    final (companies, error) = await companyRepository.getCompanies();

    if (error != null) {
      emit(ErrorState());
    } else {
      emit(SuccessState(list: companies));
    }
  }
}
