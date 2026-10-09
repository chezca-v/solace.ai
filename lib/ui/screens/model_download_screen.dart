import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import '../../services/model_download_service.dart';
import 'sanctuary_dashboard_screen.dart';

/// Onboarding Step 5+ loading screen that downloads or bypasses Gemma SLM setup.
class ModelDownloadScreen extends StatefulWidget {
  final VoidCallback? onComplete;
  final Widget? destinationScreen;

  const ModelDownloadScreen({
    super.key,
    this.onComplete,
    this.destinationScreen,
  });

  @override
  State<ModelDownloadScreen> createState() => _ModelDownloadScreenState();
}

class _ModelDownloadScreenState extends State<ModelDownloadScreen> {
  double _progress = 0.0;
  bool _isChecking = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _checkModelAndStart();
  }

  /// Demo bypass check and initialization.
  Future<void> _checkModelAndStart() async {
    setState(() {
      _isChecking = true;
      _errorMessage = null;
    });

    try {
      final appDir = await getApplicationDocumentsDirectory();
      final filePath = '${appDir.path}/${ModelDownloadService.modelFileName}';
      final file = File(filePath);

      // Crucial Demo Bypass: If already present, instantly route to Sanctuary Dashboard
      if (await file.exists()) {
        if (!mounted) return;
        _navigateToDashboard();
        return;
      }

      if (!mounted) return;
      setState(() {
        _isChecking = false;
        _progress = 0.0;
      });

      // Begin in-app download
      await downloadGemmaModel((progress) {
        if (!mounted) return;
        setState(() {
          _progress = progress;
        });
      });

      if (!mounted) return;
      _navigateToDashboard();
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isChecking = false;
        _errorMessage = 'Download interrupted: ${e.toString()}';
      });
    }
  }

  void _navigateToDashboard() {
    if (widget.onComplete != null) {
      widget.onComplete!();
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) =>
              widget.destinationScreen ?? const SanctuaryDashboardScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final percentage = (_progress * 100).toInt();

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A), // Slate 900
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Glowing Icon Container
                Container(
                  width: 96,
                  height: 96,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E293B),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF6366F1).withOpacity(0.25),
                        blurRadius: 28,
                        spreadRadius: 4,
                      ),
                    ],
                    border: Border.all(
                      color: const Color(0xFF334155),
                      width: 1.5,
                    ),
                  ),
                  child: const Icon(
                    Icons.auto_awesome,
                    size: 44,
                    color: Color(0xFF818CF8), // Indigo 400
                  ),
                ),
                const SizedBox(height: 36),

                // Main Heading
                const Text(
                  'Setting up your private offline brain...',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFF8FAFC),
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 12),

                // Subtitle
                const Text(
                  'Downloading the on-device AI model so your journaling reflections remain 100% offline and private.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF94A3B8),
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 40),

                // Progress Indicator Card
                if (_errorMessage == null) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 18,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E293B),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: const Color(0xFF334155),
                      ),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _isChecking
                                  ? 'Checking offline storage...'
                                  : 'Downloading Gemma 3 (1B int4)',
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFFE2E8F0),
                              ),
                            ),
                            Text(
                              _isChecking ? '...' : '$percentage%',
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF818CF8),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: LinearProgressIndicator(
                            value: _isChecking ? null : _progress,
                            minHeight: 8,
                            backgroundColor: const Color(0xFF334155),
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              Color(0xFF6366F1), // Indigo 500
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ] else ...[
                  // Error State with Retry
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF450A0A),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: const Color(0xFF991B1B),
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(
                          _errorMessage!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Color(0xFFFECACA),
                          ),
                        ),
                        const SizedBox(height: 14),
                        ElevatedButton.icon(
                          onPressed: _checkModelAndStart,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFDC2626),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          icon: const Icon(Icons.refresh, size: 18),
                          label: const Text('Retry Download'),
                        ),
                      ],
                    ),
                  ),
                ],

                const SizedBox(height: 32),

                // Privacy Footnote
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.lock_outline,
                      size: 16,
                      color: Color(0xFF64748B),
                    ),
                    SizedBox(width: 8),
                    Text(
                      'No accounts. No telemetry. Fully on-device.',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
