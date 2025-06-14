import 'package:flutter/material.dart';
import '../models/transacao.dart';

class AddTransacaoScreen extends StatefulWidget {
  final Function(String, double, String) onSalvar;
  final Transacao? transacao;

  const AddTransacaoScreen({super.key, required this.onSalvar, this.transacao});

  @override
  State<AddTransacaoScreen> createState() => _AddTransacaoScreenState();
}

class _AddTransacaoScreenState extends State<AddTransacaoScreen> {
  final _descricaoController = TextEditingController();
  final _valorController = TextEditingController();
  String _tipoSelecionado = 'despesa';

  @override
  void initState() {
    super.initState();
    if (widget.transacao != null) {
      _descricaoController.text = widget.transacao!.descricao;
      _valorController.text = widget.transacao!.valor.toString();
      _tipoSelecionado = widget.transacao!.tipo;
    }
  }

  void _salvar() {
    final descricao = _descricaoController.text.trim();
    final valor = double.tryParse(_valorController.text) ?? 0;
    if (descricao.isEmpty || valor <= 0) return;

    widget.onSalvar(descricao, valor, _tipoSelecionado);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            widget.transacao == null ? 'Nova Transação' : 'Editar Transação'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _descricaoController,
              decoration: InputDecoration(labelText: 'Descrição'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _valorController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(labelText: 'Valor'),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _tipoSelecionado,
              items: const [
                DropdownMenuItem(value: 'despesa', child: Text('Despesa')),
                DropdownMenuItem(value: 'receita', child: Text('Receita')),
              ],
              onChanged: (valor) {
                if (valor != null) {
                  setState(() => _tipoSelecionado = valor);
                }
              },
              decoration: InputDecoration(labelText: 'Tipo'),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _salvar,
              child: Text(
                  widget.transacao == null ? 'Adicionar' : 'Salvar Alterações'),
            )
          ],
        ),
      ),
    );
  }
}
