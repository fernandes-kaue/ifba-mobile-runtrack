import 'package:flutter/material.dart';
import 'package:runtrack/gerenciador_estado.dart';
import 'package:toast/toast.dart';

class NovoTreino extends StatefulWidget {
  const NovoTreino({super.key});

  @override
  State<NovoTreino> createState() => _NovoTreinoState();
}

class _NovoTreinoState extends State<NovoTreino> {
  final _formKey = GlobalKey<FormState>();
  final _controladorNome = TextEditingController();
  final _controladorDescricao = TextEditingController();
  final _controladorDistancia = TextEditingController();
  final _controladorDuracao = TextEditingController();
  final _controladorAltimetria = TextEditingController();

  String _tipoSelecionado = "Longo";
  final List<String> _tiposTreino = [
    "Longo",
    "Intervalado",
    "Regenerativo",
    "Tempo Run",
    "Fartlek",
  ];

  @override
  void initState() {
    super.initState();
    ToastContext().init(context);
  }

  @override
  void dispose() {
    _controladorNome.dispose();
    _controladorDescricao.dispose();
    _controladorDistancia.dispose();
    _controladorDuracao.dispose();
    _controladorAltimetria.dispose();
    super.dispose();
  }

  String _calcularPace() {
    final dist = double.tryParse(_controladorDistancia.text.replaceAll(',', '.'));
    final dur = double.tryParse(_controladorDuracao.text);
    if (dist != null && dist > 0 && dur != null && dur > 0) {
      final paceDecimal = dur / dist;
      final minutos = paceDecimal.floor();
      final segundos = ((paceDecimal - minutos) * 60).round();
      return "$minutos:${segundos.toString().padLeft(2, '0')} min/km";
    }
    return "0:00 min/km";
  }

  void _salvarTreino() {
    if (_formKey.currentState!.validate()) {
      Toast.show(
        "Treino salvo com sucesso!",
        duration: Toast.lengthLong,
        gravity: Toast.bottom,
      );
      estadoApp.exibirTreinos();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Registrar Treino de Corrida"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            estadoApp.exibirTreinos();
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _controladorNome,
                decoration: const InputDecoration(
                  labelText: "Título do Treino",
                  hintText: "Ex: Rodagem de Terça na Orla",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.directions_run),
                ),
                validator: (valor) {
                  if (valor == null || valor.trim().isEmpty) {
                    return "Informe o título do treino";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: _tipoSelecionado,
                decoration: const InputDecoration(
                  labelText: "Tipo de Treino",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.category),
                ),
                items: _tiposTreino.map((tipo) {
                  return DropdownMenuItem(value: tipo, child: Text(tipo));
                }).toList(),
                onChanged: (novoTipo) {
                  if (novoTipo != null) {
                    setState(() {
                      _tipoSelecionado = novoTipo;
                    });
                  }
                },
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _controladorDistancia,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      decoration: const InputDecoration(
                        labelText: "Distância (km)",
                        hintText: "10.0",
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.straighten),
                      ),
                      onChanged: (_) => setState(() {}),
                      validator: (valor) {
                        if (valor == null || valor.isEmpty) {
                          return "Informe a distância";
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _controladorDuracao,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: "Duração (min)",
                        hintText: "50",
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.timer),
                      ),
                      onChanged: (_) => setState(() {}),
                      validator: (valor) {
                        if (valor == null || valor.isEmpty) {
                          return "Informe a duração";
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _controladorAltimetria,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Ganho de Altimetria (m, opcional)",
                  hintText: "45",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.terrain),
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue.withValues(alpha: 0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.speed, color: Colors.blueAccent),
                    const SizedBox(width: 8),
                    const Text(
                      "Ritmo Médio (Pace Estimado): ",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      _calcularPace(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _controladorDescricao,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: "Sensações e Observações",
                  hintText: "Descreva a sensação do treino, hidratação...",
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _salvarTreino,
                icon: const Icon(Icons.check),
                label: const Text(
                  "Salvar Treino",
                  style: TextStyle(fontSize: 16),
                ),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
