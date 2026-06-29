import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:heathy_teacher/models/payment_model.dart';
import 'package:heathy_teacher/repo/payment_repo.dart';
import 'package:heathy_teacher/screens/notification/notification_screen.dart';
import 'package:heathy_teacher/utils/constants/color.dart';
import 'package:heathy_teacher/utils/constants/styles.dart';
import 'package:intl/intl.dart';

class HocPhiScreen extends StatefulWidget {
  const HocPhiScreen({super.key});

  @override
  State<HocPhiScreen> createState() => _HocPhiScreenState();
}

class _HocPhiScreenState extends State<HocPhiScreen> {
  bool isLoading = true;
  List<PaymentModel> listPaymented = [];
  List<PaymentModel> listPayment = [];
  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      final data = await PaymentRepo().getPaymentHistory();
      final data2 = await PaymentRepo().getPendingPayment();
      setState(() {
        listPaymented = data;
        listPayment = data2;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      debugPrint('Error fetching data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainGreen,
      appBar: AppBar(
        backgroundColor: mainGreen,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Học phí',
          style: defaultText16B.copyWith(color: Colors.white),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NotificationScreen()),
              );
            },
            child: SvgPicture.asset(
              'assets/icons/bell.svg',
              width: 20.w,
              height: 20.h,
              colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),
            ),
          ),
          SizedBox(width: 16.w),
        ],
      ),
      body: isLoading
          ? CircularProgressIndicator()
          : Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(26.r),
                  topRight: Radius.circular(26.r),
                ),
              ),
              child: Column(
                children: [
                  Expanded(
                    child: LessonHistoryBody(
                      listPaymented: listPaymented,
                      listPayment: listPayment,
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

class LessonHistoryBody extends StatefulWidget {
  const LessonHistoryBody({
    super.key,
    required this.listPaymented,
    required this.listPayment,
  });
  final List<PaymentModel> listPaymented;
  final List<PaymentModel> listPayment;
  @override
  State<LessonHistoryBody> createState() => _LessonHistoryBodyState();
}

class _LessonHistoryBodyState extends State<LessonHistoryBody> {
  int selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // --- Thanh chọn ---
        Container(
          margin: const EdgeInsets.all(12),
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: Color(0xffF2E8E8),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => selectedTab = 0),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: selectedTab == 0
                          ? Colors.white
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Chờ thanh toán",
                          style: defaultText14M.copyWith(
                            color: selectedTab == 0
                                ? colorText
                                : colorText.withValues(alpha: 0.8),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => selectedTab = 1),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: selectedTab == 1
                          ? Colors.white
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Đã thanh toán",
                          style: defaultText14M.copyWith(
                            color: selectedTab == 1
                                ? colorText
                                : colorText.withValues(alpha: 0.8),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        selectedTab == 0
            ? Expanded(
                child: widget.listPayment.isEmpty
                    ? Text('Không có hóa đơn', style: defaultText16B)
                    : ListView.builder(
                        itemCount: widget.listPayment.length,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        itemBuilder: (context, index) {
                          var item = widget.listPayment[index];
                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                              vertical: 16.h,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.title,
                                  style:
                                      defaultText16M, // hoặc style bạn có sẵn
                                ),
                                SizedBox(height: 12),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Số tiền:", style: defaultText14B),
                                    Text(
                                      '${NumberFormat('#,###', 'vi_VN').format(int.tryParse(item.amount) ?? 0)} vnd',
                                      style: defaultText14B.copyWith(
                                        color: mainOrange,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8),

                                SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Hình thức:", style: defaultText14B),
                                    Text(
                                      item.paymentMethod,
                                      style: defaultText14B.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8),
                                Text("Nội dung:", style: defaultText14B),
                                SizedBox(height: 8),
                                Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade100,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    item.title,
                                    style: defaultText14B.copyWith(
                                      color: Colors.black54,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 16),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      // Navigator.push(
                                      //   context,
                                      //   MaterialPageRoute(
                                      //     builder: (context) =>
                                      //         ThanhToanScreen(
                                      //       id: item.pendingPaymentId,
                                      //     ),
                                      //   ),
                                      // );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: mainGreen,
                                      padding: EdgeInsets.symmetric(
                                        vertical: 10.h,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                          12.r,
                                        ),
                                      ),
                                    ),
                                    child: Text(
                                      "Thanh toán",
                                      style: defaultText14B.copyWith(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              )
            : Expanded(
                child: ListView.builder(
                  itemCount: widget.listPaymented.length,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  itemBuilder: (context, index) {
                    var item = widget.listPaymented[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 16.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.title,
                            style: defaultText16M, // hoặc style bạn có sẵn
                          ),
                          SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Số tiền:", style: defaultText14B),
                              Text(
                                '${NumberFormat('#,###', 'vi_VN').format(int.tryParse(item.amount) ?? 0)} vnd',
                                style: defaultText14B.copyWith(
                                  color: mainOrange,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Hình thức:", style: defaultText14B),
                              Text(
                                item.paymentMethod,
                                style: defaultText14B.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Ngày thanh toán:", style: defaultText14B),
                              Text(
                                convertDate(
                                  DateFormat(
                                    'dd-MM-yyyy HH:mm',
                                  ).format(item.paymentDate),
                                ),
                                style: defaultText14B.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          // SizedBox(height: 8),
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //   children: [
                          //     Text("Thời gian:", style: defaultText14B),
                          //     Text(
                          //       DateFormat('HH:mm dd/MM/yyyy')
                          //           .format(DateTime.parse(item.createdAt)),
                          //       style: defaultText14B.copyWith(
                          //           fontWeight: FontWeight.bold),
                          //     ),
                          //   ],
                          // ),
                          SizedBox(height: 8),
                          Text("Nội dung:", style: defaultText14B),
                          SizedBox(height: 8),
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              item.note,
                              style: defaultText14B.copyWith(
                                color: Colors.black54,
                              ),
                            ),
                          ),
                          SizedBox(height: 16),
                          SizedBox.shrink(),
                        ],
                      ),
                    );
                  },
                ),
              ),
      ],
    );
  }
}

String convertDate(String input) {
  final parts = input.split('-'); // [12, 09, 2025]
  return '${parts[0]}/${parts[1]}/${parts[2]}';
}
