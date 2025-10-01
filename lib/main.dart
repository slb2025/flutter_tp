import 'package:flutter/material.dart';
import 'package:tp_widget/models/item.dart';
import 'package:tp_widget/widgets/item_card.dart';
import 'package:tp_widget/widgets/new_contract_screen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  runApp(const MyApp());
}

// --- Widget racine de l'application ---
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SLB Assur',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        useMaterial3: true,
      ),
      // --- Configuration des localisations (pour le français) ---
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      supportedLocales: const [
        Locale('fr', ''),
      ],

      // --- Définition de l'écran d'accueil ---
      home: const HomeScreen(),
    );
  }
}

// --- Widget de l'écran d'accueil (Stateful) ---
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  // --- Liste des contrats (état géré) ---
  List<Item> _contracts = Item.items;

  // --- Variable d'état pour la BottomNavigationBar ---
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  // --- Fonction pour ajouter un nouveau contrat ---
  void _addNewContract(Item newContract) {
    setState(() {
      _contracts.add(newContract);
      // Optionnel : s'assurer que l'onglet 'Mes assurances' est sélectionné
      _selectedIndex = 0;
    });
  }

  // --- Gestion du clic sur la BottomNavigationBar ---
  void _onItemTapped(int index) async {
    if (index == 1) {
      // --- Logique pour l'ajout (ouverture de NewContractScreen) ---
      final Item? newContract = await Navigator.of(context).push(
        MaterialPageRoute<Item>(
          builder: (context) => const NewContractScreen(),
        ),
      );
      if (newContract != null) {
        _addNewContract(newContract);
      }
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  // --- Fonction pour retirer un contrat ---
  void _removeContract(Item contract) {
    setState(() {
      _contracts.remove(contract);
    });
  }

  @override
  Widget build(BuildContext context) {

    // --- Contenu de l'onglet actif (ici, seulement l'onglet 0 est implémenté) ---
    final List<Widget> widgetOptions = <Widget>[
      ItemListContent(
        items: _contracts,
        onAddContract: _addNewContract,
        onRemoveContract: _removeContract,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: false,

        // --- Titre de la barre d'application ---
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon (
              Icons.directions_car,
              color: Colors.white,
              size: 20,
            ),
            SizedBox(width: 10),
            Text(
              "Mes véhicules assurés",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),

        // --- Actions (icônes de recherche et paramètres) ---
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: () {
            },
          ),
        ],
      ),

      // --- Corps de l'application (affiche le contenu de la liste) ---
      body: widgetOptions.elementAt(0),

      // --- Barre de navigation inférieure ---
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        selectedItemColor: Colors.blue[300],
        unselectedItemColor: Colors.white70,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,

        // --- Items de la barre de navigation ---
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.folder),
            label: 'Mes contrats d\'assurance',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline),
            label: 'Ajouter un nouveau contrat',
          ),
        ],
      ),
    );
  }
}

// --- Widget séparé pour le contenu de la liste des items (Stateless) ---
class ItemListContent extends StatelessWidget {
  final List<Item> items;
  final Function(Item) onAddContract;
  final Function(Item) onRemoveContract;

  const ItemListContent({
    super.key,
    required this.items,
    required this.onAddContract,
    required this.onRemoveContract,
  });

  @override
  Widget build(BuildContext context) {
    // --- Construction de la liste par ItemCard ---
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return ItemCard(
          item: item,
          // --- Passer la fonction de suppression à ItemCard ---
          onTapDelete: () => onRemoveContract(item),
        );
      },
    );
  }
}