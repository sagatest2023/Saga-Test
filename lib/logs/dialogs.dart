import 'package:flutter/material.dart';

import '../saga_lib/sa_api.dart';

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
              Text(infoLog.resultado.toString()),
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
