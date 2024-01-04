import 'dart:convert';
import 'package:borsavergihesaplama/constant/CustomColor.dart';
import 'package:borsavergihesaplama/screens/anasayfa.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class ekleDialog extends StatefulWidget {
  const ekleDialog({super.key});

  @override
  State<ekleDialog> createState() => _ekleDialogState();
}

class _ekleDialogState extends State<ekleDialog> {
  final TextEditingController _lotController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  DateTime? selectedDate;
  bool isSell = false;
  String? formatTarih;
  final formController = GlobalKey<FormState>();
  bool isDateSelected = false;



  Future<void> pickDateTime(BuildContext context) async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2012),
      lastDate: DateTime(2030),
      locale: const Locale('tr', 'TR'),
    );
    if (date == null) return; // Kullanıcı iptal ettiyse bir şey yapma

    DateTime now = DateTime.now();
    setState(() {
      selectedDate = DateTime.utc(
        date.year,
        date.month,
        date.day,
        now.hour,
        now.minute,
        now.second,
        now.millisecond,
      );
      isDateSelected = true;
      formatTarih = selectedDate!.toIso8601String();
      print('Normal Tarih: $formatTarih');
    });
  }

  Future<void> saveUserInput() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> transactions = prefs.getStringList('transactions') ?? [];

    Map<String, dynamic> transaction = {
      "lot": double.parse(_lotController.text),
      "price": double.parse(_priceController.text),
      "date": formatTarih,
      "sell": isSell
    };
    transactions.add(json.encode(transaction));
    await prefs.setStringList('transactions', transactions);
    print(transactions);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dropdownValue = null;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.symmetric(vertical: 7, horizontal: 20),
      titlePadding: const EdgeInsets.only(left: 20, top: 5),
      shape: const RoundedRectangleBorder(
        side: BorderSide(
          color: CustomColor.textC,
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(15),
        ),
      ),
      backgroundColor: CustomColor.background,
      title: const Text('Ekle'),
      content: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Form(
          key: formController,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              TextButton(
                style: TextButton.styleFrom(
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                        side: BorderSide(
                          width: 1,
                          color: CustomColor.textC,
                        ))),
                onPressed: () => pickDateTime(context),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Icon(
                      Icons.date_range,
                      color: CustomColor.textC,
                    ),
                    Text(
                      selectedDate == null
                          ? "Tarih Seçiniz"
                          : DateFormat('dd.MM.yyyy')
                              .format(selectedDate!.toLocal()),
                      style: TextStyle(
                        color: selectedDate == null
                            ? CustomColor.textC
                            : CustomColor.textC,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5),
                child: DropdownButtonFormField<String>(
                  style: const TextStyle(color: Colors.black, fontSize: 14),
                  decoration: const InputDecoration(
                    hintText: 'İşlem Türü',
                    filled: true,
                    fillColor: CustomColor.textC,
                    prefixIcon: Icon(Icons.find_in_page),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "İşlem türü seçmelisiniz!";
                    }
                    return null;
                  },
                  value: dropdownValue,
                  onChanged: (String? newValue) {
                    setState(() {
                      dropdownValue = newValue!;
                      isSell = dropdownValue == "Alış" ? false : true;
                    });
                  },
                  items: <String>['Alış', 'Satış']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: const TextStyle(color: Colors.black),
                      ),
                    );
                  }).toList(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5),
                child: TextFormField(
                  maxLines: 1,
                  controller: _lotController,
                  style: const TextStyle(color: Colors.black, fontSize: 14),
                  cursorColor: Colors.black,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    DecimalTextInputFormatter(decimalRange: 9),
                  ],
                  decoration: const InputDecoration(
                    hintText: 'Hisse Adeti',
                    hintStyle: TextStyle(
                      color: Colors.grey,
                    ),
                    filled: true,
                    fillColor: CustomColor.textC,
                    prefixIcon: Icon(Icons.add_chart_sharp)
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Hisse Adeti girmelisiniz!";
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5),
                child: TextFormField(
                  maxLines: 1,
                  controller: _priceController,
                  style: const TextStyle(color: Colors.black, fontSize: 14),
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    DecimalTextInputFormatter(decimalRange: 9),
                  ],
                  decoration: const InputDecoration(
                    hintText: 'Hisse Fiyat',
                    hintStyle: TextStyle(
                      color: Colors.grey,
                    ),
                    filled: true,
                    fillColor: CustomColor.textC,
                    prefixIcon: Icon(Icons.attach_money)
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Hisse Fiyatı girmelisiniz!";
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        TextButton(
          child:
              const Text('İptal', style: TextStyle(color: CustomColor.textC)),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: const Text('Ekle', style: TextStyle(color: CustomColor.textC)),
          onPressed: () {
            if (formController.currentState!.validate()) {
              if (!isDateSelected) {
                showTopSnackBar(
                  Overlay.of(context),
                  const CustomSnackBar.error(
                    message: "Ekleme yaparken tarih seçmediniz!",
                  ),
                );
                return;
              } else {
                saveUserInput();
                Navigator.pushReplacement(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        const Anasayfa(),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      var begin = const Offset(0.0, -1.0); // Sağdan başla
                      var end = Offset.zero; // Sol üst köşede bitir
                      var curve = Curves.easeInOut; // Yumuşak bir geçiş için

                      var tween = Tween(begin: begin, end: end)
                          .chain(CurveTween(curve: curve));
                      var offsetAnimation = animation.drive(tween);

                      return SlideTransition(
                        position: offsetAnimation,
                        child: child,
                      );
                    },
                  ),
                );
              }
            }
          },
        ),
      ],
    );
  }
}

class DecimalTextInputFormatter extends TextInputFormatter {
  final RegExp _decimalRegex;

  DecimalTextInputFormatter({int decimalRange = 2})
      : _decimalRegex = RegExp(r'^\d*\.?\d{0,' + '$decimalRange' + r'}$');

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (_decimalRegex.hasMatch(newValue.text)) {
      return newValue;
    }
    return oldValue;
  }
}

class temizleButtonDialog extends StatefulWidget {
  const temizleButtonDialog({super.key});

  @override
  State<temizleButtonDialog> createState() => _temizleButtonDialogState();
}

class _temizleButtonDialogState extends State<temizleButtonDialog> {
  Future<void> clearTransactions() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> transactions = prefs.getStringList('transactions') ?? [];

    // transactions listesi boşsa, bir uyarı mesajı göster
    if (transactions.isEmpty) {
      showTopSnackBar(
        Overlay.of(context),
        const CustomSnackBar.error(
          message: "Silinecek veri bulunamadı!",
        ),
      );
      return;
    } else {
      await prefs.remove('transactions'); // Verileri sil
      print('Veriler silindi');

      // Başarılı işlem sonrası mesaj
      showTopSnackBar(
        Overlay.of(context),
        const CustomSnackBar.success(
          message: "Tüm veriler silindi.",
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: const RoundedRectangleBorder(
        side: BorderSide(color: CustomColor.textC),
        borderRadius: BorderRadius.all(
          Radius.circular(15),
        ),
      ),
      backgroundColor: CustomColor.background,
      title: const Text('Uyarı'),
      content: const Text("Tüm veriler silinecek emin misin?"),
      actions: <Widget>[
        TextButton(
          child:
              const Text('İptal', style: TextStyle(color: CustomColor.textC)),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: const Text(
            'Onayla',
            style: TextStyle(color: CustomColor.textC),
          ),
          onPressed: () {
            // Tamam butonuna basıldığında yapılacak işlemler
            clearTransactions();
            Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                    const Anasayfa(),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  var begin = const Offset(0.0, -1.0); // Sağdan başla
                  var end = Offset.zero; // Sol üst köşede bitir
                  var curve = Curves.easeInOut; // Yumuşak bir geçiş için

                  var tween = Tween(begin: begin, end: end)
                      .chain(CurveTween(curve: curve));
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
              const CustomSnackBar.success(
                message: "Bütün veriler başarıyla silinmiştir.",
              ),
            );
          },
        ),
      ],
    );
  }
}
