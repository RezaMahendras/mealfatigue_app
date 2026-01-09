import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'notification_provider.dart';

const Color primaryOrange = Color(0xFFFF6B4A);
const Color darkNavy = Color(0xFF1E293B);

class AdminPage extends StatelessWidget {
  const AdminPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<NotificationProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Admin Panel", style: TextStyle(color: darkNavy, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: darkNavy),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Dashboard Kontrol", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: darkNavy)),
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: darkNavy, borderRadius: BorderRadius.circular(16)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Notifikasi Aktif", style: TextStyle(color: Colors.white70)),
                  Text("${provider.notifications.length}", style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Manajemen Notifikasi", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
                ElevatedButton(
                  onPressed: () => _showForm(context),
                  style: ElevatedButton.styleFrom(backgroundColor: primaryOrange),
                  child: const Text("Buat Baru"),
                )
              ],
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                itemCount: provider.notifications.length,
                itemBuilder: (context, index) {
                  final item = provider.notifications[index];
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.notifications_active, color: primaryOrange),
                    title: Text(item.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(item.message, maxLines: 1, overflow: TextOverflow.ellipsis),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(icon: const Icon(Icons.edit, size: 20), onPressed: () => _showForm(context, item: item)),
                        IconButton(icon: const Icon(Icons.delete, size: 20, color: Colors.red), onPressed: () => provider.deleteNotification(item.id)),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showForm(BuildContext context, {NotificationItem? item}) {
    final titleController = TextEditingController(text: item?.title);
    final msgController = TextEditingController(text: item?.message);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(item == null ? "Buat Notifikasi" : "Edit Notifikasi"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: titleController, decoration: const InputDecoration(labelText: "Judul")),
            TextField(controller: msgController, decoration: const InputDecoration(labelText: "Pesan"), maxLines: 3),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Batal")),
          ElevatedButton(
            onPressed: () {
              final p = Provider.of<NotificationProvider>(context, listen: false);
              if (item == null) {
                p.addNotification(titleController.text, msgController.text);
              } else {
                p.updateNotification(item.id, titleController.text, msgController.text);
              }
              Navigator.pop(context);
            },
            child: const Text("Simpan"),
          ),
        ],
      ),
    );
  }
}
