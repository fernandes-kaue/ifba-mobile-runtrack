import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:page_view_dot_indicator/page_view_dot_indicator.dart';
import 'package:runtrack/componentes/cartao_comentario.dart';
import 'package:runtrack/componentes/cartao_detalhes_treino.dart';
import 'package:runtrack/componentes/controles_usuario.dart';
import 'package:runtrack/gerenciador_estado.dart';
import 'package:toast/toast.dart';

class Detalhes extends StatefulWidget {
  const Detalhes({super.key});

  @override
  State<StatefulWidget> createState() {
    return _DetalhesState();
  }
}

class _DetalhesState extends State<Detalhes> {
  dynamic _treino;

  List<dynamic> _comentarios = [];
  bool _carregandoComentarios = false;

  bool _curtiu = false;

  final TextEditingController _controladorNovoComentario =
      TextEditingController();
  final ScrollController _controladorListaComentarios = ScrollController();

  late PageController _controladorSlides;
  late int _slideSelecionado;

  @override
  void initState() {
    super.initState();

    ToastContext().init(context);

    _iniciarSlides();
    _carregarTreino();
  }

  void _iniciarSlides() {
    _slideSelecionado = 0;
    _controladorSlides = PageController(initialPage: _slideSelecionado);
  }

  Future<dynamic> _acessarTreino(int idTreino) async {
    final String conteudo = await rootBundle.loadString(
      "recursos/jsons/treinos.json",
    );
    final dynamic dicionario = await json.decode(conteudo);

    final treino = dicionario["treinos"].firstWhere(
      (t) => t["_id"] == idTreino,
      orElse: () => dicionario["treinos"].first,
    );

    return treino;
  }

  void _carregarTreino() {
    _acessarTreino(estadoApp.idTreino).then((treino) {
      if (!mounted) return;
      setState(() {
        _treino = treino;
      });
      _carregarComentarios();
    });
  }

  Future<List<dynamic>> _acessarComentarios() async {
    final String conteudo = await rootBundle.loadString(
      "recursos/jsons/comentarios.json",
    );
    final dynamic dicionario = await json.decode(conteudo);

    return dicionario["comentarios"];
  }

  void _carregarComentarios() {
    if (_treino == null) return;
    setState(() {
      _carregandoComentarios = true;
    });

    _acessarComentarios().then((comentarios) {
      if (!mounted) return;
      setState(() {
        _comentarios = comentarios
            .where(
              (c) =>
                  c["workoutId"] == _treino["_id"] ||
                  c["productId"] == _treino["_id"],
            )
            .toList();

        _carregandoComentarios = false;
      });
    });
  }

  Widget _exibirMensagemComentariosInexistentes() {
    return const Expanded(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.comment, size: 26, color: Colors.grey),
            SizedBox(height: 6),
            Text(
              "Não existem comentários ainda",
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _exibirComentarios() {
    return _carregandoComentarios
        ? const Center(child: CircularProgressIndicator())
        : Expanded(
            child: ListView.builder(
              controller: _controladorListaComentarios,
              scrollDirection: Axis.vertical,
              physics: const AlwaysScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: _comentarios.length,
              itemBuilder: (context, index) {
                final comentario = _comentarios[index];
                bool usuarioLogadoComentou =
                    estadoApp.usuario != null &&
                    estadoApp.usuario!.email == comentario["user"]["email"];

                return SizedBox(
                  height: 90,
                  child: Dismissible(
                    key: UniqueKey(),
                    direction: usuarioLogadoComentou
                        ? DismissDirection.endToStart
                        : DismissDirection.none,
                    background: Container(
                      alignment: Alignment.centerRight,
                      color: Colors.red[50],
                      child: const Padding(
                        padding: EdgeInsets.only(right: 16.0),
                        child: Icon(Icons.delete, color: Colors.red),
                      ),
                    ),
                    child: CartaoComentario(
                      comentario: comentario,
                      somenteLeitura: !usuarioLogadoComentou,
                    ),
                    confirmDismiss: (direction) async {
                      return await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            content: const Text(
                              "Deseja apagar o comentário?",
                            ),
                            actions: [
                              TextButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(false),
                                child: const Text("NÃO"),
                              ),
                              TextButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(true),
                                child: const Text("SIM"),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    onDismissed: (direction) {
                      setState(() {
                        _comentarios.removeAt(index);
                      });
                      Toast.show(
                        "Comentário removido",
                        duration: Toast.lengthLong,
                        gravity: Toast.bottom,
                      );
                    },
                  ),
                );
              },
            ),
          );
  }

  void _adicionarComentario(String conteudo) {
    if (conteudo.trim().isEmpty) return;

    setState(() {
      _comentarios.insert(0, {
        "_id": _comentarios.length + 1,
        "workoutId": _treino["_id"],
        "user": {
          "userId": "1",
          "email": estadoApp.usuario?.email,
          "name": estadoApp.usuario?.nome,
        },
        "datetime": DateTime.now().toIso8601String(),
        "content": conteudo.trim(),
      });
      _controladorNovoComentario.clear();
    });

    Toast.show(
      "Comentário adicionado",
      duration: Toast.lengthLong,
      gravity: Toast.bottom,
    );
  }

  void _onCurtiuDescurtiu() {
    setState(() {
      _curtiu = !_curtiu;
      if (_curtiu) {
        _treino["likes"] = (_treino["likes"] ?? 0) + 1;
      } else {
        _treino["likes"] = (_treino["likes"] ?? 1) - 1;
      }
    });

    Toast.show(
      _curtiu ? "Obrigado pela avaliação!" : "Avaliação removida",
      duration: Toast.lengthLong,
      gravity: Toast.bottom,
    );
  }

  Widget _exibirTreino() {
    bool usuarioLogado = estadoApp.usuario != null;
    final athlete = _treino["athlete"] ?? {};

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        titleSpacing: 0,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Row(
          children: [
            Image.asset("recursos/imagens/avatar.png", width: 34),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                athlete["name"] ?? "Atleta",
                style: const TextStyle(fontSize: 16),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            IconButton(
              onPressed: () {
                estadoApp.exibirTreinos();
              },
              icon: const Icon(Icons.arrow_back),
              tooltip: "Voltar para treinos",
            ),
          ],
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 220,
            child: Stack(
              children: [
                PageView.builder(
                  itemCount: 3,
                  controller: _controladorSlides,
                  onPageChanged: (slide) {
                    setState(() {
                      _slideSelecionado = slide;
                    });
                  },
                  itemBuilder: (context, pagePosition) {
                    return Image.asset(
                      "recursos/imagens/treino.jpeg",
                      fit: BoxFit.cover,
                      width: double.infinity,
                    );
                  },
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.85),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: ControlesUsuario(
                      treino: _treino,
                      usuarioCurtiu: _curtiu,
                      usuarioLogado: usuarioLogado,
                      onCurtiu: _onCurtiuDescurtiu,
                      onDescurtiu: _onCurtiuDescurtiu,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: PageViewDotIndicator(
              currentItem: _slideSelecionado,
              count: 3,
              unselectedColor: Colors.black26,
              selectedColor: Colors.blueAccent,
              duration: const Duration(milliseconds: 200),
              boxShape: BoxShape.circle,
            ),
          ),
          CartaoDetalhesTreino(treino: _treino),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            child: Text(
              "Comentários da Comunidade",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
          ),
          usuarioLogado
              ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  child: TextField(
                    controller: _controladorNovoComentario,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.black45,
                          width: 1.0,
                        ),
                      ),
                      border: const OutlineInputBorder(),
                      hintStyle: const TextStyle(fontSize: 13),
                      hintText: 'Escreva um comentário sobre o treino...',
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.send, color: Colors.blueAccent),
                        onPressed: () {
                          _adicionarComentario(_controladorNovoComentario.text);
                        },
                      ),
                    ),
                  ),
                )
              : const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  child: Text(
                    "Conecte-se como atleta para comentar ou curtir o treino.",
                    style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
                  ),
                ),
          _comentarios.isNotEmpty
              ? _exibirComentarios()
              : _exibirMensagemComentariosInexistentes(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget detalhes = const SizedBox.expand(
      child: Center(child: CircularProgressIndicator()),
    );

    if (_treino != null) {
      detalhes = _exibirTreino();
    }

    return detalhes;
  }
}
