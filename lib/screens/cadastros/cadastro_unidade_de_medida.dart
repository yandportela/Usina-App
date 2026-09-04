import 'package:flutter/material.dart';
import '../../models/unidade_de_medida.dart';

class CadastroUnidadeDeMedidaPage extends StatefulWidget {
  const CadastroUnidadeDeMedidaPage({super.key});

  @override
  State<CadastroUnidadeDeMedidaPage> createState() =>
      _CadastroUnidadeDeMedidaPageState();
}

class _CadastroUnidadeDeMedidaPageState
    extends State<CadastroUnidadeDeMedidaPage> {
  final formKey = GlobalKey<FormState>();

  final nomeController = TextEditingController();
  final simboloController = TextEditingController();

  void salvar() {
    if (formKey.currentState!.validate()) {
      final unidadeDeMedida = UnidadeDeMedida(
        nome: nomeController.text.trim(),
        simbolo: simboloController.text.trim(),
      );

      print('Unidade de medida: ${unidadeDeMedida.nome}');
      print('Símbolo: ${unidadeDeMedida.simbolo}');

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Unidade de medida cadastrada com sucesso!'),
        ),
      );

      nomeController.clear();
      simboloController.clear();
    }
  }

  @override
  void dispose() {
    nomeController.dispose();
    simboloController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro de Unidade de Medida'),
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
                  labelText: 'Nome',
                  hintText: 'Ex.: Quilograma',
                  border: OutlineInputBorder(),
                ),
                validator: (valor) {
                  if (valor == null || valor.trim().isEmpty) {
                    return 'Informe o nome da unidade de medida';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: simboloController,
                textCapitalization: TextCapitalization.characters,
                decoration: const InputDecoration(
                  labelText: 'Símbolo',
                  hintText: 'Ex.: kg, L, °C',
                  border: OutlineInputBorder(),
                ),
                validator: (valor) {
                  if (valor == null || valor.trim().isEmpty) {
                    return 'Informe o símbolo';
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