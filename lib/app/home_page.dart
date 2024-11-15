import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:tree_view_app/app/common/widgets/elevated_button_widget.dart';
import 'package:tree_view_app/app/features/companies/domain/entities/company_entity.dart';
import 'package:tree_view_app/app/features/companies/presenter/cubit/campany_cubit_state.dart';
import 'package:tree_view_app/app/features/companies/presenter/cubit/company_cubit.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    Future(() => BlocProvider.of<CompanyCubit>(context).loadComapanies());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset('assets/images/logo.png'),
      ),
      body: Center(
        child: BlocBuilder<CompanyCubit, CompanyCubitState>(
          bloc: BlocProvider.of<CompanyCubit>(context),
          builder: (context, state) {
            if (state is LoadingState) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is ErrorState) {
              const SizedBox.shrink();
            }
            if (state is SuccessState) {
              return ListView.builder(
                  itemCount: state.list.length,
                  itemBuilder: (context, index) {
                    final CompanyEntity item = state.list[index];
                    return Padding(
                      padding: const EdgeInsets.all(15),
                      child: ElevatedButtonWidget(
                        icon: SvgPicture.asset('assets/svgs/company_icon.svg'),
                        label: item.name,
                        width: 10,
                        height: 70,
                        onPressed: () {
                          context.pushNamed('/company_details', extra: item.id);
                        },
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
}
