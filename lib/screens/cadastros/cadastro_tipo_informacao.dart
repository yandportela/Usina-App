import 'package:flutter/material.dart';
import '../../models/tipo_informacao.dart';
import '../../models/unidade_de_medida.dart';

class CadastroTipoInformacaoPage extends StatefulWidget {
  const CadastroTipoInformacaoPage({super.key});

  @override
  State<CadastroTipoInformacaoPage> createState() =>
      _CadastroTipoInformacaoPageState();
}

class _CadastroTipoInformacaoPageState
    extends State<CadastroTipoInformacaoPage> {
  final formKey = GlobalKey<FormState>();
  final nomeController = TextEditingController();

  final List<UnidadeDeMedida> unidadesDeMedida = [
    UnidadeDeMedida(nome: 'Quilograma', simbolo: 'kg'),
    UnidadeDeMedida(nome: 'Litro', simbolo: 'L'),
    UnidadeDeMedida(nome: 'Celsius', simbolo: '°C'),
    UnidadeDeMedida(nome: 'Porcentagem', simbolo: '%'),
    UnidadeDeMedida(nome: 'Unidade', simbolo: 'un'),
  ];

  UnidadeDeMedida? unidadeSelecionada;

  void salvar() {
    final formularioValido = formKey.currentState!.validate();

    if (unidadeSelecionada == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Selecione uma unidade de medida'),
        ),
      );
      return;
    }

    if (formularioValido) {
      final tipoInformacao = TipoInformacao(
        nome: nomeController.text.trim(),
        unidadeDeMedida: unidadeSelecionada!,
      );

      print('Tipo de informação: ${tipoInformacao.nome}');
      print(
        'Unidade: '
        '${tipoInformacao.unidadeDeMedida.nome} '
        '(${tipoInformacao.unidadeDeMedida.simbolo})',
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Tipo de informação cadastrado com sucesso!'),
        ),
      );

      nomeController.clear();

      setState(() {
        unidadeSelecionada = null;
      });
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
        title: const Text('Cadastro de Tipo de Informação'),
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
                  hintText: 'Ex.: Produção de cana',
                  border: OutlineInputBorder(),
                ),
                validator: (valor) {
                  if (valor == null || valor.trim().isEmpty) {
                    return 'Informe o nome do tipo de informação';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 16),

              DropdownButtonFormField<UnidadeDeMedida>(
                value: unidadeSelecionada,
                decoration: const InputDecoration(
                  labelText: 'Unidade de medida',
                  border: OutlineInputBorder(),
                ),
                items: unidadesDeMedida.map((unidade) {
                  return DropdownMenuItem<UnidadeDeMedida>(
                    value: unidade,
                    child: Text(
                      '${unidade.nome} (${unidade.simbolo})',
                    ),
                  );
                }).toList(),
                onChanged: (unidade) {
                  setState(() {
                    unidadeSelecionada = unidade;
                  });
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