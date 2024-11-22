import 'package:flutter/material.dart';
import 'package:tree_view_app/app/common/utils/app_assets.dart';
import 'package:tree_view_app/app/common/widgets/svg_reader_widget.dart';

class EmptyStateSearchWidget extends StatelessWidget {
  const EmptyStateSearchWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final texts = Theme.of(context).textTheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgReaderWidget(path: AppAssets.empty, height: 150),
            SizedBox(height: 24),
            Text(
              'Nada por aqui...',
              style: texts.titleLarge,
            ),
            SizedBox(height: 16),
            Text(
              'Tente ajustar os filtros ou usar a busca livre para encontrar o que você procura.',
              style: texts.labelLarge,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
