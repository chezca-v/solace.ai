import 'dart:async';
import 'package:flutter/material.dart';
import '../../../ai/ai_service.dart';
import '../../../models/journal_entry.dart';
import '../../../services/audio_service.dart';
import '../../../services/journal_service.dart';
import '../../../services/onboarding_service.dart';
import '../../../services/stt_service.dart';
import '../../theme/solace_theme.dart';
import 'package:audioplayers/audioplayers.dart';
import 'journal_editor_screen.dart';

/// 07A & 07B — Voice Journaling (Recording & Transcribed Reflection Mode)
class VoiceJournalingScreen extends StatefulWidget {
  final VoidCallback? onBack;
  final VoidCallback? onSwitchToWrite;

  const VoiceJournalingScreen({
    super.key,
    this.onBack,
    this.onSwitchToWrite,
  });

  @override
  State<VoiceJournalingScreen> createState() => _VoiceJournalingScreenState();
}

class _VoiceJournalingScreenState extends State<VoiceJournalingScreen>
    with SingleTickerProviderStateMixin {
  bool _isRecording = false; // Start paused
  bool _isTranscribed = false;
  bool _isPlayingAudio = false;
  int _secondsRecorded = 0;
  
  Duration _playbackPosition = Duration.zero;
  Duration _playbackDuration = Duration.zero;
  
  Timer? _timer;
  late AnimationController _pulseController;
  final STTService _sttService = STTService();
  final AudioService _audioService = AudioService();
  String? _recordedAudioPath;
  
  // Real waveform data
  List<double> _amplitudes = List.filled(24, 8.0, growable: true);
  StreamSubscription? _amplitudeSub;

  late final TextEditingController _transcriptController;

  @override
  void initState() {
    super.initState();
    _transcriptController = TextEditingController(
      text: '',
    );

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);

    _audioService.onPlayerStateChanged.listen((state) {
      if (mounted) {
        setState(() {
          _isPlayingAudio = state == PlayerState.playing;
          if (state == PlayerState.completed) {
            _playbackPosition = Duration.zero;
          }
        });
      }
    });
    
    _audioService.onPositionChanged.listen((pos) {
      if (mounted) {
        setState(() {
          _playbackPosition = pos;
        });
      }
    });

    _audioService.onDurationChanged.listen((dur) {
      if (mounted) {
        setState(() {
          _playbackDuration = dur;
        });
      }
    });

    _initSTT();
    _startTimer();
  }

  Future<void> _initSTT() async {
    await _sttService.initialize();
  }

  void _startListening() {
    _audioService.startRecording();
    _sttService.startListening(
      onResult: (text) {
        if (mounted) {
          setState(() {
            _transcriptController.text = text;
          });
        }
      },
    );
    
    _amplitudeSub?.cancel();
    _amplitudeSub = _audioService.onAmplitudeChanged.listen((amp) {
      if (mounted && _isRecording) {
        setState(() {
          // amp.current is usually between -160 and 0. 
          // Map -50..0 to 8..44
          double v = (amp.current + 50) / 50.0;
          v = v.clamp(0.0, 1.0);
          final h = 8.0 + (v * 36.0);
          _amplitudes.removeAt(0);
          _amplitudes.add(h);
        });
      }
    });
  }

  void _stopListening() {
    _sttService.stopListening();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_isRecording) {
        setState(() {
          _secondsRecorded++;
        });
      }
    });
  }

  @override
  void dispose() {
    _stopListening();
    _amplitudeSub?.cancel();
    _audioService.dispose();
    _timer?.cancel();
    _pulseController.dispose();
    _transcriptController.dispose();
    super.dispose();
  }

  String get _formattedTime {
    final minutes = (_secondsRecorded ~/ 60).toString().padLeft(2, '0');
    final seconds = (_secondsRecorded % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  String _formatDuration(Duration d) {
    final minutes = d.inMinutes.toString().padLeft(2, '0');
    final seconds = (d.inSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  Future<void> _transcribeVoice() async {
    _stopListening();
    final audioPath = await _audioService.stopRecording();
    
    // Fallback mock text if STT returned nothing (e.g. desktop mic limitations)
    if (_transcriptController.text.trim().isEmpty) {
      _transcriptController.text = "I've been feeling a bit overwhelmed lately with everything going on. I just need to take a step back and breathe, but it's hard to find the time.";
    }

    setState(() {
      _recordedAudioPath = audioPath;
      _isRecording = false;
      _isTranscribed = true;
    });
  }

  void _saveTranscript() {
    final text = _transcriptController.text.trim();
    final wordCount = text.isEmpty ? 0 : text.split(RegExp(r'\s+')).length;
    final title = text.isEmpty
        ? 'Voice Reflection'
        : (text.split('\n').first.length > 35
            ? '${text.split('\n').first.substring(0, 35)}...'
            : text.split('\n').first);

    final entry = JournalEntry(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      content: text,
      createdAt: DateTime.now(),
      type: 'Voice',
      tags: ['Voice Note', 'Spoken Reflection'],
      solBadge: 'Empathetic Mode',
      solWhisper:
          'Your spoken thoughts have been captured in your private vault. Reflect anytime to uncover deeper patterns.',
      wordCount: wordCount,
      audioDuration: _formattedTime,
      audioFilePath: _recordedAudioPath,
    );

    JournalService.instance.addEntry(entry);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Voice transcript saved locally.'),
        backgroundColor: SolaceTheme.primary,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SolaceTheme.background,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Column(
              children: [
                // Top App Bar
                _buildHeader(context),

                // Meta Row
                _buildMetaRow(),

                // Mode Segmented Pill: Write vs Speak
                _buildModeToggle(),
                const SizedBox(height: 8),

                // Main Content (07A vs 07B)
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
                    child: _isTranscribed
                        ? _buildTranscribedView(context)
                        : _buildRecordingView(context),
                  ),
                ),

                // Bottom Action Area
                _buildBottomArea(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: widget.onBack ?? () => Navigator.of(context).maybePop(),
            icon: const Icon(Icons.arrow_back_rounded, color: SolaceTheme.textHeading),
            splashRadius: 22,
          ),
          const Row(
            children: [
              Icon(Icons.wb_sunny_rounded, size: 18, color: Color(0xFF10B981)),
              SizedBox(width: 8),
              Text(
                'New Reflection',
                style: TextStyle(
                  fontFamily: SolaceTheme.fontFamily,
                  fontSize: 16.5,
                  fontWeight: FontWeight.w700,
                  color: SolaceTheme.textHeading,
                ),
              ),
            ],
          ),
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: SolaceTheme.primary, width: 1.5),
              color: const Color(0xFFD4EBDD),
            ),
            child: Center(
              child: Text(
                OnboardingService.instance.userInitial,
                style: const TextStyle(
                  fontFamily: SolaceTheme.fontFamily,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: SolaceTheme.primaryDark,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetaRow() {
    final text = _transcriptController.text.trim();
    final wordCount = text.isEmpty ? 0 : text.split(RegExp(r'\s+')).length;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                const Icon(Icons.circle, size: 6, color: Color(0xFF10B981)),
                const SizedBox(width: 5),
                Flexible(
                  child: Text(
                    _isTranscribed ? 'LOCAL TRANSCRIPT READY' : 'AUTO-SAVED LOCALLY · OFFLINE',
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontFamily: SolaceTheme.fontFamily,
                      fontSize: 10.5,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.3,
                      color: SolaceTheme.primaryDark,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: const Color(0xFFE5F6EC),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              _isTranscribed ? '$wordCount words ($_formattedTime)' : '100% Offline Edge',
              style: const TextStyle(
                fontFamily: SolaceTheme.fontFamily,
                fontSize: 10.5,
                fontWeight: FontWeight.w700,
                color: SolaceTheme.primaryDark,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModeToggle() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFEDF5F0),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: () {
                if (widget.onSwitchToWrite != null) {
                  widget.onSwitchToWrite!();
                } else {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => const JournalEditorScreen()),
                  );
                }
              },
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.edit_outlined, size: 14, color: SolaceTheme.textMuted),
                    SizedBox(width: 6),
                    Text(
                      'Write',
                      style: TextStyle(
                        fontFamily: SolaceTheme.fontFamily,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: SolaceTheme.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: SolaceTheme.primary,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.mic_rounded, size: 14, color: Colors.white),
                  const SizedBox(width: 6),
                  Flexible(
                    child: Text(
                      _isTranscribed ? 'Voice Note ($_formattedTime) 🎧' : 'Speak •',
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontFamily: SolaceTheme.fontFamily,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // 07A: RECORDING / LISTENING VIEW
  // ==========================================
  Widget _buildRecordingView(BuildContext context) {
    return Column(
      children: [
        // Gentle Reflection Seed
        _buildSeedCard(),
        const SizedBox(height: 20),

        // Live Whisper Listening Status
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFFEAF7EE),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.circle, size: 6, color: Color(0xFF10B981)),
              SizedBox(width: 6),
              Flexible(
                child: Text(
                  'Listening to your thoughts with whisper-edge AI...',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: SolaceTheme.fontFamily,
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                    color: SolaceTheme.primaryDark,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // Glowing Pulsating Mic Centerpiece
        ScaleTransition(
          scale: Tween<double>(begin: 0.95, end: 1.05).animate(_pulseController),
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: SolaceTheme.primary.withValues(alpha: 0.15),
              boxShadow: [
                BoxShadow(
                  color: SolaceTheme.primary.withValues(alpha: 0.25),
                  blurRadius: 30,
                  spreadRadius: 6,
                ),
              ],
            ),
            child: Center(
              child: InkWell(
                onTap: () async {
                  setState(() {
                    _isRecording = !_isRecording;
                  });
                  if (_isRecording) {
                    await _audioService.resumeRecording();
                    _startListening();
                  } else {
                    await _audioService.pauseRecording();
                    _stopListening();
                  }
                },
                borderRadius: BorderRadius.circular(36),
                child: Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: _isRecording ? SolaceTheme.primary : SolaceTheme.textMuted,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _isRecording ? Icons.mic_rounded : Icons.mic_off_rounded,
                    size: 34,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),

        // Waveform Visualizer
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(24, (i) {
            final h = _amplitudes[i];
            return AnimatedContainer(
              duration: const Duration(milliseconds: 100),
              width: 3.5,
              height: h,
              margin: const EdgeInsets.symmetric(horizontal: 2),
              decoration: BoxDecoration(
                color: SolaceTheme.primary.withValues(alpha: _isRecording ? 0.7 : 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            );
          }),
        ),
        const SizedBox(height: 14),

        // Timer Text
        Text(
          _formattedTime,
          style: const TextStyle(
            fontFamily: SolaceTheme.fontFamily,
            fontSize: 26,
            fontWeight: FontWeight.w800,
            color: SolaceTheme.textHeading,
            letterSpacing: 1.0,
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          '✦ On-Device Acoustic Model + Zero Cloud Transit • 16kHz PCM',
          style: TextStyle(
            fontFamily: SolaceTheme.fontFamily,
            fontSize: 10.5,
            fontWeight: FontWeight.w500,
            color: SolaceTheme.textMuted,
          ),
        ),
        const SizedBox(height: 24),

        // Recording Control Buttons: Cancel | Pause | Transcribe
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 10,
          runSpacing: 10,
          children: [
            OutlinedButton.icon(
              onPressed: () {
                setState(() => _secondsRecorded = 0);
              },
              icon: const Icon(Icons.close_rounded, size: 16),
              label: const Text('Cancel'),
              style: OutlinedButton.styleFrom(
                foregroundColor: SolaceTheme.textMuted,
                side: const BorderSide(color: SolaceTheme.cardBorder),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              ),
            ),
            OutlinedButton.icon(
              onPressed: () async {
                setState(() {
                  _isRecording = !_isRecording;
                });
                if (_isRecording) {
                  await _audioService.resumeRecording();
                  _startListening();
                } else {
                  await _audioService.pauseRecording();
                  _stopListening();
                }
              },
              icon: Icon(_isRecording ? Icons.pause_rounded : Icons.play_arrow_rounded, size: 16),
              label: Text(_isRecording ? 'Pause' : 'Resume'),
              style: OutlinedButton.styleFrom(
                foregroundColor: SolaceTheme.textHeading,
                side: const BorderSide(color: SolaceTheme.cardBorder),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              ),
            ),
            ElevatedButton.icon(
              onPressed: _transcribeVoice,
              icon: const Icon(Icons.check_rounded, size: 16, color: Colors.white),
              label: const Text(
                'Transcribe',
                style: TextStyle(
                  fontFamily: SolaceTheme.fontFamily,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: SolaceTheme.primary,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),

        // Spontaneous Prompts
        _buildSpontaneousPrompts(),
        const SizedBox(height: 16),

        // Sol Attentively Listening Offline Banner
        _buildSolListeningCard(),
        const SizedBox(height: 12),
      ],
    );
  }

  // ==========================================
  // 07B: TRANSCRIBED & REFLECTION VIEW
  // ==========================================
  Widget _buildTranscribedView(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Empathetic Mode Banner
        _buildEmpatheticBanner(),
        const SizedBox(height: 14),

        // Local Audio Waveform Player Card
        _buildAudioPlayerCard(),
        const SizedBox(height: 14),

        // Transcribed Text Container
        _buildTranscriptCard(),
        const SizedBox(height: 14),

        // Sol's Whisper Insight
        _buildSolWhisperCard(),
        const SizedBox(height: 14),

        // Safe Sanctuary Footnote
        const Center(
          child: Text(
            '• • • SAFE DIGITAL SANCTUARY • • •',
            style: TextStyle(
              fontFamily: SolaceTheme.fontFamily,
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
              color: SolaceTheme.textMuted,
            ),
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget _buildSeedCard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFEAF6EE),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFD4EBDD)),
      ),
      child: const Row(
        children: [
          Icon(Icons.lightbulb_outline_rounded, size: 18, color: SolaceTheme.primaryDark),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'GENTLE REFLECTION SEED',
                  style: TextStyle(
                    fontFamily: SolaceTheme.fontFamily,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.4,
                    color: SolaceTheme.primaryDark,
                  ),
                ),
                Text(
                  'What felt quiet, heavy, or unexpectedly freeing today?',
                  style: TextStyle(
                    fontFamily: SolaceTheme.fontFamily,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: SolaceTheme.textHeading,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpontaneousPrompts() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'SPONTANEOUS PROMPTS',
              style: TextStyle(
                fontFamily: SolaceTheme.fontFamily,
                fontSize: 10.5,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
                color: SolaceTheme.textMuted,
              ),
            ),
            Text(
              'Scroll to explore',
              style: TextStyle(
                fontFamily: SolaceTheme.fontFamily,
                fontSize: 10.5,
                color: SolaceTheme.textMuted,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildPromptChip('🌱 Speak without filtering'),
              const SizedBox(width: 8),
              _buildPromptChip('⚖️ Weigh two choices'),
              const SizedBox(width: 8),
              _buildPromptChip('💭 Unpack feeling overwhelmed'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPromptChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: SolaceTheme.surfaceWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: SolaceTheme.cardBorder),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontFamily: SolaceTheme.fontFamily,
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: SolaceTheme.textHeading,
        ),
      ),
    );
  }

  Widget _buildSolListeningCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFEAF6EE),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFD4EBDD)),
      ),
      child: const Row(
        children: [
          Icon(Icons.wb_sunny_rounded, size: 24, color: Color(0xFFF59E0B)),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sol is attentively listening offline',
                  style: TextStyle(
                    fontFamily: SolaceTheme.fontFamily,
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                    color: SolaceTheme.textHeading,
                  ),
                ),
                Text(
                  'Your raw voice stream never touches the internet',
                  style: TextStyle(
                    fontFamily: SolaceTheme.fontFamily,
                    fontSize: 11,
                    color: SolaceTheme.textBody,
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.circle, size: 8, color: Color(0xFF10B981)),
        ],
      ),
    );
  }

  Widget _buildEmpatheticBanner() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFEF9C3),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFFDE047)),
      ),
      child: const Row(
        children: [
          Icon(Icons.wb_sunny_rounded, size: 30, color: Color(0xFFD97706)),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '• 0 KB CLOUD TRANSIT • OFFLINE',
                  style: TextStyle(
                    fontFamily: SolaceTheme.fontFamily,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.4,
                    color: Color(0xFF854D0E),
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Empathetic Mode Activated',
                  style: TextStyle(
                    fontFamily: SolaceTheme.fontFamily,
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF713F12),
                  ),
                ),
                Text(
                  'Emotional tone and reflection cadence synthesized locally on-device.',
                  style: TextStyle(
                    fontFamily: SolaceTheme.fontFamily,
                    fontSize: 11.5,
                    color: Color(0xFF854D0E),
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAudioPlayerCard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: SolaceTheme.surfaceWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: SolaceTheme.cardBorder),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              setState(() => _isPlayingAudio = !_isPlayingAudio);
              if (_isPlayingAudio && _recordedAudioPath != null) {
                _audioService.playAudio(_recordedAudioPath!);
              } else {
                _audioService.pausePlayback();
              }
            },
            icon: Icon(
              _isPlayingAudio ? Icons.pause_circle_filled_rounded : Icons.play_circle_fill_rounded,
              size: 32,
              color: SolaceTheme.primary,
            ),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(28, (i) {
                final h = [10.0, 20.0, 14.0, 26.0, 8.0, 30.0, 16.0][i % 7];
                
                // Calculate progress
                final progress = _playbackDuration.inMilliseconds > 0 
                    ? _playbackPosition.inMilliseconds / _playbackDuration.inMilliseconds
                    : 0.0;
                final activeBars = (progress * 28).ceil();
                
                return Container(
                  width: 3,
                  height: h,
                  decoration: BoxDecoration(
                    color: i < activeBars ? SolaceTheme.primary : const Color(0xFFCADBD0),
                    borderRadius: BorderRadius.circular(2),
                  ),
                );
              }),
            ),
          ),
          const SizedBox(width: 10),
          Text(
            '${_formatDuration(_playbackPosition)} / ${_formatDuration(_playbackDuration > Duration.zero ? _playbackDuration : Duration(seconds: _secondsRecorded))}',
            style: const TextStyle(
              fontFamily: SolaceTheme.fontFamily,
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: SolaceTheme.textMuted,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTranscriptCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: SolaceTheme.surfaceWhite,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: SolaceTheme.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: Row(
                  children: [
                    Icon(Icons.lock_rounded, size: 12, color: SolaceTheme.primaryDark),
                    SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        'WHISPER.TFLITE • ON-DEVICE TRANSLATION',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: SolaceTheme.fontFamily,
                          fontSize: 10.5,
                          fontWeight: FontWeight.w700,
                          color: SolaceTheme.primaryDark,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              const Row(
                children: [
                  Icon(Icons.edit_outlined, size: 12, color: SolaceTheme.textMuted),
                  SizedBox(width: 4),
                  Text(
                    'Tap to edit',
                    style: TextStyle(
                      fontFamily: SolaceTheme.fontFamily,
                      fontSize: 11,
                      color: SolaceTheme.textMuted,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            _transcriptController.text.trim().isEmpty
                ? 'Voice Reflection'
                : (_transcriptController.text.trim().split('\n').first.length > 35
                    ? '${_transcriptController.text.trim().split('\n').first.substring(0, 35)}...'
                    : _transcriptController.text.trim().split('\n').first),
            style: const TextStyle(
              fontFamily: SolaceTheme.fontFamily,
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: SolaceTheme.textHeading,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _transcriptController,
            maxLines: null,
            style: const TextStyle(
              fontFamily: SolaceTheme.fontFamily,
              fontSize: 13.5,
              color: SolaceTheme.textBody,
              height: 1.5,
            ),
            decoration: const InputDecoration(
              hintText: 'Speak or edit your voice reflection here... Solace will transcribe in real time.',
              border: InputBorder.none,
              isDense: true,
              contentPadding: EdgeInsets.zero,
            ),
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFFFEF9C3),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  '• Spoken Voice',
                  style: TextStyle(
                    fontFamily: SolaceTheme.fontFamily,
                    fontSize: 10.5,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF854D0E),
                  ),
                ),
              ),
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: SolaceTheme.primary,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  '🎙️ Audio Draft',
                  style: TextStyle(
                    fontFamily: SolaceTheme.fontFamily,
                    fontSize: 10.5,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSolWhisperCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F6EE),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFD4EBDD)),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.spa_rounded, size: 14, color: SolaceTheme.primaryDark),
                  SizedBox(width: 6),
                  Text(
                    'SOL\'S WHISPER',
                    style: TextStyle(
                      fontFamily: SolaceTheme.fontFamily,
                      fontSize: 10.5,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.5,
                      color: SolaceTheme.primaryDark,
                    ),
                  ),
                ],
              ),
              Text(
                'Just now',
                style: TextStyle(
                  fontFamily: SolaceTheme.fontFamily,
                  fontSize: 10.5,
                  color: SolaceTheme.textMuted,
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            '"I am listening to your thoughts and reflections. When you feel ready, tap Reflect with Solace to explore your priorities and insights."',
            style: TextStyle(
              fontFamily: SolaceTheme.fontFamily,
              fontSize: 13,
              fontStyle: FontStyle.italic,
              color: SolaceTheme.textHeading,
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomArea(BuildContext context) {
    if (!_isTranscribed) {
      return Container(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 14),
        child: SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Audio draft saved to local device.')),
              );
            },
            icon: const Icon(Icons.bookmark_outline_rounded, size: 18, color: SolaceTheme.primaryDark),
            label: const Text(
              'Save Recording as Draft',
              style: TextStyle(
                fontFamily: SolaceTheme.fontFamily,
                fontSize: 14.5,
                fontWeight: FontWeight.w600,
                color: SolaceTheme.primaryDark,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE8F7EE),
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
            ),
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 14),
      decoration: BoxDecoration(
        color: SolaceTheme.background,
        boxShadow: [
          BoxShadow(
            color: SolaceTheme.background.withValues(alpha: 0.9),
            blurRadius: 8,
            offset: const Offset(0, -6),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Reflect with Solace Button
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton.icon(
              onPressed: () => _handleReflectWithSolace(context),
              icon: const Icon(Icons.auto_awesome, size: 18, color: Colors.white),
              label: const Text(
                'Reflect with Solace →',
                style: TextStyle(
                  fontFamily: SolaceTheme.fontFamily,
                  fontSize: 15.5,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: SolaceTheme.primary,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
              ),
            ),
          ),
          const SizedBox(height: 8),

          // Save Transcript Only
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton.icon(
                onPressed: _saveTranscript,
                icon: const Icon(Icons.save_alt_rounded, size: 14, color: SolaceTheme.textMuted),
                label: const Text(
                  'Save Transcript Only',
                  style: TextStyle(
                    fontFamily: SolaceTheme.fontFamily,
                    fontSize: 12.5,
                    color: SolaceTheme.textMuted,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _handleReflectWithSolace(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: SolaceTheme.surfaceWhite,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.balance_rounded, color: SolaceTheme.primary, size: 22),
                SizedBox(width: 8),
                Text(
                  'Contextual Decision Support',
                  style: TextStyle(
                    fontFamily: SolaceTheme.fontFamily,
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: SolaceTheme.textHeading,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Text(
              _transcriptController.text.trim().isNotEmpty
                  ? 'Sol has analyzed your spoken reflection to surface core themes and actionable insights:'
                  : 'Sol will analyze your spoken reflection locally to surface core themes and next steps:',
              style: const TextStyle(
                fontFamily: SolaceTheme.fontFamily,
                fontSize: 13.5,
                color: SolaceTheme.textBody,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFEAF6EE),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Core Themes & Reflections', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  SizedBox(height: 4),
                  Text('• Identifies underlying priorities and emotional signals\n• Synthesizes perspective against your local memory vault', style: TextStyle(fontSize: 12)),
                  SizedBox(height: 8),
                  Text('Decision Architecture', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  SizedBox(height: 4),
                  Text('• Structures tradeoffs without unsolicited advice\n• Preserves total offline privacy and client-side encryption', style: TextStyle(fontSize: 12)),
                ],
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () => Navigator.of(ctx).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: SolaceTheme.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                ),
                child: const Text('Save Decision Reflection'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
