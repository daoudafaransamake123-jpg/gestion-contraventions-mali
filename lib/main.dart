import 'package:flutter/material.dart';
import 'dart:math';

// -------------------- MODELE --------------------
class Contravention {
  final String id;
  final String nom;
  final String telephone;
  final String infraction;
  final String adresse;
  final String date;
  String statut;

  Contravention({
    required this.nom,
    required this.telephone,
    required this.infraction,
    required this.adresse,
    required this.date,
    this.statut = "Non payée",
  }) : id = DateTime.now().millisecondsSinceEpoch.toString();
}

// -------------------- SERVICE API SIMULE --------------------
class ContraventionService {
  static final List<Contravention> _contraventions = [];

  static Future<List<Contravention>> getContraventions() async {
    // Simule un délai réseau
    await Future.delayed(const Duration(milliseconds: 500));
    return _contraventions;
  }

  static Future<void> saveContravention(Contravention c) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _contraventions.add(c);
  }

  static Future<void> toggleStatut(String id) async {
    final c = _contraventions.firstWhere((c) => c.id == id);
    c.statut = c.statut == "Payée" ? "Non payée" : "Payée";
  }
}

// -------------------- APPLICATION --------------------
void main() {
  runApp(const ContraventionApp());
}

// -------------------- LOGIN --------------------
class ContraventionApp extends StatelessWidget {
  const ContraventionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Application Contravention',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  void _login() {
    if (!_formKey.currentState!.validate()) return;
    setState(() => isLoading = true);
    Future.delayed(const Duration(seconds: 1), () {
      setState(() => isLoading = false);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomePage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Card(
          elevation: 6,
          margin: const EdgeInsets.symmetric(horizontal: 32),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Connexion",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 24),
                  TextFormField(
                    controller: emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                    ),
                    validator: (v) =>
                        v == null || !v.contains('@') ? "Email invalide" : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: passwordController,
                    decoration: const InputDecoration(
                      labelText: 'Mot de passe',
                      border: OutlineInputBorder(),
                    ),
                    obscureText: true,
                    validator: (v) =>
                        v == null || v.length < 4 ? "Mot de passe trop court" : null,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: isLoading ? null : _login,
                    style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(48)),
                    child: isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text("Se connecter"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// -------------------- PAGE PRINCIPALE --------------------
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController nomController = TextEditingController();
  final TextEditingController telephoneController = TextEditingController();
  final TextEditingController infractionController = TextEditingController();
  final TextEditingController adresseController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  List<Contravention> contraventions = [];

  @override
  void initState() {
    super.initState();
    _loadContraventions();
  }

  void _loadContraventions() async {
    final list = await ContraventionService.getContraventions();
    setState(() => contraventions = list);
  }

  void _enregistrer() async {
    if (!_formKey.currentState!.validate()) return;

    final c = Contravention(
      nom: nomController.text,
      telephone: telephoneController.text,
      infraction: infractionController.text,
      adresse: adresseController.text,
      date: dateController.text,
    );

    await ContraventionService.saveContravention(c);
    _loadContraventions();

    nomController.clear();
    telephoneController.clear();
    infractionController.clear();
    adresseController.clear();
    dateController.clear();
  }

  void _toggleStatut(Contravention c) async {
    await ContraventionService.toggleStatut(c.id);
    _loadContraventions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Contraventions"),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      const Text("Nouvelle Contravention",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: nomController,
                        decoration: const InputDecoration(
                          labelText: 'Nom du contrevenant',
                          border: OutlineInputBorder(),
                        ),
                        validator: (v) => v == null || v.length < 3
                            ? "Nom trop court"
                            : null,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: telephoneController,
                        decoration: const InputDecoration(
                          labelText: 'Téléphone',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.phone,
                        validator: (v) =>
                            v == null || v.length < 8 ? "Téléphone invalide" : null,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: infractionController,
                        decoration: const InputDecoration(
                          labelText: 'Infraction',
                          border: OutlineInputBorder(),
                        ),
                        validator: (v) =>
                            v == null || v.isEmpty ? "Champ requis" : null,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: adresseController,
                        decoration: const InputDecoration(
                          labelText: 'Adresse',
                          border: OutlineInputBorder(),
                        ),
                        validator: (v) =>
                            v == null || v.isEmpty ? "Champ requis" : null,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: dateController,
                        decoration: const InputDecoration(
                          labelText: 'Date (JJ/MM/AAAA)',
                          border: OutlineInputBorder(),
                        ),
                        validator: (v) => v == null || !RegExp(r'\d{2}/\d{2}/\d{4}')
                                .hasMatch(v)
                            ? "Date invalide"
                            : null,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                          onPressed: _enregistrer,
                          style: ElevatedButton.styleFrom(
                              minimumSize: const Size.fromHeight(48)),
                          child: const Text("Enregistrer")),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: contraventions.length,
              itemBuilder: (context, index) {
                final c = contraventions[index];
                return Card(
                  color:
                      c.statut == "Payée" ? Colors.green.shade50 : Colors.red.shade50,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  child: ListTile(
                    leading: const Icon(Icons.assignment, color: Colors.deepPurple),
                    title: Text(c.nom),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.phone, size: 16, color: Colors.deepPurple),
                            const SizedBox(width: 4),
                            Text(c.telephone),
                          ],
                        ),
                        Row(
                          children: [
                            const Icon(Icons.warning, size: 16, color: Colors.deepPurple),
                            const SizedBox(width: 4),
                            Text(c.infraction),
                          ],
                        ),
                        Row(
                          children: [
                            const Icon(Icons.home, size: 16, color: Colors.deepPurple),
                            const SizedBox(width: 4),
                            Text(c.adresse),
                          ],
                        ),
                        Row(
                          children: [
                            const Icon(Icons.calendar_today, size: 16, color: Colors.deepPurple),
                            const SizedBox(width: 4),
                            Text(c.date),
                          ],
                        ),
                        Row(
                          children: [
                            const Icon(Icons.check_circle, size: 16, color: Colors.deepPurple),
                            const SizedBox(width: 4),
                            Text(c.statut),
                          ],
                        ),
                      ],
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.swap_horiz, color: Colors.deepPurple),
                      tooltip: 'Changer le statut',
                      onPressed: () => _toggleStatut(c),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}