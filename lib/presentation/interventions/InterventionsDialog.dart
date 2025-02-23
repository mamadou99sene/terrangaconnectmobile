import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:terangaconnect/models/DonEspece.dart';
import 'package:terangaconnect/models/DonMateriel.dart';
import 'package:terangaconnect/models/Pret.dart';

class InterventionsDialog extends StatefulWidget {
  final List<Donespece> especes;
  final List<Donmateriel> materiels;
  final List<Pret> prets;

  const InterventionsDialog({
    Key? key,
    required this.especes,
    required this.materiels,
    required this.prets,
  }) : super(key: key);

  @override
  State<InterventionsDialog> createState() => _InterventionsDialogState();
}

class _InterventionsDialogState extends State<InterventionsDialog> {
  bool isEspeceExpanded = true;
  bool isMaterielExpanded = false;
  bool isPretExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Interventions',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
              ),
              const SizedBox(height: 20),
              // Section Dons en Espèces
              _buildSection(
                title: 'Dons en Espèces',
                isExpanded: isEspeceExpanded,
                onToggle: () =>
                    setState(() => isEspeceExpanded = !isEspeceExpanded),
                count: widget.especes.length,
                content: _buildEspecesList(),
              ),
              const Divider(),
              // Section Dons Matériels
              _buildSection(
                title: 'Dons Matériels',
                isExpanded: isMaterielExpanded,
                onToggle: () =>
                    setState(() => isMaterielExpanded = !isMaterielExpanded),
                count: widget.materiels.length,
                content: _buildMaterielsList(),
              ),
              const Divider(),
              // Section Prêts
              _buildSection(
                title: 'Prêts',
                isExpanded: isPretExpanded,
                onToggle: () =>
                    setState(() => isPretExpanded = !isPretExpanded),
                count: widget.prets.length,
                content: _buildPretsList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required bool isExpanded,
    required VoidCallback onToggle,
    required int count,
    required Widget content,
  }) {
    return Column(
      children: [
        InkWell(
          onTap: onToggle,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                Icon(
                  isExpanded
                      ? Icons.keyboard_arrow_down
                      : Icons.keyboard_arrow_right,
                  color: Theme.of(context).primaryColor,
                ),
                const SizedBox(width: 8),
                Text(
                  '$title ($count)',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Spacer(),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    count.toString(),
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (isExpanded) content,
      ],
    );
  }

  Widget _buildEspecesList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: widget.especes.length,
      itemBuilder: (context, index) {
        final espece = widget.especes[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 4),
          child: ListTile(
            title: Text(
              '${espece.donnateur?.telephone}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              'Montant: ${espece.montant.toStringAsFixed(0)} FCFA\n'
              'Date: ${DateFormat('dd/MM/yyyy').format(espece.datePublication!)}',
            ),
            leading: CircleAvatar(
              backgroundColor: Theme.of(context).primaryColor,
              child: const Icon(Icons.monetization_on, color: Colors.white),
            ),
          ),
        );
      },
    );
  }

  Widget _buildMaterielsList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: widget.materiels.length,
      itemBuilder: (context, index) {
        final materiel = widget.materiels[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 4),
          child: ExpansionTile(
            leading: CircleAvatar(
              backgroundColor: Theme.of(context).primaryColor,
              child: const Icon(Icons.category, color: Colors.white),
            ),
            title: Text(
              materiel.titre,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text('${materiel.donnateur?.telephone}'),
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(materiel.description),
                    if (materiel.imagesDon!.isNotEmpty)
                      Container(
                        height: 100,
                        margin: const EdgeInsets.only(top: 8),
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: materiel.imagesDon!.length,
                          itemBuilder: (context, imgIndex) {
                            return Container(
                              margin: const EdgeInsets.only(right: 8),
                              width: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                image: DecorationImage(
                                  image: NetworkImage(
                                      materiel.imagesDon![imgIndex]),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPretsList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: widget.prets.length,
      itemBuilder: (context, index) {
        final pret = widget.prets[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 4),
          child: ExpansionTile(
            leading: CircleAvatar(
              backgroundColor: Theme.of(context).primaryColor,
              child: const Icon(Icons.access_time, color: Colors.white),
            ),
            title: Text(
              pret.titre,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              '${pret.donnateur?.telephone}\n'
              'Durée: ${pret.duree} jours',
            ),
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(pret.description),
                    if (pret.images!.isNotEmpty)
                      Container(
                        height: 100,
                        margin: const EdgeInsets.only(top: 8),
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: pret.images!.length,
                          itemBuilder: (context, imgIndex) {
                            return Container(
                              margin: const EdgeInsets.only(right: 8),
                              width: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                image: DecorationImage(
                                  image: NetworkImage(pret.images![imgIndex]),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
