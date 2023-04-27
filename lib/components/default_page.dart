import 'package:flutter/material.dart';

import 'default_header.dart';
import 'log_menu.dart';

class DefaultPage extends StatelessWidget {
  const DefaultPage({
    Key? key,
    this.children,
    required this.title,
  }) : super(key: key);

  final List<Widget>? children;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      drawer: null,
      backgroundColor: const Color(0xffF7F7F8),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Row(
            children: [
              const LogMenu(),
              Expanded(
                child: Column(
                  children: [
                    DefaultHeader(title: title),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              children == null
                                  ? Container()
                                  : Padding(
                                      padding: const EdgeInsets.only(
                                        left: 48,
                                        right: 48,
                                        top: 24,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: children!,
                                      ),
                                    ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
