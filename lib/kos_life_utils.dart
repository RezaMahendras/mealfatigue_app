import 'package:intl/intl.dart';

class CurrencyFormat {
  static String convertToIdr(dynamic number, int decimalDigit) {
    NumberFormat currencyFormatter = NumberFormat.currency(
      locale: 'id',
      symbol: 'Rp ',
      decimalDigits: decimalDigit,
    );
    return currencyFormatter.format(number);
  }

  static int parseIdr(String idrString) {
    String cleaned = idrString.replaceAll(RegExp(r'[^0-9]'), '');
    if (cleaned.isEmpty) return 0;
    return int.parse(cleaned);
  }
}

class ShoppingMasterData {
  static final List<Map<String, dynamic>> essentials = [
    {'name': 'Beras 5kg', 'price': 65000},
    {'name': 'Minyak Goreng 1L', 'price': 16000},
    {'name': 'Telur 1kg', 'price': 28000},
    {'name': 'Sabun Mandi', 'price': 15000},
    {'name': 'Pasta Gigi', 'price': 12000},
    {'name': 'Detergen', 'price': 10000},
    {'name': 'Air Galon', 'price': 20000},
    {'name': 'Gas Elpiji 3kg', 'price': 22000},
  ];

  static final List<Map<String, dynamic>> wants = [
    {'name': 'Susu UHT 1L', 'price': 19000},
    {'name': 'Roti Tawar', 'price': 14000},
    {'name': 'Kopi Instan', 'price': 15000},
    {'name': 'Mie Instan (5pcs)', 'price': 15000},
    {'name': 'Camilan', 'price': 10000},
    {'name': 'Minuman Ringan', 'price': 7000},
  ];

  static Map<String, dynamic> generatePlan(int totalMoney) {
    int budgetMust = (totalMoney * 0.5).toInt();
    int budgetAllow = (totalMoney * 0.3).toInt();

    List<Map<String, dynamic>> mustBuy = [];
    List<Map<String, dynamic>> canBuy = [];
    int currentMust = 0;
    int currentAllow = 0;

    // 1. Pilih Barang Wajib
    for (var item in essentials) {
      // PERBAIKAN DI SINI: Cast ke 'int'
      int price = item['price'] as int;

      if (currentMust + price <= budgetMust) {
        mustBuy.add({...item, 'category': 'must'});
        currentMust += price;
      }
    }

    // 2. Pilih Barang Boleh
    for (var item in wants) {
      // PERBAIKAN DI SINI: Cast ke 'int'
      int price = item['price'] as int;

      if (currentAllow + price <= budgetAllow) {
        canBuy.add({...item, 'category': 'allow'});
        currentAllow += price;
      }
    }

    int totalSpent = currentMust + currentAllow;
    int remaining = totalMoney - totalSpent;

    return {
      'items': [...mustBuy, ...canBuy],
      'totalSpent': totalSpent,
      'remaining': remaining,
      'mustTotal': currentMust,
      'allowTotal': currentAllow
    };
  }
}
