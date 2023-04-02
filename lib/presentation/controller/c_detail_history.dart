
import 'package:get/get.dart';
import 'package:moneyrecord/data/model/history_model.dart';

import 'package:moneyrecord/data/model/source/source_history.dart';

class CDetailHistory extends GetxController {
  final _data = History().obs;
  History get data => _data.value;

  getData(idUser, date, type) async {
    History? history = await SourceHistory.detail(idUser, date, type);
    _data.value = history ?? History();
    update();
  }
}
