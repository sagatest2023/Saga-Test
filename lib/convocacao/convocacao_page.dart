import 'package:flutter/material.dart';

import '../components/default_card.dart';
import '../components/default_page.dart';

class ConvocacaoPage extends StatelessWidget {
  const ConvocacaoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultPage(
      title: "Convocação",
      children: [
        DefaultCard(
          child: Container(),
        ),
      ],
    );
  }
}
