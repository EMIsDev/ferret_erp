import 'package:flutter/material.dart';

class EmpleadoAutoCompleteSearch extends StatelessWidget {
  const EmpleadoAutoCompleteSearch({
    super.key,
    required this.listaEmpleados,
    required this.refreshNotifier,
    this.selectedTrabajador = '',
  });

  final String selectedTrabajador;
  final List<Map<String, dynamic>> listaEmpleados;
  final Function(dynamic) refreshNotifier;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Autocomplete<String>(
          initialValue: selectedTrabajador.isNotEmpty
              ? TextEditingValue(
                  text: listaEmpleados.firstWhere((element) =>
                      element['id'] == selectedTrabajador)['nombre'])
              : null,
          fieldViewBuilder:
              (context, textEditingController, focusNode, onFieldSubmitted) =>
                  TextFormField(
            controller: textEditingController,
            focusNode: focusNode,
            onFieldSubmitted: (String value) => onFieldSubmitted.call(),
            decoration: const InputDecoration(
              hintText: 'Buscar Empleado...',
            ),
          ),
          optionsViewBuilder: (context, onSelected, options) => Align(
            alignment: Alignment.topLeft,
            child: Material(
              child: SizedBox(
                width:
                    constraints.maxWidth, // Utiliza el ancho del campo de texto
                child: ListView(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  children: options
                      .map((e) => ListTile(
                            tileColor: Colors.grey.withOpacity(0.1),
                            onTap: () => onSelected(e),
                            title: Text(e),
                          ))
                      .toList(),
                ),
              ),
            ),
          ),
          optionsBuilder: (TextEditingValue textEditingValue) {
            if (textEditingValue.text == '') {
              return const Iterable<String>.empty();
            }
            return listaEmpleados
                .where((element) => element['nombre']
                    .toLowerCase()
                    .contains(textEditingValue.text.toLowerCase()))
                .map((e) => e['nombre'] as String);
          },
          onSelected: (String selection) {
            final selectedEmpleado = listaEmpleados.firstWhere(
              (Map<String, dynamic> empleado) =>
                  empleado['nombre'] == selection,
              orElse: () => {}, // si no encuentra nada, devuelve un Map vacío
            );
            refreshNotifier(selectedEmpleado); // devolver map del empleado
          },
        );
      },
    );
  }
}
