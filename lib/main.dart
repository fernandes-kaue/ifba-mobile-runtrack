import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:runtrack/gerenciador_estado.dart';
import 'package:runtrack/telas/detalhes.dart';
import 'package:runtrack/telas/login.dart';
import 'package:runtrack/telas/novo_treino.dart';
import 'package:runtrack/telas/treinos.dart';

void main() {
  runApp(const RunTrack());
}

class ComportamentoRolagem extends MaterialScrollBehavior {
  const ComportamentoRolagem();

  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.trackpad,
        PointerDeviceKind.stylus,
      };
}

class RunTrack extends StatelessWidget {
  const RunTrack({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => GerenciadorEstado(),
      child: MaterialApp(
        title: 'RunTrack',
        debugShowCheckedModeBanner: false,
        scrollBehavior: const ComportamentoRolagem(),
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.blueAccent,
            brightness: Brightness.light,
          ),
        ),
        home: const TelaPrincipal(),
      ),
    );
  }
}

class TelaPrincipal extends StatefulWidget {
  const TelaPrincipal({super.key});

  @override
  State<TelaPrincipal> createState() => _TelaPrincipalState();
}

class _TelaPrincipalState extends State<TelaPrincipal> {
  @override
  Widget build(BuildContext context) {
    estadoApp = context.watch<GerenciadorEstado>();

    Widget tela = const SizedBox.shrink();
    if (estadoApp.exibicao == EmExibicao.telaTreinos) {
      tela = const Treinos();
    } else if (estadoApp.exibicao == EmExibicao.telaDetalhes) {
      tela = const Detalhes();
    } else if (estadoApp.exibicao == EmExibicao.telaNovoTreino) {
      tela = const NovoTreino();
    } else if (estadoApp.exibicao == EmExibicao.telaLogin) {
      tela = const Login();
    }

    return tela;
  }
}
