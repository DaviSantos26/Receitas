import 'package:flutter/material.dart';
import 'package:receitas/features/banco.dart';
import 'package:receitas/models/receitas.dart';

class ReceitaProvider extends ChangeNotifier {
  List<Receita> _receitas = [];
  bool _isLoading = false;

  List<Receita> get receitas => _receitas;
  bool get isLoading => _isLoading;

  // Definição das colunas da tabela
  final Map<String, String> _colunas = {
    'nome': 'TEXT NOT NULL',
    'categoria': 'TEXT NOT NULL',
    'ingredientes': 'TEXT NOT NULL',
    'modo_preparo': 'TEXT NOT NULL',
    'tempo_preparo': 'TEXT',
    'porcoes': 'TEXT',
  };

  // Carregar todas as receitas
  Future<void> carregarReceitas() async {
    _isLoading = true;
    notifyListeners();

    try {
      final dados = await DB.getAll('receitas');
      _receitas = dados.map((map) => Receita.fromMap(map)).toList();
    } catch (e) {
      // Se a tabela não existir ainda, apenas inicializa vazia
      print('Aviso ao carregar receitas: $e');
      _receitas = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Adicionar nova receita
  Future<void> adicionarReceita(Receita receita) async {
    try {
      final id = await DB.inserir('receitas', _colunas, receita.toMap());
      final novaReceita = Receita(
        id: id,
        nome: receita.nome,
        categoria: receita.categoria,
        ingredientes: receita.ingredientes,
        modoPreparo: receita.modoPreparo,
        tempoPreparo: receita.tempoPreparo,
        porcoes: receita.porcoes,
        createdAt: DateTime.now(),
      );
      _receitas.add(novaReceita);
      notifyListeners();
    } catch (e) {
      print('Erro ao adicionar receita: $e');
      rethrow;
    }
  }

  // Atualizar receita
  Future<void> atualizarReceita(int id, Receita receita) async {
    try {
      await DB.atualizar('receitas', id, receita.toMap());
      final index = _receitas.indexWhere((r) => r.id == id);
      if (index != -1) {
        _receitas[index] = Receita(
          id: id,
          nome: receita.nome,
          categoria: receita.categoria,
          ingredientes: receita.ingredientes,
          modoPreparo: receita.modoPreparo,
          tempoPreparo: receita.tempoPreparo,
          porcoes: receita.porcoes,
          updatedAt: DateTime.now(),
        );
        notifyListeners();
      }
    } catch (e) {
      print('Erro ao atualizar receita: $e');
      rethrow;
    }
  }

  // Deletar receita
  Future<void> deletarReceita(int id) async {
    try {
      await DB.deletar('receitas', id);
      _receitas.removeWhere((r) => r.id == id);
      notifyListeners();
    } catch (e) {
      print('Erro ao deletar receita: $e');
      rethrow;
    }
  }

  // Obter receitas por categoria
  List<Receita> getReceitasPorCategoria(String categoria) {
    return _receitas.where((r) => r.categoria == categoria).toList();
  }
}