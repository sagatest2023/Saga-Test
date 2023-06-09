import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:saga_test/components/default_card.dart';

import '../saga_lib/sa_api.dart';

class LogMenu extends StatefulWidget {
  const LogMenu({super.key});

  @override
  State<LogMenu> createState() => _LogMenuState();
}

class _LogMenuState extends State<LogMenu> {
  ValueNotifier<int> currentIndexChoose = ValueNotifier(0);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Row(
            children: const [
              Text(
                "Menu de logs",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 24,
                  color: Colors.black,
                ),
              ),
              SizedBox(
                height: 48,
                width: 48,
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 24),
          child: DefaultCard(
            width: 400,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ValueListenableBuilder(
                valueListenable: logsList,
                builder: (context, value, child) {
                  currentIndexChoose.value = logsList.value.length - 1;
                  return logsList.value.isNotEmpty
                      ? ValueListenableBuilder(
                          valueListenable: currentIndexChoose,
                          builder: (context, value, child) {
                            String parametros =
                                "Esse método não pede parametros.";

                            if (logsList.value[currentIndexChoose.value]
                                    .parametros !=
                                null) {
                              if (logsList.value[currentIndexChoose.value]
                                  .parametros!.isNotEmpty) {
                                parametros = "";
                                logsList
                                    .value[currentIndexChoose.value].parametros!
                                    .forEach(
                                  (key, value) {
                                    parametros += "$key: $value\n";
                                  },
                                );
                                parametros = parametros.substring(
                                    0, parametros.length - 1);
                              }
                            }
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Text(
                                      "Index: ",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 24,
                                        color: Colors.black,
                                      ),
                                    ),
                                    Text(
                                      (currentIndexChoose.value + 1).toString(),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 24,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                                const Divider(),
                                logsList.value[currentIndexChoose.value]
                                            .resultado is Exception ||
                                        logsList.value[currentIndexChoose.value]
                                            .resultado is DioError
                                    ? const Center(
                                        child: Icon(
                                          Icons.error_rounded,
                                          color: Colors.red,
                                          size: 150,
                                        ),
                                      )
                                    : const Center(
                                        child: Icon(
                                          Icons.check_circle_rounded,
                                          color: Colors.green,
                                          size: 150,
                                        ),
                                      ),
                                const SizedBox(height: 32),
                                const Text(
                                  "IP:",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(logsList
                                    .value[currentIndexChoose.value].ip),
                                const SizedBox(height: 8),
                                const Text(
                                  "PORTA:",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(logsList
                                    .value[currentIndexChoose.value].porta),
                                const SizedBox(height: 8),
                                const Text(
                                  "Nome do método:",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(logsList.value[currentIndexChoose.value]
                                    .nomeMetodo),
                                const SizedBox(height: 8),
                                const Text(
                                  "Nome do controller:",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(logsList.value[currentIndexChoose.value]
                                    .controller),
                                const SizedBox(height: 8),
                                const Text(
                                  "Descrição do método:",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(logsList.value[currentIndexChoose.value]
                                        .descricao ??
                                    ""),
                                const SizedBox(height: 8),
                                const Text(
                                  "Paramêtros (pedidos pelo método/enviados)",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(parametros),
                                const SizedBox(height: 8),
                                const Text(
                                  "Tempo de duração da chamada(ms):",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(logsList
                                    .value[currentIndexChoose.value].tempo),
                                const SizedBox(height: 8),
                                const Text(
                                  "Resultado:",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  logsList.value[currentIndexChoose.value]
                                          .resultado is Exception
                                      ? logsList.value[currentIndexChoose.value]
                                          .resultado
                                          .toString()
                                      : logsList.value[currentIndexChoose.value]
                                          .resultado.runtimeType
                                          .toString(),
                                ),
                                Expanded(
                                  child: Container(
                                    alignment: Alignment.bottomCenter,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        IconButton(
                                          onPressed: () {
                                            if (currentIndexChoose.value != 0) {
                                              currentIndexChoose.value -= 1;
                                              currentIndexChoose
                                                  .notifyListeners();
                                            }
                                          },
                                          icon: const Icon(
                                              Icons.arrow_back_ios_outlined),
                                        ),
                                        IconButton(
                                          onPressed: () {
                                            if (currentIndexChoose.value !=
                                                logsList.value.length - 1) {
                                              currentIndexChoose.value += 1;
                                              currentIndexChoose
                                                  .notifyListeners();
                                            }
                                          },
                                          icon: const Icon(
                                            Icons.arrow_forward_ios_outlined,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            );
                          },
                        )
                      : const Center(child: Text("Sem logs"));
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}

Future<void> showResult(BuildContext context) async {
  final infoLog = logsList.value.last;
  await showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        content: SizedBox(
          width: MediaQuery.of(context).size.width * 0.5,
          height: MediaQuery.of(context).size.height * 0.8,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              infoLog.resultado is Exception
                  ? const Center(
                      child: Icon(
                        Icons.error_rounded,
                        color: Colors.red,
                        size: 150,
                      ),
                    )
                  : const Center(
                      child: Icon(
                        Icons.check_circle_rounded,
                        color: Colors.green,
                        size: 150,
                      ),
                    ),
              const SizedBox(height: 32),
              const Text(
                "IP:",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(infoLog.ip),
              const SizedBox(height: 8),
              const Text(
                "PORTA:",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(infoLog.porta),
              const SizedBox(height: 8),
              const Text(
                "Nome do método:",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(infoLog.nomeMetodo),
              const SizedBox(height: 8),
              const Text(
                "Nome do controller:",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(infoLog.controller),
              const SizedBox(height: 8),
              const Text(
                "Descrição do método:",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(infoLog.descricao ?? ""),
              const SizedBox(height: 8),
              const Text(
                "Tempo de duração da chamada(ms):",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(infoLog.tempo),
              const SizedBox(height: 8),
              const Text(
                "Resultado:",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(infoLog.resultado is Exception
                  ? infoLog.resultado.toString()
                  : infoLog.resultado.runtimeType.toString()),
            ],
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Sair"),
          )
        ],
      );
    },
  );
}
