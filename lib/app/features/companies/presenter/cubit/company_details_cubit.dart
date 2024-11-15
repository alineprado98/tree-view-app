import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tree_view_app/app/core/services/locator/dependency_locator_service.dart';
import 'package:tree_view_app/app/features/companies/domain/repositories/i_company_repository.dart';
import 'package:tree_view_app/app/features/companies/presenter/cubit/company_details_cubit_state.dart';

class CompanyDetailsCubit extends Cubit<CompanyDetailsCubitState> {
  final BuildContext context;
  CompanyDetailsCubit(this.context) : super(CompanyDetailsInitialState());

  Future<void> buildTheTree(String companyId) async {
    emit(CompanyDetailsLoadingState());
    final companyRepository = getIt.get<ICompanyRepository>();

    final result = await companyRepository.buildTheTree(companyId: companyId);

    if (result.isNotEmpty) {
      emit(CompanyDetailsSuccessState(list: result));
    }

    if (result.isEmpty) {
      emit(CompanyDetailsEmptyState());
    }
  }
}
