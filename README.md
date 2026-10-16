# 🏃 RunTrack — Gerenciador de Treinos de Corrida

> **Disciplina:** Programação Móvel  
> **Professor:** Luis Paulo da Silva Carvalho  
> **Aluno:** Kauê Santos Fernandes  
> **Instituição:** Instituto Federal da Bahia (IFBA) — Campus Vitória da Conquista  
> **Tema Aprovado:** ID 14 — RunTrack  

---

## 📹 Vídeo de Apresentação e Demonstração
- **Link do Vídeo (máx. 3 minutos):** [Clique aqui para assistir ao vídeo no YouTube / Google Drive](https://link-do-seu-video-aqui)

---

## 📖 Sobre o Projeto
O **RunTrack** é um aplicativo mobile desenvolvido em **Flutter e Dart** para acompanhamento, visualização e registro de treinos de corrida de rua. 

O projeto adota estritamente a arquitetura e convenções canônicas trabalhadas em aula (projeto de referência *Marcas*), estruturado para atender com rigor a todos os requisitos da **Avaliação I (Front-End)** da disciplina e preparando a base para a futura integração com API REST na **Avaliação II (Back-End)**.

---

## 🎯 Atendimento aos Requisitos da Avaliação

| Requisito | Como o RunTrack implementa |
| :--- | :--- |
| **Mínimo de 2 telas com listagem** | Implementa 3 telas integradas: **Treinos (Grid de treinos com busca)**, **Detalhes do Treino (Carrossel, métricas e comentários com Dismissible)** e **Registrar Novo Treino (Formulário com cálculo de pace)**. |
| **Login e Logoff (Regra 12)** | Autenticação mockada via `Autenticador` com controle de sessão no AppBar e feedback através do pacote `toast`. |
| **Modo Visitante vs. Logado (Regra 12)** | **Visitante:** pode navegar livremente pelo feed público de treinos, realizar buscas textuais, inspecionar detalhes completos e compartilhar treinos.<br>**Logado:** pode curtir treinos com atualização reativa do contador, publicar comentários, excluir seus próprios comentários via gesto de arrastar (`Dismissible` com confirmação) e cadastrar novos treinos via FloatingActionButton. |
| **Manipulação via JSON Estático** | Carga inicial e consumo dinâmico a partir de `recursos/jsons/treinos.json` e `recursos/jsons/comentarios.json` via `rootBundle` e `json.decode`. |
| **Tema Exclusivo** | Tema esportivo original e exclusivo focado em treinos de corrida e bem-estar (Tema ID 14 aprovado). |

---

## 📱 Estrutura de Telas e Componentes

1. **Treinos (`lib/telas/treinos.dart`)**
   - Campo de busca na AppBar para filtragem dinâmica por título de treino ou nome de atleta.
   - Botão de Login / Logout no canto superior direito com notificações via `Toast`.
   - Grid de treinos responsivo com atualização via `RefreshIndicator` e paginação com `ScrollController`.
   - Botão de ação flutuante (`FloatingActionButton`) para cadastrar novo treino (exibido para atletas autenticados).
2. **Detalhes do Treino (`lib/telas/detalhes.dart`)**
   - AppBar com avatar e identificação do atleta e ação de retorno ao feed.
   - Carrossel de fotos do treino com `PageView.builder` e indicador de páginas `PageViewDotIndicator`.
   - Controles de interação (`ControlesUsuario`) com botão de curtir (coração) e compartilhamento nativo via `share_plus`.
   - Cartão com métricas completas: distância (km), duração (min), ritmo médio (*pace*), altimetria (m) e contagem de curtidas.
   - Seção de comentários da comunidade com suporte a `Dismissible` para exclusão de comentários do próprio usuário com diálogo de confirmação (`AlertDialog`).
   - Campo para inserção de novo comentário (visível para usuários autenticados).
3. **Registrar Novo Treino (`lib/telas/novo_treino.dart`)**
   - Formulário com validação de campos obrigatórios (título, categoria, distância e tempo).
   - Cálculo automático do ritmo médio (*pace* em min/km) em tempo real à medida que o atleta preenche as métricas.
   - Retorno imediato ao feed com confirmação via `Toast`.
4. **Identificação e Perfil do Atleta (`lib/telas/login.dart`)**
   - Formulário de login com campos para e-mail e senha, validação de campos e atalho para preenchimento de conta de teste.
   - Opção para continuar navegando como visitante.
   - Quando autenticado, exibe o perfil do atleta (avatar, nome, e-mail, resumo de treinos registrados e botão de logoff).

---

## 📂 Arquitetura do Código-Fonte

A arquitetura do projeto segue o modelo canônico apresentado em aula:

```
PROJETO/
├── recursos/
│   ├── jsons/
│   │   ├── treinos.json               # Base estática de treinos de corrida
│   │   └── comentarios.json           # Base estática de comentários da comunidade
│   └── imagens/
│       ├── avatar.png                 # Foto de perfil padrão dos atletas
│       └── treino.jpeg                # Foto ilustrativa dos treinos de corrida
├── lib/
│   ├── main.dart                      # Ponto de entrada, ChangeNotifierProvider e roteamento
│   ├── autenticador.dart              # Camada de autenticação mockada (login, logout, recuperarUsuario)
│   ├── usuario.dart                   # Entidade Usuario (nome, e-mail)
│   ├── gerenciador_estado.dart        # GerenciadorEstado (ChangeNotifier, EmExibicao, estadoApp)
│   ├── componentes/
│   │   ├── cartao_treino.dart         # Card de exibição resumida do treino no grid
│   │   ├── cartao_detalhes_treino.dart# Card com métricas detalhadas (km, tempo, pace, altimetria)
│   │   ├── cartao_comentario.dart     # Card com comentário, autor e data formatada
│   │   └── controles_usuario.dart     # Botões de curtir (coração) e compartilhar (share_plus)
│   └── telas/
│       ├── treinos.dart               # Tela de feed com busca em tempo real, grid e atalho para login/perfil
│       ├── detalhes.dart              # Tela com carrossel de fotos, métricas, comentários e Dismissible para exclusão
│       ├── login.dart                 # Tela de login com credenciais de atleta e perfil do usuário
│       └── novo_treino.dart           # Tela de cadastro de novo treino com cálculo de pace automático
└── test/
    └── widget_test.dart               # Smoke test de inicialização do aplicativo
```

---

## 🚀 Como Executar o Projeto

### Pré-requisitos:
- Flutter SDK $\ge$ 3.13.0 instalado e configurado no PATH
- Emulador Android, dispositivo conectado ou suporte a Desktop Linux configurado

### Passos:
1. Obtenha as dependências:
   ```bash
   flutter pub get
   ```

2. Execute o aplicativo:
   ```bash
   flutter run
   ```
   *(Ou execute no desktop Linux com `flutter run -d linux`)*
