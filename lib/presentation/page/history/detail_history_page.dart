import 'dart:convert';

import 'package:d_view/d_view.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:moneyrecord/config/app_asset.dart';
import 'package:moneyrecord/config/app_color.dart';
import 'package:moneyrecord/config/app_format.dart';
import 'package:moneyrecord/presentation/controller/c_detail_history.dart';

class DetailHistoryPage extends StatefulWidget {
  const DetailHistoryPage(
      {super.key,
      required this.idUser,
      required this.date,
      required this.type});
  final String idUser;
  final String date;
  final String type;

  @override
  State<DetailHistoryPage> createState() => _DetailHistoryPageState();
}

class _DetailHistoryPageState extends State<DetailHistoryPage> {
  final cDetailHistory = Get.put(CDetailHistory());

  @override
  void initState() {
    cDetailHistory.getData(widget.idUser, widget.date, widget.type);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(() {
          if (cDetailHistory.data.date == null) return DView.nothing();
          return Row(
            children: [
              Expanded(
                child: Text(
                  AppFormat.date(cDetailHistory.data.date!),
                ),
              ),
              cDetailHistory.data.type == 'Pemasukan'
                  ? Icon(
                      Icons.south_west,
                      color: Colors.green[300],
                    )
                  : Icon(
                      Icons.north_east,
                      color: Colors.red[300],
                    ),
              DView.spaceHeight(),
            ],
          );
        }),
        actions: const [],
      ),
      body: GetBuilder<CDetailHistory>(builder: (_) {
        if (_.data.date == null) {
          String today = DateFormat('yyyy-MM-dd').format(DateTime.now());
          if (widget.date == today && widget.type == 'Pengeluaran') {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  AppAsset.emptyState,
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.5,
                ),
                Text(
                  'Belum Ada Pengeluaran',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .copyWith(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                DView.spaceHeight(200)
              ],
            );
          }
          return DView.nothing();
        }
        List details = jsonDecode(_.data.details!);
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Total',
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColor.primary),
              ),
              DView.spaceHeight(4),
              Text(
                AppFormat.currency(_.data.total!),
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    fontSize: 32,
                    fontWeight: FontWeight.w400,
                    color: AppColor.primary),
              ),
              DView.spaceHeight(28),
              Center(
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColor.bg,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  height: 5,
                  width: 100,
                ),
              ),
              Expanded(
                  child: ListView.separated(
                      separatorBuilder: (context, index) => const Divider(
                            height: 1,
                            indent: 16,
                            endIndent: 16,
                            color: Colors.grey,
                            thickness: 0.5,
                          ),
                      itemCount: details.length,
                      itemBuilder: (context, index) {
                        Map item = details[index];
                        return Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              Text('${index + 1}.'),
                              DView.spaceWidth(8),
                              Expanded(
                                  child: Text(item['name'],
                                      style: Theme.of(context)
                                          .textTheme
                                          .displaySmall!
                                          .copyWith(
                                            fontSize: 20,
                                          ))),
                              Text(
                                AppFormat.currency(
                                  item['price'],
                                ),
                                style: Theme.of(context)
                                    .textTheme
                                    .displaySmall!
                                    .copyWith(
                                      fontSize: 20,
                                    ),
                              )
                            ],
                          ),
                        );
                      }))
            ],
          ),
        );
      }),
    );
  }
}
