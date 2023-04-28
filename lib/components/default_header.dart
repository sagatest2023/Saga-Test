import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:saga_test/login/login_api.dart';

import '../helpers/page_routes.dart';
import '../main/app.dart';
import '../saga_lib/sa_api.dart';
import 'default_button.dart';
import 'default_dialog.dart';
import 'default_text_field.dart';
import 'log_menu.dart';
import 'popup_menu_content.dart';

class DefaultHeader extends StatelessWidget {
  const DefaultHeader({
    super.key,
    this.title,
  });
  final String? title;

  @override
  Widget build(BuildContext context) {
    final urlConexao = TextEditingController();
    urlConexao.text = ApiDefaults.baseURL.isNotEmpty
        ? ApiDefaults.baseURL
        : 'http://192.168.50.132:9007';

    return Padding(
      padding: const EdgeInsets.fromLTRB(48.0, 4, 32, 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title ?? "",
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 24,
                    color: Colors.black,
                  ),
                ),
              ),
              if (Get.routing.current != PagesRoutes.login) ...[
                PopupMenu(
                  title: "Dados Login",
                  height: 230,
                  content: [
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Text(
                          "Usuário: ",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(App.nomeUsuario),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Text(
                          "Site: ",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(App.nomeSite),
                      ],
                    ),
                    Row(
                      children: [
                        const Text(
                          "Posto: ",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(App.nomePosto),
                      ],
                    ),
                    Row(
                      children: [
                        const Text(
                          "Equipamento: ",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(App.nomeEquipamento!),
                      ],
                    ),
                    Container(
                      alignment: Alignment.bottomRight,
                      child: IconButton(
                        onPressed: () async {
                          final result = await showList<InfoMotivoLogout>(
                            context: context,
                            title: 'Equipamentos',
                            loadList: () => LoginAPI()
                                .getMotivosLogout(App.idcGrupoUsuario),
                            showItem: (item) {
                              return Column(children: [
                                ListTile(
                                  title: Text(item.nome),
                                ),
                                const Divider(),
                              ]);
                            },
                          );
                          if (result == null) return;
                          await LoginAPI().logout(
                            App.idcSite,
                            App.idcUsuario,
                            result.idc,
                          );
                          Get.offAndToNamed(PagesRoutes.login);
                        },
                        icon: const Icon(Icons.logout_rounded),
                      ),
                    )
                  ],
                  child: SizedBox(
                    key: GlobalKey(),
                    height: 48,
                    width: 48,
                    child: const Icon(Icons.person_rounded),
                  ),
                ),
              ],
              PopupMenu(
                title: "Configurações de API",
                height: 230,
                content: [
                  const SizedBox(height: 8),
                  DefaultTextField(
                    "API",
                    urlConexao,
                    autofocus: true,
                  ),
                  DefaultButton(
                    label: "Alterar",
                    onPressed: () async {
                      final url = urlConexao.text;
                      ApiDefaults.baseURL = url;
                      baseURL = url;
                      await SAApi().get(
                        '/api/mobile/GetVersoes',
                        {},
                        null,
                        descricao:
                            "Método para buscar as versões disponíveis do SAGA",
                      );

                      if (logsList.value.last.resultado is Exception) {
                        showResult(context);
                      }
                      Navigator.pop(context);
                    },
                  ),
                ],
                child: SizedBox(
                  key: GlobalKey(),
                  height: 48,
                  width: 48,
                  child: const Icon(Icons.compass_calibration_rounded),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
