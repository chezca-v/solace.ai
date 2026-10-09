import 'package:flutter/material.dart';
import '../../../services/journal_service.dart';
import '../../../services/onboarding_service.dart';
import '../../theme/solace_theme.dart';
import '../../widgets/sun_illustration.dart';

/// 06 — Sanctuary Home Dashboard
class SanctuaryHomeScreen extends StatefulWidget {
  final VoidCallback? onNewEntry;
  final VoidCallback? onVoiceEntry;
  final Function(String)? onSelectEntry;
  final VoidCallback? onMemoriesTab;
  final VoidCallback? onJournalTab;
  final VoidCallback? onSettingsTab;

  const SanctuaryHomeScreen({
    super.key,
    this.onNewEntry,
    this.onVoiceEntry,
    this.onSelectEntry,
    this.onMemoriesTab,
    this.onJournalTab,
    this.onSettingsTab,
  });

  @override
  State<SanctuaryHomeScreen> createState() => _SanctuaryHomeScreenState();
}

class _SanctuaryHomeScreenState extends State<SanctuaryHomeScreen> {
  int _currentNavIndex = 0;
  bool _isPlayingAmbient = false;
  final _journalService = JournalService.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SolaceTheme.background,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top App Bar: Brand + On-Device Badge + Avatar
                  _buildTopBar(),
                  const SizedBox(height: 12),

                  // Sol Active On-Device Status Banner
                  _buildSolStatusBanner(),
                  const SizedBox(height: 16),

                  // Sanctuary Greeting Section
                  _buildGreetingSection(),
                  const SizedBox(height: 16),

                  // Sol's Gentle Prompt Card
                  _buildGentlePromptCard(),
                  const SizedBox(height: 16),

                  // Action Bar: + New Entry Button & Search
                  _buildActionBar(),
                  const SizedBox(height: 20),

                  // Mind Rhythm 7-Day Tracker
                  _buildMindRhythmCard(),
                  const SizedBox(height: 22),

                  // Your Recent Reflections Feed
                  _buildRecentReflectionsSection(),
                  const SizedBox(height: 16),

                  // Mindful Exhale Soundscape Player Card
                  _buildMindfulAudioCard(),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildTopBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Solace AI Brand + Mini Sun Icon
        Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: const BoxDecoration(
                color: Color(0xFFE8F7EE),
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Icon(
                  Icons.wb_sunny_rounded,
                  size: 18,
                  color: Color(0xFF2E8B62),
                ),
              ),
            ),
            const SizedBox(width: 8),
            const Text(
              'Solace AI',
              style: TextStyle(
                fontFamily: SolaceTheme.fontFamily,
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: SolaceTheme.textHeading,
              ),
            ),
          ],
        ),

        // Center/Right Badge + Avatar
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFE5F6EC),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFCEECD9), width: 0.8),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(radius: 2.5, backgroundColor: SolaceTheme.primary),
                  SizedBox(width: 5),
                  Text(
                    'ON-DEVICE AI',
                    style: TextStyle(
                      fontFamily: SolaceTheme.fontFamily,
                      fontSize: 10.5,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.4,
                      color: SolaceTheme.badgeText,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),

            // Profile Avatar
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: SolaceTheme.primary, width: 1.5),
                color: const Color(0xFFD4EBDD),
              ),
              child: const Center(
                child: Text(
                  'E',
                  style: TextStyle(
                    fontFamily: SolaceTheme.fontFamily,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: SolaceTheme.primaryDark,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSolStatusBanner() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
      decoration: BoxDecoration(
        color: const Color(0xFFEBF6EF),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFD4EBDD), width: 0.8),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: const BoxDecoration(
                  color: Color(0xFFFEF3C7),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.sentiment_satisfied_alt_rounded,
                  size: 17,
                  color: Color(0xFFD97706),
                ),
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Sol is active on-device',
                      style: TextStyle(
                        fontFamily: SolaceTheme.fontFamily,
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                        color: SolaceTheme.textHeading,
                      ),
                    ),
                    Text(
                      'Listening for privacy-first cues',
                      style: TextStyle(
                        fontFamily: SolaceTheme.fontFamily,
                        fontSize: 11,
                        color: SolaceTheme.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFFD3F2DF),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  '• Local Neural Core Active',
                  style: TextStyle(
                    fontFamily: SolaceTheme.fontFamily,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF166E49),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: Row(
                  children: [
                    Icon(Icons.circle, size: 6, color: Color(0xFF10B981)),
                    SizedBox(width: 4),
                    Icon(Icons.circle, size: 6, color: Color(0xFF10B981)),
                    SizedBox(width: 5),
                    Flexible(
                      child: Text(
                        'Offline & Encrypted',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: SolaceTheme.fontFamily,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1B7A52),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                'Wednesday, Oct 11',
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
    );
  }

  Widget _buildGreetingSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'SANCTUARY SPACE',
                style: TextStyle(
                  fontFamily: SolaceTheme.fontFamily,
                  fontSize: 10.5,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8,
                  color: SolaceTheme.primaryDark,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Good morning,\n${onboarding.userName.isNotEmpty ? onboarding.userName : 'Friend'}',
                style: const TextStyle(
                  fontFamily: SolaceTheme.fontFamily,
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: SolaceTheme.textHeading,
                  letterSpacing: -0.5,
                  height: 1.15,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Here is a gentle space for your\nthoughts today.',
                style: TextStyle(
                  fontFamily: SolaceTheme.fontFamily,
                  fontSize: 13,
                  color: SolaceTheme.textBody,
                  height: 1.35,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Container(
          width: 36,
          height: 36,
          decoration: const BoxDecoration(
            color: Color(0xFFEAF7EE),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.spa_rounded,
            size: 20,
            color: SolaceTheme.primary,
          ),
        ),
      ],
    );
  }

  Widget _buildGentlePromptCard() {
    final onboarding = OnboardingService.instance;
    final priorities = onboarding.workingToward;
    final goals = onboarding.selectedGoals;
    
    String promptText = 'Take a breath. How does your mind feel right now?';
    if (priorities.isNotEmpty) {
      promptText = 'Take a breath. You mentioned wanting clarity on: $priorities. How does your mind feel right now?';
    } else if (goals.isNotEmpty) {
      promptText = 'Take a breath. You are focusing on ${goals.first}. How does your mind feel right now?';
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F6EE),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFD4EBDD), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.wb_sunny_rounded, size: 16, color: Color(0xFFF59E0B)),
              SizedBox(width: 8),
              Text(
                'Sol\'s Gentle Prompt',
                style: TextStyle(
                  fontFamily: SolaceTheme.fontFamily,
                  fontSize: 13.5,
                  fontWeight: FontWeight.w700,
                  color: SolaceTheme.textHeading,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            promptText,
            style: const TextStyle(
              fontFamily: SolaceTheme.fontFamily,
              fontSize: 13,
              fontStyle: FontStyle.normal,
              color: SolaceTheme.textBody,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              ElevatedButton.icon(
                onPressed: widget.onNewEntry,
                icon: const Icon(Icons.auto_awesome, size: 14, color: Colors.white),
                label: const Text(
                  'Reflect on this',
                  style: TextStyle(
                    fontFamily: SolaceTheme.fontFamily,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: SolaceTheme.primary,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                width: 36,
                height: 36,
                decoration: const BoxDecoration(
                  color: Color(0xFFD4EBDD),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Prompt refreshed offline!'),
                        duration: Duration(seconds: 1),
                      ),
                    );
                  },
                  icon: const Icon(Icons.refresh_rounded, size: 18, color: SolaceTheme.primaryDark),
                  padding: EdgeInsets.zero,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionBar() {
    return Row(
      children: [
        // + + New Entry Button
        Expanded(
          child: SizedBox(
            height: 50,
            child: ElevatedButton.icon(
              onPressed: widget.onNewEntry,
              icon: const Icon(Icons.add_rounded, size: 20, color: Colors.white),
              label: const Text(
                'New Entry',
                style: TextStyle(
                  fontFamily: SolaceTheme.fontFamily,
                  fontSize: 15.5,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: SolaceTheme.primary,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),

        // Voice Journaling Button
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: const Color(0xFFE8F7EE),
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xFFD4EBDD)),
          ),
          child: IconButton(
            onPressed: widget.onVoiceEntry,
            icon: const Icon(Icons.mic_rounded, color: SolaceTheme.primaryDark, size: 22),
          ),
        ),
        const SizedBox(width: 10),

        // Search Button
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: SolaceTheme.surfaceWhite,
            shape: BoxShape.circle,
            border: Border.all(color: SolaceTheme.cardBorder),
          ),
          child: IconButton(
            onPressed: () => _showSearchSheet(context),
            icon: const Icon(Icons.search_rounded, color: SolaceTheme.textHeading, size: 22),
          ),
        ),
      ],
    );
  }

  Widget _buildMindRhythmCard() {
    const days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
    const activeDays = [true, true, true, true, false, false, false];

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
              const Row(
                children: [
                  Icon(Icons.timeline_rounded, size: 16, color: SolaceTheme.primary),
                  SizedBox(width: 6),
                  Text(
                    'Mind Rhythm',
                    style: TextStyle(
                      fontFamily: SolaceTheme.fontFamily,
                      fontSize: 14.5,
                      fontWeight: FontWeight.w700,
                      color: SolaceTheme.textHeading,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: SolaceTheme.iconBg,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  '4 / 7 DAYS',
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
          const SizedBox(height: 4),
          const Text(
            '4 days of grounded reflection this week',
            style: TextStyle(
              fontFamily: SolaceTheme.fontFamily,
              fontSize: 12,
              color: SolaceTheme.textMuted,
            ),
          ),
          const SizedBox(height: 14),

          // Day Tracker Circles
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(7, (i) {
              final isDone = activeDays[i];
              return Column(
                children: [
                  Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: isDone ? SolaceTheme.primary : const Color(0xFFEDF5F0),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: isDone
                          ? const Icon(Icons.check_rounded, size: 16, color: Colors.white)
                          : const Icon(Icons.circle, size: 5, color: Color(0xFFB0C9BD)),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    days[i],
                    style: TextStyle(
                      fontFamily: SolaceTheme.fontFamily,
                      fontSize: 11,
                      fontWeight: isDone ? FontWeight.w700 : FontWeight.w500,
                      color: isDone ? SolaceTheme.textHeading : SolaceTheme.textMuted,
                    ),
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentReflectionsSection() {
    return ListenableBuilder(
      listenable: _journalService,
      builder: (context, _) {
        final entries = _journalService.entries;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Expanded(
                  child: Row(
                    children: [
                      Icon(Icons.auto_stories_outlined, size: 16, color: SolaceTheme.primary),
                      SizedBox(width: 6),
                      Flexible(
                        child: Text(
                          'Your Recent Reflections',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontFamily: SolaceTheme.fontFamily,
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: SolaceTheme.textHeading,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () {
                    setState(() => _currentNavIndex = 1);
                  },
                  child: const Text(
                    'View All',
                    style: TextStyle(
                      fontFamily: SolaceTheme.fontFamily,
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                      color: SolaceTheme.primaryDark,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            ...entries.map((entry) => Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: _buildReflectionCard(entry),
                )),
          ],
        );
      },
    );
  }

  Widget _buildReflectionCard(dynamic entry) {
    return InkWell(
      onTap: () => widget.onSelectEntry?.call(entry.id),
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: SolaceTheme.surfaceWhite,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: SolaceTheme.cardBorder),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF1B3C2D).withValues(alpha: 0.02),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Row: Tag Pill + Timestamp
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEAF6EF),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    entry.type,
                    style: const TextStyle(
                      fontFamily: SolaceTheme.fontFamily,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: SolaceTheme.primaryDark,
                    ),
                  ),
                ),
                Text(
                  'Yesterday, 9:42 PM',
                  style: const TextStyle(
                    fontFamily: SolaceTheme.fontFamily,
                    fontSize: 11.5,
                    color: SolaceTheme.textMuted,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Title
            Text(
              entry.title,
              style: const TextStyle(
                fontFamily: SolaceTheme.fontFamily,
                fontSize: 14.5,
                fontWeight: FontWeight.w700,
                color: SolaceTheme.textHeading,
              ),
            ),
            const SizedBox(height: 4),

            // Content snippet
            Text(
              entry.content,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontFamily: SolaceTheme.fontFamily,
                fontSize: 12.5,
                color: SolaceTheme.textBody,
                height: 1.35,
              ),
            ),
            const SizedBox(height: 10),

            // Sol Badge & Arrow
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEBF6EF),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.auto_awesome, size: 11, color: SolaceTheme.primaryDark),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            'Sol Badge: ${entry.solBadge ?? "Reflection active"}',
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontFamily: SolaceTheme.fontFamily,
                              fontSize: 10.5,
                              fontWeight: FontWeight.w600,
                              color: SolaceTheme.primaryDark,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(
                  Icons.arrow_forward_rounded,
                  size: 16,
                  color: SolaceTheme.textMuted,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMindfulAudioCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: SolaceTheme.surfaceWhite,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: SolaceTheme.cardBorder),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: Color(0xFFEAF7EE),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.headphones_rounded,
              size: 20,
              color: SolaceTheme.primaryDark,
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '2-Minute Mindful Exhale',
                  style: TextStyle(
                    fontFamily: SolaceTheme.fontFamily,
                    fontSize: 13.5,
                    fontWeight: FontWeight.w700,
                    color: SolaceTheme.textHeading,
                  ),
                ),
                Text(
                  'Calm ambient soundscape',
                  style: TextStyle(
                    fontFamily: SolaceTheme.fontFamily,
                    fontSize: 11.5,
                    color: SolaceTheme.textMuted,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              setState(() => _isPlayingAmbient = !_isPlayingAmbient);
            },
            icon: Icon(
              _isPlayingAmbient ? Icons.pause_circle_filled_rounded : Icons.play_circle_fill_rounded,
              size: 34,
              color: SolaceTheme.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNav() {
    return NavigationBar(
      selectedIndex: _currentNavIndex,
      onDestinationSelected: (i) {
        setState(() => _currentNavIndex = i);
        if (i == 0) {
          // Home
        } else if (i == 1) {
          widget.onJournalTab?.call();
        } else if (i == 2) {
          widget.onMemoriesTab?.call();
        } else if (i == 3) {
          widget.onSettingsTab?.call();
        }
      },
      backgroundColor: SolaceTheme.surfaceWhite,
      indicatorColor: const Color(0xFFE5F6EC),
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.home_outlined),
          selectedIcon: Icon(Icons.home_rounded, color: SolaceTheme.primaryDark),
          label: 'Home',
        ),
        NavigationDestination(
          icon: Icon(Icons.book_outlined),
          selectedIcon: Icon(Icons.book_rounded, color: SolaceTheme.primaryDark),
          label: 'Journal',
        ),
        NavigationDestination(
          icon: Icon(Icons.psychology_outlined),
          selectedIcon: Icon(Icons.psychology_rounded, color: SolaceTheme.primaryDark),
          label: 'Memories',
        ),
        NavigationDestination(
          icon: Icon(Icons.settings_outlined),
          selectedIcon: Icon(Icons.settings_rounded, color: SolaceTheme.primaryDark),
          label: 'Settings',
        ),
      ],
    );
  }

  void _showSearchSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: SolaceTheme.surfaceWhite,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.fromLTRB(20, 20, 20, MediaQuery.of(ctx).viewInsets.bottom + 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Local Search Vault',
              style: TextStyle(
                fontFamily: SolaceTheme.fontFamily,
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: SolaceTheme.textHeading,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              autofocus: true,
              decoration: InputDecoration(
                hintText: 'Search journal entries and memories...',
                prefixIcon: const Icon(Icons.search_rounded),
                filled: true,
                fillColor: const Color(0xFFF2F7F4),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
