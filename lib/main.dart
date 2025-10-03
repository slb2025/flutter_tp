import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tp_widget/models/item.dart';
import 'package:tp_widget/widgets/contract_form_screen.dart';
import 'package:tp_widget/widgets/item_card.dart';
import 'package:tp_widget/widgets/item_detail_screen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'providers/contract_manager.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ContractManager(),
      child: const MyApp(),
    ),
  );
}

final GoRouter _router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/new_contract',
      builder: (context, state) => const ContractFormScreen(),
    ),
    GoRoute(
      path: '/detail',
      builder: (context, state) {
        final item = state.extra as Item;
        return ItemDetailScreen(item: item);
      },
    ),
    GoRoute(
        path: '/edit_contract',
        builder: (context, state) {
          final itemToEdit = state.extra as Item;
          return ContractFormScreen(itemToEdit: itemToEdit);
        }
    )
  ],
);


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

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  int _selectedIndex = 0;

  void _onItemTapped(int index) async {
    final manager = context.read<ContractManager>();

    if (index == 1) {
      final Item? newContract = await context.push<Item?>(
        '/new_contract',
      );
      if (newContract != null) {
        manager.addNewContract(newContract);
      }
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Item> contracts = context.watch<ContractManager>().contracts;

    final List<Widget> widgetOptions = <Widget>[
      ItemListContent(
        items: contracts,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: false,

        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon (
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

      body: widgetOptions.elementAt(_selectedIndex),

      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        selectedItemColor: Colors.blue[300],
        unselectedItemColor: Colors.white70,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
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

class ItemListContent extends StatelessWidget {
  final List<Item> items;

  const ItemListContent({
    super.key,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    final manager = context.read<ContractManager>();

    return ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return ItemCard(
              item: item,
              onTapDelete: () => manager.removeContract(item),
              onTapDetail: () async {
                final Item oldItem = item;
                final Item? updatedItem = await context.push<Item?>(
                  '/detail',
                  extra: oldItem,
                );
                if (updatedItem != null) {
                  manager.updateContractInList(oldItem, updatedItem);
                }
              }
          );
        }
    );
  }
}