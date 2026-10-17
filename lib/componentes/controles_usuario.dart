import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:toast/toast.dart';

class ControlesUsuario extends StatelessWidget {
  final dynamic treino;

  final bool usuarioLogado;
  final bool usuarioCurtiu;

  final void Function() onCurtiu;
  final void Function() onDescurtiu;

  const ControlesUsuario({
    super.key,
    required this.treino,
    required this.usuarioLogado,
    required this.usuarioCurtiu,
    required this.onCurtiu,
    required this.onDescurtiu,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        usuarioLogado
            ? IconButton(
                onPressed: () {
                  if (usuarioCurtiu) {
                    onDescurtiu();
                  } else {
                    onCurtiu();
                  }
                },
                icon: Icon(
                  usuarioCurtiu ? Icons.favorite : Icons.favorite_border,
                ),
                color: Colors.red,
                iconSize: 32,
              )
            : const SizedBox.shrink(),
        IconButton(
          onPressed: () {
            final workout = treino["workout"] ?? {};
            final texto =
                'Treino de corrida: ${workout["name"] ?? "Treino"} (${workout["distanceKm"] ?? 0} km em ${workout["durationMin"] ?? 0} min, ritmo de ${workout["pace"] ?? "N/A"}). Registrado no RunTrack!\n\nBaixe o RunTrack!';

            Clipboard.setData(ClipboardData(text: texto));
            Toast.show(
              "Compartilhando treino...",
              duration: Toast.lengthLong,
              gravity: Toast.bottom,
            );

            try {
              SharePlus.instance.share(
                ShareParams(title: "RunTrack", text: texto),
              );
            } catch (_) {}
          },
          icon: const Icon(Icons.share),
          color: Colors.blue,
          iconSize: 26,
        ),
      ],
    );
  }
}
