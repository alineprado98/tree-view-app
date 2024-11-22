import 'package:tree_view_app/app/features/companies/domain/entities/item.dart';

abstract class CompanyDetailsCubitState {}

class CompanyDetailsLoadingState implements CompanyDetailsCubitState {}

class CompanyDetailsErrorState implements CompanyDetailsCubitState {}

class CompanyDetailsInitialState implements CompanyDetailsCubitState {}

class CompanyDetailsSuccessState implements CompanyDetailsCubitState {
  final List<Item> list;
  final bool hasFilters;
  CompanyDetailsSuccessState({required this.list, this.hasFilters = false});
}
