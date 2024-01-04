import 'dart:convert';


import 'package:borsavergihesaplama/constant/CustomColor.dart';
import 'package:borsavergihesaplama/model/borsaModel.dart';
import 'package:borsavergihesaplama/widgets/cardWidget.dart';
import 'package:borsavergihesaplama/widgets/customAppbar.dart';
import 'package:borsavergihesaplama/widgets/customButtons.dart';
import 'package:borsavergihesaplama/widgets/customDialog.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Anasayfa extends StatefulWidget {
  const Anasayfa({super.key});

  @override
  State<Anasayfa> createState() => _AnasayfaState();
}

String? dropdownValue; // İlk değer için bir örnek
DateTime selectedDate = DateTime.now();

class _AnasayfaState extends State<Anasayfa> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<List<Map<String, dynamic>>> getSavedTransactions() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> storedTransactions = prefs.getStringList('transactions') ?? [];

    List<Map<String, dynamic>> transactions = [];
    for (String jsonString in storedTransactions) {
      transactions.add(json.decode(jsonString));
    }

    return transactions;
  }

  @override
  Widget build(BuildContext context) {
    final genislik = MediaQuery.of(context).size.width;
    final yukseklik = MediaQuery.of(context).size.height;
    Orientation orientation = MediaQuery.of(context).orientation;

    return Scaffold(
      resizeToAvoidBottomInset : false,
      backgroundColor: CustomColor.background,
      appBar: CustomAppBar(orientation),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SizedBox(
              height: orientation == Orientation.portrait
                  ? yukseklik * 0.7
                  : yukseklik * 0.5,
              child: Scrollbar(
                thumbVisibility: true,
                controller: _scrollController,
                radius: const Radius.circular(10),
                child: FutureBuilder<List<Map<String, dynamic>>>(
                  future: getSavedTransactions(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Hata: ${snapshot.error}');
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Text('Kayıtlı veri bulunamadı!');
                    } else {
                      // JSON map'lerini BorsaModel listesine dönüştürme
                      var transactions = snapshot.data!
                          .map((transactionMap) =>
                              BorsaModel.fromJson(transactionMap))
                          .where((transaction) =>
                              transaction !=
                              null) // null olmayanları filtrele
                          .toList();

                      return ListView.builder(
                        controller: _scrollController,
                        itemCount: transactions.length,
                        itemBuilder: (context, index) {
                          // Her bir transaction için istenen verileri göster
                          var transaction = transactions[index];
                          return Column(
                            children: [
                              borsaCard(
                                index: index,
                                borsaDbVeri: transactions,
                                yukseklik: 100, // Örnek yükseklik değeri
                              ),
                            ],
                          );
                        },
                      );
                    }
                  },
                ),
              ),
            ),
            const hesaplaButton(),
            SizedBox(
              height: yukseklik * 0.0005,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const ekleButton(),
                TextButton.icon(
                  style: TextButton.styleFrom(
                      backgroundColor: CustomColor.primary,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        side: BorderSide(
                          width: 1,
                          color: CustomColor.textC,
                        ),
                      ),
                      minimumSize: Size(genislik * 0.47, 40)),
                  label: const Text(
                    "Temizle",
                    style: TextStyle(color: CustomColor.textC),
                  ),
                  icon: const Icon(
                    Icons.delete_forever,
                    color: CustomColor.textC,
                  ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return const temizleButtonDialog();
                      },
                    );
                  },
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
