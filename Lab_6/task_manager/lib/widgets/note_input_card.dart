import 'package:flutter/material.dart';

class NoteInputCard extends StatelessWidget {
  final String noteText;
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  const NoteInputCard({
    super.key,
    required this.noteText,
    required this.controller,
    required this.onChanged,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF15181F),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF2A3142),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: controller,
            onChanged: onChanged,
            style: const TextStyle(color: Colors.white, fontSize: 14),
            decoration: InputDecoration(
              labelText: 'Коментар або нотатка',
              labelStyle: const TextStyle(color: Color(0xFF8B949E)),
              hintText: 'Введіть деталі або оновлення...',
              hintStyle: const TextStyle(color: Color(0xFF555F70), fontSize: 13),
              prefixIcon: const Icon(
                Icons.edit_note,
                color: Color(0xFFD4FF00),
              ),
              suffixIcon: noteText.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear, color: Color(0xFF8B949E)),
                      onPressed: onClear,
                    )
                  : null,
              filled: true,
              fillColor: const Color(0xFF1F2430),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(
                  color: Color(0xFFD4FF00),
                  width: 1.5,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 12,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Введена нотатка: ',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF8B949E),
                ),
              ),
              Expanded(
                child: Text(
                  noteText.isEmpty ? '— (поле порожнє)' : noteText,
                  style: TextStyle(
                    fontSize: 13,
                    fontStyle: noteText.isEmpty ? FontStyle.italic : FontStyle.normal,
                    color: noteText.isEmpty
                        ? const Color(0xFF555F70)
                        : const Color(0xFFD4FF00),
                    fontWeight: noteText.isEmpty ? FontWeight.normal : FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
