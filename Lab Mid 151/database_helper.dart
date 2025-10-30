import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    // Initialize sqflite for desktop platforms
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }
    
    String path = join(await getDatabasesPath(), 'doctor_app.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Create patients table
    await db.execute('''
      CREATE TABLE patients (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        age INTEGER NOT NULL,
        gender TEXT NOT NULL,
        phone TEXT NOT NULL,
        email TEXT,
        address TEXT,
        medical_history TEXT,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL
      )
    ''');

    // Create doctors table
    await db.execute('''
      CREATE TABLE doctors (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        specialization TEXT NOT NULL,
        phone TEXT NOT NULL,
        email TEXT,
        experience INTEGER,
        qualification TEXT,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL
      )
    ''');

    // Create patient_documents table
    await db.execute('''
      CREATE TABLE patient_documents (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        patient_id INTEGER NOT NULL,
        document_name TEXT NOT NULL,
        document_path TEXT NOT NULL,
        document_type TEXT NOT NULL,
        created_at TEXT NOT NULL,
        FOREIGN KEY (patient_id) REFERENCES patients (id)
      )
    ''');
  }

  // Patient CRUD operations
  Future<int> insertPatient(Map<String, dynamic> patient) async {
    final db = await database;
    patient['created_at'] = DateTime.now().toIso8601String();
    patient['updated_at'] = DateTime.now().toIso8601String();
    return await db.insert('patients', patient);
  }

  Future<List<Map<String, dynamic>>> getAllPatients() async {
    final db = await database;
    return await db.query('patients', orderBy: 'name ASC');
  }

  Future<Map<String, dynamic>?> getPatient(int id) async {
    final db = await database;
    final results = await db.query('patients', where: 'id = ?', whereArgs: [id]);
    return results.isNotEmpty ? results.first : null;
  }

  Future<int> updatePatient(int id, Map<String, dynamic> patient) async {
    final db = await database;
    patient['updated_at'] = DateTime.now().toIso8601String();
    return await db.update('patients', patient, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deletePatient(int id) async {
    final db = await database;
    // Also delete associated documents
    await db.delete('patient_documents', where: 'patient_id = ?', whereArgs: [id]);
    return await db.delete('patients', where: 'id = ?', whereArgs: [id]);
  }

  // Doctor CRUD operations
  Future<int> insertDoctor(Map<String, dynamic> doctor) async {
    final db = await database;
    doctor['created_at'] = DateTime.now().toIso8601String();
    doctor['updated_at'] = DateTime.now().toIso8601String();
    return await db.insert('doctors', doctor);
  }

  Future<List<Map<String, dynamic>>> getAllDoctors() async {
    final db = await database;
    return await db.query('doctors', orderBy: 'name ASC');
  }

  Future<Map<String, dynamic>?> getDoctor(int id) async {
    final db = await database;
    final results = await db.query('doctors', where: 'id = ?', whereArgs: [id]);
    return results.isNotEmpty ? results.first : null;
  }

  Future<int> updateDoctor(int id, Map<String, dynamic> doctor) async {
    final db = await database;
    doctor['updated_at'] = DateTime.now().toIso8601String();
    return await db.update('doctors', doctor, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteDoctor(int id) async {
    final db = await database;
    return await db.delete('doctors', where: 'id = ?', whereArgs: [id]);
  }

  // Patient documents operations
  Future<int> insertPatientDocument(Map<String, dynamic> document) async {
    final db = await database;
    document['created_at'] = DateTime.now().toIso8601String();
    return await db.insert('patient_documents', document);
  }

  Future<List<Map<String, dynamic>>> getPatientDocuments(int patientId) async {
    final db = await database;
    return await db.query('patient_documents', 
        where: 'patient_id = ?', 
        whereArgs: [patientId],
        orderBy: 'created_at DESC');
  }

  Future<int> deletePatientDocument(int id) async {
    final db = await database;
    return await db.delete('patient_documents', where: 'id = ?', whereArgs: [id]);
  }

  // Search operations
  Future<List<Map<String, dynamic>>> searchPatients(String query) async {
    final db = await database;
    return await db.query('patients',
        where: 'name LIKE ? OR phone LIKE ? OR email LIKE ?',
        whereArgs: ['%$query%', '%$query%', '%$query%'],
        orderBy: 'name ASC');
  }

  Future<List<Map<String, dynamic>>> searchDoctors(String query) async {
    final db = await database;
    return await db.query('doctors',
        where: 'name LIKE ? OR specialization LIKE ? OR phone LIKE ?',
        whereArgs: ['%$query%', '%$query%', '%$query%'],
        orderBy: 'name ASC');
  }

  Future<void> close() async {
    final db = await database;
    db.close();
  }
}
