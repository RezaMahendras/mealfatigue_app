import 'package:intl/intl.dart';

class CurrencyFormat {
  static String convertToIdr(dynamic number, int decimalDigit) {
    final formatter = NumberFormat.currency(
      locale: 'id',
      symbol: 'Rp ',
      decimalDigits: decimalDigit,
    );
    return formatter.format(number);
  }

  static int parseIdr(String idrString) {
    final cleaned = idrString.replaceAll(RegExp(r'[^0-9]'), '');
    if (cleaned.isEmpty) return 0;
    return int.parse(cleaned);
  }
}

/// ===============================
/// ENUM KONDISI (WAJIB ADA)
/// ===============================
enum KondisiSaatIni {
  normal,
  utsUas,
  tanggalTua,
  lagiHemat,
}

/// ===============================
/// MASTER DATA BARANG
/// ===============================
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
    {'name': 'Mie Instan (5 pcs)', 'price': 15000},
    {'name': 'Camilan', 'price': 10000},
    {'name': 'Minuman Ringan', 'price': 7000},
  ];
}

/// ===============================
/// DECISION ENGINE (INTI AI LOGIC)
/// ===============================
class KosLifeDecisionEngine {
  static Map<String, dynamic> generatePlan(
      int totalMoney,
      KondisiSaatIni kondisi,
      ) {
    // Default rule
    double mustRatio = 0.5;
    double allowRatio = 0.3;
    double budgetLimit = 1.0;
    String smartTip = '';

    /// ===============================
    /// RULE BERDASARKAN KONDISI
    /// ===============================
    switch (kondisi) {
      case KondisiSaatIni.normal:
        smartTip = 'Belanja seimbang sesuai kebutuhan harian.';
        break;

      case KondisiSaatIni.utsUas:
        mustRatio = 0.6;
        allowRatio = 0.25;
        smartTip =
        'UTS/UAS: prioritaskan makanan praktis agar hemat waktu dan energi.';
        break;

      case KondisiSaatIni.tanggalTua:
        mustRatio = 0.7;
        allowRatio = 0.2;
        budgetLimit = 0.85;
        smartTip =
        'Tanggal tua: fokus kebutuhan pokok dan kurangi belanja tambahan.';
        break;

      case KondisiSaatIni.lagiHemat:
        mustRatio = 0.65;
        allowRatio = 0.2;
        budgetLimit = 0.8;
        smartTip =
        'Mode hemat aktif: kurangi pengeluaran tidak wajib dan simpan sisa uang.';
        break;
    }

    /// ===============================
    /// HITUNG BATAS BUDGET
    /// ===============================
    final int effectiveBudget = (totalMoney * budgetLimit).toInt();
    final int budgetMust = (effectiveBudget * mustRatio).toInt();
    final int budgetAllow = (effectiveBudget * allowRatio).toInt();

    /// ===============================
    /// PILIH BARANG
    /// ===============================
    List<Map<String, dynamic>> mustBuy = [];
    List<Map<String, dynamic>> canBuy = [];

    int currentMust = 0;
    int currentAllow = 0;

    // Barang wajib
    for (final item in ShoppingMasterData.essentials) {
      final int price = item['price'] as int;
      if (currentMust + price <= budgetMust) {
        mustBuy.add({...item, 'category': 'must'});
        currentMust += price;
      }
    }

    // Barang boleh
    for (final item in ShoppingMasterData.wants) {
      final int price = item['price'] as int;
      if (currentAllow + price <= budgetAllow) {
        canBuy.add({...item, 'category': 'allow'});
        currentAllow += price;
      }
    }

    /// ===============================
    /// HASIL AKHIR
    /// ===============================
    final int totalSpent = currentMust + currentAllow;
    final int remaining = totalMoney - totalSpent;

    return {
      'items': [...mustBuy, ...canBuy],
      'totalSpent': totalSpent,
      'remaining': remaining,
      'mustTotal': currentMust,
      'allowTotal': currentAllow,
      'smartTip': smartTip,
      'effectiveBudget': effectiveBudget,
    };
  }
}
