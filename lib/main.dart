import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tp_widget/models/item.dart';
import 'package:tp_widget/widgets/contract_form_screen.dart';
import 'package:tp_widget/widgets/item_card.dart';
import 'package:tp_widget/widgets/item_detail_screen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  runApp(const MyApp());
}

// --- Configuration GoRouter ---
final GoRouter _router = GoRouter(
  initialLocation: '/',
  routes: [
    // ... (Route Principale inchangée) ...
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
    ),

    // Route pour Ajouter un Contrat (Utilise le nouveau widget sans argument)
    GoRoute(
      path: '/new_contract',
      // Utilise ContractFormScreen
      builder: (context, state) => const ContractFormScreen(),
    ),

    // Route pour les Détails (inchangée)
    GoRoute(
      path: '/detail',
      builder: (context, state) {
        final item = state.extra as Item;
        return ItemDetailScreen(item: item);
      },
    ),

    // Route pour l'édition (Utilise le nouveau widget avec l'argument itemToEdit)
    GoRoute(
        path: '/edit_contract',
        builder: (context, state) {
          final itemToEdit = state.extra as Item;
          // Utilise ContractFormScreen avec l'objet à modifier
          return ContractFormScreen(itemToEdit: itemToEdit);
        }
    )
  ],
);


// --- Widget racine de l'application (Stateless) ---
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
        title: 'SLB Assur',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blueGrey,
          useMaterial3: true,
        ),

        routerConfig: _router,

        // --- Configuration des localisations (pour le français) ---
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],

        supportedLocales: const [
          Locale('fr', ''),
        ],
    );
  }
}

// --- Widget de l'écran d'accueil (Stateful) ---
// Gère l'état principal de l'application : la liste des contrats.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  // --- Liste des contrats (état géré par l'état du widget) ---
  List<Item> _contracts = Item.items;

  // --- Variable d'état pour la BottomNavigationBar ---
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  // --- Fonction pour ajouter un nouveau contrat ---
  // Met à jour l'état (_contracts) et retourne sur le premier onglet.
  void _addNewContract(Item newContract) {
    setState(() {
      _contracts.add(newContract);
      _selectedIndex = 0;
    });
  }

  // --- Fonction pour mettre à jour un contrat existant ---
  void _updateContractInList(Item oldContract, Item updatedContract) {
    setState(() {
      // On trouve l'index de l'ancien contrat pour le remplacer
      final index = _contracts.indexOf(oldContract);
      if (index != -1) {
        _contracts[index] = updatedContract;
      }
      _selectedIndex = 0; // Revenir à l'onglet de la liste
    });
  }

  // --- Gestion du clic sur la BottomNavigationBar ---
  void _onItemTapped(int index) async {
    if (index == 1) {
      // --- Logique pour l'ajout (ouverture de NewContractScreen) ---
      final Item? newContract = await context.push<Item?>(
        '/new_contract',
      );
      if (newContract != null) {
        _addNewContract(newContract);
      }
    } else {
      // Changement d'onglet (si index est 0 ou autre)
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
    // Cette liste permet d'intégrer d'autres vues si des onglets supplémentaires sont ajoutés.
    final List<Widget> widgetOptions = <Widget>[
      ItemListContent(
        items: _contracts,
        onAddContract: _addNewContract, // Passé pour pouvoir être utilisé dans d'autres contextes futurs.
        onRemoveContract: _removeContract,
        onUpdatedContract: _updateContractInList,
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
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),

      // --- Corps de l'application (affiche le contenu de la liste) ---
      // Affiche le contenu de l'onglet sélectionné.
      body: widgetOptions.elementAt(_selectedIndex), // Correction: utilise _selectedIndex

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
// Ce widget reçoit la liste d'items et les fonctions de gestion de l'état en paramètre.
class ItemListContent extends StatelessWidget {
  final List<Item> items;
  final Function(Item) onAddContract;
  final Function(Item) onRemoveContract;
  final Function(Item oldItem, Item updatedItem) onUpdatedContract;


  const ItemListContent({
    super.key,
    required this.items,
    required this.onAddContract,
    required this.onRemoveContract,
    required this.onUpdatedContract,
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
            onTapDelete: () => onRemoveContract(item),
            onTapDetail: () async {
              final Item oldItem = item;
              final Item? updatedItem = await context.push<Item?>(
                '/detail',
                extra: oldItem,
              );
              if (updatedItem != null) {
                onUpdatedContract(oldItem, updatedItem);
              }
            }
        );
      }
    );
  }
}