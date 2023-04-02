import 'package:d_info/d_info.dart';
import 'package:d_view/d_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:intl/intl.dart';

import 'package:moneyrecord/config/app_color.dart';
import 'package:moneyrecord/config/app_format.dart';
import 'package:moneyrecord/data/model/history_model.dart';
import 'package:moneyrecord/data/model/source/source_history.dart';
import 'package:moneyrecord/presentation/controller/c_history.dart';

import 'package:moneyrecord/presentation/controller/c_user.dart';

import 'detail_history_page.dart';

class HistoryData extends StatefulWidget {
  const HistoryData({
    super.key,
  });

  @override
  State<HistoryData> createState() => _HistoryDataState();
}

class _HistoryDataState extends State<HistoryData> {
  final cHistory = Get.put(CHistory());
  final cUser = Get.put(CUser());
  final controllsearch = TextEditingController();
  refresh() {
    cHistory.getList(cUser.data.idUser!);
  }

  delete(String idHistory) async {
    bool? yes = await DInfo.dialogConfirmation(context, 'Delete',
        'Apakah kamu yakin ingin menghapus history ini? Tindakan ini tidak dapat dibatalkan.');
    if (yes!) {
      bool success = await SourceHistory.delete(idHistory);
      if (success) refresh();
    }
  }

  @override
  void initState() {
    refresh();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(
              ('Riwayat'),
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: AppColor.secondary),
            ),
            Expanded(
              child: SizedBox(
                height: 70,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: TextField(
                    controller: controllsearch,
                    onTap: () async {
                      DateTime? result = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000, 01, 01),
                        lastDate: DateTime(DateTime.now().year + 1),
                      );
                      if (result != null) {
                        controllsearch.text =
                            DateFormat('yyyy-MM-dd').format(result);
                      }
                    },
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32),
                            borderSide: BorderSide.none),
                        fillColor: AppColor.chart.withOpacity(0.5),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.search),
                          alignment: Alignment.center,
                          color: Colors.white,
                          iconSize: 24,
                          onPressed: () {
                            cHistory.search(
                                cUser.data.idUser!, controllsearch.text);
                          },
                        ),
                        isDense: true,
                        isCollapsed: true,
                        hintText: 'Input Date',
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 8),
                        hintStyle: Theme.of(context)
                            .textTheme
                            .displayMedium!
                            .copyWith(
                                fontSize: 16,
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.w500,
                                color: AppColor.secondary.withOpacity(0.5)),
                        filled: true),
                    textAlign: TextAlign.center,
                    textAlignVertical: TextAlignVertical.center,
                    style: Theme.of(context).textTheme.displayMedium!.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: AppColor.secondary),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
      body: GetBuilder<CHistory>(builder: (_) {
        if (_.loading) return DView.loadingCircle();
        if (_.list.isEmpty) return DView.empty('Kosong');
        return RefreshIndicator(
          onRefresh: () async => refresh(),
          child: ListView.builder(
              itemCount: _.list.length,
              itemBuilder: (context, index) {
                History history = _.list[index];

                return Card(
                  elevation: 4,
                  margin: EdgeInsets.fromLTRB(16, index == 0 ? 16 : 8, 16,
                      index == _.list.length - 1 ? 16 : 8),
                  child: InkWell(
                    onTap: () {
                      Get.to(() => DetailHistoryPage(
                            date: history.date!,
                            idUser: cUser.data.idUser!,
                            type: history.type!,
                          ));
                    },
                    child: Row(children: [
                      DView.spaceWidth(),
                      history.type == 'Pemasukan'
                          ? Icon(
                              Icons.south_west,
                              color: Colors.green[300]!,
                            )
                          : const Icon(
                              Icons.north_east,
                              color: Colors.red,
                            ),
                      DView.spaceWidth(),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          AppFormat.date(history.date!),
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: AppColor.primary),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          AppFormat.currency(history.total!),
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: AppColor.primary),
                          textAlign: TextAlign.end,
                        ),
                      ),
                      IconButton(
                          onPressed: () => delete(history.idHistory!),
                          icon: Icon(
                            Icons.delete_forever,
                            color: Colors.red[300]!,
                          ))
                    ]),
                  ),
                );
              }),
        );
      }),
    );
  }
}
