import 'package:flutter/material.dart';
import 'package:runtrack/autenticador.dart';
import 'package:runtrack/gerenciador_estado.dart';
import 'package:toast/toast.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final _controladorEmail = TextEditingController();
  final _controladorSenha = TextEditingController();
  bool _mostrarSenha = false;

  @override
  void initState() {
    super.initState();
    ToastContext().init(context);
  }

  @override
  void dispose() {
    _controladorEmail.dispose();
    _controladorSenha.dispose();
    super.dispose();
  }

  void _preencherContaTeste() {
    setState(() {
      _controladorEmail.text = "kaue@runtrack.com";
      _controladorSenha.text = "123456";
    });
  }

  void _submeterLogin() {
    if (_formKey.currentState!.validate()) {
      Autenticador.login(
        email: _controladorEmail.text.trim(),
        nome: "Kauê Fernandes",
      ).then((usuario) {
        if (!mounted) return;
        setState(() {
          estadoApp.login(usuario);
        });

        Toast.show(
          "Conectado como ${usuario?.nome}",
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
        );

        estadoApp.exibirTreinos();
      });
    }
  }

  void _realizarLogout() {
    Autenticador.logout().then((_) {
      if (!mounted) return;
      setState(() {
        estadoApp.logout();
      });

      Toast.show(
        "Você foi desconectado com sucesso",
        duration: Toast.lengthLong,
        gravity: Toast.bottom,
      );

      estadoApp.exibirTreinos();
    });
  }

  Widget _buildFormularioLogin() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Icon(Icons.directions_run, size: 64, color: Colors.blueAccent),
          const SizedBox(height: 12),
          const Center(
            child: Text(
              "Acesse sua Conta de Atleta",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 6),
          const Center(
            child: Text(
              "Identifique-se para curtir, comentar e registrar treinos",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: Colors.black54),
            ),
          ),
          const SizedBox(height: 24),
          TextFormField(
            controller: _controladorEmail,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              labelText: "E-mail do Atleta",
              hintText: "exemplo@runtrack.com",
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.email_outlined),
            ),
            validator: (valor) {
              if (valor == null || valor.trim().isEmpty) {
                return "Informe seu e-mail";
              }
              return null;
            },
          ),
          const SizedBox(height: 14),
          TextFormField(
            controller: _controladorSenha,
            obscureText: !_mostrarSenha,
            decoration: InputDecoration(
              labelText: "Senha de Acesso",
              border: const OutlineInputBorder(),
              prefixIcon: const Icon(Icons.lock_outline),
              suffixIcon: IconButton(
                icon: Icon(
                  _mostrarSenha ? Icons.visibility_off : Icons.visibility,
                ),
                onPressed: () {
                  setState(() {
                    _mostrarSenha = !_mostrarSenha;
                  });
                },
              ),
            ),
            validator: (valor) {
              if (valor == null || valor.isEmpty) {
                return "Informe sua senha";
              }
              return null;
            },
          ),
          const SizedBox(height: 14),
          OutlinedButton.icon(
            onPressed: _preencherContaTeste,
            icon: const Icon(Icons.auto_fix_high, size: 18),
            label: const Text("Preencher Credenciais de Teste"),
          ),
          const SizedBox(height: 14),
          ElevatedButton(
            onPressed: _submeterLogin,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              backgroundColor: Colors.blueAccent,
              foregroundColor: Colors.white,
            ),
            child: const Text(
              "Entrar como Atleta",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 10),
          TextButton(
            onPressed: () {
              estadoApp.exibirTreinos();
            },
            child: const Text("Continuar navegando como Visitante"),
          ),
        ],
      ),
    );
  }

  Widget _buildPerfilLogado() {
    final usuario = estadoApp.usuario!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 20),
        Center(
          child: Image.asset("recursos/imagens/avatar.png", width: 90),
        ),
        const SizedBox(height: 14),
        Center(
          child: Text(
            usuario.nome,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 4),
        Center(
          child: Text(
            usuario.email,
            style: const TextStyle(fontSize: 14, color: Colors.black54),
          ),
        ),
        const SizedBox(height: 24),
        Card(
          elevation: 1,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Status da Conta:",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        "Atleta Conectado",
                        style: TextStyle(
                          color: Colors.green.shade900,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
                const Divider(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Treinos Registrados na Sessão:"),
                    Text(
                      "${estadoApp.treinos.length}",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        ElevatedButton.icon(
          onPressed: () {
            estadoApp.exibirTreinos();
          },
          icon: const Icon(Icons.arrow_back),
          label: const Text("Voltar para Treinos"),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 14),
          ),
        ),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: _realizarLogout,
          icon: const Icon(Icons.logout, color: Colors.red),
          label: const Text(
            "Desconectar (Sair da Conta)",
            style: TextStyle(color: Colors.red),
          ),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 14),
            side: const BorderSide(color: Colors.red),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLogado = estadoApp.usuario != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isLogado ? "Perfil do Atleta" : "Identificação do Atleta"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            estadoApp.exibirTreinos();
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: isLogado ? _buildPerfilLogado() : _buildFormularioLogin(),
      ),
    );
  }
}
