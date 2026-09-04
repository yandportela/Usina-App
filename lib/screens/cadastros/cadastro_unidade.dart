import 'package:flutter/material.dart';
import '../../models/unidade.dart';

class CadastroUnidadePage extends StatefulWidget {
  const CadastroUnidadePage({super.key});

  @override
  State<CadastroUnidadePage> createState() =>
      _CadastroUnidadePageState();
}

class _CadastroUnidadePageState
    extends State<CadastroUnidadePage> {
  final formKey = GlobalKey<FormState>();
  final nomeController = TextEditingController();

  void salvar() {
    if (formKey.currentState!.validate()) {
      final unidade = Unidade(
        nome: nomeController.text.trim(),
      );

      print('Unidade: ${unidade.nome}');

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Unidade cadastrada com sucesso!'),
        ),
      );

      nomeController.clear();
    }
  }

  @override
  void dispose() {
    nomeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro de Unidade'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: nomeController,
                decoration: const InputDecoration(
                  labelText: 'Nome da unidade',
                  hintText: 'Ex.: Unidade Sorocaba',
                  border: OutlineInputBorder(),
                ),
                validator: (valor) {
                  if (valor == null || valor.trim().isEmpty) {
                    return 'Informe o nome da unidade';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 24),

              ElevatedButton(
                onPressed: salvar,
                child: const Text('Salvar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}