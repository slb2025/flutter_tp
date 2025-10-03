import 'package:flutter/material.dart';
import '../models/item.dart';

class ContractManager extends ChangeNotifier {
  List<Item> _contracts = Item.items;

  List<Item> get contracts => _contracts;

  void addNewContract(Item newContract) {
    _contracts.add(newContract);
    notifyListeners();
  }

  void updateContractInList(Item oldContract, Item updatedContract) {
    final index = _contracts.indexOf(oldContract);
    if (index != -1) {
      _contracts[index] = updatedContract;
      notifyListeners();
    }
  }

  void removeContract(Item contract) {
    _contracts.remove(contract);
    notifyListeners();
  }
}