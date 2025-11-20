import 'package:flutter/material.dart';
import '../models/storage_location.dart';
import '../widgets/storage_card.dart';
import '../theme/app_theme.dart';
import '../services/api_client.dart';
import '../widgets/storage_booking_bottom_sheet.dart';
import 'package:travellight_frontend/screens/courses_page.dart';

class FindStoragePage extends StatefulWidget {
    const FindStoragePage({super.key});

    @override
    State<FindStoragePage> createState() => _FindStoragePageState();
    }

class _FindStoragePageState extends State<FindStoragePage> {
    // 필터 선택 상태 표시
    DistrictFilter _selectedDistrict = DistrictFilter.yongsan;
    StorageType _selectedType = StorageType.stationLocker;

    late Future<List<StorageLocation>> _futureStorages;

    @override
    void initState() {
        super.initState();
        _futureStorages = _loadStorages();
    }

    Future<List<StorageLocation>> _loadStorages() {
        return StorageApiService.fetchStorages(
        district: _selectedDistrict,
        type: _selectedType,
        );
    }

    void _onDistrictTap(DistrictFilter district) {
        setState(() {
        _selectedDistrict = district;
        _futureStorages = _loadStorages();
        });
    }

    void _onTypeTap(StorageType type) {
        setState(() {
        _selectedType = type;
        _futureStorages = _loadStorages();
        });
    }


    Future<void> _openStorageBookingBottomSheet(StorageLocation storage) async {
        final selection = await showModalBottomSheet<StorageBookingSelection>(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (_) => StorageBookingBottomSheet(
            storage: storage,
        ),
        );

        if (!mounted || selection == null) return;
            Navigator.of(context).push(
            MaterialPageRoute(
                builder: (_) => CoursesPage.mock(),
            ),
        );
    }


    @override
    Widget build(BuildContext context) {
        return Scaffold(
        // 배경은 theme 의 scaffoldBackgroundColor 그대로 사용
        appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0.5,
            centerTitle: true,
            title: Text(
            'Find Storage',
            style: AppTextStyles.pageTitle,
            ),
        ),
        body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            // 상단 지역 + 타입 필터 영역 (전체 너비 흰 배경)
            Container(
                width: double.infinity,
                color: Colors.white,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                    // 상단 지역 필터 (용산구 / 종로구 / 마포구)
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                            children: DistrictFilter.values.map((district) {
                            final bool isSelected = _selectedDistrict == district;
                            return Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: ChoiceChip(
                                label: Text(
                                    district.labelKo,
                                    style: TextStyle(
                                    color: isSelected
                                        ? Colors.white
                                        : const Color(0xFF838383),
                                    fontWeight: FontWeight.w600,
                                    ),
                                ),
                                selected: isSelected,
                                onSelected: (_) => _onDistrictTap(district),
                                selectedColor: AppColors.primary, // #8400FF
                                backgroundColor: Colors.white,
                                side: BorderSide(
                                    color: isSelected
                                        ? AppColors.primary
                                        : const Color(0xFFD0D0D0), // #D0D0D0
                                ),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(999),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                ),
                                ),
                            );
                            }).toList(),
                        ),
                        ),
                    ),

                    const SizedBox(height: 8),

                    // 보관소 타입 필터 (Station / Private / Local)
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                            children: StorageType.values.map((type) {
                            final bool isSelected = _selectedType == type;
                            return Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: ChoiceChip(
                                label: Text(
                                    type.label, // enum extension 에서 'Station Locker' 등으로 변환
                                    style: TextStyle(
                                    color: isSelected
                                        ? Colors.white
                                        : const Color(0xFF838383),
                                    fontWeight: FontWeight.w500,
                                    ),
                                ),
                                selected: isSelected,
                                onSelected: (_) => _onTypeTap(type),
                                selectedColor: AppColors.primary,
                                backgroundColor: Colors.white,
                                side: BorderSide(
                                    color: isSelected
                                        ? AppColors.primary
                                        : const Color(0xFFD0D0D0),
                                ),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(999),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 6,
                                ),
                                ),
                            );
                            }).toList(),
                        ),
                        ),
                    ),
                    ],
                ),
            ),

            const SizedBox(height: 8),

            // 3) 짐 보관소 리스트 (백엔드 연동)
            Expanded(
                child: FutureBuilder<List<StorageLocation>>(
                future: _futureStorages,
                builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                    return Center(
                        child: Text(
                        'Failed to load storages',
                        style: AppTextStyles.body,
                        ),
                    );
                    }

                    final storages = snapshot.data ?? [];

                    if (storages.isEmpty) {
                    return Center(
                        child: Text(
                        'No storage locations found',
                        style: AppTextStyles.body.copyWith(
                            color: AppColors.textMuted,
                        ),
                        ),
                    );
                    }

                    return ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        itemCount: storages.length,
                        itemBuilder: (context, index) {
                            final storage = storages[index];

                            return StorageCard(
                                storage: storage,
                                onTap: () => _openStorageBookingBottomSheet(storage),
                            );
                        },
                        separatorBuilder: (_, __) => const SizedBox(height: 16),
                        );
                },
                ),
            ),
            ],
        ),
        );
    }

}