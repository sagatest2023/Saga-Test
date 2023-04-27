import 'package:flutter/material.dart';

Future<T?> showList<T>({
  required BuildContext context,
  required String title,
  List<T>? list,
  Future<List<T>> Function()? loadList,
  required Widget Function(T item) showItem,
  bool useFullScreen = false,
  bool canSelect = true, // lista para selecionar ou apenas consultar???
  bool canCancel = false, // se exibe botão Cancelar...
  String noItemsMessage = 'Não há nenhum item',
}) async {
  assert(list != null || loadList != null);

  list ??= await loadList!();

  final listView = list.isEmpty
      ? Center(child: Text(noItemsMessage))
      : ListView.builder(
          itemCount: list.length,
          itemBuilder: (BuildContext context, int index) {
            final item = list![index];
            return InkWell(
              child: showItem(item),
              onTap: () => canSelect ? Navigator.pop(context, item) : null,
            );
          },
        );

  final page = useFullScreen
      ? Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: list.isEmpty || !canSelect,
            title: Text(title),
          ),
          body: listView,
        )
      : AlertDialog(
          title: Text(title),
          content: SizedBox(
            height: MediaQuery.of(context).size.height * 0.5,
            width: MediaQuery.of(context).size.width * 0.5,
            child: listView,
          ),
          actions: [
            if (canCancel)
              ElevatedButton(
                child: const Text('Cancelar'),
                onPressed: () => Navigator.pop(context, null),
              )
          ],
        );

  final result = await showDialog<T>(
    context: context,
    builder: (context) => page,
    barrierDismissible: true,
  );

  // se não permite cancelar, NÃO PODE retornar NULL!!!
  // if (result == null && !canCancel) abort();

  return result;
}
