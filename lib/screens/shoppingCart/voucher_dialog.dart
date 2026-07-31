import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:heathy_teacher/models/payment_model.dart';
import 'package:heathy_teacher/utils/constants/styles.dart';
import 'package:intl/intl.dart';

class VoucherDialog extends StatefulWidget {
  final List<PromoCodeModel> vouchers;
  final PromoCodeModel? selectedVoucher;

  const VoucherDialog({
    super.key,
    required this.vouchers,
    this.selectedVoucher,
  });

  @override
  State<VoucherDialog> createState() => _VoucherDialogState();
}

class _VoucherDialogState extends State<VoucherDialog> {
  PromoCodeModel? _tempSelected;

  @override
  void initState() {
    super.initState();
    _tempSelected = widget.selectedVoucher;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      insetPadding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Chọn Voucher', style: defaultText18B),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.close, color: Colors.grey),
                ),
              ],
            ),
            const Divider(height: 24, thickness: 1),
            widget.vouchers.isNotEmpty
                ? Text('Có thể chọn 1 Voucher', style: defaultText14B)
                : Text('Không có voucher', style: defaultText14B),
            const SizedBox(height: 12),
            Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: widget.vouchers.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final voucher = widget.vouchers[index];
                  final isSelected = _tempSelected?.id == voucher.id;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _tempSelected = voucher;
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            decoration: const BoxDecoration(
                              color: Color(0xFF68B342),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(8),
                                bottomLeft: Radius.circular(8),
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  'Voucher',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  '${voucher.valuePercent ?? 0}%',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                RichText(
                                  text: TextSpan(
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.black,
                                    ),
                                    children: [
                                      TextSpan(
                                        text:
                                            'Giảm ${voucher.valuePercent ?? 0}% ',
                                      ),
                                      TextSpan(
                                        text:
                                            '(Tối đa ${NumberFormat('#,###', 'vi_VN').format(int.tryParse(voucher.priceMaxUse ?? '0') ?? 0)}đ)',
                                        style: const TextStyle(
                                          color: Colors.red,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Đơn tối thiểu ${NumberFormat('#,###', 'vi_VN').format(int.tryParse(voucher.totalPriceMin ?? '0') ?? 0)}đ',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'HSD: hết ${voucher.expiryDate != null ? DateFormat('dd/MM/yyyy').format(DateTime.tryParse(voucher.expiryDate!) ?? DateTime.now()) : ""}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 12),
                            child: Icon(
                              isSelected
                                  ? Icons.check_circle
                                  : Icons.radio_button_unchecked,
                              color: isSelected
                                  ? const Color(0xFFF26522)
                                  : Colors.grey.shade400,
                              size: 24,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const Divider(height: 24, thickness: 1),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton(
                  onPressed: () {
                    Navigator.pop(context, 'clear');
                  },
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    side: const BorderSide(color: Colors.grey),
                  ),
                  child: const Text(
                    'Bỏ chọn',
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: () {
                    if (_tempSelected == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Vui lòng chọn 1 Voucher'),
                        ),
                      );
                      return;
                    }
                    Navigator.pop(context, _tempSelected);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF26522),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'OK',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
