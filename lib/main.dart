import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Application Contravention',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Application Contravention'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController nomController = TextEditingController();
  final TextEditingController telephoneController = TextEditingController();
  final TextEditingController infractionController = TextEditingController();
  final TextEditingController adresseController = TextEditingController();
  final TextEditingController dateController = TextEditingController();

  List<Map<String, String>> contraventions = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nomController,
              decoration: const InputDecoration(
                labelText: 'Nom du contrevenant',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: telephoneController,
              decoration: const InputDecoration(
                labelText: 'Numéro de téléphone',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: infractionController,
              decoration: const InputDecoration(
                labelText: 'Type d’infraction',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: adresseController,
              decoration: const InputDecoration(
                labelText: 'Adresse',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: dateController,
              decoration: const InputDecoration(
                labelText: 'Date et heure',
                border: OutlineInputBorder(),
              ),
              readOnly: true, // empêche la saisie manuelle
              onTap: () async {
                DateTime? date = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                if (date != null) {
                  TimeOfDay? time = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (time != null) {
                    final dateTime = DateTime(
                      date.year,
                      date.month,
                      date.day,
                      time.hour,
                      time.minute,
                    );
                    dateController.text = "${dateTime.day}/${dateTime.month}/${dateTime.year} "
                        "${time.format(context)}";
                  }
                }
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                print("BOUTON CLIQUE");
                setState(() {
                  contraventions.add({
                    "nom": nomController.text,
                    "telephone": telephoneController.text,
                    "infraction": infractionController.text,
                    "adresse": adresseController.text,
                    "date": dateController.text,
                  });

                  nomController.clear();
                  telephoneController.clear();
                  infractionController.clear();
                  adresseController.clear();
                  dateController.clear();
                });
              },
              child: const Text("Enregistrer la contravention"),
            ),
            const SizedBox(height: 20),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: contraventions.length,
              itemBuilder: (context, index) {
                final c = contraventions[index];
                return Card(
                  child: ListTile(
                    title: Text(c["nom"] ?? ""),
                    subtitle: Text(
                      "Téléphone: ${c["telephone"]}\n"
                      "Infraction: ${c["infraction"]}\n"
                      "Adresse: ${c["adresse"]}\n"
                      "Date/Heure: ${c["date"]}",
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