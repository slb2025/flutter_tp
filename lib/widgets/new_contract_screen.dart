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

  // --- Variables d'état pour les champs de type liste déroulante ou date ---
  String? _selectedName;
  String? _selectedVehicleType;
  String? _selectedMotorisation;
  String? _selectedUsage;
  String? _selectedFrequence;
  DateTime? _selectedDate;


  // --- Contrôleurs pour les champs libres (puissance, kilométrage, immatriculation) ---
  final TextEditingController _puissanceController = TextEditingController();
  final TextEditingController _kilometrageController = TextEditingController();
  final TextEditingController _immatController = TextEditingController();
  // --- Autres contrôleurs conservés pour l'information du contrat/date ---
  final TextEditingController _contractNumberController = TextEditingController();
  final TextEditingController _warrantyTypeController = TextEditingController();

  final String _defaultImage = 'assets/peugeot_308.webp';
  // --- Clé globale pour gérer l'état du formulaire (validation) ---
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    // --- Libération des ressources des contrôleurs lors de la destruction du Widget ---
    _puissanceController.dispose();
    _kilometrageController.dispose();
    _immatController.dispose();
    _contractNumberController.dispose();
    _warrantyTypeController.dispose();
    super.dispose();
  }

  void _saveContract(BuildContext context) {
    // --- Vérification de la validation du formulaire et de la sélection du nom ---
    if (_formKey.currentState!.validate() && _selectedName != null) {

      // --- Construction de la chaîne 'description' à partir des champs techniques ---
      final description =
          "Type: ${_selectedVehicleType ?? 'Non spécifié'} | "
          "Moteur: ${_selectedMotorisation ?? 'Non spécifié'} | "
          "Puissance: ${_puissanceController.text} CV";

      // --- Construction de la chaîne 'detail' à partir des champs d'usage ---
      final detail =
          "Usage: ${_selectedUsage ?? 'Non spécifié'} | "
          "Fréquence: ${_selectedFrequence ?? 'Non spécifié'} | "
          "Km/an: ${_kilometrageController.text}";

      // --- Création du nouvel objet Item à ajouter à la liste principale ---
      final newItem = Item(
        // Le nom combine le modèle et l'immatriculation pour correspondre au format existant
        name: '${_selectedName!} (${_immatController.text.toUpperCase()})',
        description: description,
        detail: detail,
        imageAsset: _defaultImage,
        effectiveDate: _selectedDate!,
      );

      // --- Fermeture de l'écran et envoi du nouvel Item au widget parent ---
      Navigator.pop(context, newItem);
    }
  }

  Future<void> _presentDatePicker() async {
    // --- Définition des bornes de la sélection de date (aujourd'hui + 90 jours) ---
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    DateTime initialDate = today;
    final firstDate = today;
    final lastDate = today.add(const Duration(days: 90));

    // --- Affichage du sélecteur de date natif ---
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
      locale: const Locale('fr'),
    );

    setState(() {
      // --- Mise à jour de la variable d'état après la sélection de la date ---
      _selectedDate = pickedDate;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // --- Barre d'application avec titre et couleur personnalisée ---
        title: const Text("Ajouter un nouveau contrat"),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        // --- Permet de faire défiler le contenu si le clavier est actif ---
        padding: const EdgeInsets.all(16.0),
        child: Form(
          // --- Association de la clé de validation au formulaire ---
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // --- Séparation et titre de section pour l'identification ---
              const Text('1. Identification du Contrat',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 10),

              // --- CHAMP 1 : NOM (Liste Déroulante - Modèle) ---
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

              // --- CHAMP 2 : Plaque du véhicule (Texte) ---
              _buildTextField(
                  _immatController, "Plaque d'immatriculation", Icons.badge, isImmat: true),
              const SizedBox(height: 20),

              // --- CHAMP 3 : Type de véhicule (Liste Déroulante) ---
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

              // --- Séparation et titre de section pour les caractéristiques ---
              const Text('2. Caractéristiques techniques',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 10),

              // --- CHAMP 4 : Motorisation (Liste Déroulante) ---
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

              // --- CHAMP 5 : Puissance fiscale (Texte, Numérique) ---
              _buildTextField(_puissanceController, "Chevaux fiscaux", Icons.flash_on, isNumeric: true),
              const SizedBox(height: 20),

              // --- Séparation et titre de section pour les données d'usage ---
              const Text('3. Données d’usage',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 10),

              // --- CHAMP 6 : Fréquence (Liste Déroulante) ---
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

              // --- CHAMP 7 : Kilométrage annuel (Texte, Numérique) ---
              _buildTextField(_kilometrageController, "Kilométrage annuel estimé", Icons.speed, isNumeric: true),
              const SizedBox(height: 30),

              // --- CHAMP 8 : Date d'effet (ListTile cliquable) ---
              ListTile(
                title: Text(
                  // --- Affichage conditionnel de la date ou d'un message d'incitation ---
                  _selectedDate == null
                      ? 'Veuillez sélectionner la date d\'effet du contrat'
                      : 'Date d\effet du contrat : ${DateFormat('dd/MM/yyyy').format(_selectedDate!)}',

                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black54,
                  ),
                ),
                trailing: const Icon(
                  Icons.calendar_today,
                  size: 28,
                  color: Colors.black54,
                ),
                // --- Appel de la méthode pour afficher le sélecteur de date ---
                onTap: _presentDatePicker,
                contentPadding: EdgeInsets.zero,
              ),

              const SizedBox(height: 30),

              // --- Bouton principal d'enregistrement du formulaire ---
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

  // --- Widget utilitaire pour les champs de texte (TextFormField) ---
  Widget _buildTextField(TextEditingController controller, String label,
      IconData icon, {int maxLines = 1, bool isNumeric = false, bool isImmat = false}) {

    // --- Expression régulière pour valider le format d'immatriculation (ex: AA-111-AA) ---
    final RegExp immatRegExp = RegExp(r'^[A-Z]{2}-\d{3}-[A-Z]{2}$');

    return TextFormField(
      controller: controller,
      // --- Ajustement du clavier en fonction du type de données attendu ---
      keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
      // --- Mise en majuscules automatique pour l'immatriculation ---
      textCapitalization: isImmat ? TextCapitalization.characters : TextCapitalization.none,
      // --- Limite de longueur pour l'immatriculation (AA-111-AA fait 9 caractères) ---
      maxLength: isImmat ? 9 : null,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: const OutlineInputBorder(),
        counterText: '', // --- Supprime le compteur de caractères par défaut ---
      ),
      maxLines: maxLines,
      validator: (value) {
        // --- Validation de base pour les champs obligatoires ---
        if (value == null || value.isEmpty) {
          return 'Ce champ est obligatoire.';
        }

        // --- Validation spécifique du format d'immatriculation ---
        if (isImmat && !immatRegExp.hasMatch(value.toUpperCase())) {
          return 'Le format doit être de type AA-111-AA';
        }

        return null; // --- La validation est réussie ---
      },
    );
  }

  // --- Widget utilitaire pour la liste déroulante (DropdownButtonFormField) ---
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
        // --- Validation : s'assurer qu'une option a été sélectionnée ---
        if (value == null || value.isEmpty) {
          return 'Veuillez sélectionner une option.';
        }
        return null;
      },
    );
  }
}