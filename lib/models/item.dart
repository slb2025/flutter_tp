// --- Définition de la classe de modèle 'Item' ---
class Item {

  // --- Propriétés (champs) de l'objet Item ---
  final String name; // Nom / Modèle du véhicule (ex: 'Peugeot 308')
  final String immat; // Immatriculation (ex: 'AB-123-CD')
  final String description;
  final String? detail;
  final String imageAsset;
  final DateTime effectiveDate;

  // --- Constructeur de la classe Item ---
  const Item ({
    required this.name,
    required this.immat, // NOUVEAU CHAMP EXIGÉ
    required this.description,
    this.detail,
    required this.imageAsset,
    required this.effectiveDate,
  });

  // --- Liste statique des items par défaut (données initiales) ---
  static List<Item> items = [
    Item(
      name: 'Peugeot 308',
      immat: 'AB-123-CD',
      // 1. DESCRIPTION (Administratif) : Contrat n° et Garantie
      description: 'Contrat n°: PGT308-001 | Garantie: Tous Risques',
      // 2. DETAIL (Technique et Usage) : Type, Moteur, Puissance, Usage, Fréquence, Km/an
      detail: 'Type: Particulier | Moteur: Essence | Puissance: 7 CV | Usage: Privé/Travail | Fréquence: Quotidienne | Km/an: 15000',
      imageAsset: 'assets/peugeot_308.webp',
      effectiveDate: DateTime(2024, 1, 1),
    ),
    Item(
      name: 'Renault Clio V',
      immat: 'EF-456-GH',
      // 1. DESCRIPTION (Administratif)
      description: 'Contrat n°: RNVCL5-002 | Garantie: Tiers Plus',
      // 2. DETAIL (Technique et Usage)
      detail: 'Type: Professionnel | Moteur: Diesel | Puissance: 5 CV | Usage: Commercial | Fréquence: Quotidienne | Km/an: 30000',
      imageAsset: 'assets/renault_clioV.webp',
      effectiveDate: DateTime(2023, 5, 15),
    ),
    Item(
      name: 'Moto Yamaha MT-07',
      immat: 'IJ-789-KL',
      // 1. DESCRIPTION (Administratif)
      description: 'Contrat n°: YMMT07-003 | Garantie: Tiers Collision',
      // 2. DETAIL (Technique et Usage)
      detail: 'Type: Moto | Moteur: Essence | Puissance: 6 CV | Usage: Loisir | Fréquence: Occasionnelle | Km/an: 5000',
      imageAsset: 'assets/yamaha_mt07.webp',
      effectiveDate: DateTime(2024, 3, 1),
    ),
    Item(
      name: 'Tesla Model 3',
      immat: 'GH-333-JK',
      // 1. DESCRIPTION (Administratif)
      description: 'Contrat n°: TSLA3-004 | Garantie: Tous Risques +',
      // 2. DETAIL (Technique et Usage)
      detail: 'Type: Particulier | Moteur: Électrique | Puissance: 12 CV | Usage: Privé | Fréquence: Quotidienne | Km/an: 20000',
      imageAsset: 'assets/tesla_model3.webp', // Assurez-vous d'avoir cette image.
      effectiveDate: DateTime(2025, 2, 10),
    ),
  ];
}