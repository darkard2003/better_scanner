import 'package:better_scanner/screens/scanner_screen/view/components/record_action.dart';
import 'package:better_scanner/screens/scanner_screen/view/components/record_card.dart';
import 'package:flutter/material.dart';

import '../../models/qr_record_model.dart';

class SearchScreenView extends StatefulWidget {
  final List<QrRecordModel> records;

  const SearchScreenView({super.key, required this.records});

  @override
  State<SearchScreenView> createState() => _SearchScreenViewState();
}

class _SearchScreenViewState extends State<SearchScreenView> {
  var query = '';
  late TextEditingController _controller;

  List<QrRecordModel> get results {
    if (query.isEmpty) {
      return widget.records;
    }

    var lowerQuery = query.toLowerCase();
    var nameMatches = widget.records.where((record) {
      return record.name.toLowerCase().contains(lowerQuery);
    }).toList();

    var contentMatches = widget.records.where((record) {
      return record.data.toLowerCase().contains(lowerQuery);
    }).toList();

    return [...nameMatches, ...contentMatches];
  }

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      padding: const EdgeInsets.all(16),
      constraints: const BoxConstraints(
        maxWidth: 700,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'Search',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _controller,
            autofocus: true,
            onChanged: (value) {
              setState(() {
                query = value;
              });
            },
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              hintText: 'Search',
              suffixIcon: query.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        setState(() {
                          query = '';
                          _controller.clear();
                        });
                      },
                    )
                  : null,
              prefixIcon: const Icon(Icons.search),
            ),
          ),
          const Divider(
            height: 20,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: results.length,
              itemBuilder: (context, i) => RecordCard(
                record: results[i],
                onTap: (record) {
                  Navigator.of(context).pop(
                    record.toIntent(RecordAction.tap),
                  );
                },
                onEdit: (record) {
                  Navigator.of(context).pop(
                    record.toIntent(RecordAction.edit),
                  );
                },
                onDelete: (record) {
                  Navigator.of(context).pop(
                    record.toIntent(RecordAction.delete),
                  );
                },
                onShare: (record) {
                  Navigator.of(context).pop(
                    record.toIntent(RecordAction.share),
                  );
                },
                shortcutAction: (record) {
                  Navigator.of(context).pop(
                    record.toIntent(RecordAction.shortcut),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class RecordSearchIntent {
  final QrRecordModel record;
  final RecordAction action;

  const RecordSearchIntent({
    required this.record,
    required this.action,
  });
}

extension Intent on QrRecordModel {
  RecordSearchIntent toIntent(RecordAction action) {
    return RecordSearchIntent(record: this, action: action);
  }
}
