class Empleado {
  final int? id;
  final String nombre;
  final String? cargo;
  final String? email;
  final String? telefono;
  final int empresaId;
  final bool esactivo;

  Empleado({
    this.id,
    required this.nombre,
    this.cargo,
    this.email,
    this.telefono,
    required this.empresaId,
    this.esactivo = true,
  });

  factory Empleado.fromJson(Map<String, dynamic> json) => Empleado(
        id: json['id'],
        nombre: json['nombre'] ?? '',
        cargo: json['cargo'],
        email: json['email'],
        telefono: json['telefono'],
        empresaId: json['empresaId'] ?? 0,
        esactivo: json['esactivo'] ?? true,
      );

  Map<String, dynamic> toJson() => {
        "nombre": nombre,
        "cargo": cargo,
        "email": email,
        "telefono": telefono,
      };
}
