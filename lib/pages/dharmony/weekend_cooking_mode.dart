import 'package:flutter/material.dart';
import 'dart:async';

// --- Definisi Warna Tema ---
const Color primaryOrange = Color(0xFFFF6B4A);
const Color darkNavy = Color(0xFF1E293B);
const Color cardSurface = Color(0xFFF6F8FA);
const Color textGrey = Color(0xFF64748B);

class WeekendCookingModePage extends StatefulWidget {
  final String recipeTitle;

  const WeekendCookingModePage({Key? key, required this.recipeTitle}) : super(key: key);

  @override
  State<WeekendCookingModePage> createState() => _WeekendCookingModePageState();
}

class _WeekendCookingModePageState extends State<WeekendCookingModePage> {
  // --- DATA DUMMY LANGKAH MEMASAK ---
  final List<Map<String, dynamic>> _steps = [
    {
      "title": "Persiapan Nasi Kembang Kol",
      "description": "Tumis Nasi Kembang Kol dengan sedikit minyak/mentega vegan, garam, dan merica. Sisihkan.",
      "duration": 300,
    },
    {
      "title": "Tumis Jamur",
      "description": "Potong jamur tipis-tipis. Tumis hingga kecoklatan dan airnya menyusut agar teksturnya meaty.",
      "duration": 420,
    },
    {
      "title": "Buat Saus Creamy",
      "description": "Masukkan coconut cream, kaldu sayur, dan bumbu stroganoff. Aduk rata hingga mengental.",
      "duration": 180,
    },
    {
      "title": "Campurkan Bahan",
      "description": "Masukkan kembali jamur ke dalam saus. Aduk rata dan koreksi rasa.",
      "duration": 60,
    },
    {
      "title": "Plating",
      "description": "Tuang nasi kembang kol ke piring, siram dengan mushroom stroganoff di atasnya.",
      "duration": 0, // Tidak ada timer
    },
  ];

  int _currentStepIndex = 0;
  Timer? _timer;
  int _remainingSeconds = 0;
  bool _isTimerRunning = false;

  @override
  void initState() {
    super.initState();
    _remainingSeconds = _steps[0]['duration'];
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  // --- LOGIKA TIMER ---
  void _toggleTimer() {
    if (_isTimerRunning) {
      _timer?.cancel();
      setState(() => _isTimerRunning = false);
    } else {
      if (_remainingSeconds <= 0) return;
      setState(() => _isTimerRunning = true);
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (_remainingSeconds > 0) {
          setState(() => _remainingSeconds--);
        } else {
          _timer?.cancel();
          setState(() => _isTimerRunning = false);
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Waktu habis!")));
        }
      });
    }
  }

  String _formatTime(int totalSeconds) {
    int min = totalSeconds ~/ 60;
    int sec = totalSeconds % 60;
    return "${min.toString().padLeft(2, '0')}:${sec.toString().padLeft(2, '0')}";
  }

  // --- LOGIKA NAVIGASI ---
  void _nextStep() {
    if (_currentStepIndex < _steps.length - 1) {
      setState(() {
        _currentStepIndex++;
        _timer?.cancel();
        _isTimerRunning = false;
        _remainingSeconds = _steps[_currentStepIndex]['duration'];
      });
    } else {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(backgroundColor: Colors.green, content: Text("Masak Selesai! Selamat Menikmati.")));
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentStepData = _steps[_currentStepIndex];
    double progress = (_currentStepIndex + 1) / _steps.length;

    return Scaffold(
      backgroundColor: Colors.white, // Latar Putih Bersih
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: darkNavy),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Text(
          "Cooking Mode",
          style: const TextStyle(color: darkNavy, fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // 1. PROGRESS BAR (Indikator Visual)
            LinearProgressIndicator(
              value: progress,
              backgroundColor: cardSurface,
              color: primaryOrange,
              minHeight: 4,
            ),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 2. STEP INDICATOR
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: primaryOrange.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        "Step ${_currentStepIndex + 1} of ${_steps.length}",
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: primaryOrange),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // 3. STEP TITLE & DESC
                    Text(
                      currentStepData['title'],
                      style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: darkNavy, height: 1.2),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      currentStepData['description'],
                      style: const TextStyle(fontSize: 16, color: textGrey, height: 1.6),
                    ),

                    const Spacer(),

                    // 4. TIMER SECTION (Modern & Clean)
                    if (currentStepData['duration'] > 0)
                      Center(
                        child: Column(
                          children: [
                            // Tampilan Waktu Digital Besar
                            Text(
                              _formatTime(_remainingSeconds),
                              style: TextStyle(
                                  fontSize: 72,
                                  fontWeight: FontWeight.w200,
                                  color: _isTimerRunning ? primaryOrange : darkNavy,
                                  letterSpacing: -2
                              ),
                            ),
                            const SizedBox(height: 20),
                            // Tombol Play/Pause Bulat Besar
                            GestureDetector(
                              onTap: _toggleTimer,
                              child: Container(
                                width: 70, height: 70,
                                decoration: BoxDecoration(
                                    color: _isTimerRunning ? Colors.white : darkNavy,
                                    shape: BoxShape.circle,
                                    border: Border.all(color: darkNavy, width: 2),
                                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 5))]
                                ),
                                child: Icon(
                                    _isTimerRunning ? Icons.pause : Icons.play_arrow,
                                    color: _isTimerRunning ? darkNavy : Colors.white,
                                    size: 32
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              _isTimerRunning ? "Pause Timer" : "Start Timer",
                              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.grey),
                            )
                          ],
                        ),
                      ),

                    const Spacer(),

                    // 5. NEXT BUTTON (Full Width)
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _nextStep,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryOrange,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          elevation: 4,
                          shadowColor: primaryOrange.withOpacity(0.4),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                                _currentStepIndex == _steps.length - 1 ? "Finish Cooking" : "Next Step",
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)
                            ),
                            const SizedBox(width: 8),
                            const Icon(Icons.arrow_forward, size: 20),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
