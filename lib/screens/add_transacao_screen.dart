import 'package:flutter/material.dart';

class AddTransacaoScreen extends StatefulWidget {
  final Function(String, double, String) onAdd;

  const AddTransacaoScreen({super.key, required this.onAdd});

  @override
  State<AddTransacaoScreen> createState() => _AddTransacaoScreenState();
}

class _AddTransacaoScreenState extends State<AddTransacaoScreen> {
  final _descricaoController = TextEditingController();
  final _valorController = TextEditingController();
  String _tipoSelecionado = 'despesa';

  void _salvar() {
    final descricao = _descricaoController.text;
    final valor = double.tryParse(_valorController.text) ?? 0;

    if (descricao.isEmpty || valor <= 0) return;

    widget.onAdd(descricao, valor, _tipoSelecionado);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nova Transação'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _descricaoController,
              decoration: const InputDecoration(labelText: 'Descrição'),
            ),
            TextField(
              controller: _valorController,
              decoration: const InputDecoration(labelText: 'Valor'),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
            ),
            DropdownButton<String>(
              value: _tipoSelecionado,
              items: const [
                DropdownMenuItem(value: 'receita', child: Text('Receita')),
                DropdownMenuItem(value: 'despesa', child: Text('Despesa')),
              ],
              onChanged: (valor) {
                if (valor != null) {
                  setState(() {
                    _tipoSelecionado = valor;
                  });
                }
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _salvar,
              child: const Text('Salvar'),
            )
          ],
        ),
      ),
    );
  }
}
