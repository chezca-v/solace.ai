import 'package:flutter/material.dart';
import '../../../models/memory_item.dart';
import '../../../services/memory_service.dart';
import '../../theme/solace_theme.dart';
import '../journal/journal_editor_screen.dart';
import '../settings/settings_screen.dart';

/// 11 — Personal Memory Vault Screen
class MemoryVaultScreen extends StatefulWidget {
  final VoidCallback? onBack;
  final VoidCallback? onHomeTab;
  final VoidCallback? onJournalTab;
  final VoidCallback? onSettingsTab;

  const MemoryVaultScreen({
    super.key,
    this.onBack,
    this.onHomeTab,
    this.onJournalTab,
    this.onSettingsTab,
  });

  @override
  State<MemoryVaultScreen> createState() => _MemoryVaultScreenState();
}

class _MemoryVaultScreenState extends State<MemoryVaultScreen> {
  final _memoryService = MemoryService.instance;
  int _selectedFilter = 0; // 0: All, 1: Priorities (3), 2: Life Context (2), 3: Recurring Themes
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _memoryService.addListener(_onServiceChanged);
  }

  void _onServiceChanged() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _memoryService.removeListener(_onServiceChanged);
    _searchController.dispose();
    super.dispose();
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
                _buildTopBar(),

                // Scrollable Content
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title & Vault Badge
                        _buildTitleSection(),
                        const SizedBox(height: 12),

                        // Zero Leakage Status Card
                        _buildStatusCard(),
                        const SizedBox(height: 14),

                        // Search Bar
                        _buildSearchBar(),
                        const SizedBox(height: 12),

                        // Filter Chips
                        _buildFilterChips(),
                        const SizedBox(height: 16),

                        // List of Memory Cards
                        _buildMemoryList(),
                        const SizedBox(height: 16),

                        // Add Custom Rule Button
                        _buildAddButton(context),
                        const SizedBox(height: 16),

                        // Solace Never Assumes Educational Card
                        _buildEducationalCard(),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 30,
                height: 30,
                decoration: const BoxDecoration(
                  color: Color(0xFFE8F7EE),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.wb_sunny_rounded,
                    size: 17, color: Color(0xFF2E8B62)),
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
          Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFE5F6EC),
                  borderRadius: BorderRadius.circular(12),
                  border:
                      Border.all(color: const Color(0xFFCEECD9), width: 0.8),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircleAvatar(
                        radius: 2.5, backgroundColor: SolaceTheme.primary),
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
              Container(
                width: 32,
                height: 32,
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
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: SolaceTheme.primaryDark,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTitleSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Expanded(
              child: Text(
                'Personal Memory Vault',
                style: TextStyle(
                  fontFamily: SolaceTheme.fontFamily,
                  fontSize: 21,
                  fontWeight: FontWeight.w800,
                  color: SolaceTheme.textHeading,
                  letterSpacing: -0.4,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: const Color(0xFFE8F6EE),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Row(
                children: [
                  Icon(Icons.lock_rounded,
                      size: 11, color: SolaceTheme.primaryDark),
                  SizedBox(width: 4),
                  Text(
                    'Local Vault',
                    style: TextStyle(
                      fontFamily: SolaceTheme.fontFamily,
                      fontSize: 10.5,
                      fontWeight: FontWeight.w700,
                      color: SolaceTheme.primaryDark,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        const Text(
          'Context you have permitted Solace to remember. Everything stays encrypted on this phone.',
          style: TextStyle(
            fontFamily: SolaceTheme.fontFamily,
            fontSize: 12.5,
            color: SolaceTheme.textBody,
            height: 1.35,
          ),
        ),
      ],
    );
  }

  Widget _buildStatusCard() {
    return ListenableBuilder(
      listenable: _memoryService,
      builder: (context, _) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: const Color(0xFFEAF6EE),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFD4EBDD)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    const Icon(Icons.shield_outlined,
                        size: 16, color: SolaceTheme.primaryDark),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '${_memoryService.activeCount} Active Memories • 0 Cloud Sync',
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontFamily: SolaceTheme.fontFamily,
                          fontSize: 11.5,
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
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.circle, size: 6, color: Color(0xFF10B981)),
                  SizedBox(width: 4),
                  Text(
                    'ZERO LEAKAGE',
                    style: TextStyle(
                      fontFamily: SolaceTheme.fontFamily,
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.4,
                      color: Color(0xFF166E49),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: SolaceTheme.surfaceWhite,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: SolaceTheme.cardBorder),
      ),
      child: TextField(
        controller: _searchController,
        style: const TextStyle(
          fontFamily: SolaceTheme.fontFamily,
          fontSize: 13,
          color: SolaceTheme.textHeading,
        ),
        decoration: const InputDecoration(
          hintText: 'Search your memories and stated priorities...',
          hintStyle: TextStyle(
            fontFamily: SolaceTheme.fontFamily,
            fontSize: 12.5,
            color: SolaceTheme.textMuted,
          ),
          prefixIcon: Icon(Icons.search_rounded,
              size: 18, color: SolaceTheme.textMuted),
          border: InputBorder.none,
          isDense: true,
          contentPadding: EdgeInsets.symmetric(vertical: 11),
        ),
        onChanged: (_) => setState(() {}),
      ),
    );
  }

  Widget _buildFilterChips() {
    return ListenableBuilder(
      listenable: _memoryService,
      builder: (context, _) {
        final all = _memoryService.memories;
        final priorities = all.where((m) => m.category.contains('PRIORITY')).length;
        final contextCount = all.where((m) => m.category.contains('CONTEXT') || m.category.contains('VALUE')).length;
        final themes = all.where((m) => m.category.contains('THEME') || m.category.contains('RULE')).length;

        final filters = [
          'All (${all.length})',
          'Priorities ($priorities)',
          'Life Context ($contextCount)',
          'Themes ($themes)',
        ];

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(filters.length, (i) {
              final isSelected = _selectedFilter == i;
              return Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: InkWell(
                  onTap: () => setState(() => _selectedFilter = i),
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? SolaceTheme.primary
                          : SolaceTheme.surfaceWhite,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected
                            ? SolaceTheme.primary
                            : SolaceTheme.cardBorder,
                      ),
                    ),
                    child: Text(
                      filters[i],
                      style: TextStyle(
                        fontFamily: SolaceTheme.fontFamily,
                        fontSize: 11.5,
                        fontWeight:
                            isSelected ? FontWeight.w700 : FontWeight.w500,
                        color: isSelected ? Colors.white : SolaceTheme.textHeading,
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        );
      },
    );
  }

  Widget _buildMemoryList() {
    return ListenableBuilder(
      listenable: _memoryService,
      builder: (context, _) {
        final query = _searchController.text.trim().toLowerCase();
        var memories = _memoryService.memories;

        if (_selectedFilter == 1) {
          memories = memories.where((m) => m.category.contains('PRIORITY')).toList();
        } else if (_selectedFilter == 2) {
          memories = memories.where((m) => m.category.contains('CONTEXT') || m.category.contains('VALUE')).toList();
        } else if (_selectedFilter == 3) {
          memories = memories.where((m) => m.category.contains('THEME') || m.category.contains('RULE')).toList();
        }

        if (query.isNotEmpty) {
          memories = memories.where((m) {
            return m.title.toLowerCase().contains(query) ||
                m.quoteOrDescription.toLowerCase().contains(query) ||
                m.category.toLowerCase().contains(query);
          }).toList();
        }

        if (memories.isEmpty) {
          return Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
            decoration: BoxDecoration(
              color: SolaceTheme.surfaceWhite,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: SolaceTheme.cardBorder),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: const BoxDecoration(
                    color: Color(0xFFE8F6EE),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.psychology_outlined,
                      size: 22, color: SolaceTheme.primaryDark),
                ),
                const SizedBox(height: 12),
                const Text(
                  'No memories in this view',
                  style: TextStyle(
                    fontFamily: SolaceTheme.fontFamily,
                    fontSize: 14.5,
                    fontWeight: FontWeight.w700,
                    color: SolaceTheme.textHeading,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Insights and core priorities will appear here once saved from your journal reflections or added manually.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: SolaceTheme.fontFamily,
                    fontSize: 12,
                    color: SolaceTheme.textMuted,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          );
        }

        return Column(
          children: memories.map((item) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: _buildMemoryCard(item),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildMemoryCard(MemoryItem item) {
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
          // Category Tag + Subcategory + Toggle Switch
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Container(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 7, vertical: 2.5),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8F6EE),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        item.category,
                        style: const TextStyle(
                          fontFamily: SolaceTheme.fontFamily,
                          fontSize: 9.5,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.4,
                          color: SolaceTheme.primaryDark,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        item.subcategory,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontFamily: SolaceTheme.fontFamily,
                          fontSize: 11,
                          color: SolaceTheme.textMuted,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Transform.scale(
                scale: 0.75,
                child: Switch(
                  value: item.isActive,
                  activeColor: SolaceTheme.primary,
                  onChanged: (_) {
                    _memoryService.toggleMemory(item.id);
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),

          // Title
          Text(
            item.title,
            style: const TextStyle(
              fontFamily: SolaceTheme.fontFamily,
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: SolaceTheme.textHeading,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            'Stated in: ${item.source}',
            style: const TextStyle(
              fontFamily: SolaceTheme.fontFamily,
              fontSize: 11.5,
              fontStyle: FontStyle.italic,
              color: SolaceTheme.textMuted,
            ),
          ),
          const SizedBox(height: 10),

          // Quote / Description Box
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF7FAF8),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFEAF0EC)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (item.isQuote)
                  const Text(
                    '“ ',
                    style: TextStyle(
                      fontFamily: SolaceTheme.fontFamily,
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: SolaceTheme.primaryDark,
                    ),
                  )
                else
                  const Padding(
                    padding: EdgeInsets.only(right: 6.0, top: 1),
                    child: Icon(Icons.school_outlined,
                        size: 16, color: SolaceTheme.primaryDark),
                  ),
                Expanded(
                  child: Text(
                    item.quoteOrDescription,
                    style: TextStyle(
                      fontFamily: SolaceTheme.fontFamily,
                      fontSize: 12.5,
                      fontStyle:
                          item.isQuote ? FontStyle.italic : FontStyle.normal,
                      color: SolaceTheme.textBody,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Bottom Action Controls
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    const Icon(Icons.circle,
                        size: 6, color: Color(0xFF10B981)),
                    const SizedBox(width: 5),
                    Expanded(
                      child: Text(
                        item.category == 'HIGH PRIORITY'
                            ? 'Active for AI Decision Support'
                            : 'Active',
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontFamily: SolaceTheme.fontFamily,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: SolaceTheme.primaryDark,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Edit memory...')),
                      );
                    },
                    icon: const Icon(Icons.edit_outlined,
                        size: 16, color: SolaceTheme.textMuted),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                  const SizedBox(width: 14),
                  IconButton(
                    onPressed: () {
                      _memoryService.toggleMemory(item.id);
                    },
                    icon: const Icon(Icons.visibility_off_outlined,
                        size: 16, color: SolaceTheme.textMuted),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                  const SizedBox(width: 14),
                  IconButton(
                    onPressed: () {
                      _memoryService.deleteMemory(item.id);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Memory deleted.')),
                      );
                    },
                    icon: const Icon(Icons.delete_outline_rounded,
                        size: 16, color: SolaceTheme.textMuted),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAddButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton.icon(
        onPressed: () => _showAddCustomRuleSheet(context),
        icon: const Icon(Icons.add_rounded, size: 18, color: Colors.white),
        label: const Text(
          'Add Custom Rule or Priority',
          style: TextStyle(
            fontFamily: SolaceTheme.fontFamily,
            fontSize: 14.5,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: SolaceTheme.primary,
          elevation: 0,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24)),
        ),
      ),
    );
  }

  Widget _buildEducationalCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F6EE),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFD4EBDD)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: const BoxDecoration(
              color: Color(0xFFD4EBDD),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.eco_rounded,
                size: 16, color: SolaceTheme.primaryDark),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Solace never assumes.',
                  style: TextStyle(
                    fontFamily: SolaceTheme.fontFamily,
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                    color: SolaceTheme.textHeading,
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  'Memories are only formed when you explicitly tap "Save insight to memories" after a reflection. You retain full authority to redact, pause, or wipe them anytime.',
                  style: TextStyle(
                    fontFamily: SolaceTheme.fontFamily,
                    fontSize: 11.5,
                    color: SolaceTheme.textBody,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showAddCustomRuleSheet(BuildContext context) {
    final titleCtrl = TextEditingController();
    final contentCtrl = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: SolaceTheme.surfaceWhite,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.fromLTRB(
            20, 20, 20, MediaQuery.of(ctx).viewInsets.bottom + 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Add Custom Memory Rule',
              style: TextStyle(
                fontFamily: SolaceTheme.fontFamily,
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: SolaceTheme.textHeading,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: titleCtrl,
              decoration: InputDecoration(
                labelText: 'Rule Title (e.g. Sleep & Rest Priority)',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: contentCtrl,
              maxLines: 2,
              decoration: InputDecoration(
                labelText: 'Guideline / Rule Content',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  if (titleCtrl.text.trim().isNotEmpty) {
                    _memoryService.addMemory(
                      MemoryItem(
                        id: DateTime.now().millisecondsSinceEpoch.toString(),
                        title: titleCtrl.text.trim(),
                        quoteOrDescription: contentCtrl.text.trim(),
                        source: 'User-defined custom vault rule',
                        category: 'CUSTOM RULE',
                        subcategory: 'Custom',
                        createdAt: DateTime.now(),
                      ),
                    );
                    Navigator.of(ctx).pop();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: SolaceTheme.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24)),
                ),
                child: const Text('Save to Memory Vault'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNav() {
    return NavigationBar(
      selectedIndex: 2, // Memories tab is index 2
      onDestinationSelected: (i) {
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
          // Already on Memories
        } else if (i == 3) {
          if (widget.onSettingsTab != null) {
            widget.onSettingsTab!();
          } else {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const SettingsScreen()),
            );
          }
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
