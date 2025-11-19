import 'package:flutter/material.dart';
import '../models/storage_location.dart';

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
        return Card(
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: onTap,
            child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                // 이름 + 가격
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                    Expanded(
                        child: Text(
                        storage.name,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                        ),
                        ),
                    ),
                    Text(
                        '\$${storage.priceSmallPerHour.toStringAsFixed(2)}/h',
                        style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF5B34FF),
                        ),
                    ),
                    ],
                ),
                const SizedBox(height: 8),
                Text(
                    storage.address,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 8),
                Row(
                    children: [
                    const Icon(Icons.star, size: 16, color: Colors.amber),
                    const SizedBox(width: 4),
                    Text(
                        '${storage.rating.toStringAsFixed(1)} (${storage.reviewCount})',
                        style: const TextStyle(fontSize: 12),
                    ),
                    const Spacer(),
                    TextButton(
                        onPressed: onTap,
                        child: const Text('Select this storage'),
                    ),
                    ],
                ),
                ],
            ),
            ),
        ),
        );
    }
}