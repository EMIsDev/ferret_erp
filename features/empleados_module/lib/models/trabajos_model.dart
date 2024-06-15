class Trabajo {
  String descripcion;
  String inicioTrabajo;
  String finalTrabajo;
  double horasTrabajadas;
  String id;

  Trabajo({
    required this.descripcion,
    required this.finalTrabajo,
    required this.id,
    required this.inicioTrabajo,
    required this.horasTrabajadas,
  });

  factory Trabajo.empty() {
    return Trabajo(
      descripcion: '',
      inicioTrabajo: '',
      finalTrabajo: '',
      id: '',
      horasTrabajadas: 0.0,
    );
  }

  Trabajo.fromFirestoreJson(String docId, Map<String, dynamic> json)
      : descripcion = json['descripcion'] as String,
        inicioTrabajo = json['inicio_trabajo'] as String,
        finalTrabajo = json['final_trabajo'] as String,
        horasTrabajadas = json['horas_trabajadas'] ?? 0.0,
        id = docId;

  Trabajo.fromJson(Map<String, dynamic> json)
      : descripcion = json['descripcion'] as String,
        inicioTrabajo = json['inicio_trabajo'] as String,
        finalTrabajo = json['final_trabajo'] as String,
        horasTrabajadas = json['horas_trabajadas'] ?? 0.0,
        id = json['id'] ??
            ''; // id por defecto vacio porque podemos coger datos de un formulario por ejemplo sin id

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['descripcion'] = descripcion;
    data['inicio_trabajo'] = inicioTrabajo;
    data['final_trabajo'] = finalTrabajo;
    data['horas_trabajadas'] = horasTrabajadas;
    data['id'] = id;
    return data;
  }

  Map<String, dynamic> toJsonBD() {
    // version sin el id para almacenar en la bd de firebase sin repetir campos
    final Map<String, dynamic> data = <String, dynamic>{};
    data['descripcion'] = descripcion;
    data['inicio_trabajo'] = inicioTrabajo;
    data['final_trabajo'] = finalTrabajo;
    data['horas_trabajadas'] = horasTrabajadas;
    return data;
  }

  set setDescripcion(String value) {
    descripcion = value;
  }

  set setInicioTrabajo(String value) {
    inicioTrabajo = value;
  }

  set setFinalTrabajo(String value) {
    finalTrabajo = value;
  }

  set setHorasTrabajadas(double value) {
    horasTrabajadas = value;
  }

  set setId(String value) {
    this.id = value;
  }

  @override
  String toString() {
    return 'Trabajo{descripcion: $descripcion, inicioTrabajo: $inicioTrabajo, finalTrabajo: $finalTrabajo, horasTrabajadas: $horasTrabajadas, id: $id}';
  }
}
