import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tree_view_app/app/core/services/locator/dependency_locator_service.dart';
import 'package:tree_view_app/app/features/companies/domain/repositories/i_company_repository.dart';
import 'package:tree_view_app/app/features/companies/presenter/cubit/company_details_cubit_state.dart';

class CompanyDetailsCubit extends Cubit<CompanyDetailsCubitState> {
  final BuildContext context;

  CompanyDetailsCubit(this.context) : super(CompanyDetailsInitialState());
  final companyRepository = getIt.get<ICompanyRepository>();
  final ValueNotifier<bool> expanded = ValueNotifier(false);

  // Filters
  final ValueNotifier<String?> search = ValueNotifier(null);
  final ValueNotifier<bool> criticalFilter = ValueNotifier(false);
  final ValueNotifier<bool> sensorEnergyFilter = ValueNotifier(false);

  Future<void> filter({required String companyId}) async {
    expanded.value = true;
    final result;
    if (criticalFilter.value == true || sensorEnergyFilter.value == true || (search.value != null && search.value!.length >= 3)) {
      result = await companyRepository.filter(
        companyId: companyId,
        criticalFilter: criticalFilter.value,
        searchField: search.value,
        sensorEnergyFilter: sensorEnergyFilter.value,
      );
    } else {
      expanded.value = false;
      result = await companyRepository.buildTheTree(companyId: companyId);
    }

    emit(CompanyDetailsSuccessState(list: result));
  }

  Future<void> buildTheTree(String companyId) async {
    expanded.value = false;
    emit(CompanyDetailsLoadingState());
    final result = await companyRepository.buildTheTree(companyId: companyId);

    if (result.isNotEmpty) {
      emit(CompanyDetailsSuccessState(list: result));
    }

    if (result.isEmpty) {
      emit(CompanyDetailsEmptyState());
    }
  }
}
