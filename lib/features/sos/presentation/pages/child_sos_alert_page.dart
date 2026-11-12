import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/widgets/app_error_dialog.dart';
import '../../domain/entities/sos_alert.dart';
import '../providers/sos_providers.dart';

class ChildSosAlertPage extends ConsumerStatefulWidget {
  const ChildSosAlertPage({
    super.key,
    required this.alert,
    required this.childId,
    required this.elderDisplayName,
    this.elderPhone,
  });

  final SosAlert alert;
  final String childId;
  final String elderDisplayName;
  final String? elderPhone;

  @override
  ConsumerState<ChildSosAlertPage> createState() => _ChildSosAlertPageState();
}

class _ChildSosAlertPageState extends ConsumerState<ChildSosAlertPage> {
  bool _acknowledging = false;
  bool _closingScheduled = false;

  Future<void> _acknowledge() async {
    if (_acknowledging) return;
    setState(() => _acknowledging = true);
    try {
      await ref
          .read(sosRepositoryProvider)
          .acknowledgeAlert(alertId: widget.alert.id, childId: widget.childId);
    } catch (error) {
      if (mounted) {
        await showAppErrorDialog(
          context,
          title: 'Không thể tiếp nhận cảnh báo',
          message: error,
        );
      }
    } finally {
      if (mounted) setState(() => _acknowledging = false);
    }
  }

  Future<void> _copyPhone() async {
    final phone = widget.elderPhone?.trim();
    if (phone == null || phone.isEmpty) {
      await showAppMessageDialog(
        context,
        message: 'Người thân chưa có số điện thoại.',
        type: AppMessageType.warning,
      );
      return;
    }
    final phoneUri = Uri(scheme: 'tel', path: phone);
    if (await launchUrl(phoneUri, mode: LaunchMode.externalApplication)) return;
    if (mounted) {
      await showAppErrorDialog(
        context,
        title: 'Không thể mở trình quay số',
        message: 'Thiết bị không có ứng dụng gọi điện phù hợp.',
      );
    }
  }

  Future<void> _markEnRoute() => _runUpdate(
    () => ref
        .read(sosRepositoryProvider)
        .markEnRoute(alertId: widget.alert.id, childId: widget.childId),
  );

  Future<void> _markArrived() => _runUpdate(
    () => ref
        .read(sosRepositoryProvider)
        .markArrived(alertId: widget.alert.id, childId: widget.childId),
  );

  Future<void> _resolve() async {
    final noteController = TextEditingController();
    var outcome = 'safe';
    final accepted = await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Kết thúc cảnh báo SOS'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                initialValue: outcome,
                decoration: const InputDecoration(labelText: 'Kết quả hỗ trợ'),
                items: const [
                  DropdownMenuItem(value: 'safe', child: Text('Đã an toàn')),
                  DropdownMenuItem(
                    value: 'hospitalized',
                    child: Text('Đã đưa đến cơ sở y tế'),
                  ),
                  DropdownMenuItem(
                    value: 'false_alarm',
                    child: Text('Báo động nhầm'),
                  ),
                ],
                onChanged: (value) =>
                    setDialogState(() => outcome = value ?? outcome),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: noteController,
                maxLength: 300,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Ghi chú (không bắt buộc)',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Đóng'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text('Hoàn tất'),
            ),
          ],
        ),
      ),
    );
    final note = noteController.text;
    noteController.dispose();
    if (accepted != true) return;
    await _runUpdate(
      () => ref
          .read(sosRepositoryProvider)
          .resolveAlert(
            alertId: widget.alert.id,
            userId: widget.childId,
            resolutionType: outcome,
            note: note,
          ),
    );
  }

  Future<void> _runUpdate(Future<void> Function() action) async {
    if (_acknowledging) return;
    setState(() => _acknowledging = true);
    try {
      await action();
    } catch (error) {
      if (mounted) {
        await showAppErrorDialog(
          context,
          title: 'Không thể cập nhật SOS',
          message: error,
        );
      }
    } finally {
      if (mounted) setState(() => _acknowledging = false);
    }
  }

  Future<void> _openLocation(SosAlert alert) async {
    final latitude = alert.latitude;
    final longitude = alert.longitude;
    if (latitude == null || longitude == null) return;
    final uri = Uri.https('www.google.com', '/maps/search/', {
      'api': '1',
      'query': '$latitude,$longitude',
    });
    if (await launchUrl(uri, mode: LaunchMode.externalApplication)) return;
    await Clipboard.setData(ClipboardData(text: uri.toString()));
    if (mounted) {
      await showAppMessageDialog(
        context,
        message: 'Đã sao chép liên kết vị trí.',
        type: AppMessageType.success,
      );
    }
  }

  void _closeWhenElderEnds(SosStatus status) {
    if (_closingScheduled ||
        (status != SosStatus.cancelled && status != SosStatus.resolved)) {
      return;
    }
    _closingScheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      await showAppMessageDialog(
        context,
        message: 'Cảnh báo SOS đã được kết thúc.',
      );
      if (mounted) Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    final liveAlert =
        ref.watch(sosAlertProvider(widget.alert.id)).asData?.value ??
        widget.alert;
    _closeWhenElderEnds(liveAlert.status);
    final acknowledged =
        liveAlert.status != SosStatus.active && liveAlert.status.isOngoing;
    final isResponder = liveAlert.acknowledgedById == widget.childId;
    final color = acknowledged ? AppColors.success : AppColors.danger;

    return PopScope(
      canPop: true,
      child: Scaffold(
        backgroundColor: color,
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final compact = constraints.maxHeight < 720;
              final horizontalPadding = constraints.maxWidth < 360
                  ? 14.0
                  : 24.0;
              final illustrationSize = (constraints.maxWidth * .5).clamp(
                130.0,
                compact ? 175.0 : 220.0,
              );
              return SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(
                  horizontalPadding,
                  compact ? 14 : 28,
                  horizontalPadding,
                  20,
                ),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight - (compact ? 34 : 52),
                  ),
                  child: IntrinsicHeight(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Align(
                          alignment: Alignment.topRight,
                          child: IconButton.filledTonal(
                            tooltip: 'Đóng giao diện',
                            onPressed: () => Navigator.pop(context),
                            style: IconButton.styleFrom(
                              backgroundColor: Colors.white.withValues(
                                alpha: .18,
                              ),
                              foregroundColor: Colors.white,
                            ),
                            icon: const Icon(Icons.close_rounded),
                          ),
                        ),
                        Icon(
                          acknowledged
                              ? Icons.verified_user_rounded
                              : Icons.emergency_rounded,
                          size: compact ? 64 : 92,
                          color: Colors.white,
                        ),
                        const SizedBox(height: 18),
                        Text(
                          acknowledged ? 'ĐÃ TIẾP NHẬN SOS' : 'CẢNH BÁO SOS',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: compact ? 28 : 38,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          acknowledged
                              ? 'Bạn đã thông báo cho người thân rằng cảnh báo đã được tiếp nhận.'
                              : '${widget.elderDisplayName} đang cần được hỗ trợ khẩn cấp!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: compact ? 19 : 23,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Spacer(),
                        Center(
                          child: SizedBox.square(
                            dimension: illustrationSize,
                            child: Container(
                              padding: EdgeInsets.all(compact ? 20 : 26),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: .16),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 5,
                                ),
                              ),
                              child: Icon(
                                Icons.notifications_active_rounded,
                                size: compact ? 82 : 126,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        const Spacer(),
                        if (liveAlert.latitude != null &&
                            liveAlert.longitude != null) ...[
                          FilledButton.icon(
                            onPressed: () => _openLocation(liveAlert),
                            style: FilledButton.styleFrom(
                              minimumSize: const Size.fromHeight(66),
                              backgroundColor: const Color(0xFFFFD54F),
                              foregroundColor: Colors.black87,
                            ),
                            icon: const Icon(Icons.location_on_rounded),
                            label: const Text('XEM VỊ TRÍ TRÊN BẢN ĐỒ'),
                          ),
                          const SizedBox(height: 14),
                        ],
                        FilledButton.icon(
                          onPressed: _copyPhone,
                          style: FilledButton.styleFrom(
                            minimumSize: const Size.fromHeight(66),
                            backgroundColor: Colors.white,
                            foregroundColor: color,
                          ),
                          icon: const Icon(Icons.phone_rounded),
                          label: Text(
                            widget.elderPhone?.trim().isNotEmpty == true
                                ? 'LIÊN HỆ ${widget.elderPhone}'
                                : 'LIÊN HỆ NGƯỜI THÂN',
                          ),
                        ),
                        const SizedBox(height: 14),
                        if (!acknowledged)
                          OutlinedButton.icon(
                            onPressed: _acknowledging ? null : _acknowledge,
                            style: OutlinedButton.styleFrom(
                              minimumSize: const Size.fromHeight(66),
                              foregroundColor: Colors.white,
                              side: const BorderSide(
                                color: Colors.white,
                                width: 3,
                              ),
                            ),
                            icon: _acknowledging
                                ? const SizedBox.square(
                                    dimension: 22,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Icon(Icons.done_all_rounded),
                            label: const Text('ĐÃ TIẾP NHẬN'),
                          )
                        else if (isResponder) ...[
                          if (liveAlert.status == SosStatus.acknowledged)
                            OutlinedButton.icon(
                              onPressed: _acknowledging ? null : _markEnRoute,
                              style: OutlinedButton.styleFrom(
                                minimumSize: const Size.fromHeight(66),
                                foregroundColor: Colors.white,
                                side: const BorderSide(
                                  color: Colors.white,
                                  width: 3,
                                ),
                              ),
                              icon: const Icon(Icons.directions_car_rounded),
                              label: const Text('TÔI ĐANG ĐẾN'),
                            ),
                          if (liveAlert.status == SosStatus.enRoute)
                            OutlinedButton.icon(
                              onPressed: _acknowledging ? null : _markArrived,
                              style: OutlinedButton.styleFrom(
                                minimumSize: const Size.fromHeight(66),
                                foregroundColor: Colors.white,
                                side: const BorderSide(
                                  color: Colors.white,
                                  width: 3,
                                ),
                              ),
                              icon: const Icon(Icons.location_on_rounded),
                              label: const Text('TÔI ĐÃ ĐẾN'),
                            ),
                          if (liveAlert.status == SosStatus.arrived)
                            OutlinedButton.icon(
                              onPressed: _acknowledging ? null : _resolve,
                              style: OutlinedButton.styleFrom(
                                minimumSize: const Size.fromHeight(66),
                                foregroundColor: Colors.white,
                                side: const BorderSide(
                                  color: Colors.white,
                                  width: 3,
                                ),
                              ),
                              icon: const Icon(Icons.task_alt_rounded),
                              label: const Text('KẾT THÚC CẢNH BÁO'),
                            ),
                        ],
                        const SizedBox(height: 12),
                        const Text(
                          'Hãy liên hệ ngay và chỉ đóng màn hình sau khi đã tiếp nhận.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white70, fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
