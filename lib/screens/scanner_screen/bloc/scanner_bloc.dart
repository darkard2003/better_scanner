import 'package:better_scanner/models/qr_models.dart';
import 'package:better_scanner/models/qr_record_model.dart';
import 'package:better_scanner/screens/scanner_screen/bloc/scanner_event.dart';
import 'package:better_scanner/screens/scanner_screen/bloc/scanner_state.dart';
import 'package:better_scanner/screens/scanner_screen/bloc/state_message.dart';
import 'package:better_scanner/services/database/database.dart';
import 'package:better_scanner/services/database/db_provider.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

export 'package:better_scanner/screens/scanner_screen/bloc/scanner_event.dart';
export 'package:better_scanner/screens/scanner_screen/bloc/scanner_state.dart';

class ScannerBloc extends Bloc<ScannerEvent, ScannerState> {
  late Database db;
  var records = <QrRecordModel>[];

  ScannerBloc() : super(ScannerStateUninitialized()) {
    on<ScannerEventInit>(_onInit);
    on<ScannerEventScan>(_onScan);
    on<ScannerEventRename>(_onRename);
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

  void _onRename(ScannerEventRename event, Emitter<ScannerState> emit) async {
    var record = event.record;
    var name = record.name;
    record.name = event.name;
    await db.updateRecord(record);
    records = await db.getRecords();
    emit(ScannerScreenState(
      qrCodes: records,
      msg: StateMessage(message: 'Renamed $name to ${event.name}'),
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

  void _onShare(ScannerEventShare event, Emitter<ScannerState> emit) {
    var record = event.record;
    Share.share(record.data, subject: record.name);
  }

  void _onTap(ScannerEventOnTap event, Emitter<ScannerState> emit) async {
    var record = event.record;
    var context = event.context;

    var res = await Navigator.pushNamed(
      context,
      '/details',
      arguments: {'qr': record},
    );
  }

  void _openUrl(ScannerEventOpenUrl event, Emitter<ScannerState> emit) async {
    if (event.record is! UrlQrModel) {
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
    if (!await canLaunchUrl(record.url)) {
      emit(
        state.copyWith(
          msg: StateMessage(
            message: 'Invalid url',
            type: StateMessageType.error,
          ),
        ),
      );
    }
    await launchUrl(record.url);
  }
}
