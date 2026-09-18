import 'package:flutter/material.dart';

class AppDropdown extends StatefulWidget {
  final String label;
  final String hint;
  final IconData icon;
  final String? value;
  final List<String> items;

  // Changed: nullable
  final ValueChanged<String?>? onChanged;

  const AppDropdown({
    super.key,
    required this.label,
    required this.hint,
    required this.icon,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  State<AppDropdown> createState() => _AppDropdownState();
}

class _AppDropdownState extends State<AppDropdown> {
  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      initialValue: widget.value,
      isExpanded: true,
      icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 20),
      style: const TextStyle(fontSize: 13, color: Color(0xFF202124)),
      decoration: InputDecoration(
        labelText: widget.label,
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFE50914), width: 1.3),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFE8E8E8)),
        ),
      ),
      hint: Text(
        widget.hint,
        style: const TextStyle(fontSize: 13, color: Color(0xFF999999)),
      ),
      items: widget.items.map((item) {
        return DropdownMenuItem<String>(value: item, child: Text(item));
      }).toList(),

      // Now null is allowed
      onChanged: widget.onChanged,
    );
  }
}
