import 'package:flutter/material.dart';
import '../../models/safra.dart';

class CadastroSafraPage extends StatefulWidget {
  const CadastroSafraPage({super.key});

  @override
  State<CadastroSafraPage> createState() =>
      _CadastroSafraPageState();
}

class _CadastroSafraPageState extends State<CadastroSafraPage> {
  final formKey = GlobalKey<FormState>();

  final nomeSafraController = TextEditingController();
  DateTime? dataInicio;
  DateTime? dataFim;

  Future<void> selecionarDataInicio() async {
    final dataSelecionada = await showDatePicker(
      context: context,
      initialDate: dataInicio ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (dataSelecionada != null) {
      setState(() {
        dataInicio = dataSelecionada;
      });
    }
  }

  Future<void> selecionarDataFim() async {
    final dataSelecionada = await showDatePicker(
      context: context,
      initialDate: dataFim ?? dataInicio ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (dataSelecionada != null) {
      setState(() {
        dataFim = dataSelecionada;
      });
    }
  }

  String formatarData(DateTime? data) {
    if (data == null) {
      return 'Selecione uma data';
    }

    final dia = data.day.toString().padLeft(2, '0');
    final mes = data.month.toString().padLeft(2, '0');

    return '$dia/$mes/${data.year}';
  }

  void salvar() {
    final formularioValido = formKey.currentState!.validate();

    if (dataInicio == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Informe a data de início'),
        ),
      );
      return;
    }

    if (dataFim == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Informe a data de fim'),
        ),
      );
      return;
    }

    if (dataFim!.isBefore(dataInicio!)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'A data de fim não pode ser anterior à data de início',
          ),
        ),
      );
      return;
    }

    if (formularioValido) {
      final safra = Safra(
        nomeSafra: nomeSafraController.text.trim(),
        dataInicio: dataInicio!,
        dataFim: dataFim!,
      );

      print('Safra: ${safra.nomeSafra}');
      print('Início: ${safra.dataInicio}');
      print('Fim: ${safra.dataFim}');

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Safra cadastrada com sucesso!'),
        ),
      );

      nomeSafraController.clear();

      setState(() {
        dataInicio = null;
        dataFim = null;
      });
    }
  }

  @override
  void dispose() {
    nomeSafraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro de Safra'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: nomeSafraController,
                decoration: const InputDecoration(
                  labelText: 'Nome da safra',
                  hintText: 'Ex.: Safra 2026',
                  border: OutlineInputBorder(),
                ),
                validator: (valor) {
                  if (valor == null || valor.trim().isEmpty) {
                    return 'Informe o nome da safra';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 16),

              OutlinedButton.icon(
                onPressed: selecionarDataInicio,
                icon: const Icon(Icons.calendar_today),
                label: Text(
                  'Data de início: ${formatarData(dataInicio)}',
                ),
              ),

              const SizedBox(height: 16),

              OutlinedButton.icon(
                onPressed: selecionarDataFim,
                icon: const Icon(Icons.calendar_today),
                label: Text(
                  'Data de fim: ${formatarData(dataFim)}',
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