import 'dart:io';
import 'dart:ui' as ui;
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';
void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Bill(),
  ));
}

class Bill extends StatefulWidget {
  const Bill({Key? key}) : super(key: key);

  @override
  State<Bill> createState() => _BillState();
}

class _BillState extends State<Bill> {
  GlobalKey gb = GlobalKey();

  DateTime dn = DateTime.now();

  bool gujvalue = false;
  bool pjbvalue = false;
  bool sivalue = false;
  bool chvalue = false;

  String gujcount = '0';
  String pnjcount = '0';
  String sicount = '0';
  String chcount = '0';
  String gendevalue = "";
  String tcount = '0';

  int gujprice = 120;
  int pnjprice = 150;
  int siprice = 100;
  int chprice = 110;

  String Gujtotal = '0';
  String Pjbtotal = '0';
  String Sitotal = '0';
  String Chtotal = '0';
  String AllTotal = '0';
  String discount = '0';

  String Discount() {
    setState(() {
      if (gendevalue == "MALE") {
        discount = "15";
      } else if (gendevalue == "FEMALE") {
        discount = "10";
      } else
        discount = "0";
      // discount= gendevalue=="MALE"?"15":"10";
    });
    return discount;
  }

  String guj() {
    int a;
    if (gujvalue == true) {
      setState(() {
        a = gujprice * int.parse(gujcount);
        Gujtotal = a.toString();
      });
    } else
      Gujtotal = '0';
    return Gujtotal;
  }

  String pjb() {
    int a;
    if (pjbvalue == true) {
      setState(() {
        a = pnjprice * int.parse(pnjcount);
        Pjbtotal = a.toString();
      });
    } else
      Pjbtotal = '0';
    return Pjbtotal;
  }

  String si() {
    int a;
    if (sivalue == true) {
      setState(() {
        a = siprice * int.parse(sicount);
        Sitotal = a.toString();
      });
    } else
      Sitotal = '0';

    return Sitotal;
  }

  String ch() {
    int a;
    if (chvalue == true) {
      setState(() {
        a = chprice * int.parse(chcount);
        Chtotal = a.toString();
      });
    } else
      Chtotal = '0';
    return Chtotal;
  }

  String totalcount() {
    int a;
    int b;
    int c;
    int d;
    int total;
    setState(() {
      a = gujvalue ? int.parse(gujcount) : 0;
      b = pjbvalue ? int.parse(pnjcount) : 0;
      c = sivalue ? int.parse(sicount) : 0;
      d = chvalue ? int.parse(chcount) : 0;
      total = a + b + c + d;
      tcount = total.toString();
    });
    return tcount;
  }

  String alltotala = "0";

  String lasttotal() {
    setState(() {
      int a = int.parse(Totalcount());
      double b = double.parse(Dicountvalue());
      double c;
      c = a - b;
      alltotala = c.toString();
    });
    return alltotala;
  }

  String Totalcount() {
    int a;
    setState(() {
      a = int.parse(guj()) +
          int.parse(pjb()) +
          int.parse(si()) +
          int.parse(ch());
      AllTotal = a.toString();
    });
    return AllTotal;
  }

  String dvalue = "0";

  String Dicountvalue() {
    setState(() {
      int a = int.parse(Totalcount());
      int b = int.parse(Discount());
      double c;
      c = a * b / 100;
      dvalue = c.toString();
    });

    return dvalue;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          actions: [
            IconButton(
                onPressed: () {
                  setState(() {
                    final pdf = pw.Document();
                    _capturePng().then((value) async {
                      final image = pw.MemoryImage(value);
                      pdf.addPage(pw.Page(build: (pw.Context context) {
                        return pw.Center(
                          child: pw.Image(image),
                        ); // Center
                      }));
                      final output = await getTemporaryDirectory();
                      final file = File("${output.path}/BILl $dn.pdf");
                      await file.writeAsBytes(await pdf.save());
                      Share.shareFiles(
                        ['${file.path}'],
                      );

                    });
                  });
                },
                icon: Icon(Icons.print))
          ],
          title: Text("BILL BOOK"),
          centerTitle: true,
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            setState(() {
              dn;
            });
          },
          child: SingleChildScrollView(
            reverse: true,
            child: RepaintBoundary(
              key: gb,
              child: Container(
                padding: EdgeInsets.all(15),
                child: Column(
                  children: [
                    SizedBox(height: 20,),
                    Container(
                      alignment: Alignment.center,
                      child: Text(
                        "INVOICE",
                        style: TextStyle(fontSize: 30, color: Colors.blue),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            "${dn.hour}:${dn.minute}\n${dn.day}/${dn.month}/${dn.year}",
                            style: TextStyle(
                              fontSize: 15,
                            ),
                            textAlign: TextAlign.end,
                          ),
                        ],
                      ),
                    ),
                    TextField(
                      autocorrect: true,
                      showCursor: false,
                      mouseCursor: MouseCursor.uncontrolled,
                      textDirection: TextDirection.rtl,
                      style: TextStyle(fontSize: 20),
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "ENTER NAME",
                          hintTextDirection: TextDirection.rtl,
                          hintStyle:
                              TextStyle(color: Colors.blue.withOpacity(.5))),
                    ),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            child: Row(
                              children: [
                                Text(
                                  "MALE",
                                  style: TextStyle(fontSize: 15),
                                ),
                                Radio(
                                  value: "MALE",
                                  groupValue: gendevalue,
                                  onChanged: (value) {
                                    setState(() {
                                      gendevalue = value.toString();
                                      print(gendevalue);
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                          Container(
                            child: Row(
                              children: [
                                Text(
                                  "FEMALE",
                                  style: TextStyle(fontSize: 15),
                                ),
                                Radio(
                                  value: "FEMALE",
                                  groupValue: gendevalue,
                                  onChanged: (value) {
                                    setState(() {
                                      gendevalue = value.toString();
                                      print(gendevalue);
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      child: Table(
                        defaultVerticalAlignment:
                            TableCellVerticalAlignment.middle,
                        columnWidths: {
                          0: FlexColumnWidth(1),
                          1: FlexColumnWidth(3),
                          2: FlexColumnWidth(1.5),
                          3: FlexColumnWidth(1.6),
                          4: FlexColumnWidth(1.5)
                        },
                        children: [
                          TableRow(
                              decoration: new BoxDecoration(
                                  color: Colors.blue.withOpacity(.6)),
                              children: [
                                Center(
                                  child: Container(
                                    padding: EdgeInsets.all(10),
                                    child: Text(
                                      '',
                                      style: TextStyle(fontSize: 17),
                                    ),
                                  ),
                                ),
                                Center(
                                  child: Text(
                                    'DISH',
                                    style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black.withOpacity(.7)),
                                  ),
                                ),
                                Center(
                                  child: Text(
                                    'PRICE',
                                    style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black.withOpacity(.7)),
                                  ),
                                ),
                                Center(
                                  child: Text(
                                    'COUNT',
                                    style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black.withOpacity(.7)),
                                  ),
                                ),
                                Center(
                                  child: Text(
                                    'TOTAL',
                                    style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black.withOpacity(.7)),
                                  ),
                                ),
                              ]),
                          TableRow(children: [
                            Center(
                              child: Text(
                                '',
                                style: TextStyle(fontSize: 17),
                              ),
                            ),
                            Center(
                              child: Text(""),
                            ),
                            Center(
                              child: Text(
                                '',
                              ),
                            ),
                            Center(
                              child: Text(
                                '',
                              ),
                            ),
                            Center(
                              child: Text(
                                '',
                              ),
                            ),
                          ]),
                          TableRow(children: [
                            Center(
                                child: Checkbox(
                              activeColor: Colors.green,
                              value: gujvalue,
                              onChanged: (value) {
                                setState(() {
                                  gujvalue = value!;
                                });
                              },
                            )),
                            Center(
                              child: Text(
                                'GUJRATI',
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.black.withOpacity(.7)),
                              ),
                            ),
                            Center(
                              child: Text(
                                '$gujprice',
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.black.withOpacity(.7)),
                              ),
                            ),
                            Center(
                                child: Container(
                              padding: EdgeInsets.only(left: 10),
                              child: Row(
                                children: [
                                  Container(
                                    child: Text(
                                      gujcount,
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.black.withOpacity(.7)),
                                    ),
                                  ),
                                  DropdownButton<String>(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5)),
                                    menuMaxHeight: 150,
                                    items: <String>[
                                      '0',
                                      '1',
                                      '2',
                                      '3',
                                      '4',
                                      '5',
                                      '6',
                                      '7',
                                      '8',
                                      '9',
                                      '10'
                                    ].map((String value) {
                                      return DropdownMenuItem<String>(
                                        onTap: () {
                                          setState(() {
                                            gujcount = value;
                                          });
                                        },
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                    onChanged: (_) {},
                                  )
                                ],
                              ),
                            )),
                            Center(
                              child: Text(
                                guj(),
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.black.withOpacity(.7)),
                              ),
                            ),
                          ]),
                          TableRow(children: [
                            Center(
                                child: Checkbox(
                              activeColor: Colors.green,
                              value: pjbvalue,
                              onChanged: (value) {
                                setState(() {
                                  pjbvalue = value!;
                                });
                              },
                            )),
                            Center(
                              child: Text(
                                'PANJABI',
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.black.withOpacity(.7)),
                              ),
                            ),
                            Center(
                              child: Text(
                                '$pnjprice',
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.black.withOpacity(.7)),
                              ),
                            ),
                            Center(
                                child: Container(
                              padding: EdgeInsets.only(left: 10),
                              child: Row(
                                children: [
                                  Container(
                                    child: Text(
                                      pnjcount,
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.black.withOpacity(.7)),
                                    ),
                                  ),
                                  DropdownButton<String>(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5)),
                                    menuMaxHeight: 150,
                                    items: <String>[
                                      '0',
                                      '1',
                                      '2',
                                      '3',
                                      '4',
                                      '5',
                                      '6',
                                      '7',
                                      '8',
                                      '9',
                                      '10'
                                    ].map((String value) {
                                      return DropdownMenuItem<String>(
                                        onTap: () {
                                          setState(() {
                                            pnjcount = value;
                                          });
                                        },
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                    onChanged: (_) {},
                                  )
                                ],
                              ),
                            )),
                            Center(
                              child: Text(
                                pjb(),
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.black.withOpacity(.7)),
                              ),
                            ),
                          ]),
                          TableRow(children: [
                            Center(
                                child: Checkbox(
                              activeColor: Colors.green,
                              value: sivalue,
                              onChanged: (value) {
                                setState(() {
                                  sivalue = value!;
                                });
                              },
                            )),
                            Center(
                              child: Text(
                                'SOUTH INDIAN',
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.black.withOpacity(.7)),
                              ),
                            ),
                            Center(
                              child: Text(
                                '$siprice',
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.black.withOpacity(.7)),
                              ),
                            ),
                            Center(
                                child: Container(
                              padding: EdgeInsets.only(left: 10),
                              child: Row(
                                children: [
                                  Container(
                                    child: Text(
                                      sicount,
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.black.withOpacity(.7)),
                                    ),
                                  ),
                                  DropdownButton<String>(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5)),
                                    menuMaxHeight: 150,
                                    items: <String>[
                                      '0',
                                      '1',
                                      '2',
                                      '3',
                                      '4',
                                      '5',
                                      '6',
                                      '7',
                                      '8',
                                      '9',
                                      '10'
                                    ].map((String value) {
                                      return DropdownMenuItem<String>(
                                        onTap: () {
                                          setState(() {
                                            sicount = value;
                                          });
                                        },
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                    onChanged: (_) {},
                                  )
                                ],
                              ),
                            )),
                            Center(
                              child: Text(
                                si(),
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.black.withOpacity(.7)),
                              ),
                            ),
                          ]),
                          TableRow(children: [
                            Center(
                                child: Checkbox(
                              activeColor: Colors.green,
                              value: chvalue,
                              onChanged: (value) {
                                setState(() {
                                  chvalue = value!;
                                });
                              },
                            )),
                            Center(
                              child: Text(
                                'CHINESS',
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.black.withOpacity(.7)),
                              ),
                            ),
                            Center(
                              child: Text(
                                '$chprice',
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.black.withOpacity(.7)),
                              ),
                            ),
                            Center(
                                child: Container(
                              padding: EdgeInsets.only(left: 10),
                              child: Row(
                                children: [
                                  Container(
                                    child: Text(
                                      chcount,
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.black.withOpacity(.7)),
                                    ),
                                  ),
                                  DropdownButton<String>(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5)),
                                    menuMaxHeight: 150,
                                    items: <String>[
                                      '0',
                                      '1',
                                      '2',
                                      '3',
                                      '4',
                                      '5',
                                      '6',
                                      '7',
                                      '8',
                                      '9',
                                      '10'
                                    ].map((String value) {
                                      return DropdownMenuItem<String>(
                                        onTap: () {
                                          setState(() {
                                            chcount = value;
                                          });
                                        },
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                    onChanged: (_) {},
                                  )
                                ],
                              ),
                            )),
                            Center(
                              child: Text(
                                ch(),
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.black.withOpacity(.7)),
                              ),
                            ),
                          ]),
                          TableRow(children: [
                            Center(
                              child: Container(
                                padding: EdgeInsets.all(10),
                                child: Text(
                                  '',
                                  style: TextStyle(fontSize: 17),
                                ),
                              ),
                            ),
                            Center(
                              child: Text(""),
                            ),
                            Center(
                              child: Text(
                                'TOTAL',
                                style: TextStyle(
                                    fontSize: 17,
                                    color: Colors.black.withOpacity(.7),
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Center(
                              child: Text(
                                totalcount(),
                                style: TextStyle(
                                    fontSize: 17,
                                    color: Colors.black.withOpacity(.7),
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Center(
                              child: Text(
                                Totalcount(),
                                style: TextStyle(
                                    fontSize: 17,
                                    color: Colors.black.withOpacity(.7),
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ]),
                          TableRow(children: [
                            Center(
                              child: Container(
                                padding: EdgeInsets.all(10),
                                child: Text(
                                  '',
                                  style: TextStyle(fontSize: 17),
                                ),
                              ),
                            ),
                            Center(
                              child: Text(""),
                            ),
                            Center(
                              child: Text(
                                'DISCOUNT',
                                style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.black.withOpacity(.7),
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Center(
                              child: Text(
                                Discount() + "%",
                                style: TextStyle(
                                    fontSize: 17,
                                    color: Colors.black.withOpacity(.7),
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Center(
                              child: Text(
                                Dicountvalue(),
                                style: TextStyle(
                                    fontSize: 17,
                                    color: Colors.black.withOpacity(.7),
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ]),
                        ],
                      ),
                    ),
                    Divider(
                      color: Colors.blue.withOpacity(.6),
                      thickness: 2,
                    ),
                    Container(
                      width: double.maxFinite,
                      padding: EdgeInsets.fromLTRB(20, 10, 23, 10),
                      decoration: BoxDecoration(),
                      child: Text(
                        "PAYABLE BILL AMOUNT    :  " + lasttotal(),
                        style: TextStyle(
                            fontSize: 17,
                            color: Colors.teal,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.end,
                      ),
                    ),

                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<Uint8List> _capturePng() async {
    try {
      print('inside');
      RenderRepaintBoundary? boundary =
          gb.currentContext!.findRenderObject() as RenderRepaintBoundary?;
      ui.Image image = await boundary!.toImage(pixelRatio: 3.0);
      ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      var pngBytes = byteData!.buffer.asUint8List();
      var bs64 = base64Encode(pngBytes);
      print(pngBytes);
      print(bs64);
      setState(() {});
      return pngBytes;
    } catch (e) {
      print(e);
      return Future.value();
    }
  }
}
