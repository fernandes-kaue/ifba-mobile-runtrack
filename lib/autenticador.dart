import 'package:runtrack/usuario.dart';

class Autenticador {
  static Future<Usuario?> login({String? email, String? nome}) async {
    return Usuario(
      nome ?? "Kauê Fernandes",
      email ?? "kaue@runtrack.com",
    );
  }

  static Future<Usuario?> recuperarUsuario() async {
    return Usuario("Kauê Fernandes", "kaue@runtrack.com");
  }

  static Future<void> logout() async {
    //
  }
}
