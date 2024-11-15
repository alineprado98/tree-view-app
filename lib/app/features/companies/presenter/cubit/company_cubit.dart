import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tree_view_app/app/core/services/locator/dependency_locator_service.dart';
import 'package:tree_view_app/app/features/companies/domain/repositories/i_company_repository.dart';
import 'package:tree_view_app/app/features/companies/presenter/cubit/campany_cubit_state.dart';

class CompanyCubit extends Cubit<CompanyCubitState> {
  final BuildContext context;
  CompanyCubit(this.context) : super(InitialState());

  Future<void> loadComapanies() async {
    final companyRepository = getIt.get<ICompanyRepository>();

    emit(LoadingState());

    final result = await companyRepository.getCompanies();

    if (result!.isNotEmpty) {
      emit(SuccessState(list: result));
    } else {
      emit(ErrorState());
    }
  }
}
