import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/widgets/app_error_dialog.dart';
import '../../../account_linking/domain/entities/account_link_request.dart';
import '../../../account_linking/presentation/providers/account_link_providers.dart';
import '../../../authentication/domain/entities/app_user.dart';
import '../../../medical_records/domain/entities/medical_visit.dart';
import '../../../medical_records/presentation/providers/medical_record_providers.dart';
import '../../domain/entities/medical_appointment.dart';
import '../providers/appointment_providers.dart';

class FamilyCoordinationPage extends ConsumerWidget {
  const FamilyCoordinationPage({
    super.key,
    required this.user,
    required this.elderId,
  });

  final AppUser user;
  final String? elderId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final id = elderId;
    if (id == null) {
      return const _EmptyState(
        icon: Icons.family_restroom_rounded,
        message: 'Hãy liên kết với bố hoặc mẹ để cùng quản lý lịch khám.',
      );
    }
    return DefaultTabController(
      length: 2,
      child: SafeArea(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 16, 20, 6),
              child: TabBar(
                tabs: [
                  Tab(icon: Icon(Icons.event_available), text: 'Lịch khám'),
                  Tab(icon: Icon(Icons.folder_shared), text: 'Hồ sơ khám'),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _AppointmentList(elderId: id, user: user),
                  _MedicalVisitList(elderId: id, user: user),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AppointmentList extends ConsumerWidget {
  const _AppointmentList({required this.elderId, required this.user});

  final String elderId;
  final AppUser user;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appointments = ref.watch(appointmentsForElderProvider(elderId));
    final familyLinks = ref.watch(acceptedFamilyLinksProvider(elderId));
    return appointments.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => _EmptyState(
        icon: Icons.cloud_off,
        message: 'Không thể tải lịch khám: $error',
      ),
      data: (items) => Scaffold(
        backgroundColor: Colors.transparent,
        floatingActionButton: FloatingActionButton.extended(
          onPressed: familyLinks.hasValue
              ? () => _createAppointment(
                  context,
                  ref,
                  familyLinks.asData?.value ?? const <AccountLinkRequest>[],
                )
              : null,
          icon: const Icon(Icons.add),
          label: const Text('Thêm lịch'),
        ),
        body: RefreshIndicator(
          onRefresh: () async =>
              ref.invalidate(appointmentsForElderProvider(elderId)),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 96),
            children: [
              if (items.isEmpty)
                const _EmptyCard(
                  icon: Icons.event_busy,
                  message: 'Chưa có lịch khám nào.',
                )
              else
                ...items.map(
                  (appointment) =>
                      _AppointmentCard(appointment: appointment, user: user),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _createAppointment(
    BuildContext context,
    WidgetRef ref,
    List<AccountLinkRequest> familyLinks,
  ) async {
    final title = TextEditingController(text: 'Khám định kỳ');
    final hospital = TextEditingController();
    final department = TextEditingController();
    final note = TextEditingController();
    final availableEscorts = familyLinks
        .where(
          (link) =>
              link.status == LinkRequestStatus.accepted &&
              link.childId != null &&
              link.childId!.isNotEmpty,
        )
        .toList();
    final myLink = availableEscorts.where((link) => link.childId == user.id);
    String? selectedEscortId = myLink.isEmpty ? null : myLink.first.childId;
    if (selectedEscortId == null && availableEscorts.isNotEmpty) {
      selectedEscortId = availableEscorts.first.childId;
    }
    var date = DateTime.now().add(const Duration(days: 1));
    String? dateError;
    final formKey = GlobalKey<FormState>();
    final accepted = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          icon: const Icon(Icons.event_available_rounded, size: 42),
          title: const Text('Thêm lịch khám'),
          content: Form(
            key: formKey,
            child: SizedBox(
              width: 520,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const _FormSectionTitle(
                      icon: Icons.local_hospital_outlined,
                      title: 'Thông tin lịch khám',
                    ),
                  TextFormField(
                    controller: title,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      labelText: 'Nội dung khám *',
                      hintText: 'Ví dụ: Khám tim mạch định kỳ',
                      prefixIcon: Icon(Icons.medical_services_outlined),
                    ),
                    validator: _required,
                  ),
                    const SizedBox(height: 12),
                  TextFormField(
                    controller: hospital,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      labelText: 'Bệnh viện/Cơ sở khám *',
                      prefixIcon: Icon(Icons.local_hospital_outlined),
                    ),
                    validator: _required,
                  ),
                    const SizedBox(height: 12),
                  TextFormField(
                    controller: department,
                    decoration: const InputDecoration(
                      labelText: 'Khoa khám',
                      prefixIcon: Icon(Icons.apartment_outlined),
                    ),
                  ),
                    const SizedBox(height: 18),
                    const _FormSectionTitle(
                      icon: Icons.schedule_rounded,
                      title: 'Thời gian và người phụ trách',
                    ),
                    if (availableEscorts.isEmpty)
                      const Padding(
                        padding: EdgeInsets.only(bottom: 12),
                        child: Text(
                          'Chưa có thành viên nào được liên kết để đưa đi khám.',
                          style: TextStyle(
                            color: AppColors.danger,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                  DropdownButtonFormField<String>(
                    initialValue: selectedEscortId,
                    decoration: const InputDecoration(
                      labelText: 'Người đưa đi khám',
                      prefixIcon: Icon(Icons.directions_car_filled_rounded),
                    ),
                    items: availableEscorts
                        .map(
                          (link) => DropdownMenuItem(
                            value: link.childId,
                            child: Text(
                              link.childId == user.id
                                  ? 'Bạn (${user.fullName})'
                                  : link.childName ?? link.childPhone,
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (value) => selectedEscortId = value,
                    validator: (value) => value == null
                        ? 'Vui lòng chọn người đưa đi khám'
                        : null,
                  ),
                    const SizedBox(height: 8),
                  _DatePickerTile(
                    label: 'Thời gian khám *',
                    value: date,
                    includeTime: true,
                    onTap: () async {
                      final pickedDate = await showDatePicker(
                        context: context,
                        initialDate: date,
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(
                          const Duration(days: 3650),
                        ),
                      );
                      if (pickedDate == null || !context.mounted) return;
                      final pickedTime = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.fromDateTime(date),
                      );
                      if (pickedTime != null) {
                        setState(
                          () {
                            date = DateTime(
                              pickedDate.year,
                              pickedDate.month,
                              pickedDate.day,
                              pickedTime.hour,
                              pickedTime.minute,
                            );
                            dateError = null;
                          },
                        );
                      }
                    },
                  ),
                    if (dateError != null)
                      Padding(
                        padding: const EdgeInsets.only(left: 12, top: 4),
                        child: Text(
                          dateError!,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.error,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    const SizedBox(height: 12),
                  TextFormField(
                    controller: note,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      labelText: 'Ghi chú chuẩn bị',
                      hintText: 'Giấy tờ, nhịn ăn, thuốc đang sử dụng...',
                      alignLabelWithHint: true,
                    ),
                  ),
                  ],
                ),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Hủy'),
            ),
            FilledButton(
              onPressed: () {
                final validTime = date.isAfter(DateTime.now());
                setState(() {
                  dateError = validTime
                      ? null
                      : 'Thời gian khám phải sau thời điểm hiện tại';
                });
                if (formKey.currentState!.validate() && validTime) {
                  Navigator.pop(dialogContext, true);
                }
              },
              child: const Text('Lưu'),
            ),
          ],
        ),
      ),
    );
    if (accepted == true) {
      final escort = availableEscorts.firstWhere(
        (link) => link.childId == selectedEscortId,
      );
      try {
        await ref
            .read(appointmentRepositoryProvider)
            .createAppointment(
            MedicalAppointment(
              id: '',
              elderUserId: elderId,
              title: title.text.trim(),
              hospitalName: hospital.text.trim(),
              department: department.text.trim(),
              scheduledAt: date,
              status: AppointmentStatus.accepted,
              createdById: user.id,
              note: note.text.trim(),
              assigneeId: escort.childId,
              assigneeName: escort.childName ?? escort.childPhone,
            ),
            );
        if (context.mounted) {
          await showAppMessageDialog(
            context,
            message: 'Đã thêm lịch khám và phân công người đưa đi khám.',
            type: AppMessageType.success,
          );
        }
      } catch (error) {
        if (context.mounted) {
          await showAppErrorDialog(
            context,
            title: 'Không thể thêm lịch khám',
            message: error,
          );
        }
      }
    }
    title.dispose();
    hospital.dispose();
    department.dispose();
    note.dispose();
  }
}

class _AppointmentCard extends ConsumerWidget {
  const _AppointmentCard({required this.appointment, required this.user});

  final MedicalAppointment appointment;
  final AppUser user;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mine = appointment.assigneeId == user.id;
    final canComplete = !DateTime.now().isBefore(appointment.scheduledAt);
    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _dateTime(appointment.scheduledAt),
              style: const TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              appointment.title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
            ),
            Text(
              [
                appointment.hospitalName,
                appointment.department,
              ].where((value) => value.isNotEmpty).join(' • '),
            ),
            if (appointment.note.isNotEmpty) Text(appointment.note),
            const SizedBox(height: 10),
            Text(
              appointment.assigneeName == null
                  ? 'Chưa có người đưa đi khám'
                  : '${mine ? 'Bạn' : appointment.assigneeName} sẽ đưa đi khám',
              style: TextStyle(
                color: appointment.assigneeName == null
                    ? AppColors.danger
                    : AppColors.success,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            if (mine &&
                appointment.status == AppointmentStatus.accepted &&
                !canComplete) ...[
              Text(
                'Chỉ có thể hoàn thành sau ${_dateTime(appointment.scheduledAt)}',
                style: const TextStyle(
                  color: AppColors.textMuted,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
            ],
            if (appointment.status == AppointmentStatus.unassigned)
              FilledButton.icon(
                onPressed: () => ref
                    .read(appointmentRepositoryProvider)
                    .acceptAppointment(
                      appointmentId: appointment.id,
                      userId: user.id,
                      userName: user.fullName,
                    ),
                icon: const Icon(Icons.volunteer_activism),
                label: const Text('Tôi sẽ đưa đi'),
              )
            else if (mine && appointment.status == AppointmentStatus.accepted)
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 48,
                      child: FilledButton(
                        onPressed: canComplete
                            ? () => _completeAppointment(context, ref)
                            : null,
                        child: const Text('Hoàn thành'),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: SizedBox(
                      height: 48,
                      child: OutlinedButton(
                        onPressed: () => ref
                            .read(appointmentRepositoryProvider)
                            .releaseAppointment(
                              appointmentId: appointment.id,
                              userId: user.id,
                            ),
                        child: const Text('Nhờ người khác'),
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _completeAppointment(
    BuildContext context,
    WidgetRef ref,
  ) async {
    await ref
        .read(appointmentRepositoryProvider)
        .completeAppointment(appointmentId: appointment.id, userId: user.id);
    if (!context.mounted) return;

    DefaultTabController.of(context).animateTo(1);
    await _showCreateMedicalVisitDialog(
      context,
      ref,
      elderId: appointment.elderUserId,
      user: user,
      initialHospital: appointment.hospitalName,
      initialDate: appointment.scheduledAt,
    );
  }
}

class _MedicalVisitList extends ConsumerWidget {
  const _MedicalVisitList({required this.elderId, required this.user});

  final String elderId;
  final AppUser user;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final visits = ref.watch(medicalVisitsForElderProvider(elderId));
    return visits.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => _EmptyState(
        icon: Icons.cloud_off,
        message: 'Không thể tải hồ sơ khám: $error',
      ),
      data: (items) => Scaffold(
        backgroundColor: Colors.transparent,
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => _showCreateMedicalVisitDialog(
            context,
            ref,
            elderId: elderId,
            user: user,
          ),
          icon: const Icon(Icons.note_add),
          label: const Text('Thêm hồ sơ'),
        ),
        body: ListView(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 96),
          children: [
            if (items.isEmpty)
              const _EmptyCard(
                icon: Icons.folder_off,
                message: 'Chưa có hồ sơ khám bệnh.',
              )
            else
              ...items.map((visit) => _VisitCard(visit: visit, user: user)),
          ],
        ),
      ),
    );
  }
}

Future<void> _showCreateMedicalVisitDialog(
  BuildContext context,
  WidgetRef ref, {
  required String elderId,
  required AppUser user,
  String initialHospital = '',
  DateTime? initialDate,
}) async {
  final hospital = TextEditingController(text: initialHospital);
  final diagnosis = TextEditingController();
  final conclusion = TextEditingController();
  var date = initialDate ?? DateTime.now();
  final documents = <_PendingMedicalDocument>[];
  final formKey = GlobalKey<FormState>();
  final accepted = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Thêm hồ sơ khám'),
          content: Form(
            key: formKey,
            child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                   TextFormField(
                     controller: hospital,
                    decoration: const InputDecoration(labelText: 'Bệnh viện'),
                     validator: _required,
                   ),
                   TextFormField(
                     controller: diagnosis,
                    decoration: const InputDecoration(labelText: 'Chẩn đoán'),
                     validator: _required,
                   ),
                    TextFormField(
                     controller: conclusion,
                     maxLines: 3,
                     decoration: const InputDecoration(
                        labelText: 'Kết luận/Ghi chú',
                     ),
                   ),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Ngày khám'),
                      subtitle: Text(_date(date)),
                      onTap: () async {
                        final value = await showDatePicker(
                          context: context,
                          initialDate: date,
                          firstDate: DateTime(2000),
                          lastDate: DateTime.now(),
                        );
                        if (value != null) setState(() => date = value);
                      },
                    ),
                    const SizedBox(height: 8),
                  OutlinedButton.icon(
                    onPressed: () async {
                      try {
                        final document = await _pickMedicalDocument(context);
                        if (document != null && context.mounted) {
                          setState(() => documents.add(document));
                        }
                      } catch (error) {
                        if (context.mounted) {
                          await showAppErrorDialog(
                            context,
                            title: 'Không thể đọc tệp',
                            message: error,
                          );
                        }
                      }
                    },
                    icon: const Icon(Icons.attach_file),
                    label: const Text('Thêm ảnh hoặc PDF'),
                  ),
                  ...documents.asMap().entries.map(
                    (entry) => ListTile(
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                      leading: Icon(
                        entry.value.contentType == 'application/pdf'
                            ? Icons.picture_as_pdf
                            : Icons.image,
                      ),
                      title: Text(entry.value.fileName),
                      trailing: IconButton(
                        tooltip: 'Bỏ tệp',
                        onPressed: () => setState(
                          () => documents.removeAt(entry.key),
                        ),
                        icon: const Icon(Icons.close),
                      ),
                    ),
                  ),
                  ],
                ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Hủy'),
            ),
            FilledButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  Navigator.pop(dialogContext, true);
                }
              },
              child: const Text('Lưu'),
            ),
          ],
        ),
      ),
  );
  if (accepted == true) {
    try {
      final repository = ref.read(medicalRecordRepositoryProvider);
      final visitId = await repository.createVisit(
          MedicalVisit(
            id: '',
            elderUserId: elderId,
            visitDate: date,
            hospitalName: hospital.text.trim(),
            diagnosis: diagnosis.text.trim(),
            conclusion: conclusion.text.trim(),
            createdById: user.id,
          ),
          );
      for (final document in documents) {
        await repository.attachDocument(
          elderId: elderId,
          visitId: visitId,
          fileName: document.fileName,
          contentType: document.contentType,
          bytes: document.bytes,
          uploadedById: user.id,
        );
      }
      if (context.mounted) {
        await showAppMessageDialog(
          context,
          message: documents.isEmpty
              ? 'Đã thêm hồ sơ khám.'
              : 'Đã thêm hồ sơ và ${documents.length} tệp đính kèm.',
          type: AppMessageType.success,
        );
      }
    } catch (error) {
      if (context.mounted) {
        await showAppErrorDialog(
          context,
          title: 'Không thể thêm hồ sơ',
          message: error,
        );
      }
    }
  }
  hospital.dispose();
  diagnosis.dispose();
  conclusion.dispose();
}

class _VisitCard extends ConsumerWidget {
  const _VisitCard({required this.visit, required this.user});

  final MedicalVisit visit;
  final AppUser user;

  @override
  Widget build(BuildContext context, WidgetRef ref) => Card(
    margin: const EdgeInsets.only(bottom: 14),
    child: ExpansionTile(
      leading: const CircleAvatar(child: Icon(Icons.medical_information)),
      title: Text(
        visit.diagnosis,
        style: const TextStyle(fontWeight: FontWeight.w900),
      ),
      subtitle: Text('${_date(visit.visitDate)} • ${visit.hospitalName}'),
      childrenPadding: const EdgeInsets.fromLTRB(18, 0, 18, 16),
      expandedCrossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (visit.conclusion.isNotEmpty) Text(visit.conclusion),
        const SizedBox(height: 10),
        Text('${visit.documents.length} tài liệu đính kèm'),
        ...visit.documents.map(
          (item) => ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(
              item.contentType.startsWith('image/')
                  ? Icons.image_outlined
                  : Icons.picture_as_pdf_outlined,
            ),
            title: Text(item.fileName),
            subtitle: Text(
              item.contentType.startsWith('image/')
                  ? 'Chạm để xem ảnh'
                  : 'Chạm để xem PDF',
            ),
            trailing: const Icon(Icons.visibility_outlined),
            onTap: () => _showDocument(context, ref, item),
          ),
        ),
        OutlinedButton.icon(
          onPressed: () => _selectSource(context, ref),
          icon: const Icon(Icons.upload_file),
          label: const Text('Thêm ảnh hoặc PDF'),
        ),
      ],
    ),
  );

  Future<void> _showDocument(
    BuildContext context,
    WidgetRef ref,
    MedicalDocument document,
  ) async {
    if (document.contentType == 'application/pdf') {
      try {
        final uri = await ref
            .read(medicalRecordRepositoryProvider)
            .createDocumentOpenUrl(
              visitId: visit.id,
              documentId: document.id,
            );
        final opened = await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
        );
        if (!opened) throw StateError('Thiết bị không có ứng dụng mở PDF.');
      } catch (error) {
        if (context.mounted) {
          await showAppErrorDialog(
            context,
            title: 'Không thể mở PDF',
            message: error,
          );
        }
      }
      return;
    }
    final future = ref
        .read(medicalRecordRepositoryProvider)
        .readDocument(visitId: visit.id, documentId: document.id);
    await showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) => AlertDialog(
        content: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 700, maxHeight: 650),
          child: FutureBuilder<Uint8List>(
            future: future,
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return const SizedBox(
                  width: 280,
                  height: 220,
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              if (snapshot.hasError) {
                return SizedBox(
                  width: 300,
                  child: Text(
                    'Không thể hiển thị ảnh: ${snapshot.error}',
                    textAlign: TextAlign.center,
                  ),
                );
              }
              return InteractiveViewer(
                minScale: 0.5,
                maxScale: 5,
                child: Image.memory(snapshot.requireData, fit: BoxFit.contain),
              );
            },
          ),
        ),
        actions: [
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Đóng'),
          ),
        ],
      ),
    );
  }

  Future<void> _selectSource(BuildContext context, WidgetRef ref) async {
    try {
      final document = await _pickMedicalDocument(context);
      if (document == null) return;
      await ref.read(medicalRecordRepositoryProvider).attachDocument(
          elderId: visit.elderUserId,
          visitId: visit.id,
          fileName: document.fileName,
          contentType: document.contentType,
          bytes: document.bytes,
          uploadedById: user.id,
        );
      if (context.mounted) {
        await showAppMessageDialog(
          context,
          message: 'Đã thêm tệp ${document.fileName}.',
          type: AppMessageType.success,
        );
      }
    } catch (error) {
      if (context.mounted) {
        await showAppErrorDialog(
          context,
          title: 'Không thể tải tệp',
          message: error,
        );
      }
    }
  }
}

class _PendingMedicalDocument {
  const _PendingMedicalDocument({
    required this.fileName,
    required this.contentType,
    required this.bytes,
  });

  final String fileName;
  final String contentType;
  final Uint8List bytes;
}

Future<_PendingMedicalDocument?> _pickMedicalDocument(
  BuildContext context,
) async {
  final source = await showModalBottomSheet<String>(
    context: context,
    builder: (context) => SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.camera_alt),
            title: const Text('Chụp ảnh'),
            onTap: () => Navigator.pop(context, 'camera'),
          ),
          ListTile(
            leading: const Icon(Icons.photo_library),
            title: const Text('Chọn ảnh'),
            onTap: () => Navigator.pop(context, 'gallery'),
          ),
          ListTile(
            leading: const Icon(Icons.picture_as_pdf),
            title: const Text('Chọn PDF'),
            onTap: () => Navigator.pop(context, 'file'),
          ),
        ],
      ),
    ),
  );
  if (source == null) return null;

  if (source == 'file') {
    final file = await FilePicker.pickFile(
      type: FileType.custom,
      allowedExtensions: const ['pdf'],
    );
    if (file == null) return null;
    final bytes = await file.readAsBytes();
    return _PendingMedicalDocument(
      fileName: file.name,
      contentType: 'application/pdf',
      bytes: bytes,
    );
  }

  final image = await ImagePicker().pickImage(
    source: source == 'camera' ? ImageSource.camera : ImageSource.gallery,
    imageQuality: 85,
  );
  if (image == null) return null;
  final fileName = image.name;
  return _PendingMedicalDocument(
    fileName: fileName,
    contentType: fileName.toLowerCase().endsWith('.png')
        ? 'image/png'
        : 'image/jpeg',
    bytes: await image.readAsBytes(),
  );
}

class _FormSectionTitle extends StatelessWidget {
  const _FormSectionTitle({required this.icon, required this.title});

  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Row(
      children: [
        Icon(icon, size: 21, color: AppColors.primary),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
        ),
      ],
    ),
  );
}

class _DatePickerTile extends StatelessWidget {
  const _DatePickerTile({
    required this.label,
    required this.value,
    required this.onTap,
    this.emptyText = 'Chưa chọn',
    this.includeTime = false,
    this.allowClear = false,
    this.onClear,
  });

  final String label;
  final DateTime? value;
  final VoidCallback onTap;
  final String emptyText;
  final bool includeTime;
  final bool allowClear;
  final VoidCallback? onClear;

  @override
  Widget build(BuildContext context) => Material(
    color: Theme.of(context).colorScheme.surfaceContainerLow,
    borderRadius: BorderRadius.circular(12),
    child: ListTile(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      leading: const Icon(Icons.calendar_month_outlined),
      title: Text(label, style: const TextStyle(fontWeight: FontWeight.w700)),
      subtitle: Text(
        value == null
            ? emptyText
            : includeTime
            ? _dateTime(value!)
            : _date(value!),
      ),
      trailing: allowClear && value != null
          ? IconButton(
              tooltip: 'Bỏ ngày đã chọn',
              onPressed: onClear,
              icon: const Icon(Icons.close),
            )
          : const Icon(Icons.edit_calendar_outlined),
      onTap: onTap,
    ),
  );
}

class _EmptyCard extends StatelessWidget {
  const _EmptyCard({required this.icon, required this.message});
  final IconData icon;
  final String message;
  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(28),
      child: Column(
        children: [
          Icon(icon, size: 54, color: AppColors.textMuted),
          const SizedBox(height: 12),
          Text(message, textAlign: TextAlign.center),
        ],
      ),
    ),
  );
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.icon, required this.message});
  final IconData icon;
  final String message;
  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 70, color: AppColors.textMuted),
          const SizedBox(height: 16),
          Text(message, textAlign: TextAlign.center),
        ],
      ),
    ),
  );
}

String? _required(String? value) =>
    value == null || value.trim().isEmpty ? 'Không được để trống' : null;

String _date(DateTime value) =>
    '${value.day.toString().padLeft(2, '0')}/${value.month.toString().padLeft(2, '0')}/${value.year}';

String _dateTime(DateTime value) =>
    '${_date(value)} • ${value.hour.toString().padLeft(2, '0')}:${value.minute.toString().padLeft(2, '0')}';
