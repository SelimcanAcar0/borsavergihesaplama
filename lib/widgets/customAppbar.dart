import 'package:borsavergihesaplama/constant/CustomColor.dart';
import 'package:flutter/material.dart';

AppBar CustomAppBar(Orientation orientation){
    return AppBar(
          backgroundColor: CustomColor.primary,
          centerTitle: true,
          automaticallyImplyLeading: false,
          titleTextStyle: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
          title: const Text("Yabancı Borsa Vergi Hesaplama"),
          bottom: PreferredSize(
            preferredSize: orientation == Orientation.portrait
                ? const Size.fromHeight(40)
                : const Size.fromHeight(10),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 4,vertical: 4,),
              decoration: const BoxDecoration(
                  border: Border(
                      bottom: BorderSide(width: 0.6, color: Colors.white))),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  children: [
                    Expanded(
                        flex: 20,
                        child: Text(
                          orientation == Orientation.portrait
                              ? "İşlem"
                              "     Türü"
                              : "İşlem Türü",
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        )),
                    const Expanded(
                        flex: 20,
                        child: Text(
                          "Tarih",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )),
                    const Expanded(
                        flex: 20,
                        child: Text(
                          "Adet",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )),
                    const Expanded(
                        flex: 20,
                        child: Text(
                          "Birim Fiyat",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )),
                    const Expanded(flex: 20, child: SizedBox()),
                  ],
                ),
              ),
            ),
          ));

  }
