import 'dart:convert';
import 'package:http/http.dart' as http;

class Survey {
  String idSurvey;
  String namaProyek;
  String deskripsiProyek;
  String tenggatPengerjaan;
  String lokasi;
  String alamat;
  List<String> keahlian;
  List<String> tipeHasil;
  String kompensasi;
  String idClient;
  String createdAt;
  String statusTask;

  Survey({
    required this.idSurvey,
    required this.namaProyek,
    required this.deskripsiProyek,
    required this.tenggatPengerjaan,
    required this.lokasi,
    required this.alamat,
    required this.keahlian,
    required this.tipeHasil,
    required this.kompensasi,
    required this.idClient,
    required this.createdAt,
    required this.statusTask,
  });

  Map<String, dynamic> toJson() {
    return {
      'id_survey': idSurvey,
      'nama_proyek': namaProyek,
      'deskripsi_proyek': deskripsiProyek,
      'tenggat_pengerjaan': tenggatPengerjaan,
      'lokasi': lokasi,
      'alamat': alamat,
      'keahlian': keahlian,
      'tipe_hasil': tipeHasil,
      'kompensasi': kompensasi,
      'id_client': idClient,
      'created_at': createdAt,
      'status_task': statusTask,
    };
  }

  static Survey fromJson(Map<String, dynamic> json) {
    return Survey(
      idSurvey: json['id_survey'],
      namaProyek: json['nama_proyek'],
      deskripsiProyek: json['deskripsi_proyek'],
      tenggatPengerjaan: json['tenggat_pengerjaan'],
      lokasi: json['lokasi'],
      alamat: json['alamat'],
      keahlian: List<String>.from(json['keahlian']),
      tipeHasil: List<String>.from(json['tipe_hasil']),
      kompensasi: json['kompensasi'],
      idClient: json['id_client'],
      createdAt: json['created_at'],
      statusTask: json['status_task'],
    );
  }

  String calculateDeadline() {
    try {
      DateTime deadline = DateTime.parse(tenggatPengerjaan).toLocal();
      DateTime now = DateTime.now();

      Duration difference = deadline.difference(now);
      bool isPast = difference.isNegative;
      int days = difference.inDays.abs();
      int weeks = (days / 7).floor();
      int months = (days / 30).floor();
      int years = (days / 365).floor();

      if (years > 0) {
        return "$years tahun ${isPast ? 'lalu' : 'lagi'}";
      } else if (months > 0) {
        return "$months bulan ${isPast ? 'lalu' : 'lagi'}";
      } else if (weeks > 0) {
        return "$weeks minggu ${isPast ? 'lalu' : 'lagi'}";
      } else if (days > 0) {
        return "$days hari ${isPast ? 'lalu' : 'lagi'}";
      } else {
        return isPast ? "Sudah lewat" : "Hari ini";
      }
    } catch (e) {
      print("Error parsing tenggat pengerjaan: $e");
      return "Format tidak valid";
    }
  }
}

class ApiService {
  final String baseUrl;
  final String authToken;

  ApiService(this.baseUrl, this.authToken);

  Future<List<Survey>> getSurveys() async {
    final response = await http.get(
      Uri.parse('$baseUrl/surveys/clientSurveys'),
      headers: {
        "Authorization": "Bearer $authToken",
        "Content-Type": "application/json",
      },
    );

    print("Response Status Code: ${response.statusCode}");
    print("Response Body: ${response.body}");

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = json.decode(response.body);

      if (jsonResponse['data'] is List) {
        List<dynamic> data = jsonResponse['data'];
        return data.map((survey) => Survey.fromJson(survey)).toList();
      } else {
        throw Exception("Unexpected data format: ${jsonResponse['data']}");
      }
    } else {
      throw Exception('Failed to load surveys');
    }
  }

  Future<Survey> getSurvey(String id) async {
    final response = await http.get(
      Uri.parse('$baseUrl/surveys/clientSurveys/$id'),
      headers: {
        "Authorization": "Bearer $authToken",
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = json.decode(response.body);

      if (jsonResponse['data'] is Map<String, dynamic>) {
        return Survey.fromJson(jsonResponse['data']);
      } else {
        throw Exception("Unexpected data format: ${jsonResponse['data']}");
      }
    } else {
      throw Exception('Failed to load survey');
    }
  }
}
