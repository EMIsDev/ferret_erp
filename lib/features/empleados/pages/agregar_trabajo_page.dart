import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AgregarTrabajoPage extends StatefulWidget {
  const AgregarTrabajoPage({super.key});
  @override
  State<AgregarTrabajoPage> createState() => _AgregarTrabajoPageState();
}

class _AgregarTrabajoPageState extends State<AgregarTrabajoPage> {
  final _formKey = GlobalKey<FormState>(); // Form key for validation
  final _descripcionController =
      TextEditingController(); // Controller for description
  DateTime _selectedDateInicio = DateTime.now(); // Initial selected date
  DateTime _horaInicio = DateTime.now(); // Initial time for work start
  DateTime _horaFinal =
      DateTime.now(); // Initial time for work endtial end date

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(16.0),
        children: <Widget>[
          TextFormField(
            decoration: const InputDecoration(labelText: 'Descripción'),
            controller: _descripcionController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor ingrese una descripción';
              }
              return null;
            },
          ),
          ListTile(
            title: Text(
                'Fecha Inicio: ${DateFormat('dd/MM/yyyy').format(_selectedDateInicio)}'),
            trailing: const Icon(Icons.calendar_today),
            onTap: () async {
              final selectedDate = await showDatePicker(
                context: context,
                initialDate: _selectedDateInicio,
                firstDate: DateTime.now().subtract(const Duration(days: 365)),
                lastDate: DateTime.now(),
                initialEntryMode: DatePickerEntryMode.input,
              );
              if (selectedDate != null) {
                setState(() {
                  _selectedDateInicio = selectedDate;
                });
              }
            },
          ),
          ListTile(
            title: Text(
                'Fecha Final: ${DateFormat('dd/MM/yyyy').format(_selectedDateInicio)}'),
            trailing: const Icon(Icons.calendar_today),
            onTap: () async {
              final selectedDate = await showDatePicker(
                context: context,
                initialDate: _selectedDateInicio,
                firstDate: DateTime.now().subtract(const Duration(days: 365)),
                lastDate: DateTime.now(),
                initialEntryMode: DatePickerEntryMode.input,
              );
              if (selectedDate != null) {
                setState(() {
                  _selectedDateInicio = selectedDate;
                });
              }
            },
          ),
          Row(
            children: [
              const Text('Hora Inicio:'),
              TextButton(
                onPressed: () async {
                  final selectedTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.fromDateTime(_horaInicio),
                    initialEntryMode: TimePickerEntryMode.input,
                  );
                  if (selectedTime != null) {
                    setState(() {
                      _horaInicio = DateTime(
                          _selectedDateInicio.year,
                          _selectedDateInicio.month,
                          _selectedDateInicio.day,
                          selectedTime.hour,
                          selectedTime.minute);
                    });
                  }
                },
                child: Text(
                    '${_horaInicio.hour.toString().padLeft(2, '0')}:${_horaInicio.minute.toString().padLeft(2, '0')}'),
              ),
            ],
          ),
          Row(
            children: [
              const Text('Hora Final:'),
              TextButton(
                onPressed: () async {
                  final selectedTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.fromDateTime(_horaFinal),
                    initialEntryMode: TimePickerEntryMode.input,
                  );
                  if (selectedTime != null) {
                    setState(() {
                      _horaFinal = DateTime(
                          _selectedDateInicio.year,
                          _selectedDateInicio.month,
                          _selectedDateInicio.day,
                          selectedTime.hour,
                          selectedTime.minute);
                    });
                  }
                },
                child: Text(
                    '${_horaFinal.hour.toString().padLeft(2, '0')}:${_horaFinal.minute.toString().padLeft(2, '0')}'),
              ),
            ],
          ),
          ElevatedButton(
            child: const Text('Guardar'),
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                // Calculate total hours using _horaFinal.difference(_horaInicio)
                // Perform saving logic using _descripcionController.text,
                // _selectedDateInicio, _horaInicio, and _horaFinal
              }
            },
          ),
        ],
      ),
    );
  }
}
