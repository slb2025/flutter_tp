import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tp_widget/models/item.dart';

// --- Définition des Constantes du Formulaire ---
const List<String> _vehicleNames = [
  'Peugeot 308',
  'Renault Clio V',
  'Moto Yamaha MT-07',
];

// --- Listes de valeurs pour les listes déroulantes ---
const List<String> _typeVehiculeOptions = ['Particulier', 'Professionnel', 'Spécifique'];
const List<String> _motorisationOptions = ['Essence', 'Diesel', 'Hybride', 'Électrique'];
const List<String> _frequenceOptions = ['Quotidienne', 'Occasionnelle'];


class NewContractScreen extends StatefulWidget {
  const NewContractScreen({super.key});

  @override
  State<NewContractScreen> createState() => _NewContractScreenState();
}

class _NewContractScreenState extends State<NewContractScreen> {

  String? _selectedName;
  String? _selectedVehicleType;
  String? _selectedMotorisation;
  String? _selectedUsage;
  String? _selectedFrequence;
  DateTime? _selectedDate;


  // --- Contrôleurs pour les champs libres (puissance, kilométrage) ---
  final TextEditingController _puissanceController = TextEditingController();
  final TextEditingController _kilometrageController = TextEditingController();
  final TextEditingController _immatController = TextEditingController();
  // --- Autres contrôleurs conservés pour l'information du contrat/date ---
  final TextEditingController _contractNumberController = TextEditingController();
  final TextEditingController _warrantyTypeController = TextEditingController();

  final String _defaultImage = 'assets/peugeot_308.webp';
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _puissanceController.dispose();
    _kilometrageController.dispose();
    _immatController.dispose();
    _contractNumberController.dispose();
    _warrantyTypeController.dispose();
    super.dispose();
  }

  void _saveContract(BuildContext context) {
    if (_formKey.currentState!.validate() && _selectedName != null) {

      // --- Assembler toutes les données dans la description et le détail ---
      final description =
          "Type: ${_selectedVehicleType ?? 'Non spécifié'} | "
          "Moteur: ${_selectedMotorisation ?? 'Non spécifié'} | "
          "Puissance: ${_puissanceController.text} CV";

      final detail =
          "Usage: ${_selectedUsage ?? 'Non spécifié'} | "
          "Fréquence: ${_selectedFrequence ?? 'Non spécifié'} | "
          "Km/an: ${_kilometrageController.text}";

      final newItem = Item(
        name: _selectedName!,
        description: description,
        detail: detail,
        imageAsset: _defaultImage,
        effectiveDate: _selectedDate!,
      );

      Navigator.pop(context, newItem);
    }
  }

  Future<void> _presentDatePicker() async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final firstDate = today;

    final lastDate = today.add(const Duration(days: 90));

    DateTime initialDate = today;

    final pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
      locale: const Locale('fr'),
    );

    setState(() {
      _selectedDate = pickedDate;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ajouter un nouveau contrat"),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const Text('1. Identification du Contrat',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 10),

              // --- CHAMP 1 : NOM (Liste Déroulante) ---
              _buildDropdownField(
                value: _selectedName,
                label: "Marque et modèle du véhicule",
                icon: Icons.directions_car,
                options: _vehicleNames,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedName = newValue;
                  });
                },
              ),
              const SizedBox(height: 20),

              // --- CHAMP 2 : Plaque du véhicule ---
              _buildTextField(
                  _immatController, "Plaque d'immatriculation", Icons.badge, isImmat: true),
              const SizedBox(height: 20),

              // --- CHAMP 3 : Type de véhicule ---
              _buildDropdownField(
                value: _selectedVehicleType,
                label: "Type de véhicule",
                icon: Icons.category,
                options: _typeVehiculeOptions,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedVehicleType = newValue;
                  });
                },
              ),
              const SizedBox(height: 20),

              const Text('2. Caractéristiques techniques',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 10),

              // --- CHAMP 4 : Motorisation ---
              _buildDropdownField(
                value: _selectedMotorisation,
                label: "Motorisation",
                icon: Icons.local_gas_station,
                options: _motorisationOptions,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedMotorisation = newValue;
                  });
                },
              ),
              const SizedBox(height: 15),

              // --- CHAMP 5 : Puissance fiscale (Texte) ---
              _buildTextField(_puissanceController, "Chevaux fiscaux", Icons.flash_on, isNumeric: true),
              const SizedBox(height: 20),

              const Text('3. Données d’usage',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 10),

              // --- CHAMP 6 : Fréquence ---
              _buildDropdownField(
                value: _selectedFrequence,
                label: "Fréquence d'utilisation",
                icon: Icons.access_time,
                options: _frequenceOptions,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedFrequence = newValue;
                  });
                },
              ),
              const SizedBox(height: 15),

              // --- CHAMP 7 : Kilométrage annuel ---
              _buildTextField(_kilometrageController, "Kilométrage annuel estimé", Icons.speed, isNumeric: true),
              const SizedBox(height: 30),

              // --- CHAMP 8 : Date d'effet ---
              ListTile(
                title: Text(
                  _selectedDate == null
                      ? 'Veuillez sélectionner la date d\'effet du contrat'
                      : 'Date d\effet du contrat : ${DateFormat('dd/MM/yyyy').format(_selectedDate!)}',

                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black54,
                  ),
                ),
                trailing: Icon(
                  Icons.calendar_today,
                  size: 28,
                  color: Colors.black54,
                ),
                onTap: _presentDatePicker,
                contentPadding: EdgeInsets.zero,
              ),

              const SizedBox(height: 30),

              // --- Bouton d'enregistrement ---
              ElevatedButton(
                onPressed: () => _saveContract(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                child: const Text(
                  'Enregistrer le contrat',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- Widget utilitaire pour les champs de texte (mis à jour pour la saisie numérique) ---
  Widget _buildTextField(TextEditingController controller, String label,
      IconData icon, {int maxLines = 1, bool isNumeric = false, bool isImmat = false}) {

    final RegExp immatRegExp = RegExp(r'^[A-Z]{2}-\d{3}-[A-Z]{2}$');

    return TextFormField(
      controller: controller,
      keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
      textCapitalization: isImmat ? TextCapitalization.characters : TextCapitalization.none,
      maxLength: isImmat ? 9 : null,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: const OutlineInputBorder(),
        counterText: '',
      ),
      maxLines: maxLines,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Ce champ est obligatoire.';
        }

        if (isImmat && !immatRegExp.hasMatch(value.toUpperCase())) {
          return 'Le format doit être de type AA-111-AA';
        }

        return null;
      },
    );
  }

  // --- Widget utilitaire pour la liste déroulante ---
  Widget _buildDropdownField({
    required String? value,
    required String label,
    required IconData icon,
    required List<String> options,
    required ValueChanged<String?> onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: const OutlineInputBorder(),
      ),
      items: options.map<DropdownMenuItem<String>>((String option) {
        return DropdownMenuItem<String>(
          value: option,
          child: Text(option),
        );
      }).toList(),
      onChanged: onChanged,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Veuillez sélectionner une option.';
        }
        return null;
      },
    );
  }
}