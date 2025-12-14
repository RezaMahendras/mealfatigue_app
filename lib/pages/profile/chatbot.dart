import 'package:flutter/material.dart';

// --- Definisi Warna (Konsisten) ---
const Color primaryOrange = Color(0xFFFF6B4A);
const Color darkNavy = Color(0xFF1E293B);
const Color cardSurface = Color(0xFFF6F8FA);

class ChatbotPage extends StatefulWidget {
  const ChatbotPage({Key? key}) : super(key: key);

  @override
  State<ChatbotPage> createState() => _ChatbotPageState();
}

class _ChatbotPageState extends State<ChatbotPage> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();

  // List Pesan (Dummy Awal)
  final List<Map<String, dynamic>> _messages = [
    {
      "isUser": false,
      "text": "Halo! Selamat datang di Layanan Pelanggan Meal Fatigue. Ada yang bisa kami bantu hari ini?",
      "time": "Now"
    }
  ];

  bool _isTyping = false; // Simulasi admin sedang mengetik

  // --- Logic Kirim Pesan ---
  void _handleSend() {
    if (_textController.text.trim().isEmpty) return;

    // 1. Tambah Pesan User
    setState(() {
      _messages.add({
        "isUser": true,
        "text": _textController.text.trim(),
        "time": "Now"
      });
      _isTyping = true; // Bot mulai "mengetik"
    });

    _textController.clear();
    _scrollToBottom();

    // 2. Simulasi Bot Membalas (Delay 1.5 detik)
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        setState(() {
          _isTyping = false;
          _messages.add({
            "isUser": false,
            "text": "Terima kasih atas pesan Anda. Agen kami sedang meninjau pertanyaan tersebut dan akan segera merespons.",
            "time": "Now"
          });
        });
        _scrollToBottom();
      }
    });
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        shadowColor: Colors.grey.withOpacity(0.1),
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: darkNavy),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            // Avatar Admin
            Container(
              padding: const EdgeInsets.all(2),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.green, // Indikator Online
              ),
              child: const CircleAvatar(
                radius: 16,
                backgroundColor: primaryOrange,
                child: Icon(Icons.support_agent, size: 20, color: Colors.white),
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Customer Service",
                  style: TextStyle(color: darkNavy, fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  "Online",
                  style: TextStyle(color: Colors.green.shade600, fontSize: 12),
                ),
              ],
            )
          ],
        ),
      ),
      body: Column(
        children: [
          // --- LIST PESAN ---
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(20),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                final isUser = msg['isUser'];
                return _buildChatBubble(isUser, msg['text']);
              },
            ),
          ),

          // --- INDIKATOR TYPING ---
          if (_isTyping)
            Padding(
              padding: const EdgeInsets.only(left: 24, bottom: 10),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Agent is typing...",
                  style: TextStyle(color: Colors.grey.shade500, fontSize: 12, fontStyle: FontStyle.italic),
                ),
              ),
            ),

          // --- INPUT FIELD ---
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    offset: const Offset(0, -4),
                    blurRadius: 10
                )
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: cardSurface,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: TextField(
                        controller: _textController,
                        focusNode: _focusNode,
                        decoration: const InputDecoration(
                          hintText: "Type a message...",
                          border: InputBorder.none,
                        ),
                        onSubmitted: (_) => _handleSend(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  InkWell(
                    onTap: _handleSend,
                    borderRadius: BorderRadius.circular(50),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: const BoxDecoration(
                        color: primaryOrange,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.send_rounded, color: Colors.white, size: 20),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  // Widget Bubble Chat
  Widget _buildChatBubble(bool isUser, String text) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isUser ? primaryOrange : Colors.grey.shade100,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: isUser ? const Radius.circular(16) : Radius.zero,
            bottomRight: isUser ? Radius.zero : const Radius.circular(16),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
              color: isUser ? Colors.white : darkNavy,
              fontSize: 14,
              height: 1.4
          ),
        ),
      ),
    );
  }
}
