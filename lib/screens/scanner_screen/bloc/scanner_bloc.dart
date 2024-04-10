import 'dart:async';

import 'package:better_scanner/models/qr_models.dart';
import 'package:better_scanner/models/qr_record_model.dart';
import 'package:better_scanner/screens/scanner_screen/bloc/scanner_event.dart';
import 'package:better_scanner/screens/scanner_screen/bloc/scanner_state.dart';
import 'package:better_scanner/screens/scanner_screen/bloc/state_message.dart';
import 'package:better_scanner/services/database/database.dart';
import 'package:better_scanner/services/database/db_provider.dart';
import 'package:better_scanner/services/qr_services/qr_services.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

export 'package:better_scanner/screens/scanner_screen/bloc/scanner_event.dart';
export 'package:better_scanner/screens/scanner_screen/bloc/scanner_state.dart';

class ScannerBloc extends Bloc<ScannerEvent, ScannerState> {
  late Database db;
  var records = <QrRecordModel>[];
  var controller = MobileScannerController();
  final BuildContext context;

  ScannerBloc(
    this.context,
  ) : super(ScannerStateUninitialized()) {
    on<ScannerEventInit>(_onInit);
    on<ScannerEventScan>(_onScan);
    on<ScannerEventEdit>(_onEdit);
    on<ScannerEventDelete>(_onDelete);
    on<ScannerEventOnTap>(_onTap);
    on<ScannerEventOnLongPress>(_onLongPress);
    on<ScannerEventShare>(_onShare);
    on<ScannerEventCopy>(_onCopy);
    on<ScannerEventOpenUrl>(_openUrl);
  }

  void _onCopy(ScannerEventCopy event, Emitter<ScannerState> emit) {
    var record = event.record;
    Clipboard.setData(ClipboardData(text: record.copyData));
    emit(
      state.copyWith(
        msg: StateMessage(message: '${record.name} Copied to clipboard'),
      ),
    );
  }

  void _onDelete(ScannerEventDelete event, Emitter<ScannerState> emit) async {
    var record = event.record;
    await db.deleteRecord(record);
    records = await db.getRecords();
    emit(
      ScannerScreenState(
        qrCodes: records,
        msg: StateMessage(
          message: "Deleted ${record.name}",
          action: MessageAction('Undo', () {
            add(ScannerEventScan(record));
          }),
        ),
      ),
    );
  }

  void _onInit(ScannerEventInit event, Emitter<ScannerState> emit) async {
    db = await DBProvider.useDB(DBType.hive, 'user');
    try {
      records = await db.getRecords();
      emit(ScannerScreenState(
        qrCodes: records,
      ));
    } catch (e) {
      emit(
        ScannerScreenState(
          qrCodes: [],
          msg: StateMessage(
            message: e.toString(),
            type: StateMessageType.error,
          ),
        ),
      );
    }
  }

  void _onLongPress(ScannerEventOnLongPress event, Emitter<ScannerState> emit) {
    var record = event.record;
    Clipboard.setData(ClipboardData(text: record.copyData));
    emit(ScannerScreenState(
      qrCodes: records,
      msg: StateMessage(message: 'Copied to clipboard'),
    ));
  }

  void _onEdit(ScannerEventEdit event, Emitter<ScannerState> emit) async {
    var record = await Navigator.pushNamed(
      context,
      '/generator',
      arguments: {'qr': event.record},
    ) as QrRecordModel?;
    if (record == null) return;
    await db.updateRecord(record);
    records = await db.getRecords();
    emit(ScannerScreenState(
      qrCodes: records,
      msg: StateMessage(message: 'Updated ${record.name}'),
    ));
  }

  void _onScan(ScannerEventScan event, Emitter<ScannerState> emit) async {
    await db.addRecord(event.record);
    records = await db.getRecords();
    emit(
      ScannerScreenState(
        qrCodes: records,
        msg: StateMessage(message: 'Added ${event.record.name}'),
      ),
    );
  }

  void _onShare(ScannerEventShare event, Emitter<ScannerState> emit) async {
    var record = event.record;
    await QrServices.shareQrText(record);
  }

  void _onTap(ScannerEventOnTap event, Emitter<ScannerState> emit) async {
    var record = event.record;

    unawaited(controller.stop());
    var _ = await Navigator.pushNamed(
      context,
      '/details',
      arguments: {'qr': record},
    );
    unawaited(controller.start());
  }

  void _openUrl(ScannerEventOpenUrl event, Emitter<ScannerState> emit) async {
    if (!event.record.canOpen) {
      emit(
        state.copyWith(
          msg: StateMessage(
            message: 'Invalid record type',
            type: StateMessageType.error,
          ),
        ),
      );
    }
    var record = event.record as UrlQrModel;
    if (!await QrServices.canLaunch(record)) {
      emit(
        state.copyWith(
          msg: StateMessage(
            message: 'Invalid url',
            type: StateMessageType.error,
          ),
        ),
      );
    }
    await QrServices.launch(record);
  }
}
