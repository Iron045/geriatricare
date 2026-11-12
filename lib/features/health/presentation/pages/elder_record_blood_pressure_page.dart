import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/widgets/app_brand.dart';
import '../../../../core/widgets/app_error_dialog.dart';
import '../../../authentication/presentation/providers/auth_providers.dart';
import '../../domain/entities/blood_pressure_status.dart';
import '../../domain/entities/health_record.dart';
import '../providers/health_providers.dart';

class ElderRecordBloodPressurePage extends ConsumerStatefulWidget {
  const ElderRecordBloodPressurePage({super.key});

  @override
  ConsumerState<ElderRecordBloodPressurePage> createState() =>
      _ElderRecordBloodPressurePageState();
}

class _ElderRecordBloodPressurePageState
    extends ConsumerState<ElderRecordBloodPressurePage> {
  int systolic = 120;
  int diastolic = 80;
  bool loading = false;

  BloodPressureStatus get status => classifyBloodPressure(systolic, diastolic);

  Future<void> handleStatusCta() async {
    if (status.code == BloodPressureStatusCode.optimal) {
      await save();
      return;
    }
    if (status.code == BloodPressureStatusCode.normal) {
      await save();
      return;
    }
    if (status.isUrgent) {
      if (!mounted) return;
      await showDialog<void>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          icon: const Icon(
            Icons.emergency_rounded,
            color: AppColors.danger,
            size: 48,
          ),
          title: const Text('Hướng dẫn khẩn cấp'),
          content: const Text(
            'Ngồi nghỉ và đo lại ngay. Nếu có đau ngực, khó thở, yếu hoặc tê, thay đổi thị lực hay khó nói, hãy gọi cấp cứu 115.',
          ),
          actions: [
            FilledButton(
              onPressed: () => Navigator.pop(dialogContext),
              style: FilledButton.styleFrom(backgroundColor: AppColors.danger),
              child: const Text('Đã hiểu'),
            ),
          ],
        ),
      );
      return;
    }
    _resetMeasurements();
  }

  void _resetMeasurements() {
    FocusManager.instance.primaryFocus?.unfocus();
    setState(() {
      systolic = 120;
      diastolic = 80;
    });
  }

  Future<void> save() async {
    if (systolic <= diastolic) {
      await showAppErrorDialog(
        context,
        message: 'Tâm thu phải lớn hơn tâm trương.',
      );
      return;
    }
    final userId = ref.read(authRepositoryProvider).currentUserId;
    if (userId == null) return;
    setState(() => loading = true);
    try {
      await ref.read(saveHealthRecordProvider)(
        HealthRecord(
          id: '',
          elderUserId: userId,
          systolic: systolic,
          diastolic: diastolic,
          recordedAt: DateTime.now(),
        ),
      );
      if (!mounted) return;
      await showAppMessageDialog(
        context,
        message: 'Đã lưu kết quả huyết áp lên Firebase.',
        type: AppMessageType.success,
      );
      if (!mounted) return;
      Navigator.pop(context);
    } catch (error) {
      if (mounted) {
        await showAppErrorDialog(
          context,
          title: 'Không thể lưu huyết áp',
          message: error,
        );
      }
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      toolbarHeight: 82,
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      shape: const Border(bottom: BorderSide(color: AppColors.border)),
      titleSpacing: 0,
      title: const AppBrand(compact: true),
    ),
    body: SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(28),
        children: [
          const Row(
            children: [
              Icon(Icons.favorite, color: AppColors.primary, size: 38),
              SizedBox(width: 14),
              Text(
                'Ghi huyết áp',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800),
              ),
            ],
          ),
          const SizedBox(height: 26),
          _Counter(
            label: 'Tâm thu (Số trên)',
            value: systolic,
            minimum: 70,
            maximum: 250,
            onChanged: (value) => setState(() => systolic = value),
          ),
          const SizedBox(height: 28),
          _Counter(
            label: 'Tâm trương (Số dưới)',
            value: diastolic,
            minimum: 40,
            maximum: 150,
            onChanged: (value) => setState(() => diastolic = value),
          ),
          const SizedBox(height: 28),
          AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: status.backgroundColor,
              borderRadius: BorderRadius.circular(16),
              border: Border(left: BorderSide(color: status.uiColor, width: 8)),
            ),
            child: Row(
              children: [
                Icon(status.icon, color: status.uiColor, size: 46),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: '${status.title}\n',
                              style: TextStyle(
                                color: status.uiColor,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            TextSpan(text: status.message),
                          ],
                        ),
                        style: const TextStyle(fontSize: 19, height: 1.4),
                      ),
                      const SizedBox(height: 12),
                      OutlinedButton.icon(
                        onPressed: loading ? null : handleStatusCta,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: status.uiColor,
                        ),
                        icon: Icon(status.ctaIcon),
                        label: Text(status.ctaLabel),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 34),
          FilledButton.icon(
            onPressed: loading ? null : save,
            icon: loading
                ? const SizedBox.square(
                    dimension: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Icon(Icons.save),
            label: const Text('LƯU KẾT QUẢ'),
          ),
          const SizedBox(height: 14),
          OutlinedButton(
            onPressed: loading ? null : () => Navigator.pop(context),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size.fromHeight(58),
            ),
            child: const Text('Hủy', style: TextStyle(fontSize: 20)),
          ),
        ],
      ),
    ),
  );
}

class _Counter extends StatefulWidget {
  const _Counter({
    required this.label,
    required this.value,
    required this.minimum,
    required this.maximum,
    required this.onChanged,
  });
  final String label;
  final int value;
  final int minimum;
  final int maximum;
  final ValueChanged<int> onChanged;

  @override
  State<_Counter> createState() => _CounterState();
}

class _CounterState extends State<_Counter> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value.toString());
  }

  @override
  void didUpdateWidget(covariant _Counter oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value &&
        _controller.text != widget.value.toString()) {
      _controller.value = TextEditingValue(
        text: widget.value.toString(),
        selection: TextSelection.collapsed(
          offset: widget.value.toString().length,
        ),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _changeBy(int amount) {
    final next = (widget.value + amount).clamp(widget.minimum, widget.maximum);
    widget.onChanged(next);
  }

  void _handleInput(String text) {
    final value = int.tryParse(text);
    if (value != null && value >= widget.minimum && value <= widget.maximum) {
      widget.onChanged(value);
    }
  }

  void _restoreValidValue() {
    final enteredValue = int.tryParse(_controller.text);
    final validValue = enteredValue == null
        ? widget.value
        : enteredValue.clamp(widget.minimum, widget.maximum) as int;
    if (validValue != widget.value) widget.onChanged(validValue);
    if (_controller.text != validValue.toString()) {
      _controller.text = validValue.toString();
      _controller.selection = TextSelection.collapsed(
        offset: _controller.text.length,
      );
    }
  }

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        widget.label,
        style: const TextStyle(fontSize: 23, fontWeight: FontWeight.w700),
      ),
      const SizedBox(height: 12),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 24),
        decoration: BoxDecoration(
          color: AppColors.surfaceMuted,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton.filledTonal(
              onPressed: widget.value > widget.minimum
                  ? () => _changeBy(-1)
                  : null,
              icon: const Icon(Icons.remove, size: 36),
            ),
            SizedBox(
              width: 126,
              child: Column(
                children: [
                  TextField(
                    controller: _controller,
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(3),
                    ],
                    style: const TextStyle(
                      fontSize: 48,
                      color: AppColors.primary,
                      fontWeight: FontWeight.w800,
                    ),
                    decoration: const InputDecoration(
                      isDense: true,
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                    ),
                    onChanged: _handleInput,
                    onEditingComplete: () {
                      _restoreValidValue();
                      FocusScope.of(context).unfocus();
                    },
                    onTapOutside: (_) {
                      _restoreValidValue();
                      FocusScope.of(context).unfocus();
                    },
                  ),
                  const Text('mmHg', style: TextStyle(fontSize: 21)),
                ],
              ),
            ),
            IconButton.filledTonal(
              onPressed: widget.value < widget.maximum
                  ? () => _changeBy(1)
                  : null,
              icon: const Icon(Icons.add, size: 36),
            ),
          ],
        ),
      ),
    ],
  );
}

extension on BloodPressureStatus {
  Color get uiColor => switch (code) {
    BloodPressureStatusCode.optimal => AppColors.success,
    BloodPressureStatusCode.normal => const Color(0xFF14A86B),
    BloodPressureStatusCode.low ||
    BloodPressureStatusCode.rising => const Color(0xFFE39A00),
    BloodPressureStatusCode.high ||
    BloodPressureStatusCode.crisis => AppColors.danger,
  };

  Color get backgroundColor => uiColor.withValues(alpha: .12);

  IconData get icon => switch (code) {
    BloodPressureStatusCode.optimal => Icons.check_circle,
    BloodPressureStatusCode.normal => Icons.monitor_heart_rounded,
    BloodPressureStatusCode.low => Icons.south_rounded,
    BloodPressureStatusCode.rising => Icons.trending_up_rounded,
    BloodPressureStatusCode.high => Icons.warning_rounded,
    BloodPressureStatusCode.crisis => Icons.emergency_rounded,
  };

  IconData get ctaIcon => switch (code) {
    BloodPressureStatusCode.optimal => Icons.save_rounded,
    BloodPressureStatusCode.normal => Icons.show_chart_rounded,
    BloodPressureStatusCode.crisis => Icons.emergency_rounded,
    _ => Icons.refresh_rounded,
  };
}
