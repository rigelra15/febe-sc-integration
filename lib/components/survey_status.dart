import 'package:flutter/material.dart';
import 'package:surveyscout/api/api_service.dart';

class SurveyStatusWidget extends StatelessWidget {
  final List<Survey> surveys;

  const SurveyStatusWidget({Key? key, required this.surveys}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Map<String, int> statusCounts = {
      'merekrut': 0,
      'dikerjakan': 0,
      'ditinjau': 0,
      'selesai': 0,
    };

    for (var survey in surveys) {
      if (statusCounts.containsKey(survey.statusTask)) {
        statusCounts[survey.statusTask] = (statusCounts[survey.statusTask] ?? 0) + 1;
      }
    }

    List<Map<String, dynamic>> statusData = [
      {'status': 'merekrut', 'label': 'Merekrut', 'icon': 'assets/images/merekrut.png'},
      {'status': 'dikerjakan', 'label': 'Dikerjakan', 'icon': 'assets/images/dikerjakan.png'},
      {'status': 'ditinjau', 'label': 'Butuh Tinjau', 'icon': 'assets/images/butuhtinjau.png'},
      {'status': 'selesai', 'label': 'Selesai', 'icon': 'assets/images/selesai.png'},
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: statusData.map((data) {
        return _buildStatusCard(
          context,
          statusCounts[data['status']] ?? 0,
          data['label'],
          data['icon'],
        );
      }).toList(),
    );
  }

  Widget _buildStatusCard(BuildContext context, int count, String label, String iconPath) {
    return Container(
      width: (MediaQuery.of(context).size.width - 54) / 4,
      height: 100,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            height: 50,
            padding: EdgeInsets.only(top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.all(0),
                  width: (MediaQuery.of(context).size.width - 54) / 8,
                  height: double.infinity,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Image.asset(
                      iconPath,
                      fit: BoxFit.contain,
                      width: 20,
                      height: 20,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(3),
                  width: (MediaQuery.of(context).size.width - 54) / 8,
                  height: double.infinity,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      count.toString(),
                      style: TextStyle(
                        fontFamily: 'SourceSans3',
                        fontSize: 24,
                        fontWeight: FontWeight.w400,
                        decoration: TextDecoration.none,
                        color: Color(0xFF705D54),
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            height: 20,
            child: Center(
              child: Text(
                label,
                style: TextStyle(
                  fontFamily: 'NunitoSans',
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  height: 16.37 / 12,
                  decorationColor: Color(0xFFA3948D),
                  decorationStyle: TextDecorationStyle.solid,
                  color: Color(0xFFA3948D),
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
