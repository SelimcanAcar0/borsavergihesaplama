import 'dart:convert';
import 'package:borsavergihesaplama/constant/CustomColor.dart';
import 'package:borsavergihesaplama/widgets/customDialog.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class hesaplaButton extends StatefulWidget {
  const hesaplaButton({super.key});

  @override
  State<hesaplaButton> createState() => _hesaplaButtonState();
}

class _hesaplaButtonState extends State<hesaplaButton> {
  bool isLoading = false;

  Future<void> calculateTransactions(BuildContext context) async {
    setState(() {
      isLoading = true;
    });

    final prefs = await SharedPreferences.getInstance();
    List<String> transactions = prefs.getStringList('transactions') ?? [];

    var apiUrl =
        Uri.parse('https://calculatorapimanagement7.azure-api.net/Calculator');
    var subscriptionKey = '7e74b615807041e89612ca4a8be94df0';

    var response = await http.post(
      apiUrl,
      headers: {
        'Content-Type': 'application/json',
        'Ocp-Apim-Subscription-Key': subscriptionKey,
      },
      body: json.encode(
          {"transactions": transactions.map((e) => json.decode(e)).toList()}),
    );

    if (transactions.isEmpty) {
      showTopSnackBar(
        Overlay.of(context),
        const CustomSnackBar.error(
          message: "İşlem yapılacak veri bulunamadı!",
        ),
      );
    } else {
      if (response.statusCode == 201) {
        var result = json.decode(response.body);
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: CustomColor.background,
              shape: const RoundedRectangleBorder(
                side: BorderSide(
                  color: CustomColor.textC,
                ),
                borderRadius: BorderRadius.all(
                  Radius.circular(15),
                ),
              ),
              content: SingleChildScrollView(
                physics: ClampingScrollPhysics(),
                padding: EdgeInsets.all(8),
                child: ListBody(
                  children: <Widget>[
                    Text(
                      'Sonuç: \n ${result['result']} TL',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                        color: Colors.white
                      ),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 10,),
                    Row(
                      children: [
                        Expanded(
                          flex: 5,
                          child:Column(
                            children: [
                              Text(
                              'Kalan Lot:',
                              style: const TextStyle(
                                fontSize: 15,
                                color:Colors.black
                              ),),
                              SizedBox(height: 5,),
                              Align(
                                alignment: Alignment.center,
                                child: Text(
                                  '${result['remainLots']}',
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      fontSize: 15,
                                      color: Colors.black
                                  ),
                                ),
                              ),
                            ],
                          )
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          flex: 5,
                          child: Column(
                            children: [
                              Text(
                                'Dolar Kârı:',
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 15,
                                  color: Colors.black
                                ),
                              ),
                              SizedBox(height: 5,),
                              Align(
                                alignment: Alignment.center,
                                child: Text(
                                  '${result['dolarProfit']}\$',
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      fontSize: 15,
                                      color: Colors.black
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: MediaQuery.sizeOf(context).height * 0.05,
                    )
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Kapat',
                    style: TextStyle(color: CustomColor.textC),
                  ),
                ),
              ],
            );
          },
        );
        print(response.body);
        print(response.statusCode);
      } else {
        var errorResponse = json.decode(response.body);
        String errorMessage;
        switch (errorResponse['exceptionType']) {
          case 2:
            errorMessage = "Satılan lot sayısı, alınan lot sayısından fazla!";
            break;
          case 1:
            errorMessage = "Geçersiz istek!";
            break;
          case 0:
            errorMessage = "Tarih bulunamadı!";
            break;
          default:
            errorMessage = "Bilinmeyen bir hata oluştu!";
        }
        showTopSnackBar(
          Overlay.of(context),
          CustomSnackBar.error(
            message: errorMessage,
          ),
        );
        print('Hata Mesajı: $errorMessage');
        print('Status Kodu: ${response.statusCode}');
        print(response.body);
      }
    }
    if (!mounted) return;
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: CustomColor.primary,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        minimumSize: Size(
          MediaQuery.of(context).size.width * 1,
          40,
        ),
      ),
      onPressed: isLoading ? null : () {
        calculateTransactions(context);
      },
      icon: isLoading
          ? const CircularProgressIndicator(color: CustomColor.textC)
          : const Icon(Icons.query_stats, color: CustomColor.textC),
      label: Text(
        isLoading ? "İşleniyor..." : "Hesapla",
        style: const TextStyle(color: CustomColor.textC),
      ),
    );
  }
}

class ekleButton extends StatelessWidget {
  const ekleButton({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      style: TextButton.styleFrom(
        backgroundColor: CustomColor.primary,
        minimumSize: Size(MediaQuery.sizeOf(context).width * 0.47, 40),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          side: BorderSide(
            width: 1,
            color: CustomColor.textC,
          ),
        ),
      ),
      label: const Text(
        "Ekle",
        style: TextStyle(color: CustomColor.textC),
      ),
      icon: const Icon(
        Icons.add,
        color: CustomColor.textC,
      ),
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) {
            return const ekleDialog();
          },
        );
      },
    );
  }
}
