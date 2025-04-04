import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:terangaconnect/models/DonSang.dart';
import 'package:terangaconnect/theme/theme_helper.dart';

class DonSangInterventionsDialog extends StatelessWidget {
  final List<Donsang> dons;

  const DonSangInterventionsDialog({
    Key? key,
    required this.dons,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Dons de Sang',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.primaryColor,
                ),
              ),
              const SizedBox(height: 20),
              // Section des dons de sang
              Row(
                children: [
                  Icon(
                    Icons.bloodtype,
                    color: theme.primaryColor,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Liste des donneurs (${dons.length})',
                    style: theme.textTheme.titleMedium,
                  ),
                  const Spacer(),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: theme.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      dons.length.toString(),
                      style: TextStyle(
                        color: theme.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _buildDonsList(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDonsList(BuildContext context) {
    if (dons.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Center(
          child: Text('Aucun don de sang pour cette demande',
              style: theme.textTheme.labelLarge),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: dons.length,
      itemBuilder: (context, index) {
        final don = dons[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 4),
          child: ListTile(
            title: Text(
              don.donnateur?.telephone ?? 'Donneur anonyme',
              style: theme.textTheme.labelLarge,
            ),
            subtitle: Text(
              'Type de sang: ${don.type}\n'
              'Adresse: ${don.adresseDonnateur}\n'
              'Date: ${DateFormat('dd/MM/yyyy').format(don.datePublication!)}',
              style: theme.textTheme.labelLarge,
            ),
            leading: CircleAvatar(
              backgroundColor: Colors.red.shade700,
              child: const Icon(Icons.bloodtype, color: Colors.white),
            ),
          ),
        );
      },
    );
  }
}
