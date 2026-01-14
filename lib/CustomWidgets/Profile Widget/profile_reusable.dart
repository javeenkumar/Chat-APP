import 'package:flutter/material.dart';

class ReusableRow extends StatefulWidget {
  final String name;
  final String value;
  final Widget icon;
  final ValueChanged<String>? onChanged; // ✅ callback with new value

  const ReusableRow({
    super.key,
    required this.name,
    required this.value,
    required this.icon,
    this.onChanged, // ✅ optional callback
  });

  @override
  State<ReusableRow> createState() => _ReusableRowState();
}

class _ReusableRowState extends State<ReusableRow> {
  bool isTap = false;
  late TextEditingController editingController;

  @override
  void initState() {
    super.initState();
    editingController = TextEditingController(text: widget.name);
  }

  @override
  void dispose() {
    editingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        setState(() {
          isTap = !isTap;
        });
      },
      leading: widget.icon,
      title: Text(
        widget.value,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w400,
          color: Colors.black87,
        ),
      ),
      trailing: isTap
          ? SizedBox(
        width: 150,
        child: TextFormField(
          controller: editingController,
          decoration: InputDecoration(
            hintText: 'Edit value',
            isDense: true,
            contentPadding:
            const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onFieldSubmitted: (newValue) {
            setState(() {
              isTap = false;
            });
            if (widget.onChanged != null) {
              widget.onChanged!(newValue);
            }
          },
        ),
      )
          : Text(
        widget.name,
        maxLines: 2,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w400,
          color: Colors.black54,
        ),
      ),
      tileColor: Colors.grey.shade100,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      dense: true,
    );
  }
}
