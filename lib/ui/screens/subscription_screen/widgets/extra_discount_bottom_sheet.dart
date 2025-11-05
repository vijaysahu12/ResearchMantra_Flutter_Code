import 'package:flutter/material.dart';
import 'dart:async';

class ExtraDiscountBottomSheet extends StatefulWidget {
  final VoidCallback onDiscountApplied;
  final Duration offerDuration;

  const ExtraDiscountBottomSheet({
    super.key,
    required this.onDiscountApplied,
    this.offerDuration = const Duration(minutes: 9),
  });

  @override
  State<ExtraDiscountBottomSheet> createState() =>
      _ExtraDiscountBottomSheetState();
}

class _ExtraDiscountBottomSheetState extends State<ExtraDiscountBottomSheet> {
  late Timer _timer;
  late Duration _remainingTime;
  bool _isDiscountApplied = false;

  @override
  void initState() {
    super.initState();
    _remainingTime = widget.offerDuration;
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingTime.inSeconds > 0) {
        setState(() {
          _remainingTime = Duration(seconds: _remainingTime.inSeconds - 1);
        });
      } else {
        _timer.cancel();
        Navigator.pop(context);
      }
    });
  }

  String _formatTime() {
    int minutes = _remainingTime.inMinutes;
    int seconds = _remainingTime.inSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  void _applyDiscount() {
    setState(() {
      _isDiscountApplied = true;
    });
    widget.onDiscountApplied();

    // Auto close after showing applied message
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        Navigator.pop(context);
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 24),

          // Icon
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.orange.shade50,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.local_offer,
              size: 40,
              color: Colors.orange.shade700,
            ),
          ),
          const SizedBox(height: 20),

          // Title
          const Text(
            '🎉 Extra Discount!',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),

          // Discount message
          if (!_isDiscountApplied) ...[
            const Text(
              'Get 10% extra discount on your order',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 20),

            // Timer container
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.red.shade200),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.access_time,
                    color: Colors.red.shade700,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Offer ends in ${_formatTime()}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.red.shade700,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Claim button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _applyDiscount,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Claim Extra Discount',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // No thanks button
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'No, Thanks',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.blue,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ]
        ],
      ),
    );
  }
}

// Example usage function
void showExtraDiscountSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (context) => ExtraDiscountBottomSheet(
      onDiscountApplied: () {
        // Handle discount application logic here
        print('Extra discount applied!');
      },
      offerDuration: const Duration(minutes: 9), // Set your desired duration
    ),
  );
}
