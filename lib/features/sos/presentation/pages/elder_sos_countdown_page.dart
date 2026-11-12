import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/widgets/app_error_dialog.dart';
import '../../data/services/sos_location_service.dart';
import '../../domain/entities/sos_alert.dart';
import '../providers/sos_providers.dart';

class ElderSosCountdownPage extends ConsumerStatefulWidget {
  const ElderSosCountdownPage({
    super.key,
    required this.elderId,
    this.triggerMethod = SosTriggerMethod.button,
  });

  final String elderId;
  final SosTriggerMethod triggerMethod;

  @override
  ConsumerState<ElderSosCountdownPage> createState() =>
      _ElderSosCountdownPageState();
}

class _ElderSosCountdownPageState extends ConsumerState<ElderSosCountdownPage> {
  String? alertId;
  bool sending = false;
  bool closing = false;
  bool locating = false;
  bool sentWithoutLocation = false;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _sendAlert();
  }

  Future<void> _sendAlert() async {
    if (sending || alertId != null) return;
    setState(() {
      sending = true;
      locating = true;
      errorMessage = null;
    });
    try {
      // Bắt đầu kiểm tra/yêu cầu quyền ngay khi bấm SOS nhưng không chặn việc
      // gửi cảnh báo nếu người dùng chưa phản hồi hoặc từ chối quyền.
      final locationFuture = SosLocationService.captureCurrentPosition();
      final id = await ref
          .read(sosRepositoryProvider)
          .sendAlert(
            SosAlert(
              id: '',
              elderUserId: widget.elderId,
              triggerMethod: widget.triggerMethod,
              status: SosStatus.active,
              triggeredAt: DateTime.now(),
            ),
          );
      if (mounted) setState(() => alertId = id);
      unawaited(_captureAndAttachLocation(id, locationFuture));
    } catch (error) {
      if (mounted) setState(() => errorMessage = error.toString());
    } finally {
      if (mounted) {
        setState(() {
          sending = false;
          if (alertId == null) locating = false;
        });
      }
    }
  }

  Future<void> _captureAndAttachLocation(
    String id,
    Future<SosLocationResult> locationFuture,
  ) async {
    try {
      final result = await locationFuture;
      final position = result.position;
      if (position != null) {
        await ref
            .read(sosRepositoryProvider)
            .updateLocation(
              alertId: id,
              latitude: position.latitude,
              longitude: position.longitude,
              accuracy: position.accuracy,
              capturedAt: position.timestamp,
            );
      }
      if (mounted) {
        setState(() {
          locating = false;
          sentWithoutLocation = position == null;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          locating = false;
          sentWithoutLocation = true;
        });
      }
    }
  }

  Future<void> _closeAlert(SosAlert? alert) async {
    if (closing) return;
    final id = alertId;
    if (id == null) {
      Navigator.pop(context);
      return;
    }
    setState(() => closing = true);
    try {
      if (alert != null && alert.status != SosStatus.active) {
        await ref
            .read(sosRepositoryProvider)
            .resolveAlert(
              alertId: id,
              userId: widget.elderId,
              resolutionType: 'safe',
              note: 'Người cao tuổi xác nhận đã an toàn.',
              includeResolutionDetails: false,
            );
      } else {
        await ref
            .read(sosRepositoryProvider)
            .cancelAlert(
              alertId: id,
              userId: widget.elderId,
              reason: 'Người cao tuổi hủy cảnh báo.',
            );
      }
      if (mounted) Navigator.pop(context);
    } catch (error) {
      if (mounted) {
        await showAppErrorDialog(
          context,
          title: 'Không thể cập nhật SOS',
          message: error,
        );
        setState(() => closing = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentAlert = alertId == null
        ? null
        : ref.watch(sosAlertProvider(alertId!)).asData?.value;
    final acknowledged =
        currentAlert != null &&
        currentAlert.status != SosStatus.active &&
        currentAlert.status.isOngoing;
    final sent = alertId != null;
    return PopScope(
      canPop: !sent || closing,
      child: Scaffold(
        backgroundColor: acknowledged ? AppColors.success : AppColors.danger,
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final compact = constraints.maxHeight < 700;
              final horizontalPadding = constraints.maxWidth < 360
                  ? 16.0
                  : 28.0;
              final illustrationSize = (constraints.maxWidth * .58).clamp(
                150.0,
                compact ? 205.0 : 260.0,
              );
              return SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(
                  horizontalPadding,
                  compact ? 12 : 28,
                  horizontalPadding,
                  20,
                ),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight - (compact ? 32 : 48),
                  ),
                  child: IntrinsicHeight(
                    child: Column(
                      children: [
                        const SizedBox(height: 18),
                        Icon(
                          acknowledged
                              ? Icons.verified_user_rounded
                              : Icons.warning_rounded,
                          color: Colors.white,
                          size: compact ? 62 : 82,
                        ),
                        Text(
                          acknowledged
                              ? 'ĐÃ CÓ NGƯỜI TIẾP NHẬN'
                              : sent
                              ? 'ĐÃ GỬI CẢNH BÁO'
                              : 'ĐANG GỬI...',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: compact ? 27 : 34,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 14),
                        Text(
                          acknowledged
                              ? 'Người thân đã xác nhận và đang liên hệ với bạn.'
                              : sent
                              ? 'Cảnh báo đã được gửi đến tài khoản con cái đã liên kết.'
                              : locating
                              ? 'Đang xác định vị trí của bạn...'
                              : 'Đang chuẩn bị gửi cảnh báo.',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                        const Spacer(),
                        Container(
                          width: illustrationSize,
                          height: illustrationSize,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withValues(alpha: .22),
                            border: Border.all(color: Colors.white, width: 5),
                          ),
                          child: Center(
                            child: sending
                                ? const CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 5,
                                  )
                                : Icon(
                                    acknowledged
                                        ? Icons.phone_in_talk_rounded
                                        : Icons.notifications_active_rounded,
                                    color: Colors.white,
                                    size: compact ? 72 : 96,
                                  ),
                          ),
                        ),
                        const Spacer(),
                        if (errorMessage != null) ...[
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Text(
                                'Không thể gửi cảnh báo: $errorMessage',
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          FilledButton.icon(
                            onPressed: sending ? null : _sendAlert,
                            icon: const Icon(Icons.refresh_rounded),
                            label: const Text('GỬI LẠI'),
                          ),
                          const SizedBox(height: 12),
                        ],
                        if (sent && sentWithoutLocation && !acknowledged) ...[
                          const Text(
                            'Cảnh báo đã gửi nhưng không kèm vị trí. Hãy bật GPS và cấp quyền vị trí cho lần sau.',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                          const SizedBox(height: 12),
                        ],
                        FilledButton.icon(
                          style: FilledButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: acknowledged
                                ? AppColors.success
                                : AppColors.danger,
                            minimumSize: const Size.fromHeight(68),
                          ),
                          onPressed: closing
                              ? null
                              : () => _closeAlert(currentAlert),
                          icon: closing
                              ? const SizedBox.square(
                                  dimension: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : Icon(
                                  acknowledged
                                      ? Icons.check_circle_rounded
                                      : Icons.cancel_outlined,
                                ),
                          label: Text(
                            acknowledged ? 'KẾT THÚC CẢNH BÁO' : 'HỦY BÁO ĐỘNG',
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          acknowledged
                              ? 'Chỉ kết thúc khi bạn đã an toàn.'
                              : 'Hủy nếu bạn bấm nhầm.',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 17,
                          ),
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
