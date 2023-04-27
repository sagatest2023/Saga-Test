import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:saga_test/helpers/page_routes.dart';
import 'package:saga_test/login/login_api.dart';
import 'package:saga_test/logs/dialogs.dart';
import 'package:saga_test/saga_lib/sa_network.dart';

import '../components/default_button.dart';
import '../components/default_card.dart';
import '../components/default_dialog.dart';
import '../components/default_page.dart';
import '../components/default_text_field.dart';
import '../main/app.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final LoginAPI loginAPI = LoginAPI();

  @override
  Widget build(BuildContext context) {
    final usuarioController = TextEditingController();
    final senhaController = TextEditingController();
    final siteController = TextEditingController();
    final postoController = TextEditingController();
    final equipamentoController = TextEditingController();

    var codigoSite = '';

    return DefaultPage(
      title: "Login",
      children: [
        DefaultCard(
          child: Center(
            child: SizedBox(
              width: 400,
              child: ListView(
                shrinkWrap: true,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Image.asset(
                      "assets/logo.png",
                      color: Colors.black,
                      width: 400,
                    ),
                  ),
                  const SizedBox(height: 48),
                  DefaultTextField(
                    "Usuario",
                    usuarioController,
                  ),
                  DefaultTextField(
                    "Senha",
                    senhaController,
                    isSecret: true,
                  ),
                  const SizedBox(height: 24),
                  DefaultTextField(
                    "Site",
                    siteController,
                    suffixIcon: IconButton(
                      onPressed: () async {
                        final result = await showList<InfoSite>(
                          context: context,
                          title: 'Sites',
                          loadList: () => loginAPI.getSites(),
                          showItem: (item) {
                            return Column(children: [
                              ListTile(
                                title: Text('${item.codigo} - ${item.nome}'),
                              ),
                              const Divider(),
                            ]);
                          },
                        );
                        codigoSite = result!.codigo;
                        siteController.text = result.nome;
                      },
                      icon: const Icon(
                        Icons.arrow_drop_down,
                      ),
                    ),
                  ),
                  DefaultTextField(
                    "Posto",
                    postoController,
                    suffixIcon: IconButton(
                      onPressed: () async {
                        final result = await showList<InfoPosto>(
                          context: context,
                          title: 'Postos',
                          loadList: () => loginAPI.getPostos(
                            codigoSite,
                            usuarioController.text,
                          ),
                          showItem: (item) {
                            return Column(children: [
                              ListTile(
                                title: Text('${item.codigo} - ${item.nome}'),
                              ),
                              Divider(),
                            ]);
                          },
                        );
                        postoController.text = result!.codigo;
                      },
                      icon: const Icon(
                        Icons.arrow_drop_down,
                      ),
                    ),
                  ),
                  DefaultTextField(
                    "Equipamento",
                    equipamentoController,
                    suffixIcon: IconButton(
                      onPressed: () async {
                        final result = await showList<InfoEquipamento>(
                          context: context,
                          title: 'Equipamentos',
                          loadList: () => loginAPI.getEquipamentos(
                            codigoSite,
                            usuarioController.text,
                          ),
                          showItem: (item) {
                            return Column(children: [
                              ListTile(
                                title: Text('${item.codigo} - ${item.nome}'),
                              ),
                              const Divider(),
                            ]);
                          },
                        );
                        equipamentoController.text = result!.codigo;
                      },
                      icon: const Icon(
                        Icons.arrow_drop_down,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  DefaultButton(
                    label: "Entrar",
                    onPressed: () async {
                      final ip = await SANetwork.ip;
                      try {
                        final infoLogin = await loginAPI.login(
                          usuario: usuarioController.text,
                          senha: senhaController.text,
                          site: codigoSite,
                          posto: postoController.text,
                          equipamento: equipamentoController.text,
                          ip: ip,
                        );

                        final infoSAGA = await loginAPI.getInfoSAGA();
                        final infoConfigSite =
                            await loginAPI.getConfigSite(infoLogin.idcSite);

                        await App.start(infoSAGA, infoLogin, infoConfigSite);

                        Get.offAllNamed(PagesRoutes.convocacao);
                      } catch (_) {
                        await showResult(context);
                      }
                    },
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
