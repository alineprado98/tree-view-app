import 'package:flutter/material.dart';
import 'package:tree_view_app/app/common/utils/app_assets.dart';
import 'package:tree_view_app/app/common/widgets/svg_reader_widget.dart';

class ErrorStateWidget extends StatelessWidget {
  final void Function()? onRefresh;
  const ErrorStateWidget({super.key, this.onRefresh});

  @override
  Widget build(BuildContext context) {
    final texts = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgReaderWidget(path: AppAssets.error, height: 150),
          SizedBox(height: 24),
          Text(
            'Ocorreu um erro...',
            style: texts.titleLarge,
          ),
          SizedBox(height: 16),
          ElevatedButton(onPressed: onRefresh, child: Text('Tentar novamente'))
        ],
      ),
    );
  }
}
