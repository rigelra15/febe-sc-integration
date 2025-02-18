import 'package:flutter/material.dart';
import 'package:surveyscout/components/survey_card.dart';
import 'package:surveyscout/components/survey_status.dart';
import 'clientchat.dart';
import 'clientsaya.dart';
import 'package:surveyscout/api/api_service.dart';

class SecondPage extends StatefulWidget {
  @override
  _SecondPageState createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  final ApiService apiService = ApiService(
      "https://a0f5-118-99-84-39.ngrok-free.app/api/v1",
      "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZF91c2VyIjoiM2JmODgxYmMtMmNmZi00YTc4LTgxNGUtMDM3YjhmMzI1NzIzIiwiZW1haWwiOiJnZWRlYXJpc3VkYW5hMTZAZ21haWwuY29tIiwiaWF0IjoxNzM5ODgxNzIzLCJleHAiOjE3Mzk5NjgxMjN9.3hBQlNz1qWVlfPszuileSpieALQbvhp-OGLyf8e7dTo");

  late Future<List<Survey>> futureSurveys;
  List<Survey> allSurveys = [];
  List<Survey> filteredSurveys = [];

  String searchQuery = "";

  @override
  void initState() {
    super.initState();
    futureSurveys = apiService.getSurveys().then((surveys) {
      allSurveys = surveys;
      filteredSurveys = surveys;
      return surveys;
    }).whenComplete(() {
      _filterSurveys();
    });
  }

  void _filterSurveys() {
    setState(() {
      filteredSurveys = allSurveys.where((survey) {
        final matchesStatus = selectedStatus == "Semua status" ||
            survey.statusTask.toLowerCase() == selectedStatus.toLowerCase();
        final matchesSearch =
            survey.namaProyek.toLowerCase().contains(searchQuery.toLowerCase());
        return matchesStatus && matchesSearch;
      }).toList();

      filteredSurveys.sort((a, b) {
        DateTime dateA = DateTime.parse(a.createdAt);
        DateTime dateB = DateTime.parse(b.createdAt);
        return dateB.compareTo(dateA);
      });
    });
  }

  final Map<String, String> statusMap = {
    "Semua status": "Semua status",
    "Peringatan": "peringatan",
    "Dikerjakan": "dikerjakan",
    "Butuh konfirmasi": "butuh konfirmasi",
    "Selesai": "selesai",
    "Kadaluwarsa": "kadaluwarsa",
    "Draft": "draft",
    "Menunggu bayar": "menunggu bayar",
  };

  String selectedStatus = "Semua status";
  String selectedPeran = "Semua peran";
  String selectedLokasi = "Semua lokasi";
  String selectedKomisi = "Semua komisi";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF1E9E5),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(165),
        child: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Color(0xFFD7CCC8),
          flexibleSpace: Padding(
            padding: const EdgeInsets.all(27.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  height: 40,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color(0xFFF1E9E5),
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0x40000000),
                          offset: Offset(0, 4),
                          blurRadius: 4,
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                    child: TextField(
                      onChanged: (value) {
                        searchQuery = value;
                        _filterSurveys();
                      },
                      decoration: InputDecoration(
                        hintText: "Cari proyek Anda...",
                        filled: true,
                        fillColor: Color(0xFFF1E9E5),
                        contentPadding: const EdgeInsets.all(10.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: Color(0xFF757575),
                            width: 0.1,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: Color(0xFF705D54),
                            width: 2.0,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: Color(0xFF705D54),
                            width: 1.0,
                          ),
                        ),
                        prefixIcon:
                            Icon(Icons.search, color: Color(0xFF826754)),
                        hintStyle: TextStyle(
                          color: Color(0xFFB0B0B0),
                          fontFamily: 'NunitoSans',
                          fontWeight: FontWeight.w300,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 17),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  clipBehavior: Clip.none,
                  child: Row(
                    children: [
                      _buildIconBox(),
                      SizedBox(width: 8),
                      _buildDropdown(
                          "Semua Status",
                          [
                            "Semua status",
                            "Peringatan",
                            "Dikerjakan",
                            "Ditinjau",
                            "Merekrut",
                            "Selesai",
                            "Kadaluwarsa",
                            "Draft",
                            "Menunggu bayar"
                          ],
                          selectedValue: selectedStatus, onChanged: (value) {
                        setState(() {
                          selectedStatus = value!;
                          _filterSurveys();
                        });
                      }),
                      SizedBox(width: 8),
                      _buildDropdown("Semua Peran",
                          ["Semua peran", "Surveyor", "Responden"],
                          selectedValue: selectedPeran, onChanged: (value) {
                        setState(() {
                          selectedPeran = value!;
                        });
                      }),
                      SizedBox(width: 8),
                      _buildDropdown("Semua Lokasi",
                          ["Semua lokasi", "Sidoarjo", "Surabaya"],
                          selectedValue: selectedLokasi, onChanged: (value) {
                        setState(() {
                          selectedLokasi = value!;
                        });
                      }),
                      SizedBox(width: 8),
                      _buildDropdown(
                          "Semua Komisi",
                          [
                            "Semua komisi",
                            "0 - 100.000 rupiah",
                            "100.000 - 200.000 rupiah",
                            "200.000 - 500.000 rupiah",
                            "500.000 - 1.000.000 rupiah",
                            "1.000.000 - 5.000.000 rupiah",
                            "5.000.000 - 10.000.000 rupiah",
                            "10.000.000 - 20.000.000 rupiah",
                            "20.000.000 - 30.000.000 rupiah",
                            "> 30.000.000 rupiah"
                          ],
                          selectedValue: selectedKomisi, onChanged: (value) {
                        setState(() {
                          selectedKomisi = value!;
                        });
                      }, isWide: true),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 27),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(height: 10),
                        Container(
                          width: double.infinity,
                          height: 100,
                          padding: EdgeInsets.all(0),
                          child: FutureBuilder<List<Survey>>(
                            future: apiService.getSurveys(),
                            builder: (context, snapshot) {
                              List<Survey> surveys = [];

                              if (snapshot.hasData && snapshot.data != null) {
                                surveys = snapshot.data!;
                              }

                              return SurveyStatusWidget(surveys: surveys);
                            },
                          ),
                        ),
                        ListView.separated(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: filteredSurveys.length,
                          separatorBuilder: (context, index) =>
                              SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            Survey survey = filteredSurveys[index];

                            return SurveyCard(
                              title: survey.namaProyek,
                              timeAgo: survey.calculateDeadline(),
                              fileType: survey.tipeHasil.join(", "),
                              status: survey.statusTask,
                              showRating: survey.statusTask == "selesai",
                              onDownload: survey.statusTask == "selesai"
                                  ? () => print("Download tapped")
                                  : null,
                              onChat: survey.statusTask == "ditinjau" ||
                                      survey.statusTask == "dikerjakan"
                                  ? () => print("Chat tapped")
                                  : null,
                              onMore: () => print("More options tapped"),
                              chatCount: (survey.statusTask == "dikerjakan")
                                  ? 3
                                  : null,
                              onWork: survey.statusTask == "merekrut"
                                  ? () => print("Work tapped")
                                  : null,
                            );
                          },
                        ),
                        SizedBox(height: 40),
                        if (filteredSurveys.isEmpty)
                          Center(
                            child: Text(
                              'Tidak ada survei yang ditemukan.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color(0xFFA3948D),
                                fontFamily: 'NunitoSans',
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        if (filteredSurveys.isNotEmpty)
                          Center(
                            child: Container(
                              width: double.infinity,
                              child: Center(
                                child: Text(
                                  'Anda memiliki total ${filteredSurveys.length} proyek',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Color(0xFFA3948D),
                                    fontFamily: 'NunitoSans',
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 32,
            right: 32,
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xFF3A2B24),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Color(0x40000000),
                    offset: Offset(0, 4),
                    blurRadius: 4,
                  ),
                ],
              ),
              child: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                onPressed: () {
                  print('Custom FAB Terklik!');
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                    SizedBox(width: 4),
                    Text(
                      "Buat Baru",
                      style: TextStyle(
                        fontFamily: 'NunitoSans',
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        decoration: TextDecoration.none,
                        color: Color(0xFFffffff),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        color: Color(0xffD7CCC8),
        padding: EdgeInsets.symmetric(horizontal: 32, vertical: 8),
        child: GestureDetector(
          onTap: () {
            print("Footer link clicked!");
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 80,
                height: 60,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/proyek.png',
                      width: 24,
                      height: 24,
                      fit: BoxFit.contain,
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Proyek',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'NunitoSans',
                        color: Color(0xFF705D54),
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Clientchat()),
                  );
                },
                child: Container(
                  width: 80,
                  height: 60,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/chat3.png',
                        width: 24,
                        height: 24,
                        fit: BoxFit.contain,
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Chat',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'NunitoSans',
                          color: Color(0xFFC4B8B1),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Clientsaya()),
                  );
                },
                child: Container(
                  width: 80,
                  height: 60,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/saya.png',
                        width: 24,
                        height: 24,
                        fit: BoxFit.contain,
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Saya',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'NunitoSans',
                          color: Color(0xFFB8ADA5),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown(String hint, List<String> options,
      {required String selectedValue,
      required ValueChanged<String?> onChanged,
      bool isWide = false}) {
    return Container(
      width: isWide ? 300 : 200,
      height: 40,
      child: DropdownButtonFormField<String>(
        isDense: true,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: Color(0xFF705D54),
              width: 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: Color(0xFF705D54),
              width: 2.0,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: Color(0xFF705D54),
              width: 1.0,
            ),
          ),
        ),
        hint: Text(
          hint,
          style: TextStyle(
            fontFamily: 'NunitoSans',
            fontSize: 16,
            fontWeight: FontWeight.w400,
            height: 21.82 / 16,
            decoration: TextDecoration.none,
            color: Color(0xFF705D54),
          ),
        ),
        value: selectedValue,
        items: options.map((String option) {
          return DropdownMenuItem<String>(
            value: option,
            child: Text(
              option,
              style: TextStyle(
                fontFamily: 'NunitoSans',
                fontSize: 16,
                fontWeight: FontWeight.w400,
                height: 21.82 / 16,
                decoration: TextDecoration.none,
                color: Color(0xFF705D54),
              ),
            ),
          );
        }).toList(),
        onChanged: onChanged,
        icon: Icon(Icons.keyboard_arrow_down, color: Color(0xFF705D54)),
      ),
    );
  }

  Widget _buildIconBox() {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedStatus = "Semua status";
          selectedPeran = "Semua peran";
          selectedLokasi = "Semua lokasi";
          selectedKomisi = "Semua komisi";
        });
      },
      child: Container(
        width: 40,
        height: 40,
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Color(0xFF705D54),
            width: 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: 2,
              color: Color(0xFF705D54),
            ),
            SizedBox(height: 4),
            Container(
              width: 2 / 3 * 20,
              height: 2,
              color: Color(0xFF705D54),
            ),
            SizedBox(height: 4),
            Container(
              width: 1 / 2 * 20,
              height: 2,
              color: Color(0xFF705D54),
            ),
          ],
        ),
      ),
    );
  }
}
