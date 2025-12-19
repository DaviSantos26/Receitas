import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:receitas/models/receitas.dart';
import 'package:receitas/providers/receita_provider.dart';

class AdicionarReceitaPage extends StatefulWidget {
  final String categoria;

  const AdicionarReceitaPage({super.key, required this.categoria});

  @override
  State<AdicionarReceitaPage> createState() => _AdicionarReceitaPageState();
}

class _AdicionarReceitaPageState extends State<AdicionarReceitaPage> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _ingredientesController = TextEditingController();
  final _modoPreparoController = TextEditingController();
  final _tempoPreparoController = TextEditingController();
  final _porcoesController = TextEditingController();

  @override
  void dispose() {
    _nomeController.dispose();
    _ingredientesController.dispose();
    _modoPreparoController.dispose();
    _tempoPreparoController.dispose();
    _porcoesController.dispose();
    super.dispose();
  }

  Future<void> _salvarReceita() async {
    if (_formKey.currentState!.validate()) {
      final receita = Receita(
        nome: _nomeController.text,
        categoria: widget.categoria,
        ingredientes: _ingredientesController.text,
        modoPreparo: _modoPreparoController.text,
        tempoPreparo: _tempoPreparoController.text.isNotEmpty 
            ? _tempoPreparoController.text 
            : null,
        porcoes: _porcoesController.text.isNotEmpty 
            ? _porcoesController.text 
            : null,
      );

      try {
        await Provider.of<ReceitaProvider>(context, listen: false)
            .adicionarReceita(receita);
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Receita adicionada com sucesso!')),
          );
          Navigator.pop(context);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erro ao salvar receita: $e')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Adicionar Receita'),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _nomeController,
              decoration: const InputDecoration(
                labelText: 'Nome da Receita',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, insira o nome da receita';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _ingredientesController,
              decoration: const InputDecoration(
                labelText: 'Ingredientes',
                border: OutlineInputBorder(),
                hintText: 'Ex: 2 xícaras de farinha\n1 xícara de açúcar...',
              ),
              maxLines: 5,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, insira os ingredientes';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _modoPreparoController,
              decoration: const InputDecoration(
                labelText: 'Modo de Preparo',
                border: OutlineInputBorder(),
                hintText: '1. Misture os ingredientes secos...',
              ),
              maxLines: 8,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, insira o modo de preparo';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _tempoPreparoController,
              decoration: const InputDecoration(
                labelText: 'Tempo de Preparo (opcional)',
                border: OutlineInputBorder(),
                hintText: 'Ex: 30 minutos',
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _porcoesController,
              decoration: const InputDecoration(
                labelText: 'Porções (opcional)',
                border: OutlineInputBorder(),
                hintText: 'Ex: 6 porções',
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _salvarReceita,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text(
                'Salvar Receita',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}