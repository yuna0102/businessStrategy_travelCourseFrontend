import 'package:flutter/material.dart';
import '../models/storage_location.dart';
import '../theme/app_theme.dart';

class StorageCard extends StatelessWidget {
    final StorageLocation storage;
    final VoidCallback? onTap;

    const StorageCard({
        super.key,
        required this.storage,
        this.onTap,
    });

    @override
    Widget build(BuildContext context) {
        //api에서 주는 네임과 같은지 확인하기
        final double basePrice = storage.priceSmallPerHour;

        return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
            decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.borderSoft),
            boxShadow: const [
                BoxShadow(
                color: Color(0x0C000000),
                blurRadius: 2,
                offset: Offset(0, 1),
                ),
            ],
            ),
            constraints: const BoxConstraints(minHeight: 180),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
                // 상단: 이름 + 평점/시간 + 가격
                Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                    // 왼쪽 정보 영역
                    Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                        // 보관소 이름
                        Text(
                            storage.name,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.pageTitle,
                        ),
                        const SizedBox(height: 4),

                        // 평점/리뷰 (모델에 있으면 사용, 없으면 이 블록 통째로 지워도 됨)
                        Row(
                            children: [
                            const Icon(
                                Icons.star,
                                size: 16,
                                color: Colors.amber,
                            ),
                            const SizedBox(width: 4),
                            Text(
                                storage.rating.toStringAsFixed(1), // double 가정
                                style: AppTextStyles.body,
                            ),
                            const SizedBox(width: 4),
                            Text(
                                '(${storage.reviewCount})', // int 가정
                                style: AppTextStyles.body.copyWith(
                                color: AppColors.textMuted,
                                ),
                            ),
                            ],
                        ),

                        const SizedBox(height: 4),

                        // 운영 시간 (모델에 없으면 이 블록 삭제)
                        Row(
                            children: [
                            const Icon(
                                Icons.access_time,
                                size: 14,
                                color: AppColors.textMuted,
                            ),
                            const SizedBox(width: 4),
                            Flexible(
                                child: Text(
                                storage.openTimeText, // String 가정
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppTextStyles.caption,
                                ),
                            ),
                            ],
                        ),
                        ],
                    ),
                    ),

                    const SizedBox(width: 12),

                    // 오른쪽 가격 영역
                    Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                        Text(
                        '\$ ${basePrice.toStringAsFixed(2)}',
                        style: AppTextStyles.price,
                        ),
                        const SizedBox(height: 2),
                        Text(
                        'per hour',
                        style: AppTextStyles.caption,
                        ),
                    ],
                    ),
                ],
                ),

                const SizedBox(height: 24),

                // 하단 CTA 버튼
                SizedBox(
                width: double.infinity,
                child: Container(
                    height: 60,
                    decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(12),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                    'Select this storage',
                    style: AppTextStyles.body.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                    ),
                    ),
                ),
                ),
            ],
            ),
        ),
        );
    }
}