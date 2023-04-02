// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:d_input/d_input.dart';
import 'package:d_view/d_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:moneyrecord/config/app_color.dart';
import 'package:moneyrecord/config/app_format.dart';
import 'package:moneyrecord/data/model/source/source_history.dart';

import 'package:moneyrecord/presentation/controller/c_home.dart';
import 'package:moneyrecord/presentation/controller/c_update_history.dart';

import '../../controller/c_user.dart';

class UpdateHistory extends StatefulWidget {
  const UpdateHistory({super.key, required this.date, required this.idHistory});
  final String date;
  final String idHistory;

  @override
  State<UpdateHistory> createState() => _UpdateHistoryState();
}

class _UpdateHistoryState extends State<UpdateHistory> {
  final cUpdateHistory = Get.put(CUpdateHistory());

  final cUser = Get.put(CUser());

  final cHome = Get.put(CHome());

  final controllerName = TextEditingController();

  final controllerPrice = TextEditingController();

  updateHistory() async {
    bool success = await SourceHistory.update(
        widget.idHistory,
        cUser.data.idUser!,
        cUpdateHistory.date,
        cUpdateHistory.type,
        jsonEncode(cUpdateHistory.items),
        cUpdateHistory.total.toString());
    if (success) {
      Future.delayed(const Duration(milliseconds: 5000), () {
        Get.back(result: true);
      });
    }
  }

  @override
  void initState() {
    cUpdateHistory.init(cUser.data.idUser, widget.date);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DView.appBarLeft('Update'),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Builder(builder: (context) {
                  return Text(
                    'Tanggal',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge!
                        .copyWith(fontSize: 16, fontWeight: FontWeight.bold),
                  );
                }),
                Row(
                  children: [
                    Obx(() {
                      return Text(
                        cUpdateHistory.date,
                        style: Theme.of(context)
                            .textTheme
                            .displayLarge!
                            .copyWith(
                                fontSize: 20, fontWeight: FontWeight.w400),
                      );
                    }),
                    DView.spaceWidth(),
                    ElevatedButton.icon(
                      onPressed: () async {
                        DateTime? result = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2002, 06, 22),
                          lastDate: DateTime(DateTime.now().year + 1),
                        );
                        if (result != null) {
                          cUpdateHistory
                              .setDate(DateFormat('yyyy-MM-dd').format(result));
                        }
                      },
                      icon: const Icon(Icons.event),
                      label: const Text('Pilih'),
                    )
                  ],
                ),
                DView.spaceHeight(),
                Text(
                  'Tipe',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .copyWith(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                DView.spaceHeight(8),
                InputTipeBox(),
                DView.spaceHeight(),
                Text(
                  'Nama Item',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .copyWith(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                DView.spaceHeight(),
                InputNameItemBox(controllerName),
                DView.spaceHeight(),
                Text(
                  'Harga',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .copyWith(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                DView.spaceHeight(),
                InputPriceBox(controllerPrice),
              ],
            ),
            DView.spaceHeight(),
            addItemsButton(controllerName, controllerPrice, context),
            DView.spaceHeight(),
            Center(
              child: Container(
                height: 4,
                width: 80,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: AppColor.primary),
              ),
            ),
            Text(
              'Items',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            DView.spaceHeight(),
            ItemsOutputBox(),
            DView.spaceHeight(),
            Row(
              children: [
                Text(
                  'Total :',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .copyWith(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                DView.spaceWidth(),
                Obx(() {
                  return Text(
                    AppFormat.currency(cUpdateHistory.total.toString()),
                    style: Theme.of(context).textTheme.displayLarge!.copyWith(
                        fontSize: 32,
                        color: AppColor.primary,
                        fontWeight: FontWeight.w900),
                  );
                }),
              ],
            ),
            DView.spaceHeight(32),
            Material(
              color: AppColor.primary,
              borderRadius: BorderRadius.circular(16),
              child: InkWell(
                child: Center(
                    child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Text(
                    'SUBMIT',
                    style: Theme.of(context).textTheme.labelLarge!.copyWith(
                        color: AppColor.secondary,
                        fontSize: 16,
                        fontWeight: FontWeight.w600),
                  ),
                )),
                onTap: () => updateHistory(),
              ),
            )
          ],
        ),
      ),
    );
  }

  ElevatedButton addItemsButton(TextEditingController controllerName,
      TextEditingController controllerPrice, BuildContext context) {
    return ElevatedButton(
        onPressed: () {
          cUpdateHistory.addItem({
            'name': controllerName.text,
            'price': controllerPrice.text,
          });

          controllerName.clear();
          controllerPrice.clear();
        },
        child: Text('Add to items',
            style: Theme.of(context).textTheme.labelMedium!.copyWith(
                fontSize: 16,
                color: AppColor.secondary,
                fontWeight: FontWeight.w500)));
  }

  Container ItemsOutputBox() {
    return Container(
      width: 150,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8), border: Border.all()),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: GetBuilder<CUpdateHistory>(builder: (_) {
          return Wrap(
              runSpacing: 8,
              spacing: 8,
              children: List.generate(_.items.length, (index) {
                return Chip(
                  label: Text(_.items[index]['name']),
                  deleteIcon: const Icon(
                    Icons.clear,
                  ),
                  onDeleted: () => _.deleteItem(index),
                );
              }));
        }),
      ),
    );
  }

  DInput InputPriceBox(TextEditingController controllerPrice) {
    return DInput(
      controller: controllerPrice,
      hint: 'Nilai (Rp. )',
    );
  }

  DInput InputNameItemBox(TextEditingController controllerName) {
    return DInput(
      controller: controllerName,
      hint: 'Misal : Penjualan',
    );
  }

  Obx InputTipeBox() {
    return Obx(() {
      return DropdownButtonFormField(
        value: cUpdateHistory.type,
        items: ['Pemasukan', 'Pengeluaran'].map((e) {
          return DropdownMenuItem(
            value: e,
            child: Text(e),
          );
        }).toList(),
        onChanged: (value) {
          cUpdateHistory.setType(value);
        },
        decoration: const InputDecoration(border: OutlineInputBorder()),
        isDense: true,
      );
    });
  }

  Text widgetTipe(BuildContext context) {
    return Text(
      'Tipe',
      style: Theme.of(context)
          .textTheme
          .titleLarge!
          .copyWith(fontSize: 16, fontWeight: FontWeight.bold),
    );
  }
}
