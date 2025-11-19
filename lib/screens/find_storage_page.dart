import 'package:flutter/material.dart';
import '../models/storage_location.dart';
import '../services/api_client.dart';
import '../widgets/storage_card.dart';

// 짐 보관소 찾기 페이지
class FindStoragePage extends StatefulWidget {
    const FindStoragePage({super.key});

    @override
    State<FindStoragePage> createState() => _FindStoragePageState();
    }

    class _FindStoragePageState extends State<FindStoragePage> {
    final _api = ApiClient();
    late Future<List<StorageLocation>> _future;

    // 상단 필터 상태
    int _selectedDistrictIndex = 0;
    int _selectedTypeIndex = 0;

    final _districts = ['용산구', '종로구', '마포구'];
    final _types = ['Station Locker', 'Private Storage', 'Cafe Storage'];

    @override
    void initState() {
        super.initState();
        _future = _api.fetchStorages();
    }

    @override
    Widget build(BuildContext context) {
        final theme = Theme.of(context);

        return Scaffold(
        backgroundColor: const Color(0xFFF5F5F7),
        appBar: AppBar(
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.white,
            elevation: 0,
            leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, size: 18),
            onPressed: () {
                // TODO: 이전 화면 연결되면 Navigator.pop()
            },
            ),
            title: const Text(
            'Find Storage',
            style: TextStyle(fontWeight: FontWeight.bold),
            ),
            actions: [
            IconButton(
                icon: const Icon(Icons.settings),
                onPressed: () {},
            ),
            const SizedBox(width: 4),
            ],
        ),
        body: Column(
            children: [
            // 상단 필터 영역
            Container(
                color: Colors.white,
                padding:
                    const EdgeInsets.only(left: 16, right: 16, top: 12, bottom: 12),
                child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                    // 구 선택 칩
                    SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                        children: List.generate(_districts.length, (index) {
                        final selected = _selectedDistrictIndex == index;
                        return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: ChoiceChip(
                            label: Text(_districts[index]),
                            selected: selected,
                            onSelected: (_) {
                                setState(() {
                                _selectedDistrictIndex = index;
                                });
                            },
                            selectedColor: const Color(0xFF5B34FF),
                            labelStyle: TextStyle(
                                color: selected ? Colors.white : Colors.black,
                            ),
                            backgroundColor: const Color(0xFFF1F1F5),
                            ),
                        );
                        }),
                    ),
                    ),
                    const SizedBox(height: 12),
                    // 검색 바
                    TextField(
                    decoration: InputDecoration(
                        hintText: 'Search station or locker...',
                        prefixIcon: const Icon(Icons.search),
                        filled: true,
                        fillColor: const Color(0xFFF5F5F7),
                        contentPadding: const EdgeInsets.symmetric(
                        vertical: 0,
                        horizontal: 12,
                        ),
                        border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                        ),
                    ),
                    ),
                    const SizedBox(height: 12),
                    // 타입 탭 (Station / Private / Cafe)
                    Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: List.generate(_types.length, (index) {
                        final selected = _selectedTypeIndex == index;
                        return Expanded(
                        child: Padding(
                            padding: EdgeInsets.only(
                            left: index == 0 ? 0 : 4,
                            right: index == _types.length - 1 ? 0 : 4,
                            ),
                            child: GestureDetector(
                            onTap: () {
                                setState(() {
                                _selectedTypeIndex = index;
                                });
                            },
                            child: Container(
                                height: 36,
                                decoration: BoxDecoration(
                                color: selected
                                    ? const Color(0xFF5B34FF)
                                    : const Color(0xFFF5F5F7),
                                borderRadius: BorderRadius.circular(18),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                _types[index],
                                style: TextStyle(
                                    color:
                                        selected ? Colors.white : Colors.black87,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                ),
                                ),
                            ),
                            ),
                        ),
                        );
                    }),
                    ),
                ],
                ),
            ),

            const SizedBox(height: 8),

            // 리스트 영역
            Expanded(
                child: FutureBuilder<List<StorageLocation>>(
                future: _future,
                builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                    return Center(
                        child: Text(
                        'Failed to load storages\n${snapshot.error}',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyMedium,
                        ),
                    );
                    }

                    final storages = snapshot.data ?? [];
                    if (storages.isEmpty) {
                    return const Center(child: Text('No storages found.'));
                    }

                    return ListView.separated(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    itemCount: storages.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                        final s = storages[index];
                        return StorageCard(
                        storage: s,
                        onTap: () {
                            // TODO: 여기서 Luggage Detail 화면으로 이동
                        },
                        );
                    },
                    );
                },
                ),
            ),
            ],
        ),
        );
    }
}