class Usuario {
  final int id;
  final String nombre;
  final String email;

  Usuario({required this.id, required this.nombre, required this.email});

  factory Usuario.fromJson(Map<String, dynamic> json) => Usuario(
        id: json['id'],
        nombre: json['nombre'] ?? '',
        email: json['email'] ?? '',
      );
}

/// Respuesta del backend al hacer login o registro: token + datos del usuario.
class AuthResult {
  final String token;
  final Usuario usuario;

  AuthResult({required this.token, required this.usuario});

  factory AuthResult.fromJson(Map<String, dynamic> json) => AuthResult(
        token: json['token'],
        usuario: Usuario.fromJson(json['usuario']),
      );
}
