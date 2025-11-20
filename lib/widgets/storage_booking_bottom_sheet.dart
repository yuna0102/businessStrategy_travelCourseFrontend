import 'package:flutter/material.dart';
import '../models/storage_location.dart';
import '../theme/app_theme.dart';

class StorageBookingBottomSheet extends StatefulWidget {
    final StorageLocation storage;

    const StorageBookingBottomSheet({
        super.key,
        required this.storage,
    });

    @override
    State<StorageBookingBottomSheet> createState() =>
        _StorageBookingBottomSheetState();
    }

    class _StorageBookingBottomSheetState extends State<StorageBookingBottomSheet> {
    int _smallCount = 0;
    int _mediumCount = 0;
    int _largeCount = 0;

    double get _totalPerHour =>
        _smallCount * widget.storage.priceSmallPerHour +
        _mediumCount * widget.storage.priceMediumPerHour +
        _largeCount * widget.storage.priceLargePerHour;

    @override
    Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(
        color: Colors.transparent,
        ),
        child: SafeArea(
        top: false,
        bottom: false, // bottom SafeArea 꺼서 바텀 시트 하단과 기기 여백 제거
        child: Container(
            padding: const EdgeInsets.fromLTRB(
            20,
            12,
            20,
            26, // 16으로 픽스
            ),
            decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(32),
                topRight: Radius.circular(32),
            ),
            boxShadow: const [
                BoxShadow(
                color: Color(0x19000000),
                blurRadius: 30,
                offset: Offset(0, -3),
                spreadRadius: 5,
                ),
            ],
            ),
        child: SingleChildScrollView(
                child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                    // 상단 드래그 핸들
                    Container(
                    width: 60,
                    height: 5,
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                        color: AppColors.borderSoft,
                        borderRadius: BorderRadius.circular(999),
                    ),
                    ),

                    // 제목
                    Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Text(
                        'Luggage Detail',
                        style: AppTextStyles.sectionTitle,
                        ),
                    ),
                    ),
                    const SizedBox(height: 20),

                    // Small / Medium / Large 카드들
                    _buildSizeCard(
                    label: 'Small',
                    price: widget.storage.priceSmallPerHour,
                    count: _smallCount,
                    onChanged: (v) => setState(() => _smallCount = v),
                    ),
                    const SizedBox(height: 12),
                    _buildSizeCard(
                    label: 'Medium',
                    price: widget.storage.priceMediumPerHour,
                    count: _mediumCount,
                    onChanged: (v) => setState(() => _mediumCount = v),
                    ),
                    const SizedBox(height: 12),
                    _buildSizeCard(
                    label: 'Large',
                    price: widget.storage.priceLargePerHour,
                    count: _largeCount,
                    onChanged: (v) => setState(() => _largeCount = v),
                    ),

                    const SizedBox(height: 24),

                    // Total 영역
                    Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                        Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                            Text(
                            'Total per hour',
                            style: AppTextStyles.bodyBold.copyWith(
                                fontSize: 16,
                            ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                            'Based on selected luggage',
                            style: AppTextStyles.caption,
                            ),
                        ],
                        ),
                        Text(
                        '\$ ${_totalPerHour.toStringAsFixed(2)}',
                        style: AppTextStyles.pageTitle.copyWith(
                            fontSize: 22,
                        ),
                        ),
                    ],
                    ),

                    const SizedBox(height: 16),

                    // Booking 버튼
                    SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                        ),
                        onPressed: _totalPerHour == 0
                            ? null
                            : () {
                                // TODO: 실제 예약 로직 연결
                                Navigator.of(context).pop();
                            },
                        child: Text(
                        'Booking',
                        style: AppTextStyles.body.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                        ),
                        ),
                    ),
                    ),
                ],
                ),
            ),
            ),
        ),
        );
    }

    Widget _buildSizeCard({
        required String label,
        required double price,
        required int count,
        required ValueChanged<int> onChanged,
    }) {
        return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
            children: [
            // 상단: 이름 + 가격
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                Text(
                    label,
                    style: AppTextStyles.bodyBold.copyWith(
                    fontSize: 18, // 이름 폰트 키움
                    ),
                ),
                Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                    Text(
                        '\$ ${price.toStringAsFixed(2)}',
                        style: AppTextStyles.bodyBold.copyWith(
                        fontSize: 18, // 가격 폰트 키움
                        ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                        'per hour',
                        style: AppTextStyles.caption.copyWith(
                        fontSize: 13,
                        ),
                    ),
                    ],
                ),
                ],
            ),
            const SizedBox(height: 12),

            // 하단: - 0 +
            Container(
                height: 52,
                decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                    _buildStepperButton(
                    icon: Icons.remove,
                    enabled: count > 0,
                    onTap: () {
                        if (count > 0) onChanged(count - 1);
                    },
                    ),
                    const SizedBox(width: 20),
                    Text(
                    '$count',
                    style: AppTextStyles.pageTitle.copyWith(fontSize: 20),
                    ),
                    const SizedBox(width: 20),
                    _buildStepperButton(
                    icon: Icons.add,
                    enabled: true,
                    onTap: () => onChanged(count + 1),
                    ),
                ],
                ),
            ),
            ],
        ),
        );
    }

    Widget _buildStepperButton({
        required IconData icon,
        required bool enabled,
        required VoidCallback onTap,
    }) {
        return GestureDetector(
        onTap: enabled ? onTap : null,
        child: Container(
            width: 44,
            height: double.infinity,
            decoration: BoxDecoration(
            color: Colors.white, // 버튼 배경 흰색
            borderRadius: BorderRadius.circular(16),
            ),
            alignment: Alignment.center,
            child: Icon(
            icon,
            size: 20,
            color: enabled ? AppColors.textMain : AppColors.textMuted,
            ),
        ),
        );
    }
}