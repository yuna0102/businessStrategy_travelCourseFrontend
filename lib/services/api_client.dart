// 시뮬레이터에서 맥에 있는 Django 서버 접속할 때는 127.0.0.1:8000 쓰기!
// 실제로 아이폰에서 테스트할 때는 baseURL을 <맥IP주소>:8000 으로 바꾸기

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/storage_location.dart';
import '../models/course.dart';

class StorageApiService {
    static const String baseUrl = 'http://127.0.0.1:8000/api';

    static Future<List<StorageLocation>> fetchStorages({
        DistrictFilter? district,
        StorageType? type,
    }) async {
        final Map<String, String> params = {};

        if (district != null) {
        params['district'] = district.backendValue;
        }
        if (type != null) {
        params['type'] = type.backendValue;
        }

        final uri = Uri.parse('$baseUrl/storages/')
            .replace(queryParameters: params.isEmpty ? null : params);

        final res = await http.get(uri);
        if (res.statusCode != 200) {
        throw Exception('Failed to load storages');
        }

        final List<dynamic> data = json.decode(res.body) as List<dynamic>;
        return data
            .map((e) => StorageLocation.fromJson(e as Map<String, dynamic>))
            .toList();
    }
}

// course api 붙이는 클래스
class CourseApiService {
    static const String baseUrl = 'http://127.0.0.1:8000/api';

    /// 특정 보관소의 코스 리스트 가져오기
    static Future<List<Course>> fetchCoursesByStorage(int storageId) async {
        final uri = Uri.parse('$baseUrl/storages/$storageId/courses/');

        final res = await http.get(uri);
        if (res.statusCode != 200) {
        throw Exception('Failed to load courses');
        }

        final List<dynamic> data = json.decode(res.body) as List<dynamic>;
        return data
            .map((e) => Course.fromJson(e as Map<String, dynamic>))
            .toList();
    }
}