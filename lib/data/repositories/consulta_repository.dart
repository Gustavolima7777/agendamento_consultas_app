import 'dart:async';

import 'package:agendamento_consultas_app/domain/entities/consulta.dart';
import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

class ConsultaRepository {
  static const _dbName = 'consultas.db';
  static const _dbVersion = 1;
  static const _tableName = 'consultas';

  Database? _db;

  // Abre (ou cria) o banco de dados
  Future<Database> get _database async {
    if (_db != null) return _db!;

    final dbPath = await getDatabasesPath();
    final path = p.join(dbPath, _dbName);

    _db = await openDatabase(
      path,
      version: _dbVersion,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $_tableName (
            id TEXT PRIMARY KEY,
            medico_id TEXT NOT NULL,
            paciente_id TEXT NOT NULL,
            data_hora TEXT NOT NULL
          )
        ''');
      },
    );

    return _db!;
  }

  Map<String, dynamic> _toMap(Consulta c) {
    return {
      'id': c.id,
      'medico_id': c.medicoId,
      'paciente_id': c.pacienteId,
      'data_hora': c.dataHora.toIso8601String(),
    };
  }

  Consulta _fromMap(Map<String, dynamic> map) {
    return Consulta(
      id: map['id'] as String,
      medicoId: map['medico_id'] as String,
      pacienteId: map['paciente_id'] as String,
      dataHora: DateTime.parse(map['data_hora'] as String),
    );
  }

  /// Cria / agenda uma nova consulta (AGORA SALVA NO BANCO)
  Future<void> criarConsulta(Consulta consulta) async {
    final db = await _database;

    await db.insert(
      _tableName,
      _toMap(consulta),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Stream com as consultas de um dia para um paciente
  ///
  /// Aqui o Stream emite **uma vez** com os dados do banco.
  /// O ViewModel já chama `_ouvirConsultasDoDia` de novo depois de agendar,
  /// então a tela é atualizada certinho.
  Stream<List<Consulta>> consultasDoDiaStream({
    required String pacienteId,
    required DateTime dia,
  }) async* {
    final db = await _database;

    final inicio = DateTime(dia.year, dia.month, dia.day);
    final fim = inicio.add(const Duration(days: 1));

    final inicioIso = inicio.toIso8601String();
    final fimIso = fim.toIso8601String();

    final resultado = await db.query(
      _tableName,
      where:
      'paciente_id = ? AND data_hora >= ? AND data_hora < ?',
      whereArgs: [pacienteId, inicioIso, fimIso],
      orderBy: 'data_hora ASC',
    );

    final consultas = resultado.map(_fromMap).toList();
    yield consultas;
  }

  /// Lista todas as consultas de um paciente (sem filtro de data)
  Future<List<Consulta>> listarConsultasPaciente(String pacienteId) async {
    final db = await _database;

    final resultado = await db.query(
      _tableName,
      where: 'paciente_id = ?',
      whereArgs: [pacienteId],
      orderBy: 'data_hora DESC',
    );

    return resultado.map(_fromMap).toList();
  }

  Future<void> dispose() async {
    final db = _db;
    if (db != null) {
      await db.close();
    }
  }
}
