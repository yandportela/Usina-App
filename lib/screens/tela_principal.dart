import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_page.dart';

// Importações dos teus cadastros existentes
import 'cadastros/cadastro_indicador.dart';
import 'cadastros/cadastro_medicoes.dart';
import 'cadastros/cadastro_safra.dart';
import 'cadastros/cadastro_tipo_informacao.dart';
import 'cadastros/cadastro_unidade.dart';
import 'cadastros/cadastro_unidade_de_medida.dart';
import 'cadastros/cadastro_usuario.dart';

// Novas importações para os Indicadores e WebView
import '../models/indicador.dart';
import '../services/indicador_service.dart';
import 'indicadores_page.dart';
import 'indicador_webview.dart';

class TelaPrincipal extends StatefulWidget {
  const TelaPrincipal({super.key});

  @override
  State<TelaPrincipal> createState() => _TelaPrincipalState();
}

class _TelaPrincipalState extends State<TelaPrincipal> {
  bool cadastroAberto = false;

  // Variável que guarda a requisição HTTP (a lista de indicadores)
  late Future<List<Indicador>> indicadores;

  @override
  void initState() {
    super.initState();
    // Inicia a busca dos indicadores logo que a tela carrega
    indicadores = IndicadorService().listar();
  }

  // Função para recarregar a lista da API
  void atualizarIndicadores() {
    setState(() {
      indicadores = IndicadorService().listar();
    });
  }

  Future<void> sair() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('loginRealizado', false);
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  Widget montarMenu() {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        const DrawerHeader(
          child: Text(
            'Menu Principal',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ),

        ListTile(
          leading: const Icon(Icons.home),
          title: const Text('Inácio'),
          onTap: () {
            Navigator.pop(context);
          },
        ),

        // --- SUBMENU DE CADASTROS EXISTENTE ---
        ListTile(
          leading: const Icon(Icons.app_registration),
          title: const Text('Cadastro'),
          trailing: Icon(
            cadastroAberto ? Icons.expand_less : Icons.expand_more,
          ),
          onTap: () {
            setState(() {
              cadastroAberto = !cadastroAberto;
            });
          },
        ),

        if (cadastroAberto) ...[
          ListTile(
            leading: const Icon(Icons.chevron_right),
            title: const Text('Safra'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) => const CadastroSafraPage()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.chevron_right),
            title: const Text('Unidade'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) => const CadastroUnidadePage()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.chevron_right),
            title: const Text('Unidade de Medida'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) => const CadastroUnidadeDeMedidaPage()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.chevron_right),
            title: const Text('Tipo de Informação'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) => const CadastroTipoInformacaoPage()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.chevron_right),
            title: const Text('Indicador (Formulário Simples)'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) => const CadastroIndicadorPage()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.chevron_right),
            title: const Text('Medições'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) => const CadastroMedicoesPage()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.chevron_right),
            title: const Text('Usuário'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) => const CadastroUsuarioPage()));
            },
          ),
        ],

        const Divider(),

        // --- NOVAS FUNCIONALIDADES DE INDICADORES ---
        
        // 1. Botão para aceder à tela de gestão (CRUD Completo)
        ListTile(
          leading: const Icon(Icons.settings),
          title: const Text('Gerenciar indicadores'),
          onTap: () async {
            Navigator.pop(context); // Fecha o menu lateral
            await Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const IndicadoresPage()),
            );
            // Ao voltar da tela de gestão, recarregamos a lista caso algo tenha sido adicionado ou apagado
            if (mounted) atualizarIndicadores();
          },
        ),

        // 2. Submenu Dinâmico que lista os Indicadores vindos da API
        ExpansionTile(
          leading: const Icon(Icons.analytics),
          title: const Text('Indicadores'),
          children: [
            FutureBuilder<List<Indicador>>(
              future: indicadores,
              builder: (context, snapshot) {
                // Enquanto a API responde
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const ListTile(title: Text('Carregando...'));
                }
                // Em caso de erro na API
                if (snapshot.hasError) {
                  return const ListTile(title: Text('Falha ao carregar indicadores'));
                }
                
                final lista = snapshot.data ?? [];
                
                // Se a API retornar uma lista vazia
                if (lista.isEmpty) {
                  return const ListTile(title: Text('Nenhum indicador'));
                }
                
                // Mapeia cada item da lista para um botão clicável (ListTile)
                return Column(
                  children: lista.map((item) => ListTile(
                    leading: const Icon(Icons.bar_chart, size: 20),
                    title: Text(item.nome),
                    onTap: () {
                      Navigator.pop(context); // Fecha o drawer
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => IndicadorWebviewPage(indicador: item),
                        ),
                      );
                    },
                  )).toList(),
                );
              },
            ),
          ],
        ),

        const Divider(),

        // Botão de Sair
        ListTile(
          leading: const Icon(Icons.exit_to_app, color: Colors.red),
          title: const Text('Sair', style: TextStyle(color: Colors.red)),
          onTap: sair,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Usina App')),
      // O onDrawerChanged garante que sempre que puxares o menu, ele consulta a API novamente
      onDrawerChanged: (aberto) {
        if (aberto) atualizarIndicadores();
      },
      drawer: Drawer(child: montarMenu()),
      body: const Center(
        child: Text('Tela Principal', style: TextStyle(fontSize: 20)),
      ),
    );
  }
}