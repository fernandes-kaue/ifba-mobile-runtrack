import 'package:flutter/material.dart';
import 'package:runtrack/usuario.dart';

enum EmExibicao { telaTreinos, telaDetalhes, telaNovoTreino, telaLogin }

class GerenciadorEstado extends ChangeNotifier {
  EmExibicao _exibicao = EmExibicao.telaTreinos;
  EmExibicao get exibicao => _exibicao;

  int _idTreino = -1;
  int get idTreino => _idTreino;

  Usuario? _usuario;
  Usuario? get usuario => _usuario;

  final List<dynamic> _treinos = [];
  List<dynamic> get treinos => _treinos;

  void inicializarTreinos(List<dynamic> lista) {
    if (_treinos.isEmpty) {
      _treinos.addAll(lista);
    }
  }

  void adicionarTreino(dynamic novoTreino) {
    _treinos.insert(0, novoTreino);
    _exibicao = EmExibicao.telaTreinos;
    notifyListeners();
  }

  void exibirTreinos() {
    _exibicao = EmExibicao.telaTreinos;

    notifyListeners();
  }

  void exibirDetalhes(int idTreino) {
    _exibicao = EmExibicao.telaDetalhes;
    _idTreino = idTreino;

    notifyListeners();
  }

  void exibirNovoTreino() {
    _exibicao = EmExibicao.telaNovoTreino;

    notifyListeners();
  }

  void exibirLogin() {
    _exibicao = EmExibicao.telaLogin;

    notifyListeners();
  }

  void login(Usuario? usuario) {
    _usuario = usuario;
    notifyListeners();
  }

  void logout() {
    _usuario = null;
    notifyListeners();
  }
}

late GerenciadorEstado estadoApp;
