import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tree_view_app/app/features/companies/presenter/cubit/home/home_cubit.dart';
import 'package:tree_view_app/app/features/companies/presenter/cubit/company/company_details_cubit.dart';
import 'package:tree_view_app/app/features/companies/presenter/pages/company_details_page.dart';
import 'package:tree_view_app/app/features/companies/presenter/pages/home_page.dart';
import 'package:tree_view_app/app/splash/presenter/cubit/splash_cubit.dart';
import 'package:tree_view_app/app/splash/presenter/pages/splash_page.dart';

class AppRoutes {
  static final routes = GoRouter(routes: [
    GoRoute(
        path: '/',
        builder: (context, state) => BlocProvider(
              create: (context) => SplashCubit(context),
              child: const SplashPage(),
            )),
    GoRoute(
        path: '/home_page',
        builder: (context, state) => BlocProvider(
              create: (context) => HomeCubit(context),
              child: const HomePage(),
            )),
    GoRoute(
        path: '/company_details',
        name: '/company_details',
        builder: (context, state) => BlocProvider(
              create: (context) => CompanyDetailsCubit(context),
              child: CompanyDetailsPage(
                companyId: state.extra as String,
              ),
            ))
  ]);
}
