import 'package:d_info/d_info.dart';
import 'package:d_view/d_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:intl/intl.dart';
import 'package:moneyrecord/config/app_asset.dart';

import 'package:moneyrecord/config/app_color.dart';
import 'package:moneyrecord/config/app_format.dart';
import 'package:moneyrecord/data/model/history_model.dart';
import 'package:moneyrecord/data/model/source/source_history.dart';
import 'package:moneyrecord/presentation/controller/c_income_outcome.dart';
import 'package:moneyrecord/presentation/controller/c_user.dart';
import 'package:moneyrecord/presentation/page/history/update_history_page.dart';

import 'detail_history_page.dart';

class IncomeOutcome extends StatefulWidget {
  const IncomeOutcome({super.key, required this.type});
  final String type;

  @override
  State<IncomeOutcome> createState() => _IncomeOutcomeState();
}

class _IncomeOutcomeState extends State<IncomeOutcome> {
  final cIncomeOutcome = Get.put(CIncomeOutcome());
  final cUser = Get.put(CUser());
  final controllsearch = TextEditingController();
  refresh() {
    cIncomeOutcome.getList(cUser.data.idUser!, widget.type);
  }

  menuOption(String value, History history) async {
    if (value == 'update') {
      Get.to(() => UpdateHistory(
            date: history.date!,
            idHistory: history.idHistory!,
          ))?.then((value) {
        if (value ?? false) {
          refresh();
        }
      });
    } else if (value == 'delete') {
      bool? yes = await DInfo.dialogConfirmation(context, 'Delete',
          'Apakah kamu yakin ingin menghapus history ini? Tindakan ini tidak dapat dibatalkan.');
      if (yes!) {
        bool success = await SourceHistory.delete(history.idHistory!);
        if (success) refresh();
      }
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
              (widget.type),
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
                            cIncomeOutcome.search(cUser.data.idUser!,
                                widget.type, controllsearch.text);
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
      body: GetBuilder<CIncomeOutcome>(builder: (_) {
        if (_.loading) return DView.loadingCircle();
        if (_.list.isEmpty) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(AppAsset.emptyState2),
              Text('Kosong',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .copyWith(fontSize: 16, fontWeight: FontWeight.w500)),
              DView.spaceHeight(200)
            ],
          );
        }
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
                    borderRadius: BorderRadius.circular(4),
                    child: Row(children: [
                      DView.spaceHeight(),
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
                      PopupMenuButton<String>(
                        itemBuilder: (context) => [
                          const PopupMenuItem(
                              value: 'update', child: Text('Update')),
                          const PopupMenuItem(
                              value: 'delete', child: Text('Delete'))
                        ],
                        onSelected: (value) {
                          menuOption(value, history);
                        },
                      )
                    ]),
                  ),
                );
              }),
        );
      }),
    );
  }
}
