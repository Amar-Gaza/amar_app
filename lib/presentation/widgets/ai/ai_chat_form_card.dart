import 'package:flutter/material.dart';

import '../../../data/models/ai/ai_chat_form.dart';

/// An inline Flutter form, not an image or LLM-controlled widget tree.
/// Choices are an allowlisted representation of verified Masar records.
class AiChatFormCard extends StatefulWidget {
  const AiChatFormCard({
    super.key,
    required this.form,
    required this.onSubmit,
    required this.enabled,
  });

  final AiChatForm form;
  final bool enabled;
  final Future<bool> Function(Map<String, dynamic>) onSubmit;

  @override
  State<AiChatFormCard> createState() => _AiChatFormCardState();
}

class _AiChatFormCardState extends State<AiChatFormCard> {
  final Map<String, dynamic> _values = {};
  final Map<String, String> _errors = {};
  final Map<String, TextEditingController> _numberControllers = {};
  bool _sending = false;

  @override
  void initState() {
    super.initState();
    for (final field in widget.form.fields) {
      if (field.type == AiFormType.integer) {
        final int start = (field.initialNumber ?? field.min)
            .clamp(field.min, field.max) as int;
        _values[field.key] = start;
        _numberControllers[field.key] = TextEditingController(text: '$start');
      } else if (field.type == AiFormType.multi) {
        _values[field.key] = <String>[];
      }
    }
  }

  @override
  void dispose() {
    for (final controller in _numberControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void _adjustNumber(AiFormField field, int delta) {
    final current = _values[field.key];
    if (current is! int) return;
    final next = current + delta;
    if (next < field.min || next > field.max) return;
    setState(() {
      _values[field.key] = next;
      _numberControllers[field.key]!.text = '$next';
      _errors.remove(field.key);
    });
  }

  Future<void> _submit() async {
    if (_sending || !widget.enabled) return;
    final errors = widget.form.validate(_values);
    setState(() {
      _errors..clear()..addAll(errors);
    });
    if (errors.isNotEmpty) return;
    setState(() => _sending = true);
    try {
      await widget.onSubmit(Map<String, dynamic>.from(_values));
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  Widget _field(AiFormField field) {
    final theme = Theme.of(context);
    final error = _errors[field.key];
    final widgets = <Widget>[
      Padding(
        padding: const EdgeInsets.only(top: 12, bottom: 6),
        child: Text(field.label, style: theme.textTheme.titleSmall),
      ),
    ];

    if (field.type == AiFormType.single) {
      for (final choice in field.choices) {
        widgets.add(RadioListTile<String>(
          title: Text(choice.label),
          subtitle: choice.detail == null ? null : Text(choice.detail!),
          value: choice.value,
          groupValue: _values[field.key] as String?,
          contentPadding: EdgeInsets.zero,
          dense: true,
          onChanged: widget.enabled && !_sending ? (value) {
            setState(() {
              _values[field.key] = value;
              _errors.remove(field.key);
            });
          } : null,
        ));
      }
    } else if (field.type == AiFormType.multi) {
      final selected = (_values[field.key] as List<String>?) ?? <String>[];
      for (final choice in field.choices) {
        widgets.add(CheckboxListTile(
          title: Text(choice.label),
          subtitle: choice.detail == null ? null : Text(choice.detail!),
          value: selected.contains(choice.value),
          contentPadding: EdgeInsets.zero,
          dense: true,
          onChanged: widget.enabled && !_sending ? (checked) {
            setState(() {
              final copy = <String>[...selected];
              if (checked == true && !copy.contains(choice.value)) {
                copy.add(choice.value);
              } else if (checked != true) {
                copy.remove(choice.value);
              }
              _values[field.key] = copy;
              _errors.remove(field.key);
            });
          } : null,
        ));
      }
    } else if (field.type == AiFormType.integer) {
      widgets.add(Row(children: [
        IconButton.outlined(
          onPressed: widget.enabled && !_sending &&
                  _values[field.key] is int &&
                  (_values[field.key] as int) > field.min
              ? () => _adjustNumber(field, -1)
              : null,
          icon: const Icon(Icons.remove),
        ),
        Expanded(child: TextFormField(
          key: ValueKey('${widget.form.id}:${field.key}'),
          controller: _numberControllers[field.key],
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          enabled: widget.enabled && !_sending,
          onChanged: (value) {
            setState(() {
              _values[field.key] = int.tryParse(value);
              _errors.remove(field.key);
            });
          },
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            hintText: '${field.min}–${field.max}',
          ),
        )),
        IconButton.outlined(
          onPressed: widget.enabled && !_sending &&
                  (_values[field.key] is int) &&
                  (_values[field.key] as int) < field.max
              ? () => _adjustNumber(field, 1)
              : null,
          icon: const Icon(Icons.add),
        ),
      ]));
      // The stepper and text input share state through the map. An edited
      // number is submitted as-is; buttons are an optional convenience.
    } else if (field.type == AiFormType.text) {
      widgets.add(TextFormField(
        initialValue: '',
        enabled: widget.enabled && !_sending,
        maxLength: field.max,
        onChanged: (value) => _values[field.key] = value,
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          hintText: field.hint,
        ),
      ));
    }

    if (error != null) {
      widgets.add(Padding(
        padding: const EdgeInsets.only(top: 4),
        child: Text(error, style: TextStyle(color: theme.colorScheme.error)),
      ));
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: widgets,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(children: [
              Icon(Icons.tune, color: theme.colorScheme.primary),
              const SizedBox(width: 8),
              Expanded(child: Text(widget.form.title,
                  style: theme.textTheme.titleMedium)),
            ]),
            if (widget.form.help != null) ...[
              const SizedBox(height: 6),
              Text(widget.form.help!, style: theme.textTheme.bodySmall),
            ],
            for (final field in widget.form.fields) _field(field),
            const SizedBox(height: 12),
            FilledButton.icon(
              onPressed: widget.enabled && !_sending ? _submit : null,
              icon: _sending
                  ? const SizedBox.square(dimension: 16,
                      child: CircularProgressIndicator(strokeWidth: 2))
                  : const Icon(Icons.check),
              label: Text(widget.form.submitLabel),
            ),
          ],
        ),
      ),
    );
  }
}
