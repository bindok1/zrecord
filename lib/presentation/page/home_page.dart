import 'package:d_chart/d_chart.dart';
import 'package:d_view/d_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:moneyrecord/config/app_asset.dart';
import 'package:moneyrecord/config/app_color.dart';
import 'package:moneyrecord/config/app_format.dart';
import 'package:moneyrecord/config/session.dart';

import 'package:moneyrecord/presentation/controller/c_add_history.dart';
import 'package:moneyrecord/presentation/controller/c_home.dart';
import 'package:moneyrecord/presentation/controller/c_user.dart';
import 'package:moneyrecord/presentation/page/history/detail_history_page.dart';
import 'package:moneyrecord/presentation/page/history/history.dart';
import 'package:moneyrecord/presentation/page/history/history_page.dart';
import 'package:moneyrecord/presentation/page/history/income_outcome_page.dart';
import 'package:moneyrecord/presentation/page/login_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final cUser = Get.put(CUser());
  final cAddHistory = Get.put(CAddHistory());
  final cHome = Get.put(CHome());

  @override
  void initState() {
    cHome.getAnalysis(cUser.data.idUser!);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColor.fgcolor,
        endDrawer: drawer(),
        body: Padding(
          padding:
              const EdgeInsets.only(top: 50, left: 20, right: 20, bottom: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.09,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.white),
                  child: profile()),
              Expanded(
                  child: RefreshIndicator(
                onRefresh: () async {
                  cHome.getAnalysis(cUser.data.idUser!);
                },
                child: ListView(
                  children: [
                    DView.spaceHeight(8),
                    spendToday(),
                    DView.spaceHeight(30),
                    Center(
                      child: Container(
                        width: 80,
                        height: 5,
                        decoration: BoxDecoration(
                            color: AppColor.bg,
                            borderRadius: BorderRadius.circular(30)),
                      ),
                    ),
                    DView.spaceHeight(30),
                    spendWeekday(),
                    DView.spaceHeight(),
                    monthOnMonth()
                  ],
                ),
              ))
            ],
          ),
        ));
  }

  Widget profile() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 48,
            width: 48,
            decoration: BoxDecoration(
                border: Border.all(width: 3, color: AppColor.secondary),
                shape: BoxShape.circle,
                image: const DecorationImage(image: AssetImage(AppAsset.profile2))),
          ),
          DView.spaceWidth(8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Hi',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Obx(() {
                return Text(
                  cUser.data.name ?? '',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .copyWith(fontSize: 16, fontWeight: FontWeight.bold),
                );
              }),
            ],
          ),
          const Spacer(),
          Builder(builder: (ctx) {
            return Material(
              color: AppColor.primary,
              borderRadius: BorderRadius.circular(4),
              child: InkWell(
                borderRadius: BorderRadius.circular(4),
                onTap: () {
                  Scaffold.of(ctx).openEndDrawer();
                },
                child: const Padding(
                  padding: EdgeInsets.all(12),
                  child: Icon(
                    Icons.menu,
                    size: 24,
                    color: Colors.white,
                  ),
                ),
              ),
            );
          })
        ],
      ),
    );
  }

//NOTE : SPEND TODAY
  Widget spendToday() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Pengeluaran Hari ini',
          style: Theme.of(context)
              .textTheme
              .titleLarge!
              .copyWith(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        DView.spaceHeight(),
        Material(
          elevation: 4,
          borderRadius: BorderRadius.circular(16),
          color: AppColor.primary,
          shadowColor: Colors.black,
          child: Padding(
            padding: const EdgeInsets.only(
              left: 16,
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Obx(() {
                    return Text(
                      AppFormat.currency(cHome.today.toString()),
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    );
                  }),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 16, right: 30, bottom: 4),
                    child: Obx(() {
                      return Text(
                        cHome.todayPercent,
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      );
                    }),
                  ),
                  DView.spaceHeight(),
                  GestureDetector(
                    onTap: () {
                      Get.to(() => DetailHistoryPage(
                            date:
                                DateFormat('yyyy-MM-dd').format(DateTime.now()),
                            idUser: cUser.data.idUser!,
                            type: 'Pengeluaran',
                          ));
                    },
                    child: Container(
                      margin: const EdgeInsets.fromLTRB(16, 0, 0, 16),
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(8),
                              bottomLeft: Radius.circular(8))),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            'Selengkapnya',
                            style: Theme.of(context)
                                .textTheme
                                .displayLarge!
                                .copyWith(
                                    fontSize: 16,
                                    color: AppColor.primary,
                                    fontWeight: FontWeight.w600),
                          ),
                          const Icon(
                            Icons.keyboard_arrow_right,
                            color: AppColor.primary,
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  //NOTE : SPEND WEEKDAY
  Widget spendWeekday() {
    return Material(
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Pengeluaran Mingguan',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              DView.spaceHeight(),
              AspectRatio(
                aspectRatio: 16 / 9,
                child: Obx(() {
                  return DChartBar(
                    data: [
                      {
                        'id': 'Bar',
                        'data': List.generate(7, (index) {
                          return {
                            'domain': cHome.weekText()[index],
                            'measure': cHome.week[index],
                          };
                        })
                      },
                    ],
                    domainLabelPaddingToAxisLine: 8,
                    axisLineTick: 2,
                    axisLinePointWidth: 6,
                    axisLineColor: AppColor.primary,
                    measureLabelPaddingToAxisLine: 16,
                    barColor: (barData, index, id) => AppColor.primary,
                    showBarValue: true,
                  );
                }),
              )
            ],
          ),
        ));
  }

  // NOTE : Drawer

  Widget drawer() {
    return Drawer(
      backgroundColor: AppColor.primary,
      child: SizedBox(
          child: ListView(
        children: [
          Padding(
            padding:
                const EdgeInsets.only(top: 40, left: 16, right: 16, bottom: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      height: 48,
                      width: 48,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          image: const DecorationImage(
                              image: AssetImage(AppAsset.profile2))),
                    ),
                    DView.spaceWidth(8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Obx(() {
                          return Text(
                            cUser.data.name ?? '',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                          );
                        }),
                        Obx(() {
                          return Text(
                            cUser.data.email ?? '',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(fontSize: 16, color: Colors.white),
                          );
                        }),
                      ],
                    ),
                  ],
                ),
                DView.spaceHeight(8),
                Material(
                  borderRadius: BorderRadius.circular(30),
                  color: Colors.white,
                  child: InkWell(
                    onTap: () {
                      Session.clearUser();
                      Get.off(() => const LoginPage());
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 8),
                      child: Text(
                        'Logout',
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            fontSize: 16,
                            color: AppColor.primary,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Column(
            children: [
              const Divider(
                height: 1,
                color: Colors.white,
              ),
              ListTile(
                onTap: () {
                  Get.to(() => AddHistory())?.then((value) {
                    if (value ?? false) {
                      cHome.getAnalysis(cUser.data.idUser!);
                    }
                  });
                },
                leading: const Icon(
                  Icons.add,
                  color: Colors.white,
                ),
                title: Text(
                  'Tambah Baru',
                  style: Theme.of(context)
                      .textTheme
                      .labelLarge!
                      .copyWith(color: Colors.white),
                ),
                horizontalTitleGap: 0,
                trailing: const Icon(
                  Icons.navigate_next,
                  color: Colors.white,
                ),
              ),
              const Divider(
                height: 1,
                color: Colors.white,
              ),
              ListTile(
                onTap: () {
                  Get.to(() => const IncomeOutcome(
                        type: 'Pemasukan',
                      ));
                },
                leading: const Icon(
                  Icons.south_west,
                  color: Colors.white,
                ),
                title: Text(
                  'Pemasukan',
                  style: Theme.of(context)
                      .textTheme
                      .labelLarge!
                      .copyWith(color: Colors.white),
                ),
                horizontalTitleGap: 0,
                trailing: const Icon(
                  Icons.navigate_next,
                  color: Colors.white,
                ),
              ),
              const Divider(
                height: 1,
                color: Colors.white,
              ),
              ListTile(
                onTap: () {
                  Get.to(() => const IncomeOutcome(type: 'Pengeluaran'));
                },
                leading: const Icon(Icons.north_east, color: Colors.white),
                title: Text(
                  'Pengeluaran',
                  style: Theme.of(context)
                      .textTheme
                      .labelLarge!
                      .copyWith(color: Colors.white),
                ),
                horizontalTitleGap: 0,
                trailing: const Icon(
                  Icons.navigate_next,
                  color: Colors.white,
                ),
              ),
              const Divider(
                height: 1,
                color: Colors.white,
              ),
              ListTile(
                onTap: () {
                  Get.to(() => const HistoryData());
                },
                leading: const Icon(
                  Icons.history,
                  color: Colors.white,
                ),
                title: Text(
                  'Riwayat',
                  style: Theme.of(context)
                      .textTheme
                      .labelLarge!
                      .copyWith(color: Colors.white),
                ),
                horizontalTitleGap: 0,
                trailing: const Icon(
                  Icons.navigate_next,
                  color: Colors.white,
                ),
              ),
              const Divider(
                height: 1,
              ),
            ],
          )
        ],
      )),
    );
  }

//NOTE : MonthOnMonth
  Widget monthOnMonth() {
    return Material(
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Perbandingan Bulan Ini',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            DView.spaceHeight(),
            Row(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.5,
                  height: MediaQuery.of(context).size.width * 0.5,
                  child: Stack(
                    children: [
                      Obx(() {
                        return DChartPie(
                          data: [
                            {'domain': 'income', 'measure': cHome.monthIncome},
                            {
                              'domain': 'outcome',
                              'measure': cHome.monthOutcome
                            },
                            if (cHome.monthIncome == 0 &&
                                cHome.monthOutcome == 0)
                              {'domain': 'nol', 'measure': 1},
                          ],
                          fillColor: (pieData, index) {
                            switch (pieData['domain']) {
                              case 'income':
                                return AppColor.primary;
                              case 'outcome':
                                return AppColor.chart;
                              default:
                                return AppColor.bg.withOpacity(0.5);
                            }
                          },
                          donutWidth: 20,
                          labelColor: Colors.transparent,
                          showLabelLine: false,
                        );
                      }),
                      Center(
                        child: Obx(() {
                          return Text(
                            '${cHome.percentIncome}%',
                            style: Theme.of(context)
                                .textTheme
                                .displayLarge!
                                .copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 36,
                                    color: AppColor.primary),
                          );
                        }),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          height: 16,
                          width: 16,
                          color: AppColor.primary,
                        ),
                        DView.spaceWidth(8),
                        Text(
                          'Pemasukan',
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge!
                              .copyWith(fontSize: 16),
                        ),
                      ],
                    ),
                    DView.spaceHeight(),
                    Row(
                      children: [
                        Container(
                          height: 16,
                          width: 16,
                          color: AppColor.chart,
                        ),
                        DView.spaceWidth(8),
                        Text(
                          'Pengeluaran',
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge!
                              .copyWith(fontSize: 16),
                        ),
                      ],
                    ),
                    DView.spaceHeight(),
                    Obx(() {
                      return Text(
                        cHome.monthPercent,
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall!
                            .copyWith(fontSize: 12),
                      );
                    }),
                    DView.spaceHeight(),
                    Text(
                      'Atau Setara',
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge!
                          .copyWith(fontSize: 12),
                    ),
                    Obx(() {
                      return Text(
                        AppFormat.currency(cHome.differentMonth.toString()),
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge!
                            .copyWith(fontSize: 16),
                      );
                    })
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
