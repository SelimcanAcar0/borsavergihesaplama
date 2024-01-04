
import 'package:borsavergihesaplama/constant/CustomColor.dart';
import 'package:borsavergihesaplama/constant/texts.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class SozlesmeSayfa extends StatefulWidget {
  const SozlesmeSayfa({super.key});

  @override
  State<SozlesmeSayfa> createState() => _SozlesmeSayfaState();
}

class _SozlesmeSayfaState extends State<SozlesmeSayfa> {

  bool onaylandi=false ;
  @override
  Widget build(BuildContext context) {

    _onaylaKaydet() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('onaylandi', true);
    }

    double yukseklik = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomColor.primary,
        title: const Text("Uygulama Kullanım Sözleşmesi",style: TextStyle(color: Colors.white,),),
        centerTitle: true,
      ),
      body:Scrollbar(
        thumbVisibility: true,
        radius: Radius.circular(10),
        child: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            constraints: BoxConstraints(
              minHeight: yukseklik
            ),
            color: CustomColor.background,
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(Texts.kullanimSozlesmesi,),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: [
                        InkWell(
                          onTap:() {
                            setState(() {
                              onaylandi=!onaylandi;
                            });
                          },
                          child: Card(
                            child: Row(
                              children: [
                                Checkbox(
                                  fillColor: MaterialStateProperty.all(Colors.white),
                                  checkColor: Colors.green,
                                  value: onaylandi, onChanged: (value) {
                                  setState(() {
                                    onaylandi=value!;
                                  });
                                },),
                                Padding(
                                  padding: const EdgeInsets.only(right:8.0),
                                  child: const Text("Onaylıyorum",style: TextStyle(color: Colors.black),),
                                )
                              ],
                            ),
                          ),
                        ),

                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: CustomColor.primary,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor:onaylandi?Colors.white:Colors.grey
          ),
          onPressed: onaylandi?() {
               Navigator.pushReplacementNamed(context, "/anasayfa");
                _onaylaKaydet();
              }:(){
            showTopSnackBar(
              Overlay.of(context),
              CustomSnackBar.error(
                message: "Sözleşmeyi onaylamalısınız!",
              ),
            );
          },
          child: const Text("Devam Et",style: TextStyle(color: Colors.black),),
        ),
      )
    );
  }
}
