import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

// 연결
import '../models/course.dart';
import '../models/course_detail.dart';
import '../services/api_client.dart';

class CourseDetailPage extends StatefulWidget {
    final Course course; // 리스트에서 넘어온 요약 정보

    const CourseDetailPage({
        super.key,
        required this.course,
    });

    @override
    State<CourseDetailPage> createState() => _CourseDetailPageState();
}

class _CourseDetailPageState extends State<CourseDetailPage> {
    late Future<CourseDetail> _futureDetail;

    @override
    void initState() {
        super.initState();
        final int courseId = int.tryParse(widget.course.id) ?? 0;
        _futureDetail = CourseApiService.fetchCourseDetail(courseId);
    }

    void _showRecommenderBottomSheet(BuildContext context) {
        showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (_) => const _RecommenderProfileBottomSheet(),
        );
    }

    @override
    Widget build(BuildContext context) {
        return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0.5,
            centerTitle: true,
            leading: IconButton(
            icon: const Icon(
                Icons.arrow_back_ios_new,
                size: 18,
                color: Color(0xFF111827),
            ),
            onPressed: () => Navigator.of(context).pop(),
            ),
            title: Text(
            'Course Detail',
            style: AppTextStyles.pageTitle.copyWith(fontSize: 16),
            ),
            actions: [
            IconButton(
                onPressed: () {
                // TODO: 나중에 공유 기능 연결
                },
                icon: const Icon(
                Icons.ios_share,
                size: 20,
                color: Color(0xFF111827),
                ),
            ),
            ],
        ),

        // 하단 "Save this course" 버튼
        bottomNavigationBar: SafeArea(
            child: Container(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(
                top: BorderSide(color: Color(0xFFE5E7EB)),
                ),
            ),
            child: SizedBox(
                height: 48,
                child: OutlinedButton(
                onPressed: () {
                    // TODO: 저장 로직
                },
                style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.primary, width: 1.2),
                    shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                    ),
                ),
                child: Text(
                    'Save this course',
                    style: AppTextStyles.bodyBold.copyWith(
                    color: AppColors.primary,
                    fontSize: 15,
                    ),
                ),
                ),
            ),
            ),
        ),

        body: SafeArea(
            top: false, // AppBar 아래까지 쓰기
            child: FutureBuilder<CourseDetail>(
            future: _futureDetail,
            builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError || !snapshot.hasData) {
                return Center(
                    child: Text(
                    'Failed to load course detail',
                    style: AppTextStyles.body,
                    ),
                );
                }

                final detail = snapshot.data!;
                return SingleChildScrollView(
                child: _CourseDetailBody(
                    detail: detail,
                    onRecommenderTap: () => _showRecommenderBottomSheet(context),
                ),
                );
            },
            ),
        ),
        );
    }
}

/// 실제 내용 레이아웃
class _CourseDetailBody extends StatelessWidget {
    final CourseDetail detail;
    final VoidCallback onRecommenderTap;

    const _CourseDetailBody({
        required this.detail,
        required this.onRecommenderTap,
    });

    @override
    Widget build(BuildContext context) {
        final stops = detail.stops;
        final summary = detail.recommenderSummary;
        final rep = summary.representative;

        // 대표 추천자 정보가 없을 때를 위한 기본(mock) 값
        final int headerTotalRecommenders =
            summary.totalCount > 0 ? summary.totalCount : 23;
        final String headerName = rep?.name ?? 'Emma Mueller';
        final String headerFlag =
            (rep?.countryFlagEmoji ?? '').isNotEmpty ? rep!.countryFlagEmoji : '🌍';

        // 총 거리(m) 합산
        final int totalDistanceM = stops.fold<int>(
        0,
        (acc, s) => acc + (s.distanceFromPrevM ?? 0),
        );
        final String distanceLabel =
            totalDistanceM > 0 ? '${(totalDistanceM / 1000).toStringAsFixed(1)}km' : '-';

        final String durationLabel = '${detail.durationMinutes}min';
        final String ratingLabel = detail.rating.toStringAsFixed(1);

        return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
            // Start from 영역
            _StartFromRow(
            location: detail.storageName.isNotEmpty
                ? detail.storageName
                : 'Start point',
            ),

            const SizedBox(height: 12),

            // duration / stops 칩
            Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
                children: [
                _InfoChip(
                    label: '${detail.durationMinutes} min course',
                    selected: true,
                ),
                const SizedBox(width: 8),
                _InfoChip(
                    label: '${stops.length} stops',
                    selected: false,
                ),
                ],
            ),
            ),

            const SizedBox(height: 12),

            // 대표 추천 여행자 헤더 (항상 노출, 없으면 mock 데이터 사용)
            _RecommenderHeaderSection(
                totalRecommenders: headerTotalRecommenders,
                name: headerName,
                countryFlag: headerFlag,
                visitText: 'Visited recently',
                onTap: onRecommenderTap,
            ),

            const SizedBox(height: 16),

            // 코스 타이틀 / 설명
            Container(
            width: double.infinity,
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                Text(
                    detail.title,
                    style: AppTextStyles.pageTitle.copyWith(fontSize: 20),
                ),
                const SizedBox(height: 6),
                Text(
                    detail.summary.isNotEmpty
                        ? detail.summary
                        : 'Perfect for a quick cultural immersion before your next journey.',
                    style: AppTextStyles.body.copyWith(
                    fontSize: 14,
                    color: AppColors.textMuted,
                    ),
                ),
                ],
            ),
            ),

            const SizedBox(height: 12),

            // 타임라인(걷는시간 + 스톱 카드들)
            Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
                children: [
                const SizedBox(height: 4),
                for (int i = 0; i < stops.length; i++) ...[
                    if (stops[i].walkMinutesFromPrev != null)
                    _WalkTimelineRow(
                        label: '${stops[i].walkMinutesFromPrev} min walk',
                        isFirst: i == 0,
                    ),
                    if (stops[i].walkMinutesFromPrev != null)
                    const SizedBox(height: 8),
                    _StopTimelineRow(
                    isFirst: i == 0,
                    isLast: i == stops.length - 1,
                    title: stops[i].name,
                    subtitle: stops[i].description,
                    stayLabel: stops[i].stayMinutes != null
                        ? '${stops[i].stayMinutes} min stay'
                        : '',
                    ratingLabel: stops[i].rating != null
                        ? stops[i].rating!.toStringAsFixed(1)
                        : '-',
                    imageUrl: stops[i].imageUrl,
                    ),
                    const SizedBox(height: 12),
                ],
                const SizedBox(height: 16),
                ],
            ),
            ),

            // 하단 요약 (거리 / 시간 / 평점)
            Container(
            width: double.infinity,
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Row(
                children: [
                _SummaryStat(
                    value: distanceLabel,
                    label: 'Total distance',
                ),
                _SummaryStat(
                    value: durationLabel,
                    label: 'Duration',
                ),
                _SummaryStat(
                    value: ratingLabel,
                    label: 'Rating',
                ),
                ],
            ),
            ),

            const SizedBox(height: 12),
        ],
        );
    }
}

/// ---------- 위젯들 ----------

class _StartFromRow extends StatelessWidget {
    final String location;

    const _StartFromRow({
        super.key,
        required this.location,
    });

    @override
    Widget build(BuildContext context) {
        return Container(
        width: double.infinity,
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                Icons.lightbulb_outline,
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
                    style: AppTextStyles.caption.copyWith(
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

class _InfoChip extends StatelessWidget {
    final String label;
    final bool selected;

    const _InfoChip({
        super.key,
        required this.label,
        required this.selected,
    });

    @override
    Widget build(BuildContext context) {
        return Container(
        height: 32,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
            color: selected ? const Color(0xFFE0ECFF) : Colors.white,
            borderRadius: BorderRadius.circular(999),
            border: Border.all(
            color: selected ? AppColors.primary : const Color(0xFFE5E7EB),
            ),
        ),
        alignment: Alignment.center,
        child: Text(
            label,
            style: AppTextStyles.caption.copyWith(
            fontSize: 13,
            color: selected ? AppColors.primary : const Color(0xFF4B5563),
            fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
            ),
        ),
        );
    }
}

class _TimelineBar extends StatelessWidget {
    final bool showTop;
    final bool showBottom;
    final bool isSolidDot;

    const _TimelineBar({
        super.key,
        required this.showTop,
        required this.showBottom,
        this.isSolidDot = true,
    });

    @override
    Widget build(BuildContext context) {
        return SizedBox(
        width: 20,
        height: 80,
        child: Column(
            children: [
            Expanded(
                child: Container(
                width: 1.5,
                color: showTop ? const Color(0xFFBFDBFE) : Colors.transparent,
                ),
            ),
            Container(
                width: isSolidDot ? 8 : 6,
                height: isSolidDot ? 8 : 6,
                decoration: BoxDecoration(
                color:
                    isSolidDot ? const Color(0xFF3B82F6) : Colors.transparent,
                borderRadius: BorderRadius.circular(999),
                border: Border.all(
                    color: const Color(0xFF3B82F6),
                    width: 1.5,
                ),
                ),
            ),
            Expanded(
                child: Container(
                width: 1.5,
                color:
                    showBottom ? const Color(0xFFBFDBFE) : Colors.transparent,
                ),
            ),
            ],
        ),
        );
    }
}

class _WalkTimelineRow extends StatelessWidget {
    final String label;
    final bool isFirst;

    const _WalkTimelineRow({
        super.key,
        required this.label,
        required this.isFirst,
    });

    @override
    Widget build(BuildContext context) {
        return Row(
        children: [
            _TimelineBar(
            showTop: !isFirst,
            showBottom: true,
            isSolidDot: false,
            ),
            const SizedBox(width: 8),
            Text(
            label,
            style: AppTextStyles.caption.copyWith(
                color: AppColors.textMuted,
            ),
            ),
        ],
        );
    }
}

class _StopTimelineRow extends StatelessWidget {
    final bool isFirst;
    final bool isLast;

    final String title;
    final String subtitle;
    final String stayLabel;
    final String ratingLabel;
    final String imageUrl;

    const _StopTimelineRow({
        super.key,
        required this.isFirst,
        required this.isLast,
        required this.title,
        required this.subtitle,
        required this.stayLabel,
        required this.ratingLabel,
        required this.imageUrl,
    });

    @override
    Widget build(BuildContext context) {
        return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
            _TimelineBar(
            showTop: true,
            showBottom: !isLast,
            isSolidDot: true,
            ),
            const SizedBox(width: 8),
            Expanded(
            child: Container(
                decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE5E7EB)),
                boxShadow: const [
                    BoxShadow(
                    color: Color(0x0C000000),
                    blurRadius: 4,
                    offset: Offset(0, 2),
                    ),
                ],
                ),
                child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                    ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(16),
                    ),
                    child: AspectRatio(
                        aspectRatio: 341 / 192,
                        child: Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        ),
                    ),
                    ),
                    Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 12),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                        Text(
                            title,
                            style:
                                AppTextStyles.bodyBold.copyWith(fontSize: 15),
                        ),
                        const SizedBox(height: 4),
                        if (subtitle.isNotEmpty)
                            Text(
                            subtitle,
                            style: AppTextStyles.body.copyWith(
                                fontSize: 13,
                                color: const Color(0xFF4B5563),
                            ),
                            ),
                        const SizedBox(height: 10),
                        Row(
                            children: [
                            if (stayLabel.isNotEmpty) ...[
                                const Icon(
                                Icons.access_time,
                                size: 14,
                                color: Color(0xFF6B7280),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                stayLabel,
                                style: AppTextStyles.caption.copyWith(
                                    color: const Color(0xFF6B7280),
                                ),
                                ),
                            ],
                            const Spacer(),
                            const Icon(
                                Icons.star,
                                size: 14,
                                color: Color(0xFFF59E0B),
                            ),
                            const SizedBox(width: 3),
                            Text(
                                ratingLabel,
                                style: AppTextStyles.caption.copyWith(
                                color: const Color(0xFF111827),
                                fontWeight: FontWeight.w600,
                                ),
                            ),
                            ],
                        )
                        ],
                    ),
                    ),
                ],
                ),
            ),
            ),
        ],
        );
    }
    }

    class _SummaryStat extends StatelessWidget {
    final String value;
    final String label;

    const _SummaryStat({
        super.key,
        required this.value,
        required this.label,
    });

    @override
    Widget build(BuildContext context) {
        return Expanded(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
            Text(
                value,
                style: AppTextStyles.bodyBold.copyWith(fontSize: 16),
            ),
            const SizedBox(height: 4),
            Text(
                label,
                style: AppTextStyles.caption.copyWith(
                color: AppColors.textMuted,
                fontSize: 11,
                ),
            ),
            ],
        ),
        );
    }
}

class _RecommenderHeaderSection extends StatelessWidget {
    final int totalRecommenders;
    final String name;
    final String countryFlag;
    final String visitText;
    final VoidCallback onTap;

    const _RecommenderHeaderSection({
        super.key,
        required this.totalRecommenders,
        required this.name,
        required this.countryFlag,
        required this.visitText,
        required this.onTap,
    });

    @override
    Widget build(BuildContext context) {
        return Material(
        color: Colors.white,
        child: InkWell(
            onTap: onTap,
            child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
                children: [
                Stack(
                    clipBehavior: Clip.none,
                    children: [
                    Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(999),
                        image: const DecorationImage(
                            image:
                                NetworkImage('https://picsum.photos/80/80?traveler'),
                            fit: BoxFit.cover,
                        ),
                        ),
                    ),
                    Positioned(
                        right: -4,
                        bottom: -4,
                        child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 4, vertical: 1),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(999),
                            boxShadow: const [
                            BoxShadow(
                                color: Color(0x14000000),
                                blurRadius: 2,
                                offset: Offset(0, 1),
                            ),
                            ],
                        ),
                        child: Text(
                            countryFlag,
                            style: const TextStyle(fontSize: 10),
                        ),
                        ),
                    ),
                    ],
                ),
                const SizedBox(width: 12),
                Expanded(
                    child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                        Text(
                        '$totalRecommenders travelers recommended this course',
                        style: AppTextStyles.caption.copyWith(
                            color: AppColors.textMuted,
                        ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                        name,
                        style:
                            AppTextStyles.bodyBold.copyWith(fontSize: 15),
                        ),
                        const SizedBox(height: 2),
                        Text(
                        visitText,
                        style: AppTextStyles.caption.copyWith(
                            color: AppColors.primary,
                        ),
                        ),
                    ],
                    ),
                ),
                const Icon(
                    Icons.chevron_right,
                    size: 20,
                    color: Color(0xFF9CA3AF),
                ),
                ],
            ),
            ),
        ),
        );
    }
}

class _RecommenderProfileBottomSheet extends StatelessWidget {
    const _RecommenderProfileBottomSheet({super.key});

    @override
    Widget build(BuildContext context) {
        return FractionallySizedBox(
        heightFactor: 0.86,
        child: Container(
            decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Column(
            children: [
                const SizedBox(height: 12),
                Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                    color: const Color(0xFFE5E7EB),
                    borderRadius: BorderRadius.circular(999),
                ),
                ),
                const SizedBox(height: 16),
                Expanded(
                child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
                    child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                        Stack(
                        clipBehavior: Clip.none,
                        children: [
                            Container(
                            width: 88,
                            height: 88,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(999),
                                image: const DecorationImage(
                                image: NetworkImage(
                                    'https://picsum.photos/160/160?traveler-main'),
                                fit: BoxFit.cover,
                                ),
                                boxShadow: const [
                                BoxShadow(
                                    color: Color(0x1A000000),
                                    blurRadius: 8,
                                    offset: Offset(0, 4),
                                ),
                                ],
                            ),
                            ),
                            Positioned(
                            right: -2,
                            bottom: -2,
                            child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 4, vertical: 2),
                                decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(999),
                                ),
                                child: const Text(
                                '🇩🇪',
                                style: TextStyle(fontSize: 12),
                                ),
                            ),
                            ),
                        ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                        'Emma Mueller',
                        style:
                            AppTextStyles.pageTitle.copyWith(fontSize: 20),
                        ),
                        const SizedBox(height: 4),
                        Text(
                        'Visited Seoul 2 weeks ago',
                        style: AppTextStyles.body.copyWith(
                            fontSize: 14,
                            color: AppColors.primary,
                        ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                        'A 29-year-old traveler from Berlin who loves discovering unique coffee spots and local culture.',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.body.copyWith(
                            fontSize: 13,
                            color: AppColors.textMuted,
                        ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: const [
                            _ProfileStat(value: '12', label: 'Routes'),
                            _ProfileStat(value: '8', label: 'Cities'),
                            _ProfileStat(value: '156', label: 'Followers'),
                        ],
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                            onPressed: () {
                            // TODO: 대표 코스 보기로 이동
                            },
                            style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(999),
                            ),
                            ),
                            child: Text(
                            'See her favorite route',
                            style: AppTextStyles.bodyBold.copyWith(
                                color: Colors.white,
                                fontSize: 15,
                            ),
                            ),
                        ),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                        width: double.infinity,
                        height: 44,
                        child: OutlinedButton(
                            onPressed: () {
                            // TODO: 팔로우 기능
                            },
                            style: OutlinedButton.styleFrom(
                            side:
                                const BorderSide(color: Color(0xFFE5E7EB)),
                            backgroundColor: const Color(0xFFF9FAFB),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(999),
                            ),
                            ),
                            child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                                const Icon(
                                Icons.person_add_alt_1,
                                size: 18,
                                color: Color(0xFF374151),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                'Follow',
                                style: AppTextStyles.body.copyWith(
                                    fontSize: 14,
                                    color: const Color(0xFF374151),
                                ),
                                ),
                            ],
                            ),
                        ),
                        ),
                        const SizedBox(height: 24),
                        Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                            'Similar travelers you might like',
                            style: AppTextStyles.caption.copyWith(
                            color: AppColors.textMuted,
                            ),
                        ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                        children: const [
                            _MiniAvatar(url: 'https://picsum.photos/40/40?1'),
                            SizedBox(width: 8),
                            _MiniAvatar(url: 'https://picsum.photos/40/40?2'),
                            SizedBox(width: 8),
                            _MiniAvatar(url: 'https://picsum.photos/40/40?3'),
                            SizedBox(width: 8),
                            _MoreMiniAvatars(countText: '+5'),
                        ],
                        ),
                    ],
                    ),
                ),
                ),
            ],
            ),
        ),
        );
    }
}

class _ProfileStat extends StatelessWidget {
    final String value;
    final String label;

    const _ProfileStat({
        super.key,
        required this.value,
        required this.label,
    });

    @override
    Widget build(BuildContext context) {
        return Column(
        children: [
            Text(
            value,
            style: AppTextStyles.bodyBold.copyWith(fontSize: 16),
            ),
            const SizedBox(height: 4),
            Text(
            label,
            style: AppTextStyles.caption.copyWith(
                color: AppColors.textMuted,
                fontSize: 11,
            ),
            ),
        ],
        );
    }
}

class _MiniAvatar extends StatelessWidget {
    final String url;

    const _MiniAvatar({
        super.key,
        required this.url,
    });

    @override
    Widget build(BuildContext context) {
        return Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(999),
            image: DecorationImage(
            image: NetworkImage(url),
            fit: BoxFit.cover,
            ),
        ),
        );
    }
}

class _MoreMiniAvatars extends StatelessWidget {
    final String countText;

    const _MoreMiniAvatars({
        super.key,
        required this.countText,
    });

    @override
    Widget build(BuildContext context) {
        return Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
            color: const Color(0xFFF3F4F6),
            borderRadius: BorderRadius.circular(999),
        ),
        alignment: Alignment.center,
        child: Text(
            countText,
            style: AppTextStyles.caption.copyWith(
            color: const Color(0xFF4B5563),
            ),
        ),
        );
    }
}