import 'package:tree_view_app/app/features/companies/domain/entities/company_entity.dart';

abstract class HomeCubitState {}

class LoadingState implements HomeCubitState {}

class ErrorState implements HomeCubitState {}

class InitialState implements HomeCubitState {}

class SuccessState implements HomeCubitState {
  final List<CompanyEntity> list;
  SuccessState({required this.list});
}
