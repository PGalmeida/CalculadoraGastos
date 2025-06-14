import 'package:flutter/material.dart';
import '../models/transacao.dart';
import 'add_transacao_screen.dart';
import 'dart:math';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Transacao> _transacoes = [];

  void _addTransacao(String descricao, double valor, String tipo) {
    final nova = Transacao(
      id: Random().nextDouble().toString(),
      descricao: descricao,
      valor: valor,
      tipo: tipo,
      data: DateTime.now(),
    );

    setState(() {
      _transacoes.add(nova);
    });
  }

  void _editarTransacao(
      Transacao transacao, String descricao, double valor, String tipo) {
    setState(() {
      final index = _transacoes.indexWhere((t) => t.id == transacao.id);
      if (index != -1) {
        _transacoes[index] = Transacao(
          id: transacao.id,
          descricao: descricao,
          valor: valor,
          tipo: tipo,
          data: DateTime.now(),
        );
      }
    });
  }

  void _removerTransacao(String id) {
    setState(() {
      _transacoes.removeWhere((t) => t.id == id);
    });
  }

  double get _saldo => _transacoes.fold(
      0.0, (soma, t) => t.tipo == 'receita' ? soma + t.valor : soma - t.valor);
  double get _totalReceitas => _transacoes
      .where((t) => t.tipo == 'receita')
      .fold(0.0, (soma, t) => soma + t.valor);
  double get _totalDespesas => _transacoes
      .where((t) => t.tipo == 'despesa')
      .fold(0.0, (soma, t) => soma + t.valor);

  void _abrirFormulario({Transacao? transacao}) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => AddTransacaoScreen(
          onSalvar: transacao == null
              ? _addTransacao
              : (descricao, valor, tipo) =>
                  _editarTransacao(transacao, descricao, valor, tipo),
          transacao: transacao,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gastos Mensais'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildResumo('Saldo', _saldo, Colors.indigo),
                _buildResumo('Receitas', _totalReceitas, Colors.green),
                _buildResumo('Despesas', _totalDespesas, Colors.red),
              ],
            ),
          ),
          Expanded(
            child: _transacoes.isEmpty
                ? Center(child: Text('Nenhuma transação.'))
                : ListView.builder(
                    itemCount: _transacoes.length,
                    itemBuilder: (ctx, i) {
                      final t = _transacoes[i];
                      return Card(
                        child: ListTile(
                          title: Text(t.descricao),
                          subtitle: Text('R\$ ${t.valor.toStringAsFixed(2)}'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit, color: Colors.blue),
                                onPressed: () => _abrirFormulario(transacao: t),
                              ),
                              IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: () => _removerTransacao(t.id),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _abrirFormulario(),
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildResumo(String label, double valor, Color cor) {
    return Column(
      children: [
        Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: 4),
        Text('R\$ ${valor.toStringAsFixed(2)}',
            style: TextStyle(color: cor, fontSize: 18)),
      ],
    );
  }
}
