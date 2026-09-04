import 'package:flutter/material.dart';
import '../../models/medicao.dart';
import '../../models/safra.dart';
import '../../models/tipo_informacao.dart';
import '../../models/unidade.dart';
import '../../models/unidade_de_medida.dart';

class CadastroMedicoesPage extends StatefulWidget {
  const CadastroMedicoesPage({super.key});

  @override
  State<CadastroMedicoesPage> createState() =>
      _CadastroMedicoesPageState();
}

class _CadastroMedicoesPageState
    extends State<CadastroMedicoesPage> {
  final formKey = GlobalKey<FormState>();
  final valorController = TextEditingController();

  final List<Safra> safras = [
    Safra(
      nomeSafra: 'Safra 2025',
      dataInicio: DateTime(2025, 1, 1),
      dataFim: DateTime(2025, 12, 31),
    ),
    Safra(
      nomeSafra: 'Safra 2026',
      dataInicio: DateTime(2026, 1, 1),
      dataFim: DateTime(2026, 12, 31),
    ),
  ];

  final List<Unidade> unidades = [
    Unidade(nome: 'Unidade Sorocaba'),
    Unidade(nome: 'Unidade Itu'),
    Unidade(nome: 'Unidade Campinas'),
  ];

  final List<TipoInformacao> tiposInformacao = [
    TipoInformacao(
      nome: 'Produção',
      unidadeDeMedida: UnidadeDeMedida(
        nome: 'Quilograma',
        simbolo: 'kg',
      ),
    ),
    TipoInformacao(
      nome: 'Temperatura',
      unidadeDeMedida: UnidadeDeMedida(
        nome: 'Celsius',
        simbolo: '°C',
      ),
    ),
    TipoInformacao(
      nome: 'Volume',
      unidadeDeMedida: UnidadeDeMedida(
        nome: 'Litro',
        simbolo: 'L',
      ),
    ),
  ];

  Safra? safraSelecionada;
  Unidade? unidadeSelecionada;
  TipoInformacao? tipoSelecionado;
  DateTime? dataSelecionada;

  Future<void> selecionarData() async {
    final data = await showDatePicker(
      context: context,
      initialDate: dataSelecionada ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (data != null) {
      setState(() {
        dataSelecionada = data;
      });
    }
  }

  String formatarData(DateTime? data) {
    if (data == null) {
      return 'Selecionar data';
    }

    final dia = data.day.toString().padLeft(2, '0');
    final mes = data.month.toString().padLeft(2, '0');

    return '$dia/$mes/${data.year}';
  }

  void salvar() {
    final formularioValido = formKey.currentState!.validate();

    if (safraSelecionada == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecione a safra')),
      );
      return;
    }

    if (unidadeSelecionada == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecione a unidade')),
      );
      return;
    }

    if (tipoSelecionado == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Selecione o tipo de informação'),
        ),
      );
      return;
    }

    if (dataSelecionada == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecione a data')),
      );
      return;
    }

    if (formularioValido) {
      final valorTexto = valorController.text
          .trim()
          .replaceAll(',', '.');

      final valor = double.parse(valorTexto);

      final medicao = Medicoes(
        safra: safraSelecionada!,
        unidade: unidadeSelecionada!,
        tipoInformacao: tipoSelecionado!,
        valor: valor,
        data: dataSelecionada!,
      );

      print('Safra: ${medicao.safra.nomeSafra}');
      print('Unidade: ${medicao.unidade.nome}');
      print('Tipo: ${medicao.tipoInformacao.nome}');
      print(
        'Unidade de medida: '
        '${medicao.tipoInformacao.unidadeDeMedida.simbolo}',
      );
      print('Valor: ${medicao.valor}');
      print('Data: ${medicao.data}');

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Medição cadastrada com sucesso!'),
        ),
      );

      valorController.clear();

      setState(() {
        safraSelecionada = null;
        unidadeSelecionada = null;
        tipoSelecionado = null;
        dataSelecionada = null;
      });
    }
  }

  @override
  void dispose() {
    valorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro de Medições'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DropdownButtonFormField<Safra>(
                value: safraSelecionada,
                decoration: const InputDecoration(
                  labelText: 'Safra',
                  border: OutlineInputBorder(),
                ),
                items: safras.map((safra) {
                  return DropdownMenuItem<Safra>(
                    value: safra,
                    child: Text(safra.nomeSafra),
                  );
                }).toList(),
                onChanged: (safra) {
                  setState(() {
                    safraSelecionada = safra;
                  });
                },
              ),

              const SizedBox(height: 16),

              DropdownButtonFormField<Unidade>(
                value: unidadeSelecionada,
                decoration: const InputDecoration(
                  labelText: 'Unidade',
                  border: OutlineInputBorder(),
                ),
                items: unidades.map((unidade) {
                  return DropdownMenuItem<Unidade>(
                    value: unidade,
                    child: Text(unidade.nome),
                  );
                }).toList(),
                onChanged: (unidade) {
                  setState(() {
                    unidadeSelecionada = unidade;
                  });
                },
              ),

              const SizedBox(height: 16),

              DropdownButtonFormField<TipoInformacao>(
                value: tipoSelecionado,
                decoration: const InputDecoration(
                  labelText: 'Tipo de informação',
                  border: OutlineInputBorder(),
                ),
                items: tiposInformacao.map((tipo) {
                  return DropdownMenuItem<TipoInformacao>(
                    value: tipo,
                    child: Text(
                      '${tipo.nome} '
                      '(${tipo.unidadeDeMedida.simbolo})',
                    ),
                  );
                }).toList(),
                onChanged: (tipo) {
                  setState(() {
                    tipoSelecionado = tipo;
                  });
                },
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: valorController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(
                  labelText: 'Valor',
                  hintText: 'Ex.: 1250,50',
                  border: OutlineInputBorder(),
                ),
                validator: (valor) {
                  if (valor == null || valor.trim().isEmpty) {
                    return 'Informe o valor da medição';
                  }

                  final valorConvertido = double.tryParse(
                    valor.trim().replaceAll(',', '.'),
                  );

                  if (valorConvertido == null) {
                    return 'Informe um número válido';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 16),

              OutlinedButton.icon(
                onPressed: selecionarData,
                icon: const Icon(Icons.calendar_today),
                label: Text(
                  'Data: ${formatarData(dataSelecionada)}',
                ),
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