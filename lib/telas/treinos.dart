import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:runtrack/componentes/cartao_treino.dart';
import 'package:runtrack/gerenciador_estado.dart';
import 'package:toast/toast.dart';

class Treinos extends StatefulWidget {
  const Treinos({super.key});

  @override
  State<StatefulWidget> createState() => _TreinosState();
}

class _TreinosState extends State<Treinos> {
  List<dynamic> _treinos = [];
  bool _carregandoTreinos = false;
  String _filtro = "";

  final ScrollController _controladorListaTreinos = ScrollController();
  final TextEditingController _controladorFiltro = TextEditingController();

  _TreinosState() {
    _controladorListaTreinos.addListener(() {
      if (_controladorListaTreinos.position.pixels ==
          _controladorListaTreinos.position.maxScrollExtent) {
        _carregarTreinos();
      }
    });
  }

  @override
  void initState() {
    super.initState();

    ToastContext().init(context);

    _carregarTreinos();
  }

  Future<List<dynamic>> _acessarTreinos() async {
    final String conteudo = await rootBundle.loadString(
      "recursos/jsons/treinos.json",
    );
    final dynamic dicionario = await json.decode(conteudo);

    return dicionario["treinos"];
  }

  void _carregarTreinos() {
    setState(() {
      _carregandoTreinos = true;
    });

    if (estadoApp.treinos.isNotEmpty) {
      _aplicarTreinosNaLista(estadoApp.treinos);
      return;
    }

    _acessarTreinos().then((treinos) async {
      estadoApp.inicializarTreinos(treinos);
      _aplicarTreinosNaLista(estadoApp.treinos);
    });
  }

  void _aplicarTreinosNaLista(List<dynamic> listaFonte) {
    setState(() {
      if (_filtro.isNotEmpty) {
        _treinos = listaFonte
            .where(
              (t) =>
                  t["workout"]["name"]
                      .toString()
                      .toLowerCase()
                      .contains(_filtro.toLowerCase()) ||
                  t["athlete"]["name"]
                      .toString()
                      .toLowerCase()
                      .contains(_filtro.toLowerCase()),
            )
            .toList();
      } else {
        _treinos = List<dynamic>.from(listaFonte);
      }

      _carregandoTreinos = false;
    });
  }

  Future<void> _atualizarTreinos() async {
    _treinos = [];
    _controladorFiltro.text = "";
    _filtro = "";

    _carregarTreinos();
  }

  void _aplicarFiltro(String filtro) {
    _filtro = filtro;
    _treinos.clear();

    _carregarTreinos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        actions: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(
                top: 8,
                bottom: 8,
                left: 10,
                right: 10,
              ),
              child: TextField(
                controller: _controladorFiltro,
                onSubmitted: (filtro) {
                  _aplicarFiltro(filtro);
                },
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 10),
                  border: OutlineInputBorder(),
                  hintText: "Buscar treinos...",
                  suffixIcon: Icon(Icons.search),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: estadoApp.usuario != null
                ? IconButton(
                    onPressed: () {
                      estadoApp.exibirLogin();
                    },
                    icon: const Icon(
                      Icons.account_circle,
                      color: Colors.blueAccent,
                      size: 28,
                    ),
                    tooltip: "Perfil do Atleta (${estadoApp.usuario!.nome})",
                  )
                : IconButton(
                    onPressed: () {
                      estadoApp.exibirLogin();
                    },
                    icon: const Icon(Icons.login),
                    tooltip: "Entrar como Atleta",
                  ),
          ),
        ],
      ),
      floatingActionButton: estadoApp.usuario != null
          ? FloatingActionButton.extended(
              onPressed: () {
                estadoApp.exibirNovoTreino();
              },
              icon: const Icon(Icons.add),
              label: const Text("Novo Treino"),
            )
          : null,
      body: _carregandoTreinos
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              color: Colors.blueAccent,
              onRefresh: () => _atualizarTreinos(),
              child: GridView.builder(
                controller: _controladorListaTreinos,
                scrollDirection: Axis.vertical,
                physics: const AlwaysScrollableScrollPhysics(),
                shrinkWrap: true,
                padding: const EdgeInsets.all(6),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 6,
                  mainAxisSpacing: 6,
                  childAspectRatio: 0.52,
                ),
                itemCount: _treinos.length,
                itemBuilder: (context, index) {
                  return CartaoTreino(treino: _treinos[index]);
                },
              ),
            ),
    );
  }
}
