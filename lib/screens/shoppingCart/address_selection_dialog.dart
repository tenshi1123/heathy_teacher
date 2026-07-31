import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:heathy_teacher/utils/constants/color.dart';

class AddressSelectionDialog {
  static Future<Map<String, dynamic>?> show(
    BuildContext context,
    String type, { // 'province', 'district', 'ward'
    String? parentCode,
  }) async {
    String url = 'https://provinces.open-api.vn/api/p/';
    if (type == 'district') {
      if (parentCode == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Vui lòng chọn Tỉnh/Thành phố trước')),
        );
        return null;
      }
      url = 'https://provinces.open-api.vn/api/p/$parentCode?depth=2';
    } else if (type == 'ward') {
      if (parentCode == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Vui lòng chọn Quận/Huyện trước')),
        );
        return null;
      }
      url = 'https://provinces.open-api.vn/api/d/$parentCode?depth=2';
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) =>
          Center(child: CircularProgressIndicator(color: mainDarkGreen)),
    );

    try {
      final dio = Dio();
      final response = await dio.get(url);
      if (!context.mounted) return null;
      Navigator.pop(context); // close loading

      List<dynamic> dataList = [];
      if (type == 'province') {
        dataList = response.data;
      } else if (type == 'district') {
        dataList = response.data['districts'];
      } else if (type == 'ward') {
        dataList = response.data['wards'];
      }

      return await showModalBottomSheet<Map<String, dynamic>>(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        builder: (context) {
          return SizedBox(
            height: MediaQuery.of(context).size.height * 0.7,
            child: Column(
              children: [
                const SizedBox(height: 16),
                Text(
                  type == 'province'
                      ? 'Chọn Tỉnh/Thành phố'
                      : (type == 'district'
                            ? 'Chọn Quận/Huyện'
                            : 'Chọn Xã/Phường'),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Divider(height: 24),
                Expanded(
                  child: ListView.builder(
                    itemCount: dataList.length,
                    itemBuilder: (context, index) {
                      final item = dataList[index];
                      return ListTile(
                        title: Text(item['name']),
                        onTap: () {
                          Navigator.pop(context, item);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      );
    } catch (e) {
      if (!context.mounted) return null;
      Navigator.pop(context); // close loading
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Lỗi tải dữ liệu: $e')));
      return null;
    }
  }
}
