// ignore_for_file: invalid_use_of_protected_member

import 'package:get/get.dart';
import 'package:moneyrecord/data/model/history_model.dart';
import 'package:moneyrecord/data/model/source/source_history.dart';

class CHistory extends GetxController {
  final _loading = false.obs;
  bool get loading => _loading.value;

  final _list = <History>[].obs;
  List<History> get list => _list.value;

  getList(idUser) async {
    _loading.value = true;
    update();

    _list.value = await SourceHistory.history(idUser);
    update();

    Future.delayed(const Duration(milliseconds: 1500), () {
      _loading.value = false;
      
      update();
    });
  }

   search(idUser, date) async {
    _loading.value = true;
    update();

    _list.value = await SourceHistory.historySearch(idUser, date);
    update();

    Future.delayed(const Duration(milliseconds: 1500), () {
      _loading.value = false;
      update();
    });
  }
}
