import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class AgregarTrabajoForm extends StatefulWidget {
  const AgregarTrabajoForm({super.key});

  @override
  State<AgregarTrabajoForm> createState() => _AgregarTrabajoFormState();
}

class _AgregarTrabajoFormState extends State<AgregarTrabajoForm> {
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return Flexible(
        child: SingleChildScrollView(
      child: FormBuilder(
        key: _formKey,
        child: Column(
          children: [
            FormBuilderTextField(
              name: 'descripcion',
              decoration: const InputDecoration(labelText: 'Descripción'),
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(),
              ]),
            ),
            const SizedBox(height: 10),
            FormBuilderDateTimePicker(
              name: 'inicio_trabajo',
              firstDate: DateTime(1970),
              lastDate: DateTime(2100),
              initialEntryMode: DatePickerEntryMode.input,
              decoration: const InputDecoration(
                  labelText: 'Inicio Trabajo',
                  icon: Icon(Icons.calendar_today)),
              validator: FormBuilderValidators.compose(
                  [FormBuilderValidators.required()]),
            ),
            FormBuilderDateTimePicker(
              name: 'fin_trabajo',
              initialDate: DateTime.now(),
              firstDate: DateTime(1970),
              lastDate: DateTime(2100),
              inputType: InputType.both,
              decoration: const InputDecoration(
                  labelText: 'Fin Trabajo', icon: Icon(Icons.calendar_today)),
              validator: FormBuilderValidators.compose(
                  [FormBuilderValidators.required()]),
            ),
            const SizedBox(height: 10),
            MaterialButton(
              color: Theme.of(context).colorScheme.secondary,
              onPressed: () {
                _formKey.currentState?.saveAndValidate();
                debugPrint(_formKey.currentState?.value.toString());

                _formKey.currentState?.validate();
                debugPrint(_formKey.currentState?.instantValue.toString());
              },
              child: const Text('Login'),
            )
          ],
        ),
      ),
    ));
  }
}
