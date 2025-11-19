// 시뮬레이터에서 맥에 있는 Django 서버 접속할 때는 127.0.0.1:8000 쓰기!
// 실제로 아이폰에서 테스트할 때는 baseURL을 <맥IP주소>:8000 으로 바꾸기

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/storage_location.dart';

/// iOS 시뮬레이터 기준 baseUrl
const String baseUrl = 'http://127.0.0.1:8000';

class ApiClient {
    Future<List<StorageLocation>> fetchStorages() async {
        final uri = Uri.parse('$baseUrl/api/storages/');
        final response = await http.get(uri);

        if (response.statusCode != 200) {
        throw Exception('Failed to load storages: ${response.statusCode}');
        }

        final List<dynamic> data = jsonDecode(response.body);
        return data
            .map((e) => StorageLocation.fromJson(e as Map<String, dynamic>))
            .toList();
    }
}