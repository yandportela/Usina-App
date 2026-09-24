import 'package:flutter/material.dart';
import 'cadastros/cadastro_indicador.dart';
import 'cadastros/cadastro_medicoes.dart';
import 'cadastros/cadastro_safra.dart';
import 'cadastros/cadastro_tipo_informacao.dart';
import 'cadastros/cadastro_unidade.dart';
import 'cadastros/cadastro_unidade_de_medida.dart';
import 'cadastros/cadastro_usuario.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_page.dart';

class TelaPrincipal extends StatefulWidget {
  const TelaPrincipal({super.key});

  @override
  State<TelaPrincipal> createState() => _TelaPrincipalState();
}

class _TelaPrincipalState extends State<TelaPrincipal> {
  bool cadastroAberto = false;

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
          title: const Text('InÃ¡cio'),
          onTap: () {
            Navigator.pop(context);
          },
        ),

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

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CadastroSafraPage(),
                ),
              );
            },
          ),

          ListTile(
            leading: const Icon(Icons.chevron_right),
            title: const Text('Unidade'),
            onTap: () {
              Navigator.pop(context);

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CadastroUnidadePage(),
                ),
              );
            },
          ),

          ListTile(
            leading: const Icon(Icons.chevron_right),
            title: const Text('Unidade de Medida'),
            onTap: () {
              Navigator.pop(context);

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CadastroUnidadeDeMedidaPage(),
                ),
              );
            },
          ),

          ListTile(
            leading: const Icon(Icons.chevron_right),
            title: const Text('Tipo de InformaÃ§Ã£o'),
            onTap: () {
              Navigator.pop(context);

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CadastroTipoInformacaoPage(),
                ),
              );
            },
          ),

          ListTile(
            leading: const Icon(Icons.chevron_right),
            title: const Text('Indicador'),
            onTap: () {
              Navigator.pop(context);

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CadastroIndicadorPage(),
                ),
              );
            },
          ),

          ListTile(
            leading: const Icon(Icons.chevron_right),
            title: const Text('MediÃ§Ãµes'),
            onTap: () {
              Navigator.pop(context);

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CadastroMedicoesPage(),
                ),
              );
            },
          ),

          ListTile(
            leading: const Icon(Icons.chevron_right),
            title: const Text('UsuÃ¡rio'),
            onTap: () {
              Navigator.pop(context);

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CadastroUsuarioPage(),
                ),
              );
            },
          ),
        ],
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Usina App')),
      drawer: Drawer(child: montarMenu()),
      body: const Center(
        child: Text('Tela Principal', style: TextStyle(fontSize: 20)),
      ),
    );
  }
}
