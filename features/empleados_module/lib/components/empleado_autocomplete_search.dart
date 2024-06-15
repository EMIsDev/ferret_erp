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
    return Autocomplete<String>(
      initialValue: selectedTrabajador.isNotEmpty
          ? TextEditingValue(
              text: listaEmpleados.firstWhere(
                  (element) => element['id'] == selectedTrabajador)['nombre'])
          : null,
      fieldViewBuilder:
          ((context, textEditingController, focusNode, onFieldSubmitted) =>
              TextFormField(
                controller: textEditingController,
                focusNode: focusNode,
                onFieldSubmitted: (String value) => onFieldSubmitted.call(),
                decoration: const InputDecoration(
                  hintText: 'Buscar Empleado...',
                ),
              )),
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
          (Map<String, dynamic> empleado) => empleado['nombre'] == selection,
          orElse: () => {}, // si no encuentra nada, devuelve un Map vacío
        );
        refreshNotifier(selectedEmpleado); // devolver map del empleado
      },
    );
  }
}
/*
DropdownButtonFormField<Map<String, dynamic>>(
      hint: const Text('Seleccione un trabajador'),
      value: selectedTrabajador != ''
          ? listaEmpleados
              .firstWhere((element) => element['id'] == selectedTrabajador)
          : null,
      items: listaEmpleados
          .map<DropdownMenuItem<Map<String, dynamic>>>(
              (empleado) => DropdownMenuItem<Map<String, dynamic>>(
                    value: empleado,
                    child: Text(empleado['nombre']),
                  ))
          .toList(),
      onChanged: (value) {
        refreshNotifier(value!);
      },
    ); */