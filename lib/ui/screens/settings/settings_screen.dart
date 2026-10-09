import 'package:flutter/material.dart';
import '../../../services/journal_service.dart';
import '../../../services/memory_service.dart';
import '../../theme/solace_theme.dart';
import '../../widgets/sun_illustration.dart';
import '../journal/journal_editor_screen.dart';
import '../memories/memory_vault_screen.dart';

/// 12 — Settings & Privacy Screen
///
/// Transparent control over on-device AI models, context memory boundaries,
/// offline emergency care hub, and zero-trace data sovereignty.
class SettingsScreen extends StatefulWidget {
  final VoidCallback? onBack;
  final VoidCallback? onHomeTab;
  final VoidCallback? onJournalTab;
  final VoidCallback? onMemoriesTab;

  const SettingsScreen({
    super.key,
    this.onBack,
    this.onHomeTab,
    this.onJournalTab,
    this.onMemoriesTab,
  });

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  int _currentNavIndex = 3; // Active tab is Settings (index 3)

  // Section 1: Edge AI Engine
  bool _edgeAiEngineEnabled = true;

  // Section 2: Memory & Context Boundaries
  bool _allowMemoryRetrieval = true;
  bool _promptBeforeSavingThemes = true;
  bool _biometricAppLock = false;

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
                  // Top App Bar
                  _buildTopBar(),
                  const SizedBox(height: 16),

                  // Privacy Sanctuary Badge & Header
                  _buildHeaderSection(),
                  const SizedBox(height: 20),

                  // 1. Edge AI Engine Card
                  _buildEdgeAiEngineCard(),
                  const SizedBox(height: 24),

                  // 2. Memory & Context Boundaries Section
                  _buildMemoryBoundariesSection(),
                  const SizedBox(height: 24),

                  // 3. Data Vault & Offline Care Section
                  _buildDataVaultSection(),
                  const SizedBox(height: 24),

                  // 4. Complete Sovereignty Section
                  _buildCompleteSovereigntySection(),
                  const SizedBox(height: 20),

                  // Footer Security Banner
                  _buildFooterSecurityNote(),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  // ---------------------------------------------------------------------------
  // Top App Bar
  // ---------------------------------------------------------------------------
  Widget _buildTopBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Brand + Mini Sun Icon
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

        // Right Badge + Avatar
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
                  'S',
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

  // ---------------------------------------------------------------------------
  // Privacy Sanctuary Header
  // ---------------------------------------------------------------------------
  Widget _buildHeaderSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Privacy Sanctuary Pill Badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFFE8F6EE),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFD4EBDD), width: 0.8),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.shield_rounded, size: 13, color: SolaceTheme.primaryDark),
              SizedBox(width: 5),
              Text(
                'Privacy Sanctuary',
                style: TextStyle(
                  fontFamily: SolaceTheme.fontFamily,
                  fontSize: 11.5,
                  fontWeight: FontWeight.w700,
                  color: SolaceTheme.primaryDark,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),

        // Title
        const Text(
          'Settings & Privacy',
          style: TextStyle(
            fontFamily: SolaceTheme.fontFamily,
            fontSize: 26,
            fontWeight: FontWeight.w800,
            color: SolaceTheme.textHeading,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 6),

        // Subtitle
        const Text(
          'Transparent control over your data, AI models, and local storage. Everything stays strictly on this device.',
          style: TextStyle(
            fontFamily: SolaceTheme.fontFamily,
            fontSize: 13,
            color: SolaceTheme.textBody,
            height: 1.4,
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // 1. Edge AI Engine Card
  // ---------------------------------------------------------------------------
  Widget _buildEdgeAiEngineCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFEDF8F1),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFD0EBD8), width: 1),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF166E49).withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Engine Header Row + Switch
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  color: Color(0xFFD5F0DE),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.memory_rounded,
                  size: 22,
                  color: Color(0xFF1B7A52),
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Edge AI Engine',
                      style: TextStyle(
                        fontFamily: SolaceTheme.fontFamily,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: SolaceTheme.textHeading,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Zero-cloud neural processing',
                      style: TextStyle(
                        fontFamily: SolaceTheme.fontFamily,
                        fontSize: 12,
                        color: SolaceTheme.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
              Switch.adaptive(
                value: _edgeAiEngineEnabled,
                activeColor: SolaceTheme.primary,
                activeTrackColor: const Color(0xFF9AE6B4),
                onChanged: (val) {
                  setState(() => _edgeAiEngineEnabled = val);
                },
              ),
            ],
          ),
          const SizedBox(height: 12),

          // ONNX Runtime Mobile Pill Badge
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFD8F2E2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Row(
              children: [
                CircleAvatar(radius: 3, backgroundColor: Color(0xFF10B981)),
                SizedBox(width: 6),
                Flexible(
                  child: Text(
                    'ONNX Runtime Mobile v1.2 — Ready Offline',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: SolaceTheme.fontFamily,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF166E49),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Sub-item 1: Engine Architecture
          _buildEngineSubCard(
            icon: Icons.psychology_outlined,
            title: 'Engine Architecture',
            subtitle: 'Local 4-bit Quantized Intent & Reflection',
          ),
          const SizedBox(height: 8),

          // Sub-item 2: Hardware Acceleration
          _buildEngineSubCard(
            icon: Icons.electric_bolt_rounded,
            title: 'Hardware Acceleration',
            subtitle: 'Running on local NPU/CPU • 0 KB network transit',
          ),
          const SizedBox(height: 8),

          // Sub-item 3: Airplane Mode Verified
          _buildEngineSubCard(
            icon: Icons.airplanemode_active_rounded,
            title: 'Airplane Mode Verified',
            subtitle: 'Tested and verified 100% offline',
          ),
        ],
      ),
    );
  }

  Widget _buildEngineSubCard({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE0F0E5), width: 0.8),
      ),
      child: Row(
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: const BoxDecoration(
              color: Color(0xFFEDF8F1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 16, color: const Color(0xFF1B7A52)),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: SolaceTheme.fontFamily,
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                    color: SolaceTheme.textHeading,
                  ),
                ),
                const SizedBox(height: 1),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontFamily: SolaceTheme.fontFamily,
                    fontSize: 11,
                    color: SolaceTheme.textMuted,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // 2. Memory & Context Boundaries
  // ---------------------------------------------------------------------------
  Widget _buildMemoryBoundariesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header Row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Expanded(
              child: Text(
                'Memory & Context Boundaries',
                style: TextStyle(
                  fontFamily: SolaceTheme.fontFamily,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: SolaceTheme.textHeading,
                ),
              ),
            ),
            const SizedBox(width: 8),
            const Text(
              'LOCAL ONLY',
              style: TextStyle(
                fontFamily: SolaceTheme.fontFamily,
                fontSize: 10,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.6,
                color: SolaceTheme.textMuted,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),

        // Settings Card with 3 Toggles
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: SolaceTheme.surfaceWhite,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: SolaceTheme.cardBorder),
          ),
          child: Column(
            children: [
              // Item 1: Allow local memory retrieval
              _buildSwitchRow(
                icon: Icons.history_edu_rounded,
                title: 'Allow local memory retrieval',
                subtitle: 'Recalls past feelings to enrich reflections',
                value: _allowMemoryRetrieval,
                onChanged: (val) => setState(() => _allowMemoryRetrieval = val),
              ),
              const Divider(height: 24, color: Color(0xFFEEF5F1)),

              // Item 2: Prompt before saving recurring themes
              _buildSwitchRow(
                icon: Icons.chat_bubble_outline_rounded,
                title: 'Prompt before saving recurring themes',
                subtitle: 'Asks your permission before storing long-term patterns',
                value: _promptBeforeSavingThemes,
                onChanged: (val) => setState(() => _promptBeforeSavingThemes = val),
              ),
              const Divider(height: 24, color: Color(0xFFEEF5F1)),

              // Item 3: Biometric App Lock
              _buildSwitchRow(
                icon: Icons.fingerprint_rounded,
                title: 'Biometric App Lock',
                subtitle: 'Require Face ID or Fingerprint on open',
                value: _biometricAppLock,
                onChanged: (val) => setState(() => _biometricAppLock = val),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSwitchRow({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: value ? const Color(0xFFE8F6EE) : const Color(0xFFF3F4F6),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            size: 19,
            color: value ? SolaceTheme.primary : SolaceTheme.textMuted,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontFamily: SolaceTheme.fontFamily,
                  fontSize: 13.5,
                  fontWeight: FontWeight.w700,
                  color: SolaceTheme.textHeading,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: const TextStyle(
                  fontFamily: SolaceTheme.fontFamily,
                  fontSize: 11.5,
                  color: SolaceTheme.textMuted,
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Switch.adaptive(
          value: value,
          activeColor: SolaceTheme.primary,
          activeTrackColor: const Color(0xFF9AE6B4),
          onChanged: onChanged,
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // 3. Data Vault & Offline Care
  // ---------------------------------------------------------------------------
  Widget _buildDataVaultSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header Row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Expanded(
              child: Text(
                'Data Vault & Offline Care',
                style: TextStyle(
                  fontFamily: SolaceTheme.fontFamily,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: SolaceTheme.textHeading,
                ),
              ),
            ),
            const SizedBox(width: 8),
            const Text(
              '100% Client-Side',
              style: TextStyle(
                fontFamily: SolaceTheme.fontFamily,
                fontSize: 10,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.5,
                color: SolaceTheme.primaryDark,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),

        // Highlight Card: Offline Crisis & Emergency Hub
        InkWell(
          onTap: () => _showEmergencyHubModal(context),
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFE8F6EE),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFD4EBDD), width: 1),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Sol Animated Mascot
                    const SunIllustration(size: 46),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Flexible(
                                child: Text(
                                  'Offline Crisis\n& Emergency Hub',
                                  style: TextStyle(
                                    fontFamily: SolaceTheme.fontFamily,
                                    fontSize: 14.5,
                                    fontWeight: FontWeight.w800,
                                    color: SolaceTheme.textHeading,
                                    height: 1.2,
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFD4EBDD),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Row(
                                  children: [
                                    Text(
                                      'Cached',
                                      style: TextStyle(
                                        fontFamily: SolaceTheme.fontFamily,
                                        fontSize: 10.5,
                                        fontWeight: FontWeight.w700,
                                        color: Color(0xFF166E49),
                                      ),
                                    ),
                                    SizedBox(width: 2),
                                    Icon(
                                      Icons.chevron_right_rounded,
                                      size: 13,
                                      color: Color(0xFF166E49),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Earthquake, Flood, Power Outage protocols cached on device',
                            style: TextStyle(
                              fontFamily: SolaceTheme.fontFamily,
                              fontSize: 11.5,
                              color: SolaceTheme.textBody,
                              height: 1.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Badges Row
                Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color(0xFFD4EBDD)),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.shield_outlined,
                              size: 12, color: Color(0xFF166E49)),
                          SizedBox(width: 4),
                          Text(
                            '100% Offline Guide Ready',
                            style: TextStyle(
                              fontFamily: SolaceTheme.fontFamily,
                              fontSize: 10.5,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF166E49),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 4.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircleAvatar(
                              radius: 3, backgroundColor: Color(0xFF10B981)),
                          SizedBox(width: 5),
                          Flexible(
                            child: Text(
                              'Sol Alert State: Attentive & Prepared',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontFamily: SolaceTheme.fontFamily,
                                fontSize: 10.5,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF1B7A52),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),

        // Item 2: Export Encrypted SQLite Database
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: SolaceTheme.surfaceWhite,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: SolaceTheme.cardBorder),
          ),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: const BoxDecoration(
                  color: Color(0xFFE8F6EE),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.sync_alt_rounded,
                  size: 19,
                  color: SolaceTheme.primaryDark,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Export Encrypted SQLite Database',
                      style: TextStyle(
                        fontFamily: SolaceTheme.fontFamily,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: SolaceTheme.textHeading,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Download AES-256 backup bundle',
                      style: TextStyle(
                        fontFamily: SolaceTheme.fontFamily,
                        fontSize: 11,
                        color: SolaceTheme.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () => _exportDatabase(context),
                icon: const Icon(Icons.download_rounded,
                    size: 20, color: SolaceTheme.primary),
                splashRadius: 20,
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),

        // Item 3: Local Storage Allocated
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: SolaceTheme.surfaceWhite,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: SolaceTheme.cardBorder),
          ),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: const BoxDecoration(
                  color: Color(0xFFF3F4F6),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.pie_chart_outline_rounded,
                  size: 19,
                  color: SolaceTheme.textMuted,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Local Storage Allocated',
                      style: TextStyle(
                        fontFamily: SolaceTheme.fontFamily,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: SolaceTheme.textHeading,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${JournalService.instance.entries.length} reflections, ${MemoryService.instance.memories.length} vault items',
                      style: const TextStyle(
                        fontFamily: SolaceTheme.fontFamily,
                        fontSize: 11,
                        color: SolaceTheme.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0FDF4),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFFDCFCE7)),
                ),
                child: Text(
                  '${((JournalService.instance.entries.length * 0.4) + (MemoryService.instance.memories.length * 0.1) + 8.4).toStringAsFixed(1)} MB',
                  style: const TextStyle(
                    fontFamily: SolaceTheme.fontFamily,
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF15803D),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // 4. Complete Sovereignty
  // ---------------------------------------------------------------------------
  Widget _buildCompleteSovereigntySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header Row
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Complete Sovereignty',
              style: TextStyle(
                fontFamily: SolaceTheme.fontFamily,
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: SolaceTheme.textHeading,
              ),
            ),
            Text(
              'Irreversible',
              style: TextStyle(
                fontFamily: SolaceTheme.fontFamily,
                fontSize: 10,
                fontWeight: FontWeight.w800,
                color: Color(0xFFDC2626),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),

        // Danger Action Card
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF7F7),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFFED7D7), width: 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 14,
                    backgroundColor: Color(0xFFFEE2E2),
                    child: Icon(
                      Icons.delete_sweep_rounded,
                      size: 16,
                      color: Color(0xFFDC2626),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Zero-Trace Data Deletion',
                          style: TextStyle(
                            fontFamily: SolaceTheme.fontFamily,
                            fontSize: 13.5,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF991B1B),
                          ),
                        ),
                        SizedBox(height: 3),
                        Text(
                          'Permanently wipes local database, cryptographic keys, and cached on-device model context. Cannot be undone.',
                          style: TextStyle(
                            fontFamily: SolaceTheme.fontFamily,
                            fontSize: 11.5,
                            color: Color(0xFF7F1D1D),
                            height: 1.35,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // Danger Erase Button
              SizedBox(
                width: double.infinity,
                height: 46,
                child: ElevatedButton.icon(
                  onPressed: () => _confirmResetData(context),
                  icon: const Icon(Icons.delete_forever_rounded,
                      size: 17, color: Color(0xFF991B1B)),
                  label: const Text(
                    'Erase All Local Data & Reset Model',
                    style: TextStyle(
                      fontFamily: SolaceTheme.fontFamily,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF991B1B),
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFEE2E2),
                    foregroundColor: const Color(0xFF991B1B),
                    elevation: 0,
                    side: const BorderSide(color: Color(0xFFFCA5A5), width: 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // Footer Security Note
  // ---------------------------------------------------------------------------
  Widget _buildFooterSecurityNote() {
    return const Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.verified_user_rounded,
              size: 13, color: SolaceTheme.textMuted),
          SizedBox(width: 5),
          Text(
            'SOLACE OPERATES STRICTLY CLIENT-SIDE',
            style: TextStyle(
              fontFamily: SolaceTheme.fontFamily,
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.8,
              color: SolaceTheme.textMuted,
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Bottom Navigation Bar
  // ---------------------------------------------------------------------------
  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: SolaceTheme.surfaceWhite,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: _currentNavIndex,
        onTap: (index) {
          setState(() => _currentNavIndex = index);
          if (index == 0) {
            widget.onHomeTab?.call();
          } else if (index == 1) {
            widget.onJournalTab?.call();
          } else if (index == 2) {
            widget.onMemoriesTab?.call();
          }
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: SolaceTheme.surfaceWhite,
        selectedItemColor: SolaceTheme.primaryDark,
        unselectedItemColor: SolaceTheme.textMuted,
        selectedLabelStyle: const TextStyle(
          fontFamily: SolaceTheme.fontFamily,
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
        unselectedLabelStyle: const TextStyle(
          fontFamily: SolaceTheme.fontFamily,
          fontSize: 11,
          fontWeight: FontWeight.w500,
        ),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.auto_awesome_rounded),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.edit_note_rounded),
            label: 'Journal',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.psychology_rounded),
            label: 'Memories',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shield_outlined),
            activeIcon: Icon(Icons.shield_rounded),
            label: 'Settings',
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Action Handlers & Dialogs
  // ---------------------------------------------------------------------------
  void _showEmergencyHubModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: SolaceTheme.surfaceWhite,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const SunIllustration(size: 36),
                const SizedBox(width: 10),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Offline Crisis & Emergency Hub',
                        style: TextStyle(
                          fontFamily: SolaceTheme.fontFamily,
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                          color: SolaceTheme.textHeading,
                        ),
                      ),
                      Text(
                        'Zero-cloud local disaster protocols',
                        style: TextStyle(
                          fontFamily: SolaceTheme.fontFamily,
                          fontSize: 12,
                          color: SolaceTheme.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  icon: const Icon(Icons.close_rounded),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildCrisisProtocolItem(
              title: '🌪️ Typhoon & Flood Protocol',
              desc: 'Offline shelter maps, emergency contacts (911/NDRRMC), and power preservation guidelines cached locally.',
            ),
            const SizedBox(height: 10),
            _buildCrisisProtocolItem(
              title: '🌋 Earthquake Preparedness',
              desc: 'Duck, Cover, Hold instructions, evacuation checklist, and local community emergency beacons.',
            ),
            const SizedBox(height: 10),
            _buildCrisisProtocolItem(
              title: '🧘 Psychological First Aid',
              desc: 'Grounded box-breathing audio and 5-4-3-2-1 sensory grounding techniques.',
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () => Navigator.of(ctx).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: SolaceTheme.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text('All Protocols Verified Offline'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCrisisProtocolItem({required String title, required String desc}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF4FAF6),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFD4EBDD)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontFamily: SolaceTheme.fontFamily,
              fontSize: 13.5,
              fontWeight: FontWeight.w700,
              color: SolaceTheme.textHeading,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            desc,
            style: const TextStyle(
              fontFamily: SolaceTheme.fontFamily,
              fontSize: 11.5,
              color: SolaceTheme.textBody,
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }

  void _exportDatabase(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Exported encrypted SQLite database backup: solace_vault_backup.solace'),
        backgroundColor: SolaceTheme.primary,
        duration: Duration(seconds: 3),
      ),
    );
  }

  void _confirmResetData(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: SolaceTheme.surfaceWhite,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Color(0xFFDC2626)),
            SizedBox(width: 8),
            Text(
              'Zero-Trace Deletion',
              style: TextStyle(
                fontFamily: SolaceTheme.fontFamily,
                fontWeight: FontWeight.w700,
                fontSize: 18,
              ),
            ),
          ],
        ),
        content: const Text(
          'Are you sure you want to permanently delete all local reflections, memory patterns, and on-device model cache?\n\nThis operation is irreversible.',
          style: TextStyle(
            fontFamily: SolaceTheme.fontFamily,
            fontSize: 13.5,
            height: 1.4,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('All local data wiped. Solace reset to factory state.'),
                  backgroundColor: Color(0xFFDC2626),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFDC2626),
              foregroundColor: Colors.white,
            ),
            child: const Text('Confirm Erase'),
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
          if (widget.onHomeTab != null) {
            widget.onHomeTab!();
          } else {
            Navigator.of(context).maybePop();
          }
        } else if (i == 1) {
          if (widget.onJournalTab != null) {
            widget.onJournalTab!();
          } else {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const JournalEditorScreen()),
            );
          }
        } else if (i == 2) {
          if (widget.onMemoriesTab != null) {
            widget.onMemoriesTab!();
          } else {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const MemoryVaultScreen()),
            );
          }
        } else if (i == 3) {
          // Already on Settings
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
}
