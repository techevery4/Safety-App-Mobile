import 'package:flutter/material.dart';
import '../../domain/entities/contact_entity.dart';

class ContactListTile extends StatelessWidget {
  final ContactEntity contact;
  final VoidCallback? onDelete;

  const ContactListTile({super.key, required this.contact, this.onDelete});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        child: Text(contact.name.substring(0, 1).toUpperCase()),
      ),
      title: Text(contact.name),
      subtitle: Text(contact.email),
      trailing: IconButton(
        icon: const Icon(Icons.delete_outline),
        onPressed: onDelete,
      ),
    );
  }
}
