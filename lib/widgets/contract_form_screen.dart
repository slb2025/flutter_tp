import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import 'package:tp_widget/models/item.dart';
import '../models/vehicle_api_data.dart';
import '../services/vehicle_api_service.dart';


const List<String> _vehicleNames = [
  'Peugeot 308',
  'Renault Clio V',
  'Moto Yamaha MT-07',
];

const List<String> _typeVehiculeOptions = ['4 Roues', '2 Roues'];
const List<String> _usageOptions = ['Particulier', 'Professionnel'];
const List<String> _motorisationOptions = [
  'Essence',
  'Diesel',
  'Hybride',
  'Électrique',
];
const List<String> _frequenceOptions = ['Quotidienne', 'Occasionnelle'];

const List<String> _garantieOptions = [
  'Tous Risques',
  'Tous Risques Plus',
  'Tiers Plus (Vol/Incendie)',
  'Tiers Simple',
  'Tous Risques Moto',
  'Tiers Collision',
  'Tiers Simple Moto',
];

class ContractFormScreen extends StatefulWidget {
  final Item? itemToEdit;

  const ContractFormScreen({super.key, this.itemToEdit});

  @override
  State<ContractFormScreen> createState() => _ContractFormScreenState();
}

class _ContractFormScreenState extends State<ContractFormScreen> {
  String? _selectedName;
  String? _selectedVehicleType;
  String? _selectedMotorisation;
  String? _selectedUsage;
  String? _selectedFrequence;
  DateTime? _selectedDate;
  String? _selectedWarranty;

  VehicleApiData? _apiData;
  bool _isLoading = false;
  late final VehicleApiService _apiService;

  _ContractFormScreenState() {
    _apiService = VehicleApiService();
  }

  final TextEditingController _puissanceController = TextEditingController();
  final TextEditingController _kilometrageController = TextEditingController();
  final TextEditingController _immatController = TextEditingController();
  final TextEditingController _contractNumberController = TextEditingController();

  final String _defaultImage = 'assets/peugeot_308.webp';

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _extractValue(String source, String key, [String defaultValue = 'Non renseigné']) {
    if (source.isEmpty) return defaultValue;
    final regex = RegExp('$key: (.+?)(\\s*\\||\$)');
    final match = regex.firstMatch(source);

    String value = match != null ? match.group(1)!.trim() : defaultValue;

    if (key == 'Puissance' && value.endsWith(' CV')) {
      return value.replaceAll(' CV', '');
    }

    if (value == 'Non renseigné' || value == 'Non spécifié' || value.contains('Km/an')) {
      return '';
    }

    return value;
  }

  Future<void> _fetchVehicleData() async {
    setState(() {
      _isLoading = true;
    });

    final vehicleData = await _apiService.fetchVehicleData(1);

    if (vehicleData != null) {
      setState(() {
        _apiData = vehicleData;
        _contractNumberController.text = 'API-${vehicleData.id}';
        _selectedMotorisation = vehicleData.completed ? 'Hybride' : 'Essence';
      });
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();

    if (widget.itemToEdit != null) {
      final Item item = widget.itemToEdit!;

      _selectedName = _vehicleNames.contains(item.name) ? item.name : null;
      _selectedDate = item.effectiveDate;
      _immatController.text = item.immat;

      _contractNumberController.text = _extractValue(item.description, 'Contrat n°', '');
      final existingWarranty = _extractValue(item.description, 'Garantie');
      _selectedWarranty = _garantieOptions.contains(existingWarranty) ? existingWarranty : null;

      final detailSource = item.detail ?? '';

      final existingType = _extractValue(detailSource, 'Type');
      _selectedVehicleType = _typeVehiculeOptions.contains(existingType) ? existingType : null;

      final existingMotorisation = _extractValue(detailSource, 'Moteur');
      _selectedMotorisation = _motorisationOptions.contains(existingMotorisation) ? existingMotorisation : null;

      _puissanceController.text = _extractValue(detailSource, 'Puissance');

      final existingUsage = _extractValue(detailSource, 'Usage');
      _selectedUsage = _usageOptions.contains(existingUsage) ? existingUsage : null;

      final existingFrequence = _extractValue(detailSource, 'Fréquence');
      _selectedFrequence = _frequenceOptions.contains(existingFrequence) ? existingFrequence : null;

      _kilometrageController.text = _extractValue(detailSource, 'Km/an');

    } else {
      _selectedDate = DateTime.now();
      _fetchVehicleData();
    }
  }

  @override
  void dispose() {
    _puissanceController.dispose();
    _kilometrageController.dispose();
    _immatController.dispose();
    _contractNumberController.dispose();
    super.dispose();
  }

  void _handleSubmit(BuildContext context) {
    if (_formKey.currentState!.validate() &&
        _selectedName != null &&
        _selectedDate != null) {

      final description =
          "Contrat n°: ${_contractNumberController.text.trim().isEmpty ? 'Non renseigné' : _contractNumberController.text} | "
          "Garantie: ${_selectedWarranty ?? 'Non renseigné'}";

      final detailTechnique =
          "Type: ${_selectedVehicleType ?? 'Non spécifié'} | "
          "Moteur: ${_selectedMotorisation ?? 'Non spécifié'} | "
          "Puissance: ${_puissanceController.text.trim().isEmpty ? 'Non renseigné' : _puissanceController.text + ' CV'}";

      final detailUsage =
          "Usage: ${_selectedUsage ?? 'Non spécifié'} | "
          "Fréquence: ${_selectedFrequence ?? 'Non spécifié'} | "
          "Km/an: ${_kilometrageController.text.trim().isEmpty ? 'Non renseigné' : _kilometrageController.text}";

      final detail = detailTechnique + " | " + detailUsage;

      final imageAsset = widget.itemToEdit != null
          ? widget.itemToEdit!.imageAsset
          : _defaultImage;

      final resultItem = Item(
        name: _selectedName!,
        immat: _immatController.text.toUpperCase(),
        description: description,
        detail: detail,
        imageAsset: imageAsset,
        effectiveDate: _selectedDate!,
      );

      context.pop(resultItem);
    }
  }

  Future<void> _presentDatePicker() async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    DateTime initialDate = _selectedDate ?? today;

    final firstDate = today.subtract(const Duration(days: 365 * 10));
    final lastDate = today.add(const Duration(days: 90));

    final pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
      locale: const Locale('fr'),
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.itemToEdit != null;
    final appBarTitle = isEditing
        ? "Éditer le contrat : ${widget.itemToEdit!.name}"
        : "Ajouter un nouveau contrat";
    final buttonText = isEditing ? 'Mettre à jour le contrat' : 'Enregistrer le contrat';

    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 10),
              Text("Chargement des données techniques..."),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(appBarTitle),
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

              _buildTextField(
                  _immatController, "Plaque d'immatriculation", Icons.badge, isImmat: true),
              const SizedBox(height: 20),

              _buildTextField(_contractNumberController, "Numéro de contrat", Icons.receipt_long),
              const SizedBox(height: 20),

              _buildDropdownField(
                value: _selectedVehicleType,
                label: "Type de véhicule (2 ou 4 roues)",
                icon: Icons.category,
                options: _typeVehiculeOptions,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedVehicleType = newValue;
                  });
                },
              ),
              const SizedBox(height: 20),

              _buildDropdownField(
                value: _selectedWarranty,
                label: "Type de Garantie",
                icon: Icons.shield,
                options: _garantieOptions,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedWarranty = newValue;
                  });
                },
              ),
              const SizedBox(height: 20),

              _buildDropdownField(
                value: _selectedUsage,
                label: "Usage (Particulier ou Professionnel)",
                icon: Icons.work,
                options: _usageOptions,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedUsage = newValue;
                  });
                },
              ),
              const SizedBox(height: 20),

              const Text('2. Caractéristiques techniques',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 10),

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

              _buildTextField(_puissanceController, "Chevaux fiscaux", Icons.flash_on, isNumeric: true),
              const SizedBox(height: 20),

              const Text('3. Données d’usage',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 10),

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

              _buildTextField(_kilometrageController, "Kilométrage annuel estimé", Icons.speed, isNumeric: true),
              const SizedBox(height: 30),

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
                trailing: const Icon(
                  Icons.calendar_today,
                  size: 28,
                  color: Colors.black54,
                ),
                onTap: _presentDatePicker,
                contentPadding: EdgeInsets.zero,
              ),

              const SizedBox(height: 30),

              ElevatedButton(
                onPressed: () => _handleSubmit(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                child: Text(
                  buttonText,
                  style: const TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller,
      String label,
      IconData icon, {
        int maxLines = 1,
        bool isNumeric = false,
        bool isImmat = false,
      }) {
    final RegExp immatRegExp = RegExp(r'^[A-Z]{2}-\d{3}-[A-Z]{2}$');

    return TextFormField(
      controller: controller,
      keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
      textCapitalization: isImmat
          ? TextCapitalization.characters
          : TextCapitalization.none,
      maxLength: isImmat ? 9 : null,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: const OutlineInputBorder(),
        counterText:
        '',
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
            child: Text(option));
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