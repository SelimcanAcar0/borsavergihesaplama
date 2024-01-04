
import 'package:borsavergihesaplama/constant/CustomColor.dart';
import 'package:borsavergihesaplama/screens/anasayfa.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../model/borsaModel.dart';

class borsaCard extends StatefulWidget {
  final int index;
  final List<BorsaModel> borsaDbVeri;
  final double yukseklik;

  const borsaCard(
      {super.key,
      required this.index,
      required this.borsaDbVeri,
      required this.yukseklik});

  @override
  State<borsaCard> createState() => _borsaCardState();
}

class _borsaCardState extends State<borsaCard> {
  Future<void> _deleteTransaction(int index) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> storedTransactions = prefs.getStringList('transactions') ?? [];
    storedTransactions.removeAt(index);
    await prefs.setStringList('transactions', storedTransactions);
    // Bu kısım artık setState ile otomatik olarak UI'ı güncelleyecektir.
  }

  Future<void> _confirmDeletion(int index) async {
    final transaction = widget.borsaDbVeri[index];
    final formattedDate = DateFormat('dd-MM-yyyy')
        .format(DateTime.parse(transaction.formatTarih));

    // AlertDialog göster
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: CustomColor.background,
          title: const Text('İşlemi Sil'),
          shape: const RoundedRectangleBorder(
            side: BorderSide(
              color: CustomColor.textC,
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(15),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Tür: ${transaction.isSell ? "Satış" : "Alış"}',
                style: const TextStyle(color: CustomColor.textC),
              ),
              Text(
                'Tarih: $formattedDate',
                style: const TextStyle(color: CustomColor.textC),
              ),
              Text(
                'Adet: ${transaction.adet}',
                style: const TextStyle(color: CustomColor.textC),
              ),
              Text(
                'Fiyat: ${transaction.fiyat}',
                style: const TextStyle(color: CustomColor.textC),
              ),
              Text(
                'Bu işlemi silmek istediğinize emin misiniz?',
                style: const TextStyle(color: CustomColor.kirmizi),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Hayır',style: TextStyle(color: CustomColor.textC),),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
                Navigator.pushReplacement(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) => Anasayfa(),
                    transitionsBuilder: (context, animation, secondaryAnimation, child) {
                      var begin = Offset(0.0, -1.0);
                      var end = Offset.zero; // Sol üst köşede bitir
                      var curve = Curves.easeInOut; // Yumuşak bir geçiş için

                      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                      var offsetAnimation = animation.drive(tween);

                      return SlideTransition(
                        position: offsetAnimation,
                        child: child,
                      );
                    },
                  ),
                );
                showTopSnackBar(
                  Overlay.of(context),
                  CustomSnackBar.success(
                    message:
                    "Veri başarıyla silindi",
                  ),
                );
              },
              child: const Text('Evet',style: TextStyle(color: CustomColor.textC)),
            ),
          ],
        );
      },
    );

    // Kullanıcı onaylarsa silme işlemi yap
    if (shouldDelete ?? false) {
      await _deleteTransaction(index);
    }
  }

  @override
  Widget build(BuildContext context) {
    var formattedDate = DateFormat('dd-MM-yyyy')
        .format(DateTime.parse(widget.borsaDbVeri[widget.index].formatTarih));

    return Card(
      color: (widget.index % 2 == 0) ? CustomColor.second : CustomColor.primary,
      child: SizedBox(
        child: Row(
          children: [
            Expanded(
                flex: 20,
                child: Text(
                  widget.borsaDbVeri[widget.index].isSell == true
                      ? "Satış"
                      : "Alış",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, color: CustomColor.textC),
                )),
            Expanded(
                flex: 20,
                child: Text(
                  formattedDate,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: CustomColor.textC, fontSize: 12),
                )),
            Expanded(
              flex: 20,
              child: Text(
                widget.borsaDbVeri[widget.index].adet.toString(),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: CustomColor.textC),
              ),
            ),
            Expanded(
                flex: 20,
                child: Text(
                  widget.borsaDbVeri[widget.index].fiyat.toString(),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: CustomColor.textC),
                )),
            Expanded(
                flex: 20,
                child: IconButton(
                  onPressed: () => _confirmDeletion(widget.index),
                  icon: const Icon(
                    Icons.delete,
                    color: CustomColor.kirmizi,
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
