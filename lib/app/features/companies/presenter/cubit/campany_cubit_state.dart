import 'package:tree_view_app/app/features/companies/domain/entities/company_entity.dart';

abstract class CompanyCubitState {}

class LoadingState implements CompanyCubitState {}

class ErrorState implements CompanyCubitState {}

class InitialState implements CompanyCubitState {}

class SuccessState implements CompanyCubitState {
  final List<CompanyEntity> list;
  SuccessState({required this.list});
}
