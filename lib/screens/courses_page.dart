import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';  


import '../theme/app_theme.dart';
import '../models/course.dart';   
import '../models/user_profile.dart';     

import 'course_detail_page.dart';       



enum CourseDurationFilter {
    all, 
    thirty,    // 30분
    sixty,     // 60분 = 1 hour
    oneTwenty, // 120분 = 2 hours
}

extension CourseDurationFilterX on CourseDurationFilter {
    String get label {
        switch (this) {
            case CourseDurationFilter.all:
                return 'All';
            case CourseDurationFilter.thirty:
                return '30 min';
            case CourseDurationFilter.sixty:
                return '1 hour';
            case CourseDurationFilter.oneTwenty:
                return '2 hours';
            }
    }

    int get minutes {
        switch (this) {
            case CourseDurationFilter.all:
                return 0;
            case CourseDurationFilter.thirty:
                return 30;
            case CourseDurationFilter.sixty:
                return 60;
            case CourseDurationFilter.oneTwenty:
                return 120;
        }
    }
}

class CoursesPage extends StatefulWidget {
    /// 시작 위치 표시 (예: “Seoul Station Locker”)
    final String? startFromLocation;

    /// 상단 토스트 보여줄지 여부 (짐 예약 완료 메시지)
    final bool showBookingBanner;
    final String? bookingBannerMessage;

    /// 보여줄 코스 리스트 (나중에 서버 데이터로 교체)
    final List<Course> courses;

    /// Reddit 추천 국가 라벨 (예: "🇬🇧 UK")
    final String redditCountryLabel;

    const CoursesPage({
        super.key,
        this.courses = const [],
        this.startFromLocation,
        this.showBookingBanner = false,
        this.bookingBannerMessage,
        this.redditCountryLabel = '🇬🇧 UK', //default값 지정
    });

    /// 지금은 목업용으로 이 팩토리 사용 → 나중에 서버 연동 시 이 부분만 교체
    factory CoursesPage.mock() {
        return CoursesPage(
        startFromLocation: 'Seoul Station Locker',
        showBookingBanner: true,
        bookingBannerMessage: 'Your luggage booking request has been received.',
        courses: [
            Course(
            id: '1',
            title: 'Insadong Tea Tour',
            subtitle: 'Traditional Korean tea & desserts',
            durationMinutes: 30,
            imageUrl: 'https://picsum.photos/600/360?1',
            walkingMinutes: 5,
            categoryEmoji: '🍵',
            categoryBgColor: const Color(0xFFFFFBEB),
            reviewerName: 'Sarah',
            reviewerMeta: '(🇬🇧, 28)',
            reviewAgoText: '3 weeks ago',
            ),
            Course(
            id: '2',
            title: 'Gyeongbokgung Palace Tour',
            subtitle: 'Historic royal palace & museum',
            durationMinutes: 60,
            imageUrl: 'https://picsum.photos/600/360?2',
            walkingMinutes: 12,
            categoryEmoji: '🏛',
            categoryBgColor: const Color(0xFFFAF5FF),
            reviewerName: 'James',
            reviewerMeta: '(🇬🇧, 32)',
            reviewAgoText: '1 week ago',
            ),
            Course(
            id: '3',
            title: 'Gwangjang Market Food Tour',
            subtitle: 'Traditional food market & street eats',
            durationMinutes: 120,
            imageUrl: 'https://picsum.photos/600/360?3',
            walkingMinutes: 18,
            categoryEmoji: '🍜',
            categoryBgColor: const Color(0xFFFEF2F2),
            reviewerName: 'Emma',
            reviewerMeta: '(🇬🇧, 26)',
            reviewAgoText: '2 days ago',
            ),
            Course(
            id: '4',
            title: 'Cafe Onion Anguk',
            subtitle: 'Trendy cafe in hanok building',
            durationMinutes: 60,
            imageUrl: 'https://picsum.photos/600/360?4',
            walkingMinutes: 8,
            categoryEmoji: '☕️',
            categoryBgColor: const Color(0xFFFFF7ED),
            reviewerName: 'Oliver',
            reviewerMeta: '(🇬🇧, 29)',
            reviewAgoText: '5 days ago',
            ),
            Course(
            id: '5',
            title: 'Bukchon Hanok Village',
            subtitle: 'Traditional Korean village & photo spots',
            durationMinutes: 30,
            imageUrl: 'https://picsum.photos/600/360?5',
            walkingMinutes: 15,
            categoryEmoji: '🏡',
            categoryBgColor: const Color(0xFFF0FDF4),
            reviewerName: 'Lucy',
            reviewerMeta: '(🇬🇧, 31)',
            reviewAgoText: '1 week ago',
            ),
        ],
        );
    }

    @override
    State<CoursesPage> createState() => _CoursesPageState();
    }

class _CoursesPageState extends State<CoursesPage> {
    CourseDurationFilter _selectedDuration = CourseDurationFilter.all;
    // 토스트 메세지 배너로 노출하지 않고 사라지게 할 거임
    bool _showBanner = false; // 토스트 배너 노출 여부
    
    List<Course> get _filteredCourses {
        // All 선택 시 전체 코스 노출
        if (_selectedDuration == CourseDurationFilter.all) {
            return widget.courses;
        }

        final target = _selectedDuration.minutes;
        // durationMinutes가 target(30/60/120)에 해당하는 코스만 보여주기
        return widget.courses.where((c) => c.durationMinutes == target).toList();
    }

    void _onDurationSelected(CourseDurationFilter filter) {
        setState(() {
        _selectedDuration = filter;
        });
    }

    @override
    void initState() {
        super.initState();

        // 페이지 진입 시 예약 완료 배너를 3초 동안만 노출
        _showBanner = widget.showBookingBanner;
        if (_showBanner) {
        Future.delayed(const Duration(seconds: 3), () {
            if (!mounted) return;
            setState(() {
            _showBanner = false;
            });
        });
        }}
    @override
    Widget build(BuildContext context) {
      // 온보딩에서 선택한 국가(TravelerCountry)를 읽어와 국기 이모지로 변환
        final userProfile = context.read<UserProfile>();

        String flagFromCountry(TravelerCountry country) {
            switch (country) {
            case TravelerCountry.uk:
                return '🇬🇧';
            case TravelerCountry.germany:
                return '🇩🇪';
            case TravelerCountry.us:
                return '🇺🇸';
            default:
                return '🌍';
            }
        }

        final flagEmoji = flagFromCountry(userProfile.country);

        return Scaffold(
            backgroundColor: AppColors.background,
            appBar: AppBar(
                backgroundColor: Colors.white,
                elevation: 0.5,
                centerTitle: true,
                title: Text(
                'Courses',
                style: AppTextStyles.pageTitle.copyWith(fontSize: 16),
                ),
            ),
            body: Column(
                children: [
                    // (선택) 상단 토스트: 짐 예약 완료 (3초 후 자동 숨김)
                    if (_showBanner)
                    _BookingBanner(
                        message: widget.bookingBannerMessage ??
                            'Your luggage booking request has been received.',
                    ),

                    // 시작 위치 Card (“Start from Seoul Station Locker”)
                    if (widget.startFromLocation != null)
                        _StartFromCard(location: widget.startFromLocation!),

                    // 시간 필터 (30 min / 1 hour / 2 hours)
                    _DurationFilterRow(
                        selected: _selectedDuration,
                        onChanged: _onDurationSelected,
                    ),

                    // 나머지는 스크롤 영역
                    Expanded(
                        child: ListView(
                        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                        children: [
                            _RedditRecommendationCard(
                                countryLabel: widget.redditCountryLabel,
                            ),
                            const SizedBox(height: 16),

                            if (_filteredCourses.isEmpty)
                                Padding(
                                    padding: const EdgeInsets.only(top: 24),
                                    child: Center(
                                    child: Text(
                                        'No courses for this duration yet.',
                                        style: AppTextStyles.body.copyWith(
                                        color: AppColors.textMuted,
                                        ),
                                    ),
                                    ),
                                )
                                else
                                ..._filteredCourses.map(
                                    (c) => Padding(
                                    padding: const EdgeInsets.only(bottom: 12),
                                    child: _CourseCard(
                                        course: c,
                                        flagEmoji: flagEmoji,
                                    ),
                                    ),
                                ),
                        ],
                        ),
                    ),
                ],
            ),
            );
        }
}

/// 상단 토스트
class _BookingBanner extends StatelessWidget {
    final String message;

    const _BookingBanner({required this.message});

    @override
    Widget build(BuildContext context) {
        return Container(
        margin: const EdgeInsets.fromLTRB(16, 12, 16, 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
            children: [
            const Icon(Icons.check_circle, color: Colors.greenAccent, size: 18),
            const SizedBox(width: 8),
            Expanded(
                child: Text(
                message,
                style: AppTextStyles.caption.copyWith(
                    color: Colors.white,
                ),
                ),
            ),
            ],
        ),
        );
    }
}

/// “Start from Seoul Station Locker” 영역
class _StartFromCard extends StatelessWidget {
    final String location;

    const _StartFromCard({required this.location});

    @override
    Widget build(BuildContext context) {
        return Container(
        width: double.infinity,
        padding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(
            bottom: BorderSide(color: Color(0xFFF3F4F6)),
            ),
        ),
        child: Row(
            children: [
            Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                color: const Color(0x19007AFF),
                borderRadius: BorderRadius.circular(999),
                ),
                child: const Icon(
                Icons.place,
                size: 18,
                color: AppColors.primary,
                ),
            ),
            const SizedBox(width: 12),
            Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                Text(
                    'Start from',
                    style: AppTextStyles.body.copyWith(
                    fontSize: 14,
                    color: AppColors.textMuted,
                    ),
                ),
                const SizedBox(height: 2),
                Text(
                    location,
                    style: AppTextStyles.bodyBold.copyWith(fontSize: 16),
                ),
                ],
            ),
            ],
        ),
        );
    }
}

class _DurationFilterRow extends StatelessWidget {
    final CourseDurationFilter selected;
    final ValueChanged<CourseDurationFilter> onChanged;

    const _DurationFilterRow({
        required this.selected,
        required this.onChanged,
    });

    @override
    Widget build(BuildContext context) {
        return Container(
        color: Colors.white,
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
                children: [
                CourseDurationFilter.all,
                CourseDurationFilter.thirty,
                CourseDurationFilter.sixty,
                CourseDurationFilter.oneTwenty,
                ].map((filter) {
                final isSelected = selected == filter;
                return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                    label: Text(
                        filter.label,
                        style: TextStyle(
                        color: isSelected
                            ? Colors.white
                            : const Color(0xFF6B7280),
                        fontWeight: FontWeight.w600,
                        ),
                    ),
                    selected: isSelected,
                    onSelected: (_) => onChanged(filter),
                    selectedColor: AppColors.primary,
                    backgroundColor: Colors.white,
                    side: BorderSide(
                        color: isSelected
                            ? AppColors.primary
                            : const Color(0xFFE5E7EB),
                    ),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(999),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 10,
                    ),
                    ),
                );
                }).toList(),
            ),
            ),
        ),
        );
    }
}

class _DurationChip extends StatelessWidget {
    final String label;
    final bool selected;
    final VoidCallback onTap;

    const _DurationChip({
        required this.label,
        required this.selected,
        required this.onTap,
    });

    @override
    Widget build(BuildContext context) {
        return Expanded(
        child: GestureDetector(
            onTap: onTap,
            child: Container(
            height: 40,
            decoration: BoxDecoration(
                color: selected ? AppColors.primary : const Color(0xFFF3F4F6),
                borderRadius: BorderRadius.circular(999),
                boxShadow: selected
                    ? const [
                        BoxShadow(
                        color: Color(0x4C3B82F6),
                        blurRadius: 10,
                        offset: Offset(0, 6),
                        ),
                    ]
                    : null,
            ),
            alignment: Alignment.center,
            child: Text(
                label,
                style: AppTextStyles.body.copyWith(
                fontSize: 14,
                color: selected ? Colors.white : const Color(0xFF4B5563),
                ),
            ),
            ),
        ),
        );
    }
}

/// “Top Picks of Reddit” 카드
class _RedditRecommendationCard extends StatelessWidget {
    final String countryLabel;
    const _RedditRecommendationCard({
        required this.countryLabel,
    });

    @override
    Widget build(BuildContext context) {
        return Container(
        width: double.infinity,
        padding:
            const EdgeInsets.fromLTRB(16, 16, 16, 16),
        decoration: BoxDecoration(
            gradient: const LinearGradient(
            begin: Alignment.centerRight,
            end: Alignment.centerLeft,
            colors: [Color(0xFFEFF6FF), Color(0xFFEEF2FF)],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFDBEAFE)),
        ),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            Row(
                children: [
                const Icon(Icons.info_outline,
                    size: 16, color: Color(0xFF007AFF)),
                const SizedBox(width: 6),
                Text(
                    'Top Picks of Reddit',
                    style: AppTextStyles.caption.copyWith(
                    color: const Color(0xFF007AFF),
                    fontWeight: FontWeight.w600,
                    ),
                ),
                ],
            ),
            const SizedBox(height: 8),
            Text(
                'Recommendations from fellow travelers from',
                style: AppTextStyles.body.copyWith(
                fontSize: 14,
                color: const Color(0xFF374151),
                ),
            ),
            const SizedBox(height: 8),
            Row(
                children: [
                Text(
                    countryLabel,
                    style: AppTextStyles.pageTitle.copyWith(
                    fontSize: 24,
                    color: const Color(0xFF374151),
                    ),
                ),
                const SizedBox(width: 12),
                // 프로필 더미 3개 + +80
                Stack(
                    clipBehavior: Clip.none,
                    children: [
                    _avatar(0),
                    Positioned(left: 16, child: _avatar(1)),
                    Positioned(left: 32, child: _avatar(2)),
                    Positioned(
                        left: 60,
                        top: 6,
                        child: Text(
                        '+80',
                        style: AppTextStyles.caption.copyWith(
                            color: const Color(0xFF007AFF),
                            fontSize: 11,
                        ),
                        ),
                    ),
                    ],
                ),
                ],
            ),
            const SizedBox(height: 10),
            Text(
                'People like you visited these places',
                style: AppTextStyles.caption.copyWith(
                color: const Color(0xFF6B7280),
                ),
            ),
            ],
        ),
        );
    }

    Widget _avatar(int index) {
        return Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: Colors.white, width: 2),
            image: DecorationImage(
            image: NetworkImage('https://picsum.photos/28/28?$index'),
            fit: BoxFit.cover,
            ),
        ),
        );
    }
}

class _CourseCard extends StatelessWidget {
    final Course course;
    final String flagEmoji; // 🔹 온보딩에서 선택한 국기 이모지

    const _CourseCard({
        super.key,
        required this.course,
        required this.flagEmoji,
    });

    @override
    Widget build(BuildContext context) {
        // 🔹 코스 카드마다 다른 목업 프로필이 보이도록 목록 정의
        const mockProfiles = [
        (
            name: 'James',
            meta: 'Foodie traveler',
            ago: '3 weeks ago',
            avatar: 'https://picsum.photos/40/40?1',
        ),
        (
            name: 'Hannah',
            meta: 'Loves local cafes',
            ago: '1 month ago',
            avatar: 'https://picsum.photos/40/40?2',
        ),
        (
            name: 'Miguel',
            meta: 'Culture explorer',
            ago: '2 months ago',
            avatar: 'https://picsum.photos/40/40?3',
        ),
        (
            name: 'Sophie',
            meta: 'Museum lover',
            ago: '5 days ago',
            avatar: 'https://picsum.photos/40/40?4',
        ),
        ];

        // 🔹 코스 id 기반으로 “랜덤처럼” 프로필 선택 (빌드마다 바뀌지 않게)
        final index = course.id.hashCode.abs() % mockProfiles.length;
        final profile = mockProfiles[index];

        return GestureDetector(
        onTap: () {
            Navigator.of(context).push(
            MaterialPageRoute(
                builder: (_) => CourseDetailPage(course: course),
            ),
            );
        },
        child: Container(
            decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFF3F4F6)),
            boxShadow: const [
                BoxShadow(
                color: Color(0x0C000000),
                blurRadius: 2,
                offset: Offset(0, 1),
                ),
            ],
            ),
            child: Column(
            children: [
                // 상단 이미지 + 이동시간 배지
                Stack(
                children: [
                    ClipRRect(
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(16)),
                    child: AspectRatio(
                        aspectRatio: 341 / 192,
                        child: 
                            Image.network(
                                course.imageUrl,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                    // 이미지 로딩 실패하면 여기로 들어옴
                                    return Image.asset(
                                    'assets/images/course_placeholder.jpeg',
                                    fit: BoxFit.cover,
                                    );
                                },
                                )
                    ),
                    ),
                    Positioned(
                    right: 12,
                    top: 12,
                    child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.95),
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(color: const Color(0xFFE5E7EB)),
                        ),
                        child: Row(
                        children: [
                            const Icon(Icons.directions_walk, size: 14),
                            const SizedBox(width: 4),
                            Text(
                            '${course.walkingMinutes} min',
                            style: AppTextStyles.caption.copyWith(
                                color: const Color(0xFF1F2937),
                            ),
                            ),
                        ],
                        ),
                    ),
                    ),
                ],
                ),

                // 텍스트 영역
                Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                    // 타이틀 + 카테고리 이모지
                    Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                        Expanded(
                            child: Text(
                            course.title,
                            style: AppTextStyles.bodyBold.copyWith(
                                fontSize: 16,
                                color: const Color(0xFF111827),
                            ),
                            ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                            color: course.categoryBgColor,
                            borderRadius: BorderRadius.circular(14),
                            ),
                            child: Center(
                            child: Text(
                                course.categoryEmoji,
                                style: const TextStyle(
                                fontSize: 24,
                                ),
                            ),
                            ),
                        ),
                        ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                        course.subtitle,
                        style: AppTextStyles.body.copyWith(
                        fontSize: 14,
                        color: const Color(0xFF4B5563),
                        ),
                    ),
                    const SizedBox(height: 8),

                    // 🔹 리뷰어 박스 (목업 + 유저 국기 이모지 사용)
                    Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 11),
                        decoration: BoxDecoration(
                        color: const Color(0xFFEFF6FF),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFDBEAFE)),
                        ),
                        child: Row(
                        children: [
                            Container(
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(999),
                                border:
                                    Border.all(color: Colors.white, width: 2),
                                image: DecorationImage(
                                image: NetworkImage(profile.avatar),
                                fit: BoxFit.cover,
                                ),
                            ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                // 이름 + 유저 국기 이모지
                                Text(
                                    '$flagEmoji  ${profile.name}',
                                    style: AppTextStyles.caption.copyWith(
                                    color: const Color(0xFF374151),
                                    ),
                                ),
                                Text(
                                    profile.meta,
                                    style: AppTextStyles.caption.copyWith(
                                    color: const Color(0xFF6B7280),
                                    ),
                                ),
                                Text(
                                    profile.ago,
                                    style: AppTextStyles.caption.copyWith(
                                    color: const Color(0xFF374151),
                                    ),
                                ),
                                ],
                            ),
                            ),
                            const Icon(
                            Icons.chevron_right,
                            size: 18,
                            color: Color(0xFF6B7280),
                            ),
                        ],
                        ),
                    ),
                    ],
                ),
                ),
            ],
            ),
        ),
        );
    }
}