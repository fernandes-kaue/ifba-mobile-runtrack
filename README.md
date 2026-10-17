# 🏃 RunTrack — Gerenciador de Treinos de Corrida

> **Disciplina:** Programação Móvel (6º Semestre BSI)  
> **Professor:** Luis Paulo da Silva Carvalho  
> **Aluno:** Kauê Santos Fernandes  
> **Instituição:** Instituto Federal da Bahia (IFBA) — Campus Vitória da Conquista  
> **Tema Aprovado:** ID 14 — RunTrack (Acompanhamento e registro de treinos de corrida de rua)  
> **Repositório Oficial:** [https://github.com/fernandes-kaue/ifba-mobile-runtrack](https://github.com/fernandes-kaue/ifba-mobile-runtrack)  

---

## 📹 Vídeo de Apresentação e Demonstração
- **Link do Vídeo (máx. 3 minutos):** [Clique aqui para assistir ao vídeo no YouTube / Google Drive](https://link-do-seu-video-aqui)  

---

## 📖 Sobre o Aplicativo
O **RunTrack** é um aplicativo mobile desenvolvido em **Flutter e Dart** para acompanhamento, visualização e registro de treinos de corrida de rua. 

O projeto adota a arquitetura, convenções e organização canônicas trabalhadas pelo professor em sala de aula (projeto de referência *Marcas*), estruturado para atender com rigor a todos os requisitos da **Avaliação I (Front-End)** e preparando a base para a futura integração com API REST na **Avaliação II (Back-End)**.

---

## 🎯 Atendimento aos Requisitos do Edital

| Requisito do Edital | Como o RunTrack Implementa |
| :--- | :--- |
| **Mínimo de 2 telas com listagem (Item 11)** | Implementa **4 telas integradas**: **Treinos** (listagem em grid com busca), **Detalhes** (carrossel de fotos, estatísticas e listagem de comentários com exclusão via gesto), **Identificação e Perfil** (login com formulário e painel do atleta) e **Novo Treino** (cadastro com cálculo automático de ritmo). |
| **Login e Logoff Mockado (Itens 12 e 13)** | Implementado via classe `Autenticador` com tela dedicada de login contendo campos de e-mail e senha, botão de atalho para preenchimento de teste rápido, controle de sessão em memória (`Usuario`) e feedback visual com o pacote `toast`. |
| **Modo Visitante vs. Logado (Item 12)** | **Visitante:** pode navegar livremente pelo feed público de treinos, realizar buscas textuais, inspecionar detalhes completos e disparar o compartilhamento nativo via `share_plus`.<br>**Logado:** ganha acesso aos controles sociais (curtir treinos com contador dinâmico, publicar comentários e remover seus próprios comentários via `Dismissible`), além do cadastro de novos treinos via `FloatingActionButton`. |
| **Manipulação via JSON Estático (Item 14)** | Carga inicial e consumo dinâmico a partir dos arquivos locais `recursos/jsons/treinos.json` e `recursos/jsons/comentarios.json` através de `rootBundle` e `json.decode`, com persistência em memória durante a sessão. |
| **Tema Exclusivo (Item 4)** | Tema esportivo focado em treinos de corrida e bem-estar (Tema ID 14 homologado na planilha oficial), sem relação com produtos comerciais ou marcas. |
| **Entrega via Git (Item 15)** | Repositório estruturado no GitHub com histórico de commits granulares cobrindo todo o ciclo de desenvolvimento do projeto. |

---

## 🔑 Credenciais Mockadas para Avaliação Rápida

Na tela de **Identificação do Atleta**, é possível digitar manualmente ou acionar o botão **"Preencher Credenciais de Teste"**:
- **E-mail:** `kaue@runtrack.com`
- **Senha:** `123456`
- **Atleta associado:** Kauê Fernandes

---

## 📱 Telas e Componentes da Aplicação

### 1. Feed de Treinos (`lib/telas/treinos.dart`)
- **Barra Superior (AppBar):** Campo de busca textual em tempo real por título de treino ou atleta, e atalho para a tela de autenticação/perfil.
- **Grid de Treinos:** Cartões responsivos (`CartaoTreino`) com foto ilustrativa, avatar do atleta, distância (km), ritmo médio (*pace* em min/km), observações e contador de curtidas.
- **Interações:** Atualização dinâmica por gesto (`RefreshIndicator`) e paginação por rolagem via `ScrollController`.
- **Ação Rápida:** Botão flutuante (`FloatingActionButton`) para cadastrar novo treino (exibido para atletas autenticados).

### 2. Detalhes do Treino (`lib/telas/detalhes.dart`)
- **Carrossel de Fotos:** `PageView.builder` com fotos do percurso e indicador por pontos animado (`PageViewDotIndicator`).
- **Controles de Interação (`ControlesUsuario`):** Botão de curtir (coração reativo com alternância visual e contador) e botão de compartilhamento externo nativo via `share_plus`.
- **Cartão de Estatísticas (`CartaoDetalhesTreino`):** Quadro com distância, tempo de treino, ritmo médio (*pace*), ganho de altimetria acumulado e likes.
- **Seção de Comentários:** Listagem de avaliações da comunidade (`CartaoComentario`) com suporte a exclusão de comentários do próprio autor via gesto de arrastar (`Dismissible`) e diálogo de confirmação (`AlertDialog`). Campo de envio imediato para atletas logados.

### 3. Identificação e Perfil do Atleta (`lib/telas/login.dart`)
- **Modo Visitante (Formulário):** Entradas validadas para e-mail e senha, alternância de visibilidade da senha, botão de preenchimento automático para testes e link para continuar navegando como visitante.
- **Modo Autenticado (Perfil):** Exibição do avatar, nome, e-mail, resumo de treinos registrados na sessão e botão explícito de logoff / desconexão.

### 4. Cadastro de Novo Treino (`lib/telas/novo_treino.dart`)
- **Formulário com Validação:** Campos obrigatórios para título, tipo de treino (Longo, Intervalado, Regenerativo, Tempo Run, Fartlek), distância (km) e duração (minutos).
- **Cálculo de Ritmo em Tempo Real:** Cálculo dinâmico do *pace* médio (minutos e segundos por km) atualizado instantaneamente à medida que distância e tempo são informados.
- **Persistência em Memória:** Ao salvar, o novo treino é inserido no topo da lista global (`estadoApp.treinos`), atualizando o feed principal e ficando disponível para inspeção de detalhes.

---

## 📂 Arquitetura do Código-Fonte

A arquitetura do projeto segue o modelo canônico trabalhado em aula:

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
│       ├── detalhes.dart              # Tela com carrossel de fotos, métricas, comentários e Dismissible
│       ├── login.dart                 # Tela de identificação com credenciais de atleta e perfil
│       └── novo_treino.dart           # Formulário de cadastro de novo treino com cálculo de pace automático
└── test/
    └── widget_test.dart               # Smoke test de inicialização do aplicativo
```

---

## 📦 Pacotes e Dependências Utilizadas

- **`provider`:** Gerenciamento centralizado de estado reativo da aplicação.
- **`intl`:** Formatação amigável de datas e horários nos comentários.
- **`toast`:** Mensagens temporárias de feedback de ações (login, logout, comentários, cadastro).
- **`share_plus`:** Compartilhamento nativo de treinos com outros aplicativos.
- **`page_view_dot_indicator`:** Indicador visual em pontos para o carrossel de fotos.

---

## 🚀 Como Executar o Projeto

### Pré-requisitos
- Flutter SDK $\ge$ 3.13.0 instalado e configurado no PATH
- Emulador Android (Android SDK) configurado ou ambiente Desktop Linux

### Execução

1. Clone o repositório ou navegue até a pasta raiz:
   ```bash
   git clone https://github.com/fernandes-kaue/ifba-mobile-runtrack.git
   cd ifba-mobile-runtrack
   ```

2. Obtenha as dependências do projeto:
   ```bash
   flutter pub get
   ```

3. Execute a validação estática de código e os testes:
   ```bash
   flutter analyze
   flutter test
   ```

4. Execute o aplicativo no emulador ou dispositivo conectado:
   ```bash
   flutter run
   ```
   *(Ou execute diretamente no desktop Linux com `flutter run -d linux`)*
