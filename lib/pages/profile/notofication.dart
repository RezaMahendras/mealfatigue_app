import 'package:flutter/material.dart';

// --- Definisi Warna & Konstanta ---
const Color primaryOrange = Color(0xFFFF6B4A);
const Color darkNavy = Color(0xFF1E293B);
const Color cardSurface = Color(0xFFF6F8FA);

// --- Model Data Notifikasi ---
class NotificationItem {
  final String id;
  final String title;
  final String message;
  final String time;
  bool isUnread;
  final IconData icon; // Ikon visual untuk mempercantik detail

  NotificationItem({
    required this.id,
    required this.title,
    required this.message,
    required this.time,
    this.isUnread = false,
    required this.icon,
  });
}

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({Key? key}) : super(key: key);

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  // Dummy Data Notifikasi
  List<NotificationItem> todayNotifications = [
    NotificationItem(
      id: '1',
      title: "Pengingat Makan Siang",
      message: "Jangan lupa mencatat makan siangmu hari ini untuk tracking kalori! Konsistensi adalah kunci keberhasilan dietmu.",
      time: "12:30 PM",
      isUnread: true,
      icon: Icons.lunch_dining,
    ),
    NotificationItem(
      id: '2',
      title: "Target Tercapai! 🎉",
      message: "Selamat! Kamu telah mencapai target minum air hari ini (2 Liter). Tubuhmu berterima kasih!",
      time: "09:00 AM",
      isUnread: false,
      icon: Icons.emoji_events,
    ),
  ];

  List<NotificationItem> yesterdayNotifications = [
    NotificationItem(
      id: '3',
      title: "Update Aplikasi",
      message: "Fitur baru 'Dark Mode' telah tersedia. Cek pengaturan sekarang untuk mengaktifkannya dan menghemat baterai.",
      time: "Yesterday",
      isUnread: false,
      icon: Icons.system_update,
    ),
  ];

  // Fungsi untuk menandai sudah dibaca dan membuka detail
  void _handleNotificationTap(NotificationItem item) {
    // Tampilkan Detail Bottom Sheet
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true, // Agar bisa menyesuaikan tinggi konten
      builder: (context) => _buildDetailSheet(item),
    );

    // Update state menjadi 'read' jika masih unread
    if (item.isUnread) {
      setState(() {
        item.isUnread = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          _buildSectionTitle("Today"),
          const SizedBox(height: 16),
          ...todayNotifications.map((item) => _buildNotifItem(item)),

          const SizedBox(height: 24),
          _buildSectionTitle("Yesterday"),
          const SizedBox(height: 16),
          ...yesterdayNotifications.map((item) => _buildNotifItem(item)),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      leading: Container(
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: IconButton(
          padding: EdgeInsets.zero,
          icon: const Icon(Icons.arrow_back, color: darkNavy, size: 20),
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }
          },
        ),
      ),
      title: const Text(
        "Notifications",
        style: TextStyle(color: darkNavy, fontWeight: FontWeight.bold, fontSize: 18),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: Colors.grey,
        fontWeight: FontWeight.bold,
        fontSize: 14,
      ),
    );
  }

  Widget _buildNotifItem(NotificationItem item) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _handleNotificationTap(item),
          borderRadius: BorderRadius.circular(16),
          // Menggunakan Ink untuk background agar efek ripple tetap terlihat di atas warna
          child: Ink(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: item.isUnread ? primaryOrange.withOpacity(0.05) : Colors.white,
              border: Border.all(
                color: item.isUnread ? primaryOrange.withOpacity(0.3) : Colors.grey.shade200,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Indikator Belum Dibaca
                Container(
                  margin: const EdgeInsets.only(top: 4),
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: item.isUnread ? primaryOrange : Colors.transparent,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            item.title,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: darkNavy,
                            ),
                          ),
                          Text(
                            item.time,
                            style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        item.message,
                        maxLines: 2, // Batasi 2 baris agar rapi
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 14, color: Colors.grey.shade600, height: 1.4),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- Widget Bottom Sheet (Tampilan Detail Premium) ---
  Widget _buildDetailSheet(NotificationItem item) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 40),
      child: Column(
        mainAxisSize: MainAxisSize.min, // Hanya setinggi konten
        children: [
          // Drag Handle (Garis abu-abu kecil di atas)
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(bottom: 24),
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Icon Besar
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: primaryOrange.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(item.icon, size: 32, color: primaryOrange),
          ),
          const SizedBox(height: 20),

          // Judul
          Text(
            item.title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: darkNavy,
            ),
          ),
          const SizedBox(height: 8),

          // Waktu
          Text(
            item.time,
            style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
          ),
          const SizedBox(height: 24),

          // Divider halus
          Divider(color: Colors.grey.shade200, thickness: 1),
          const SizedBox(height: 24),

          // Pesan Lengkap
          Text(
            item.message,
            style: const TextStyle(
              fontSize: 16,
              color: Color(0xFF475569), // Slate 600
              height: 1.6,
            ),
          ),

          const SizedBox(height: 32),

          // Tombol Tutup (Opsional, karena user bisa swipe down)
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: darkNavy,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: const Text("Tutup", style: TextStyle(fontWeight: FontWeight.w600)),
            ),
          ),
        ],
      ),
    );
  }
}
