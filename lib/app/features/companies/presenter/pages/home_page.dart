import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tree_view_app/app/common/utils/app_assets.dart';
import 'package:tree_view_app/app/common/widgets/error_widget.dart';
import 'package:tree_view_app/app/features/companies/domain/entities/company_entity.dart';
import 'package:tree_view_app/app/features/companies/presenter/cubit/home/home_cubit.dart';
import 'package:tree_view_app/app/features/companies/presenter/cubit/home/home_cubit_state.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    Future(() => _loadCompanies);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(AppAssets.logo),
      ),
      body: Center(
        child: BlocBuilder<HomeCubit, HomeCubitState>(
          bloc: BlocProvider.of<HomeCubit>(context),
          builder: (context, state) {
            if (state is LoadingState) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is ErrorState) {
              return ErrorStateWidget(onRefresh: _loadCompanies);
            }
            if (state is SuccessState) {
              return ListView.builder(
                  itemCount: state.list.length,
                  itemBuilder: (context, index) {
                    final CompanyEntity item = state.list[index];
                    return Padding(
                      padding: const EdgeInsets.all(15),
                      child: ElevatedButton.icon(
                        onPressed: () => context.pushNamed('/company_details', extra: item.id),
                        icon: SvgPicture.asset(AppAssets.companyIcon),
                        label: Text(item.name),
                        style: ElevatedButton.styleFrom(
                            minimumSize: Size(double.infinity, 76),
                            textStyle: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            )),
                      ),
                    );
                  });
            } else {
              return const SizedBox.shrink();
            }
          },
        ),
      ),
    );
  }

  Future<void> _loadCompanies() async {
    await BlocProvider.of<HomeCubit>(context).loadComapanies();
  }
}
