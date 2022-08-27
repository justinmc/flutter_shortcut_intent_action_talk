import 'package:flutter/material.dart';

class MyListItem extends StatelessWidget {
  const MyListItem({
    Key? key,
    required this.route,
    required this.subtitle,
    required this.title,
    this.assetName,
  }) : super(key: key);

  final String route;
  final String subtitle;
  final String title;
  final String? assetName;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(route);
      },
      child: Card(
        margin: const EdgeInsets.all(12.0),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: ListTile(
            title: Text(title),
            subtitle: Text(subtitle),
            trailing: assetName == null ? null : Image.asset(assetName!),
          ),
        ),
      ),
    );
  }
}
