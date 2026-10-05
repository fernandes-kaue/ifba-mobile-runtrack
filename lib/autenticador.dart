import 'package:runtrack/usuario.dart';

class Autenticador {
  static Future<Usuario?> login() async {
    return Usuario("Kauê Fernandes", "kaue@runtrack.com");
  }

  static Future<Usuario?> recuperarUsuario() async {
    return Usuario("Kauê Fernandes", "kaue@runtrack.com");
  }

  static Future<void> logout() async {
    //
  }
}
