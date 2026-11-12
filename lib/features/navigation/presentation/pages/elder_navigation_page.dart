import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/widgets/app_brand.dart';
import '../../../account_linking/presentation/pages/elder_account_linking_page.dart';
import '../../../medication/presentation/pages/elder_medication_reminder_page.dart';
import '../../../medication/data/services/medication_notification_service.dart';
import '../../../location/presentation/providers/elder_location_providers.dart';
import '../../../profile/presentation/pages/settings_page.dart';
import '../../../care/presentation/pages/elder_care_page.dart';
import '../../../home/presentation/pages/elder_home_page.dart';
import '../../../sos/data/services/fall_detection_service.dart';
import '../../../sos/domain/entities/sos_alert.dart';
import '../../../sos/presentation/pages/elder_sos_countdown_page.dart';
import '../../../sos/presentation/widgets/fall_confirmation_dialog.dart';

class ElderNavigationPage extends ConsumerStatefulWidget {
  const ElderNavigationPage({super.key, this.userId});

  final String? userId;

  @override
  ConsumerState<ElderNavigationPage> createState() =>
      _ElderNavigationPageState();
}

class _ElderNavigationPageState extends ConsumerState<ElderNavigationPage>
    with WidgetsBindingObserver {
  int _index = 0;
  CareTab _careTab = CareTab.medication;
  StreamSubscription<String>? _reminderOpenedSubscription;
  Timer? _locationTimer;
  final FallDetectionService _fallDetectionService = FallDetectionService();
  bool _fallDialogOpen = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    final notifications = MedicationNotificationService.instance;
    _reminderOpenedSubscription = notifications.reminderOpened.listen(
      (_) => _openMedicationReminder(),
    );
    if (notifications.consumePendingOpen()) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _openMedicationReminder();
      });
    }
    WidgetsBinding.instance.addPostFrameCallback((_) => _publishLocation());
    _locationTimer = Timer.periodic(
      const Duration(minutes: 5),
      (_) => _publishLocation(),
    );
    _fallDetectionService.start(onFallDetected: _handlePossibleFall);
  }

  Future<void> _handlePossibleFall() async {
    final elderId = widget.userId;
    if (!mounted || _fallDialogOpen || elderId == null || elderId.isEmpty) {
      return;
    }
    _fallDialogOpen = true;
    final shouldSend = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const FallConfirmationDialog(),
    );
    _fallDialogOpen = false;
    if (!mounted || shouldSend != true) return;
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => ElderSosCountdownPage(
          elderId: elderId,
          triggerMethod: SosTriggerMethod.shake,
        ),
      ),
    );
  }

  Future<void> _publishLocation() async {
    final userId = widget.userId;
    if (userId == null || userId.isEmpty) return;
    try {
      await publishCurrentElderLocation(ref, userId);
    } catch (_) {
      // Keep the Elder home usable when offline or before rules are deployed.
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) _publishLocation();
  }

  void _openMedicationReminder() {
    if (!mounted) return;
    Navigator.of(context).push(
      MaterialPageRoute<void>(
                    builder: (_) => const ElderMedicationReminderPage(),
      ),
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _locationTimer?.cancel();
    _reminderOpenedSubscription?.cancel();
    _fallDetectionService.dispose();
    super.dispose();
  }

  void _openCare(CareTab tab) {
    setState(() {
      _careTab = tab;
      _index = 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 82,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        shape: const Border(bottom: BorderSide(color: AppColors.border)),
        titleSpacing: 20,
        title: const AppBrand(compact: true),
      ),
      body: IndexedStack(
        index: _index,
        children: [
          ElderHomePage(
            userId: widget.userId,
            onViewMedication: _openMedicationReminder,
            onOpenMedication: () => _openCare(CareTab.medication),
            onOpenHealth: () => _openCare(CareTab.healthJournal),
          ),
          ElderCarePage(initialTab: _careTab),
          ElderAccountLinkingPage(elderId: widget.userId),
          SettingsPage(userId: widget.userId),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        height: 82,
        selectedIndex: _index,
        onDestinationSelected: (value) => setState(() => _index = value),
        indicatorColor: AppColors.primary,
        labelTextStyle: WidgetStateProperty.resolveWith(
          (states) => TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: states.contains(WidgetState.selected)
                ? AppColors.primary
                : AppColors.textMuted,
          ),
        ),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home, color: Colors.white),
            label: 'Trang chủ',
          ),
          NavigationDestination(
            icon: Icon(Icons.health_and_safety_outlined),
            selectedIcon: Icon(Icons.health_and_safety, color: Colors.white),
            label: 'Sức khỏe',
          ),
          NavigationDestination(
            icon: Icon(Icons.contact_phone_outlined),
            selectedIcon: Icon(Icons.contact_phone, color: Colors.white),
            label: 'Liên hệ',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings, color: Colors.white),
            label: 'Cài đặt',
          ),
        ],
      ),
    );
  }
}
