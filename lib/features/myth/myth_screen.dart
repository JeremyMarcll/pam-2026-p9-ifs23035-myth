import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../providers/myth_provider.dart';

class MythScreen extends StatefulWidget {
  @override
  State<MythScreen> createState() => _MythScreenState();
}

class _MythScreenState extends State<MythScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    final provider = context.read<MythProvider>();
    provider.fetchMyths();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        provider.fetchMyths();
      }
    });
  }

  String formatDate(String date) {
    try {
      final parsed = DateTime.parse(date);
      return DateFormat("dd MMM yyyy, HH:mm").format(parsed);
    } catch (e) {
      return date;
    }
  }

  void showGenerateDialog() {
    final themeController = TextEditingController();
    final totalController = TextEditingController();

    showDialog(
      context: context,
      builder: (_) {
        return Consumer<MythProvider>(
          builder: (context, provider, _) {
            return AlertDialog(
              backgroundColor: Color(0xFF1E1B2E),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: Row(
                children: [
                  Icon(Icons.auto_awesome, color: Colors.purpleAccent),
                  SizedBox(width: 8),
                  Text("Summon Myth"),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: themeController,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: "Theme (e.g. Greek, Dragon)",
                      labelStyle: TextStyle(color: Colors.white70),
                      filled: true,
                      fillColor: Colors.black26,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  SizedBox(height: 12),
                  TextField(
                    controller: totalController,
                    keyboardType: TextInputType.number,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: "Total",
                      labelStyle: TextStyle(color: Colors.white70),
                      filled: true,
                      fillColor: Colors.black26,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: provider.isGenerating
                      ? null
                      : () => Navigator.pop(context),
                  child: Text("Cancel"),
                ),
                ElevatedButton(
                  onPressed: provider.isGenerating
                      ? null
                      : () async {
                    await provider.generate(
                      themeController.text,
                      int.parse(totalController.text),
                    );
                    Navigator.pop(context);
                  },
                  child: provider.isGenerating
                      ? SizedBox(
                    height: 18,
                    width: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                      : Text("Summon"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<MythProvider>();

    return Scaffold(
      backgroundColor: Color(0xFF0F0F1B),

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "Myth Encyclopedia",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: showGenerateDialog,
        backgroundColor: Colors.deepPurple,
        icon: Icon(Icons.auto_awesome),
        label: Text("Summon"),
      ),

      body: Stack(
        children: [
          ListView.builder(
            controller: _scrollController,
            padding: EdgeInsets.only(bottom: 120, top: 10),
            itemCount: provider.myths.length + 1,
            itemBuilder: (context, index) {
              if (index < provider.myths.length) {
                final myth = provider.myths[index];

                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  padding: EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: LinearGradient(
                      colors: [
                        Color(0xFF1E1B2E),
                        Color(0xFF2A2545),
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.purple.withValues(alpha: 0.3),
                        blurRadius: 12,
                        offset: Offset(0, 6),
                      )
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 🔥 NAME
                      Text(
                        myth.name,
                        style: TextStyle(
                          color: Colors.amberAccent,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      SizedBox(height: 6),

                      // 🕒 DATE
                      Text(
                        formatDate(myth.createdAt),
                        style: TextStyle(
                          color: Colors.white54,
                          fontSize: 11,
                        ),
                      ),

                      SizedBox(height: 12),

                      // 📜 DESCRIPTION
                      Text(
                        myth.description,
                        style: TextStyle(
                          color: Colors.white,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                return provider.isLoading
                    ? Padding(
                  padding: EdgeInsets.all(20),
                  child: Center(child: CircularProgressIndicator()),
                )
                    : SizedBox();
              }
            },
          ),

          if (provider.isGenerating)
            Container(
              color: Colors.black.withValues(alpha: 0.4),
              child: Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }
}